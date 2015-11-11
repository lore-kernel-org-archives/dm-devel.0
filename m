From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] block: Introduce BIO_ENDIO_FREE for bio flags
Date: Wed, 11 Nov 2015 12:54:11 -0500
Message-ID: <20151111175411.GC12236@redhat.com>
References: <cover.1447233227.git.baolin.wang@linaro.org>
 <2bd3cc769530061501af545c7949dcc832263930.1447233227.git.baolin.wang@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2bd3cc769530061501af545c7949dcc832263930.1447233227.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Baolin Wang <baolin.wang@linaro.org>
Cc: axboe@kernel.dk, agk@redhat.com, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, jack@suse.cz, arnd@arndb.de, linux-kernel@vger.kernel.org, keith.busch@intel.com, jmoyer@redhat.com, broonie@kernel.org, tj@kernel.org, bart.vanassche@sandisk.com, dineshg@quicinc.com
List-Id: dm-devel.ids

On Wed, Nov 11 2015 at  4:31am -0500,
Baolin Wang <baolin.wang@linaro.org> wrote:

> When we use dm-crypt to decrypt block data, it will decrypt the block data
> in endio() when one IO is completed. In this situation we don't want the
> cloned bios is freed before calling the endio().
> 
> Thus introduce 'BIO_ENDIO_FREE' flag to support the request handling for dm-crypt,
> this flag will ensure that blk layer does not complete the cloned bios before
> completing the request. When the crypt endio is called, post-processsing is
> done and then the dm layer will complete the bios (clones) and free them.

Not following why request-based DM's partial completion handling
(drivers/md/dm.c:end_clone_bio) isn't a sufficient hook -- no need to
add block complexity.

But that aside, I'm not liking the idea of a request-based dm-crypt.

> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 76d23fa..f636c50 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -407,6 +407,11 @@ union map_info *dm_get_rq_mapinfo(struct request *rq);
>  
>  struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
>  
> +void dm_end_request(struct request *clone, int error);
> +void dm_kill_unmapped_request(struct request *rq, int error);
> +void dm_dispatch_clone_request(struct request *clone, struct request *rq);
> +struct request *dm_get_orig_rq(struct request *clone);
> +
>  /*
>   * Geometry functions.
>   */

I have no interest in seeing any request-based DM interfaces exported.
