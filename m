From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [PATCH] dm-writeboost: Remove unsure BUG() from
 init_rambuf_pool
Date: Tue, 22 Jul 2014 16:14:36 +0900
Message-ID: <20140722161436.90e7b2c56830872354cc636b@gmail.com>
References: <87egxr0wul.wl%satoru.takeuchi@gmail.com>
	<20140718100130.5bc9f9cc4e9ce674ab014423@gmail.com>
	<CAMym5wu+DUrxqOaenW1h4WgcJOGzMK1H1amMbYS7783qugQFNg@mail.gmail.com>
	<87bnsl37az.wl%satoru.takeuchi@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87bnsl37az.wl%satoru.takeuchi@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>, ejt@redhat.com
List-Id: dm-devel.ids

Hi, Satoru,

As for removing BUG() at the line I will definitely ack but
please also send a pull request to Joe's tree where we
are raising up dm-writeboost. Sorry, I didn't tell you this.

In my opinion, I like to see the patch in both pull request and dm-devel.
This shares where dm-writeboost is going to with DM guys.
If you have other works to dm-writeboost, please do as this time.

Note that where you send the pull request is
thin-dev branch of jthornber/linux-2.6.
It's where dm-writeboost is in.

Anyway, I think you start to involve dm-writeboost.
It is really welcome.
And bringing us discussion from user/sysadmin perspective
is greatly welcome, too.

- Akira



On Sat, 19 Jul 2014 20:40:52 +0900
Satoru Takeuchi <satoru.takeuchi@gmail.com> wrote:

> Hi Joe and Akira,
> 
> At Sat, 19 Jul 2014 11:13:13 +0900,
> Satoru Takeuchi wrote:
> > 
> > Hi Akira,
> > 
> > 2014-07-18 10:01 GMT+09:00 Akira Hayakawa <ruby.wktk@gmail.com>:
> > > Hi, Satoru,
> > >
> > > I totally agree with removing the BUG() at (2).
> > >
> > > However, I don't agree with setting the upper limit of nr_rambuf_pool.
> > > You are saying that any memory allocation failure on initialization should be avoided
> > > but that sounds going too far. Removing that possibility from all kernel codes is impossible in practice.
> > > Carefully terminating the initialization on allocation failure is sufficient.
> 
> Both Akira and me seem to have completely different policy about the upper
> limit of nr_rambuf_pool argument. However both of us agree with removing
> unsure BUG() in int init_rambuf_pool(). So I wrote a patch to do so as a
>  first step. Please apply this patch.
> 
> In addition, I'd like to know your opinion about whether setting
> the upper limit of nr_rambuf_pool argument is neccesary or not.
> 
> 
> 
> =======
> From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> 
> If users set a very large value to nr_rambuf_pool argument, kernel would hit
> BUG() in the error route of init_rambuf_pool().
> 
> drivers/md/dm-writeboost-metadata.c:
> ===============================================================================
> ...
> static int init_rambuf_pool(struct wb_device *wb)
> {
> 	int r = 0;
> 	size_t i;
> 
> 	wb->rambuf_pool = kmalloc(sizeof(struct rambuffer) * wb->nr_rambuf_pool,
> 				  GFP_KERNEL);
> 	if (!wb->rambuf_pool)			# It is true here.
> 		return -ENOMEM;
> 
> 	wb->rambuf_cachep = kmem_cache_create("dmwb_rambuf",
> 			1 << (wb->segment_size_order + SECTOR_SHIFT),
> 			1 << (wb->segment_size_order + SECTOR_SHIFT),
> 			SLAB_RED_ZONE, NULL);
> 	if (!wb->rambuf_cachep) {
> 		r = -ENOMEM;			# Enter this route or ....
> 		goto bad_cachep;
> 	}
> 
> 	for (i = 0; i < wb->nr_rambuf_pool; i++) {
> 		size_t j;
> 		struct rambuffer *rambuf = wb->rambuf_pool + i;
> 
> 		rambuf->data = kmem_cache_alloc(wb->rambuf_cachep, GFP_KERNEL);
> 		if (!rambuf->data) {
> 			...			# ... enter this route.
> 			goto bad_alloc_data;
> 		}
> 		check_buffer_alignment(rambuf->data);
> 	}
> 
> 	return r;
> 
> bad_alloc_data:
> 	kmem_cache_destroy(wb->rambuf_cachep);
> bad_cachep:
> 	kfree(wb->rambuf_pool);
> 	BUG();					# Kernel panic happens here.
> 	return r;
> }
> ...
> ===============================================================================
> 
> Probably this BUG() was introduced erroneously and is safe to remove.
> 
> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> Cc: Joe Thornber <ejt@redhat.com>
> Cc: Akira Hayakawa <ruby.wktk@gmail.com>
> ---
>  drivers/md/dm-writeboost-metadata.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/dm-writeboost-metadata.c b/drivers/md/dm-writeboost-metadata.c
> index b7b3eb7..ce6ea056 100644
> --- a/drivers/md/dm-writeboost-metadata.c
> +++ b/drivers/md/dm-writeboost-metadata.c
> @@ -702,7 +702,6 @@ bad_alloc_data:
>  	kmem_cache_destroy(wb->rambuf_cachep);
>  bad_cachep:
>  	kfree(wb->rambuf_pool);
> -	BUG();
>  	return r;
>  }
>  
> -- 
> 2.0.1
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel


-- 
Akira Hayakawa <ruby.wktk@gmail.com>
