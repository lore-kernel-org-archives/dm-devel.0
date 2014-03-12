From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: stop using bi_private
Date: Wed, 12 Mar 2014 16:56:18 -0400
Message-ID: <20140312205618.GA4784@redhat.com>
References: <alpine.LRH.2.02.1403041721520.29476@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1403041721520.29476@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 04 2014 at  6:24pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Device mapper uses the bi_private field as a pointer to dm_target_io or 
> dm_rq_clone_bio_info. With current kernel, the bio structure is embedded 
> in the structures dm_target_io and dm_rq_clone_bio_info, so the pointer to 
> the structure that contains the bio can be found with the macro 
> container_of.
> 
> This patch removes the use of bi_private and uses container_of instead.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  drivers/md/dm.c |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> Index: linux-3.14-rc4/drivers/md/dm.c
> ===================================================================
> --- linux-3.14-rc4.orig/drivers/md/dm.c	2014-03-01 17:19:05.000000000 +0100
> +++ linux-3.14-rc4/drivers/md/dm.c	2014-03-01 17:23:31.000000000 +0100
> @@ -753,7 +753,7 @@ static void dec_pending(struct dm_io *io
>  static void clone_endio(struct bio *bio, int error)
>  {
>  	int r = 0;
> -	struct dm_target_io *tio = bio->bi_private;
> +	struct dm_target_io *tio = dm_per_bio_data(bio, 0);
>  	struct dm_io *io = tio->io;
>  	struct mapped_device *md = tio->io->md;
>  	dm_endio_fn endio = tio->ti->type->end_io;

FYI, I've picked this up for 3.15.

But I decided to use this instead:
  struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);

While I understand dm_per_bio_data() with 0 accomplishes the same I
think it clearer to use container_of().

Mike
