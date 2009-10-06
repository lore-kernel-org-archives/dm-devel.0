From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Do we support ioprio on SSDs with NCQ (Was: Re: IO
	scheduler based IO controller V10)
Date: Tue, 6 Oct 2009 10:41:20 +0200
Message-ID: <20091006084120.GJ5216@kernel.dk>
References: <20091002195815.GE4494@redhat.com>
	<4e5e476b0910021514i1b461229t667bed94fd67f140@mail.gmail.com>
	<20091002222756.GG4494@redhat.com>
	<4e5e476b0910030543o776fb505ka0ce38da9d83b33c@mail.gmail.com>
	<20091003133810.GC12925@redhat.com>
	<4e5e476b0910040215m35af5c99pf2c3a463a5cb61dd@mail.gmail.com>
	<20091004121122.GB18778@redhat.com>
	<4e5e476b0910040546h5f77cd1fo3172fe5c229eb579@mail.gmail.com>
	<x49my457uef.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0910051409x33f8365flf32e8e7548d72e79@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4e5e476b0910051409x33f8365flf32e8e7548d72e79@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, Jeff Moyer <jmoyer@redhat.com>, nauman@google.com, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, Valdis.Kletnieks@vt.edu, containers@lists.linux-foundation.org, Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Mon, Oct 05 2009, Corrado Zoccolo wrote:
> On Mon, Oct 5, 2009 at 5:06 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> > Corrado Zoccolo <czoccolo@gmail.com> writes:
> >
> >> Moreover, I suggest removing also the slice_resid part, since its
> >> semantics doesn't seem consistent.
> >> When computed, it is not the residency, but the remaining time slice=
.
> >
> > It stands for residual, not residency. =A0Make more sense?
> It makes sense when computed, but not when used in rb_key computation.
> Why should we postpone queues that where preempted, instead of giving
> them a boost?

We should not, if it is/was working correctly, it should allow both for
increase/descrease of tree position (hence it's a long and can go
negative) to account for both over and under time.

--=20
Jens Axboe
