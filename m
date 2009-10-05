From: Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: Do we support ioprio on SSDs with NCQ (Was: Re: IO
	scheduler based IO controller V10)
Date: Mon, 5 Oct 2009 23:21:34 +0200
Message-ID: <4e5e476b0910051421n6a3b7797xe416cc790d38b124@mail.gmail.com>
References: <20091002154020.GC4494@redhat.com>
	<20091002195815.GE4494@redhat.com>
	<4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com>
	<20091002222756.GG4494@redhat.com>
	<4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com>
	<20091003133810.GC12925@redhat.com>
	<4e5e476b0910040215m35af5c99pf2c3a463a5cb61dd@mail.gmail.com>
	<20091004121122.GB18778@redhat.com>
	<4e5e476b0910040546h5f77cd1fo3172fe5c229eb579@mail.gmail.com>
	<20091004162005.GH4650@gandalf.sssup.it>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091004162005.GH4650@gandalf.sssup.it>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Fabio Checconi <fchecconi@gmail.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, Jens Axboe <jens.axboe@oracle.com>, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, Valdis.Kletnieks@vt.edu, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Sun, Oct 4, 2009 at 6:20 PM, Fabio Checconi <fchecconi@gmail.com> wrote:
> But if the ``always ready to perform I/O'' assumption held then even RR
> would have provided service differentiation, always seeing backlogged
> queues and serving them according to their weights.

Right, this property is too strong. But also a weaker "the two queues
have think times less than the disk access time" will be enough to
achieve the same goal by means of proper placement in the RR tree.

If both think times are greater than access time, then each queue will
get a service level equivalent to it being the only queue in the
system, so in this case service differentiation will not apply (do we
need to differentiate when everyone gets exactly what he needs?).

If one think time is less, and the other is more than the access time,
then we should decide what kind of fairness we want to have,
especially if the one with larger think time has also higher priority.

> In this case the problem is what Vivek described some time ago as the
> interlocked service of sync queues, where the scheduler is trying to
> differentiate between the queues, but they are not always asking for
> service (as they are synchronous and they are backlogged only for short
> time intervals).

Corrado
