From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [for-4.16 PATCH v6 0/3] blk-mq: improve DM's blk-mq IO merging
 via blk_insert_cloned_request feedback
Date: Wed, 17 Jan 2018 09:50:53 -0700
Message-ID: <45f70a28-aeea-8278-0b8e-9601ea043595@kernel.dk>
References: <20180117162558.28553-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180117162558.28553-1-snitzer@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lei <tom.leiming@gmail.com>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 1/17/18 9:25 AM, Mike Snitzer wrote:
> Hi Jens,
> 
> Think this finally takes care of it! ;)
> 
> Thanks,
> Mike
> 
> Mike Snitzer (2):
>   blk-mq: factor out a few helpers from __blk_mq_try_issue_directly
>   blk-mq-sched: remove unused 'can_block' arg from blk_mq_sched_insert_request
> 
> Ming Lei (1):
>   blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback

Applied - added actual commit message to patch 3.

-- 
Jens Axboe
