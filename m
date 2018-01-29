From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Mon, 29 Jan 2018 14:37:00 -0800
Message-ID: <bb221027-3fcf-fbf8-7535-05569fb850ca@wdc.com>
References: <20180118024124.8079-1-ming.lei@redhat.com>
 <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
 <20180118170353.GB19734@redhat.com> <1516296056.2676.23.camel@wdc.com>
 <20180118183039.GA20121@redhat.com> <1516301278.2676.35.camel@wdc.com>
 <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
 <20180119023212.GA25413@ming.t460p>
 <eba1191e-4d59-a763-03b2-acd2d2812ea3@kernel.dk>
 <20180119072623.GB25369@ming.t460p>
 <047f68ec-f51b-190f-2f89-f413325c2540@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <047f68ec-f51b-190f-2f89-f413325c2540@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: "snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>
List-Id: dm-devel.ids

On 01/19/18 07:24, Jens Axboe wrote:
> That's what I thought. So for a low queue depth underlying queue, it's
> quite possible that this situation can happen. Two potential solutions
> I see:
> 
> 1) As described earlier in this thread, having a mechanism for being
>     notified when the scarce resource becomes available. It would not
>     be hard to tap into the existing sbitmap wait queue for that.
> 
> 2) Have dm set BLK_MQ_F_BLOCKING and just sleep on the resource
>     allocation. I haven't read the dm code to know if this is a
>     possibility or not.
> 
> I'd probably prefer #1. It's a classic case of trying to get the
> request, and if it fails, add ourselves to the sbitmap tag wait
> queue head, retry, and bail if that also fails. Connecting the
> scarce resource and the consumer is the only way to really fix
> this, without bogus arbitrary delays.

(replying to an e-mail from ten days ago)

Implementing a notification mechanism for all cases in which 
blk_insert_cloned_request() returns BLK_STS_RESOURCE today would require 
a lot of work. If e.g. a SCSI LLD returns one of the SCSI_MLQUEUE_*_BUSY 
return codes from its .queuecommand() implementation then the SCSI core 
will translate that return code into BLK_STS_RESOURCE. From scsi_queue_rq():

	reason = scsi_dispatch_cmd(cmd);
	if (reason) {
		scsi_set_blocked(cmd, reason);
		ret = BLK_STS_RESOURCE;
		goto out_dec_host_busy;
	}

In other words, implementing a notification mechanism for all cases in 
which blk_insert_cloned_request() can return BLK_STS_RESOURCE would 
require to modify all SCSI LLDs.

Bart.
