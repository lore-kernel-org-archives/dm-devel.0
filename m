From: Ray Lee <ray-lk@madrabbit.org>
Subject: Re: IO scheduler based IO controller V10
Date: Fri, 2 Oct 2009 09:33:44 -0700
Message-ID: <2c0942db0910020933l6d312c6ahae0e00619f598b39@mail.gmail.com>
References: <1254340730.7695.32.camel@marge.simson.net> <20090930202447.GA28236@redhat.com>
	<1254382405.7595.9.camel@marge.simson.net> <20091001185816.GU14918@kernel.dk>
	<1254464628.7158.101.camel@marge.simson.net> <20091002080417.GG14918@kernel.dk>
	<20091002092409.GA19529@elte.hu> <20091002092839.GA26962@kernel.dk>
	<alpine.LFD.2.01.0910020715160.6996@localhost.localdomain>
	<20091002145610.GD31616@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756641AbZJBQeC@vger.kernel.org>
In-Reply-To: <20091002145610.GD31616@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, riel@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 2, 2009 at 7:56 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> In some cases I wish we had a server vs desktop switch, since it would
> decisions on this easier. I know you say that servers care about
> latency, but not at all to the extent that desktops do. Most desktop
> users would gladly give away the top of the performance for latency,
> that's not true of most server users. Depends on what the server does,
> of course.

If most of the I/O on a system exhibits seeky tendencies, couldn't the
schedulers notice that and use that as the hint for what to optimize?

I mean, there's no switch better than the actual I/O behavior itself.
