From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm bufio: update comment in dm-bufio.c
Date: Tue, 30 Oct 2018 10:20:57 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1810301020450.28237@file01.intranet.prod.int.rdu2.redhat.com>
References: <20181030073554.1801-1-shhuiw@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181030073554.1801-1-shhuiw@foxmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shenghui Wang <shhuiw@foxmail.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

OK.

Acked-by: Mikulas Patocka <mpatocka@redhat.com>


On Tue, 30 Oct 2018, Shenghui Wang wrote:

> * Hashtable has been replaced by rbtree to manage buffers.
>   Update the comment.
> * Fix typo in the comment for dm_bufio_issue_flush
> 
> Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
> ---
>  drivers/md/dm-bufio.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> index dc385b70e4c3..0e9fcceaefd2 100644
> --- a/drivers/md/dm-bufio.c
> +++ b/drivers/md/dm-bufio.c
> @@ -65,7 +65,7 @@
>  
>  /*
>   * Linking of buffers:
> - *	All buffers are linked to cache_hash with their hash_list field.
> + *	All buffers are linked to buffer_tree with their node field.
>   *
>   *	Clean buffers that are not being written (B_WRITING not set)
>   *	are linked to lru[LIST_CLEAN] with their lru_list field.
> @@ -457,7 +457,7 @@ static void free_buffer(struct dm_buffer *b)
>  }
>  
>  /*
> - * Link buffer to the hash list and clean or dirty queue.
> + * Link buffer to the buffer tree and clean or dirty queue.
>   */
>  static void __link_buffer(struct dm_buffer *b, sector_t block, int dirty)
>  {
> @@ -472,7 +472,7 @@ static void __link_buffer(struct dm_buffer *b, sector_t block, int dirty)
>  }
>  
>  /*
> - * Unlink buffer from the hash list and dirty or clean queue.
> + * Unlink buffer from the buffer tree and dirty or clean queue.
>   */
>  static void __unlink_buffer(struct dm_buffer *b)
>  {
> @@ -993,7 +993,7 @@ static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
>  
>  	/*
>  	 * We've had a period where the mutex was unlocked, so need to
> -	 * recheck the hash table.
> +	 * recheck the buffer tree.
>  	 */
>  	b = __find(c, block);
>  	if (b) {
> @@ -1327,7 +1327,7 @@ int dm_bufio_write_dirty_buffers(struct dm_bufio_client *c)
>  EXPORT_SYMBOL_GPL(dm_bufio_write_dirty_buffers);
>  
>  /*
> - * Use dm-io to send and empty barrier flush the device.
> + * Use dm-io to send an empty barrier to flush the device.
>   */
>  int dm_bufio_issue_flush(struct dm_bufio_client *c)
>  {
> @@ -1356,7 +1356,7 @@ EXPORT_SYMBOL_GPL(dm_bufio_issue_flush);
>   * Then, we write the buffer to the original location if it was dirty.
>   *
>   * Then, if we are the only one who is holding the buffer, relink the buffer
> - * in the hash queue for the new location.
> + * in the buffer tree for the new location.
>   *
>   * If there was someone else holding the buffer, we write it to the new
>   * location but not relink it, because that other user needs to have the buffer
> -- 
> 2.18.0
> 
> 
> 
