From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: Re: [PATCH 1/2] dm-ioband: I/O bandwidth controller
	v1.10.0: Source code and patch
Date: Wed, 21 Jan 2009 22:03:56 +0900 (JST)
Message-ID: <20090121.220356.39155811.ryov@valinux.co.jp>
References: <20090120.141022.193708059.ryov@valinux.co.jp>
	<20090120.141114.226778416.ryov@valinux.co.jp>
	<20090120145208.GE9859@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090120145208.GE9859@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair,

Thank you for reviewing and giving me suggestions.

> On Tue, Jan 20, 2009 at 02:11:14PM +0900, Ryo Tsuruta wrote:
> > This patch is the dm-ioband version 1.10.0 release.
>  
> drivers/md/dm-ioband-ctl.c:194:2: warning: context problem in 'suspend_ioband_device': '_spin_unlock_irqrestore' expected different c
> ontext
> drivers/md/dm-ioband-ctl.c:194:2:    context 'lock': wanted >= 1, got 0
> drivers/md/dm-ioband-ctl.c:608:3: warning: context problem in 'prevent_burst_bios': '_spin_unlock_irq' expected different context
> drivers/md/dm-ioband-ctl.c:608:3:    context 'lock': wanted >= 1, got 0
> 
> 
> Last time we had something like that, it was straightforward to restructure the
> functions to avoid it - see if you can manage that here too.

I'm trying to suppress these warnings, but the latest sparse command
(2009-01-21) doesn't seem to interpret __acquires() and __releases()
macros properly.

I wrote the following sample code and tested with sparse-0.4.1 and
sparse-2009-01-21.

  static void foo(struct ioband_device *dp, unsigned long flags)
  {
          spin_unlock_irqrestore(&dp->g_lock, flags);
  }

The both sparse commands issued warnings as I expected.

  sparse-0.4.1
    CHECK   /home/ryov/work/dm-ioband/dm-ioband/src/dm-ioband-ctl.c
  /home/ryov/work/dm-ioband/dm-ioband/src/dm-ioband-ctl.c:171:13:
    warning: context imbalance in 'foo' - unexpected unlock

  sparse-2009-01-21
  /home/ryov/work/dm-ioband/dm-ioband/src/dm-ioband-ctl.c:173:2:
  warning: context problem in 'foo': '_spin_unlock_irqrestore'
    expected different context
  /home/ryov/work/dm-ioband/dm-ioband/src/dm-ioband-ctl.c:173:2:
    context 'lock': wanted >= 1, got 0

Next, I added a __releases() macro and tested again.

  static void foo(struct ioband_device *dp, unsigned long flags)
	__releases(dp->g_lock)
  {
          spin_unlock_irqrestore(&dp->g_lock, flags);
  }

Only sparse-2009-01-21 still issued the warning.

  CHECK   /home/ryov/work/dm-ioband/dm-ioband/src/dm-ioband-ctl.c
  /home/ryov/work/dm-ioband/dm-ioband/src/dm-ioband-ctl.c:174:2:
    warning: context problem in 'foo': '_spin_unlock_irqrestore'
    expected different context
  /home/ryov/work/dm-ioband/dm-ioband/src/dm-ioband-ctl.c:174:2:
    context 'lock': wanted >= 1, got 0

Could you tell me which sparse version are you using?

Thanks,
Ryo Tsuruta
