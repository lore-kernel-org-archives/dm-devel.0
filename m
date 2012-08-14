From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH v5 02/12] dm: Use bioset's front_pad for dm_rq_clone_bio_info
Date: Tue, 14 Aug 2012 14:33:20 +0900
Message-ID: <5029E320.3050603@ce.jp.nec.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com> <1344290921-25154-3-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1344290921-25154-3-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
List-Id: dm-devel.ids

On 08/07/12 07:08, Kent Overstreet wrote:
>  struct dm_rq_clone_bio_info {
>  	struct bio *orig;
>  	struct dm_rq_target_io *tio;
> +	struct bio clone;
>  };
...
> -	pools->bs = bioset_create(pool_size, 0);
> +	pools->bs = bioset_create(pool_size,
> +				  offsetof(struct dm_rq_clone_bio_info, orig));
>  	if (!pools->bs)
>  		goto free_tio_pool_and_out;

Shouldn't this be offsetof(struct dm_rq_clone_bio_info, clone)?

-- 
Jun'ichi Nomura, NEC Corporation
