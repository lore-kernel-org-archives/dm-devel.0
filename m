From: Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: Do we support ioprio on SSDs with NCQ (Was: Re: IO
	scheduler based IO controller V10)
Date: Tue, 6 Oct 2009 11:00:48 +0200
Message-ID: <4e5e476b0910060200i7c028b3fr4c235bf5f18c3aa1@mail.gmail.com>
References: <20091002195815.GE4494@redhat.com>
	<20091002222756.GG4494@redhat.com>
	<4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com>
	<20091003133810.GC12925@redhat.com>
	<4e5e476b0910040215m35af5c99pf2c3a463a5cb61dd@mail.gmail.com>
	<20091004121122.GB18778@redhat.com>
	<4e5e476b0910040546h5f77cd1fo3172fe5c229eb579@mail.gmail.com>
	<x49my457uef.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0910051409x33f8365flf32e8e7548d72e79@mail.gmail.com>
	<20091006084120.GJ5216@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091006084120.GJ5216@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, Jeff Moyer <jmoyer@redhat.com>, nauman@google.com, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, Valdis.Kletnieks@vt.edu, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Tue, Oct 6, 2009 at 10:41 AM, Jens Axboe <jens.axboe@oracle.com> wrote=
:
> On Mon, Oct 05 2009, Corrado Zoccolo wrote:
>> On Mon, Oct 5, 2009 at 5:06 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> > It stands for residual, not residency. =C2=A0Make more sense?
>> It makes sense when computed, but not when used in rb_key computation.
>> Why should we postpone queues that where preempted, instead of giving
>> them a boost?
>
> We should not, if it is/was working correctly, it should allow both for
> increase/descrease of tree position (hence it's a long and can go
> negative) to account for both over and under time.

I'm doing some tests with and without it.
How it is working now is:
definition:
        if (timed_out && !cfq_cfqq_slice_new(cfqq)) {
                cfqq->slice_resid =3D cfqq->slice_end - jiffies;
                cfq_log_cfqq(cfqd, cfqq, "resid=3D%ld",
cfqq->slice_resid);
        }
* here resid is > 0 if there was residual time, and < 0 if the queue
overrun its slice.
use:
                rb_key =3D cfq_slice_offset(cfqd, cfqq) + jiffies;
                rb_key +=3D cfqq->slice_resid;
                cfqq->slice_resid =3D 0;
* here if residual is > 0, we postpone, i.e. penalize.  If residual is
< 0 (i.e. the queue overrun), we anticipate it, i.e. we boost it.

So this is likely not what we want.
I did some tests with and without it, or changing the sign, and it
doesn't matter at all for pure sync workloads.

The only case in which it matters a little, from my experiments, is
for sync vs async workload. Here, since async queues are preempted,
the current form of the code penalizes them, so they get larger
delays, and we get more bandwidth for sync.
This is, btw, the only positive outcome (I can think of) from the
current form of the code, and I think we could obtain it more easily
by unconditionally adding a delay for async queues:
                rb_key =3D cfq_slice_offset(cfqd, cfqq) + jiffies;
		if (!cfq_cfqq_sync(cfqq)) {
                        rb_key +=3D CFQ_ASYNC_DELAY;
	        }

removing completely the resid stuff (or at least leaving us with the
ability of using it with the proper sign).

Corrado
>
> --
> Jens Axboe
>
>
