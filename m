From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Wed, 17 Dec 2014 17:51:44 -0500
Message-ID: <20141217225143.GB15390@redhat.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
	<alpine.LNX.2.00.1412172133240.4026@localhost.lm.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1412172133240.4026@localhost.lm.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: axboe@kernel.dk, bvanassche@acm.org, hch@infradead.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

On Wed, Dec 17 2014 at  4:42pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Tue, 16 Dec 2014, Mike Snitzer wrote:
> >Here is v3 of the request-based DM blk-support patchset.  I've also
> >published a git repo here:
> >https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.20-blk-mq
> >
> >I found quite a few issues with v2 for both blk-mq and old
> >request-based DM.  I've still attributed the original patches from
> >Keith to him even though I fixed/rewrote significant portions.  Keith,
> >I'm happy to leave attribution like this unless you'd prefer I change
> >it.
> 
> Thanks a bunch, Mike! I'll need to merge your tree with Jens' for nvme
> blk-mq, and one patch for a nvme scsi translation fix, then I can test
> this out. I get my dual ported nvme controller back tomorrow, so should
> have results before the end of the week.

No problem.  Please test with the latest 'dm-for-3.20-blk-mq' -- topmost
commit should be 1943bd21bf8df061b3112c945160e2a740a906ba

I don't have any dual ported NVMe hardware or anything so I haven't
_really_ tested all aspects of this code.  I've mainly studied the code
_a lot_ and made sure that basic IO is getting submitted/completed as
expected (for both the old and blk-mq cases).

I'll be interested to understand if these changes are sufficient for
your hardware.. I'm left wondering how/if scsi-mq should fit into
dm-multipath given that I know iSER is at least slated to use scsi-mq.
Also, we have the scsi_dh layer that obviously isn't in the mix here
with direct submission and completion with the blk-mq driver.

> I'm happy to take credit, but if your rewrite is sufficiently different,
> I'm okay to just append a Tested-by once that's done. :)

It is pretty different in that I'm maintaining both the old and blk-mq
paths in DM core's request-based path.  But your v2 series provided a
roadmap for what was needed for the blk-mq path... so you'll still find
your code for sure.  I'd say the 8th patch is what saw the biggest
rewrite so I can go ahead and flip that to be attributed to me if you'd
rather not get all the blame ;)

Mike
