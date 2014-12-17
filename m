From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Wed, 17 Dec 2014 21:42:25 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1412172133240.4026@localhost.lm.intel.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, hch@infradead.org, bvanassche@acm.org, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

On Tue, 16 Dec 2014, Mike Snitzer wrote:
> Here is v3 of the request-based DM blk-support patchset.  I've also
> published a git repo here:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.20-blk-mq
>
> I found quite a few issues with v2 for both blk-mq and old
> request-based DM.  I've still attributed the original patches from
> Keith to him even though I fixed/rewrote significant portions.  Keith,
> I'm happy to leave attribution like this unless you'd prefer I change
> it.

Thanks a bunch, Mike! I'll need to merge your tree with Jens' for nvme
blk-mq, and one patch for a nvme scsi translation fix, then I can test
this out. I get my dual ported nvme controller back tomorrow, so should
have results before the end of the week.

I'm happy to take credit, but if your rewrite is sufficiently different,
I'm okay to just append a Tested-by once that's done. :)
