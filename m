From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH block#for-2.6.31] block: add request clone interface
	(v2)
Date: Thu, 11 Jun 2009 13:09:03 +0200
Message-ID: <20090611110903.GO11363@kernel.dk>
References: <4A3075B2.9040208@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762838AbZFKLJT@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A3075B2.9040208@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On Thu, Jun 11 2009, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> This patch adds the following 2 interfaces for request-stacking drivers:
> 
>   - blk_rq_prep_clone(struct request *clone, struct request *orig,
> 		      struct bio_set *bs, gfp_t gfp_mask,
> 		      int (*bio_ctr)(struct bio *, struct bio*, void *),
> 		      void *data)
>       * Clones bios in the original request to the clone request
>         (bio_ctr is called for each cloned bios.)
>       * Copies attributes of the original request to the clone request.
>         The actual data parts (e.g. ->cmd, ->buffer, ->sense) are not
>         copied.
> 
>   - blk_rq_unprep_clone(struct request *clone)
>       * Frees cloned bios from the clone request.
> 
> Request stacking drivers (e.g. request-based dm) need to make a clone
> request for a submitted request and dispatch it to other devices.
> 
> To allocate request for the clone, request stacking drivers may not
> be able to use blk_get_request() because the allocation may be done
> in an irq-disabled context.
> So blk_rq_prep_clone() takes a request allocated by the caller
> as an argument.
> 
> For each clone bio in the clone request, request stacking drivers
> should be able to set up their own completion handler.
> So blk_rq_prep_clone() takes a callback function which is called
> for each clone bio, and a pointer for private data which is passed
> to the callback.
> 
> NOTE:
> blk_rq_prep_clone() doesn't copy any actual data of the original
> request.  Pages are shared between original bios and cloned bios.
> So caller must not complete the original request before the clone
> request.

This looks good to me now, I've applied it.

-- 
Jens Axboe
