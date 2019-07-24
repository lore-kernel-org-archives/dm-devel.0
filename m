From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH V3 1/2] blk-mq: add callback of .cleanup_rq
Date: Wed, 24 Jul 2019 21:03:22 +0000
Message-ID: <20190724210323.1B74B2189F@mail.kernel.org>
References: <20190724031258.31688-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190724031258.31688-2-ming.lei@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sasha Levin <sashal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.com>, Bart Van Assche <bvanassche@acm.org>, Mike Snitzer <snitzer@redhat.com>, "Ewan D. Milne" <emilne@redhat.com>, Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 396eaf21ee17 blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback.

The bot has tested the following trees: v5.2.2, v5.1.19, v4.19.60.

v5.2.2: Build OK!
v5.1.19: Failed to apply! Possible dependencies:
    5de719e3d01b ("dm mpath: fix missing call of path selector type->end_io")

v4.19.60: Failed to apply! Possible dependencies:
    36e765392e48 ("blk-mq: complete req in softirq context in case of single queue")
    5de719e3d01b ("dm mpath: fix missing call of path selector type->end_io")
    7b7ab780a048 ("block: make request_to_qc_t public")
    9ba20527f4d1 ("blk-mq: provide mq_ops->busy() hook")
    c7bb9ad1744e ("block: get rid of q->softirq_done_fn()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
