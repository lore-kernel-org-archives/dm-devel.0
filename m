From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm mpath: potential NULL dereference with parse_path()
Date: Sat, 6 Jan 2018 11:20:45 -0500
Message-ID: <20180106162045.GA27922@redhat.com>
References: <20180106092643.pq67kkzj2jsjlvzy@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180106092643.pq67kkzj2jsjlvzy@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Jan 06 2018 at  4:26P -0500,
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> We forgot to set the error code on this path so it means we accidentally
> return NULL.  The caller is expecting error pointers and will crash
> with a NULL dereference.
> 
> Fixes: faf782b1c93d ("dm mpath: optimize NVMe bio-based support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index d1f32103ae86..0436a5466281 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -883,6 +883,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
>  		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
>  		if (setup_scsi_dh(p->path.dev->bdev, m, &ti->error)) {
>  			dm_put_device(ti, p->path.dev);
> +			r = -EINVAL;
>  			goto bad;
>  		}
>  	}

Thanks for the report, but I prefer the following fix, which I'll fold
into the original commit:

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 99420b0ac2db..be581765edd1 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -882,7 +882,8 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 
 	if (m->queue_mode != DM_TYPE_NVME_BIO_BASED) {
 		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
-		if (setup_scsi_dh(p->path.dev->bdev, m, &ti->error)) {
+		r = setup_scsi_dh(p->path.dev->bdev, m, &ti->error);
+		if (r) {
 			dm_put_device(ti, p->path.dev);
 			goto bad;
 		}
