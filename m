From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: dm-ioband: Test results.
Date: Mon, 13 Apr 2009 22:49:43 -0400
Message-ID: <20090414024943.GA976@redhat.com>
References: <20090413.130552.226792299.ryov@valinux.co.jp>
	<20090413144626.GF18007@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090413144626.GF18007@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 13, 2009 at 10:46:26AM -0400, Vivek Goyal wrote:
> On Mon, Apr 13, 2009 at 01:05:52PM +0900, Ryo Tsuruta wrote:
> > Hi Alasdair and all,
> > 
> > I did more tests on dm-ioband and I've posted the test items and
> > results on my website. The results are very good.
> > http://people.valinux.co.jp/~ryov/dm-ioband/test/test-items.xls
> > 
> 
> Hi Ryo,
> 
> I quickly looked at the xls sheet. Most of the test cases seem to be
> direct IO. Have you done testing with buffered writes/async writes and
> been able to provide service differentiation between cgroups?
> 
> For example, two "dd" threads running in two cgroups doing writes.
> 

Just realized that last time I replied to wrong mail id. Ryo, this time
you should get the mail. This is reply to my original reply.

Also I wanted to test run your patches. How do I do that? I see that your
patches are based on dm quilt tree. I downloaded the dm-patches and tried
to apply on top of 2.6.30-rc1 but it failed. So can't apply your patches
now.

So what's the simplest way of testing your changes on latest kernels?

Thanks
Vivek

Applying patch dm-add-request-based-facility.patch
patching file drivers/md/dm-table.c
Hunk #1 succeeded at 1021 (offset 29 lines).
patching file drivers/md/dm.c
Hunk #1 succeeded at 90 (offset 6 lines).
Hunk #2 succeeded at 175 (offset -1 lines).
Hunk #3 succeeded at 427 (offset 6 lines).
Hunk #4 succeeded at 648 (offset 10 lines).
Hunk #5 succeeded at 1246 with fuzz 2 (offset 20 lines).
Hunk #6 succeeded at 1273 (offset 3 lines).
Hunk #7 succeeded at 1615 with fuzz 1 (offset 20 lines).
Hunk #8 succeeded at 2016 with fuzz 1 (offset 14 lines).
Hunk #9 succeeded at 2141 (offset 33 lines).
Hunk #10 FAILED at 2321.
Hunk #11 FAILED at 2336.
Hunk #12 succeeded at 2388 with fuzz 2 (offset 29 lines).
2 out of 12 hunks FAILED -- rejects in file drivers/md/dm.c
patching file drivers/md/dm.h
patching file include/linux/device-mapper.h
Hunk #1 succeeded at 230 (offset -1 lines).
Patch dm-add-request-based-facility.patch does not apply (enforce with -f)

> Thanks
> Vivek
