From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 3/7] dm-crypt: avoid deadlock in mempools
Date: Fri, 13 Feb 2015 16:16:15 -0500
Message-ID: <20150213211614.GA7180@redhat.com>
References: <alpine.LRH.2.02.1502130823540.6449@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1502130823540.6449@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ondrej Kozina <okozina@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 13 2015 at  8:24P -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> This patch fixes a theoretical deadlock introduced in the previous patch.
> 
> The function crypt_alloc_buffer may be called concurrently. If we allocate
> from the mempool concurrently, there is a possibility of deadlock.
> For example, if we have mempool of 256 pages, two processes, each wanting 256,
> pages allocate from the mempool concurrently, it may deadlock in a situation
> where both processes have allocated 128 pages and the mempool is exhausted.
> 
> In order to avoid this scenarios, we allocate the pages under a mutex.
> 
> In order to not degrade performance with excessive locking, we try
> non-blocking allocations without a mutex first and if it fails, we fallback
> to a blocking allocation with a mutex.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm-crypt.c |   41 ++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 36 insertions(+), 5 deletions(-)
> 
> Index: linux-3.18-rc1/drivers/md/dm-crypt.c
> ===================================================================
> --- linux-3.18-rc1.orig/drivers/md/dm-crypt.c	2014-10-21 00:49:31.000000000 +0200
> +++ linux-3.18-rc1/drivers/md/dm-crypt.c	2014-10-21 00:49:34.000000000 +0200
> @@ -124,6 +124,7 @@ struct crypt_config {
>  	mempool_t *req_pool;
>  	mempool_t *page_pool;
>  	struct bio_set *bs;
> +	struct mutex bio_alloc_lock;
>  
>  	struct workqueue_struct *io_queue;
>  	struct workqueue_struct *crypt_queue;
> @@ -949,27 +950,51 @@ static void crypt_free_buffer_pages(stru
>  /*
>   * Generate a new unfragmented bio with the given size
>   * This should never violate the device limitations
> + *
> + * This function may be called concurrently. If we allocate from the mempool
> + * concurrently, there is a possibility of deadlock. For example, if we have
> + * mempool of 256 pages, two processes, each wanting 256, pages allocate from
> + * the mempool concurrently, it may deadlock in a situation where both processes
> + * have allocated 128 pages and the mempool is exhausted.
> + *
> + * In order to avoid this scenarios, we allocate the pages under a mutex.
> + *
> + * In order to not degrade performance with excessive locking, we try
> + * non-blocking allocations without a mutex first and if it fails, we fallback
> + * to a blocking allocation with a mutex.
>   */

I folded this in:

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index cb075a7..6fc655d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -968,10 +968,10 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
  * the mempool concurrently, it may deadlock in a situation where both processes
  * have allocated 128 pages and the mempool is exhausted.
  *
- * In order to avoid this scenarios, we allocate the pages under a mutex.
+ * In order to avoid this scenario we allocate the pages under a mutex.
  *
  * In order to not degrade performance with excessive locking, we try
- * non-blocking allocations without a mutex first and if it fails, we fallback
+ * non-blocking allocation without a mutex first and if it fails, we fallback
  * to a blocking allocation with a mutex.
  */
 static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned size)
