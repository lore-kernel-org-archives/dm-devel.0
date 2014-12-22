From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Mon, 22 Dec 2014 13:49:10 -0500
Message-ID: <20141222184910.GB8054@redhat.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
	<alpine.LNX.2.00.1412172133240.4026@localhost.lm.intel.com>
	<5491F906.1090004@kernel.dk> <20141217230622.GC15390@redhat.com>
	<54943714.2040704@acm.org> <20141219153801.GA8697@redhat.com>
	<20141219171438.GA6347@redhat.com> <5498389D.6070909@acm.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5498389D.6070909@acm.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, hch@infradead.org, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

Hi Bart,

On Mon, Dec 22 2014 at 10:28am -0500,
Bart Van Assche <bvanassche@acm.org> wrote:
 
> Hello Mike,
> 
> Good news: with this patch my standard SRP multipath test ran fine for
> several hours, after which I stopped the test.

Great, thanks for testing!  Did you happen to look at the performance of
your testing?  If so, is it comparable/better/worse?

FYI, I went ahead and added your Tested-by: to this commit:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=e596370123136b37757f4c7d01fb6a6cba26452b

And I also staged the entire series in linux-next (for 3.20 at
earliest).  Still have much more testing to do on these changes but
it'll be good to let them soak in linux-next over the holiday break.

> The only issue I hit during this test is the one mentioned on
> https://lkml.org/lkml/2014/10/29/523 but that's a bug in the e1000
> driver that is not related to multipath.

OK, hopefully you'll hear back from the maintainers on that thread soon.
