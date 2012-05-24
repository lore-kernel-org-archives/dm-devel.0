From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [dm-devel] [PATCH v2 02/14] dm: kill dm_rq_bio_destructor
Date: Thu, 24 May 2012 09:19:12 +0900
Message-ID: <4FBD7E80.4020005@ce.jp.nec.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com> <1337817771-25038-3-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1337817771-25038-3-git-send-email-koverstreet@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, yehuda@hq.newdream.net, mpatocka@redhat.com, vgoyal@redhat.com, bharrosh@panasas.com, tj@kernel.org, sage@newdream.net, agk@redhat.com, drbd-dev@lists.linbit.com
List-Id: dm-devel.ids

Hi,

On 05/24/12 09:02, Kent Overstreet wrote:
> @@ -1438,15 +1439,6 @@ void dm_dispatch_request(struct request *rq)
>  }
>  EXPORT_SYMBOL_GPL(dm_dispatch_request);
>  
> -static void dm_rq_bio_destructor(struct bio *bio)
> -{
> -	struct dm_rq_clone_bio_info *info = bio->bi_private;
> -	struct mapped_device *md = info->tio->md;
> -
> -	free_bio_info(info);
> -	bio_free(bio, md->bs);
> -}
> -
>  static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
>  				 void *data)
>  {
> @@ -1461,7 +1453,6 @@ static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
>  	info->tio = tio;
>  	bio->bi_end_io = end_clone_bio;
>  	bio->bi_private = info;
> -	bio->bi_destructor = dm_rq_bio_destructor;

The destructor may also be called from blk_rq_unprep_clone(),
which just puts bio.
So this patch will introduce a memory leak.

Please check this comment as well:
https://www.redhat.com/archives/dm-devel/2012-May/msg00216.html

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
