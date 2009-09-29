From: Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: IO scheduler based IO controller V10
Date: Tue, 29 Sep 2009 09:14:48 +0200
Message-ID: <4e5e476b0909290014u1374e65an859528441373510f@mail.gmail.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	 <4ABC28DE.7050809@datenparkplatz.de>
	 <20090925202636.GC15007@redhat.com>
	 <4e5e476b0909271000u69d79346s27cccad219e49902@mail.gmail.com>
	 <20090928145655.GB8192@redhat.com>
	 <4e5e476b0909280835w3410d58aod93a29d1dcda8909@mail.gmail.com>
	 <1254160274.9820.25.camel@marge.simson.net>
	 <20090928181846.GC3643@redhat.com>
	 <1254164034.9820.81.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753483AbZI2HOp@vger.kernel.org>
In-Reply-To: <1254164034.9820.81.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com, jens.axboe@oracle.com, Tobias Oetiker <tobi@oetiker.ch>
List-Id: dm-devel.ids

Hi Mike,
On Mon, Sep 28, 2009 at 8:53 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Mon, 2009-09-28 at 14:18 -0400, Vivek Goyal wrote:
>> On Mon, Sep 28, 2009 at 07:51:14PM +0200, Mike Galbraith wrote:
>
>> I guess changing class to IDLE should have helped a bit as now this =
is
>> equivalent to setting the quantum to 1 and after dispatching one req=
uest
>> to disk, CFQ will always expire the writer once. So it might happen =
that
>> by the the reader preempted writer, we have less number of requests =
in
>> disk and lesser latency for this reader.
>
> I expected SCHED_IDLE to be better than setting quantum to 1, because
> max is quantum*4 if you aren't IDLE. =C2=A0But that's not what happen=
ed. =C2=A0I
> just retested with all knobs set back to stock, fairness off, and
> quantum set to 1 with everything running nice 0. =C2=A02.8 seconds av=
g :-/

Idle doesn't work very well for async writes, since the writer process
will just send its writes to the page cache.
The real writeback will happen in the context of a kernel thread, with
best effort scheduling class.

>
>> > I saw
>> > the reference to Vivek's patch, and gave it a shot. =C2=A0Makes a =
large
>> > difference.
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0A=
vg
>> > perf stat =C2=A0 =C2=A0 12.82 =C2=A0 =C2=A0 7.19 =C2=A0 =C2=A0 8.4=
9 =C2=A0 =C2=A0 5.76 =C2=A0 =C2=A0 9.32 =C2=A0 =C2=A08.7 =C2=A0 =C2=A0 =
anticipatory
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 16.24 =C2=A0 175.=
82 =C2=A0 154.38 =C2=A0 228.97 =C2=A0 147.16 =C2=A0144.5 =C2=A0 =C2=A0 =
noop
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 43.23 =C2=A0 =C2=A0=
57.39 =C2=A0 =C2=A096.13 =C2=A0 148.25 =C2=A0 180.09 =C2=A0105.0 =C2=A0=
 =C2=A0 deadline
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A09.15 =C2=A0=
 =C2=A014.51 =C2=A0 =C2=A0 9.39 =C2=A0 =C2=A015.06 =C2=A0 =C2=A0 9.90 =C2=
=A0 11.6 =C2=A0 =C2=A0 cfq fairness=3D0 dd=3Dnice 0
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 12.22 =C2=A0 =C2=A0=
 9.85 =C2=A0 =C2=A012.55 =C2=A0 =C2=A0 9.88 =C2=A0 =C2=A015.06 =C2=A0 1=
1.9 =C2=A0 =C2=A0 cfq fairness=3D0 dd=3Dnice 19
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A09.77 =C2=A0=
 =C2=A013.19 =C2=A0 =C2=A011.78 =C2=A0 =C2=A017.40 =C2=A0 =C2=A0 9.51 =C2=
=A0 11.9 =C2=A0 =C2=A0 cfq fairness=3D0 dd=3DSCHED_IDLE
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A04.59 =C2=A0=
 =C2=A0 2.74 =C2=A0 =C2=A0 4.70 =C2=A0 =C2=A0 3.45 =C2=A0 =C2=A0 4.69 =C2=
=A0 =C2=A04.0 =C2=A0 =C2=A0 cfq fairness=3D1 dd=3Dnice 0
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03.79 =C2=A0=
 =C2=A0 4.66 =C2=A0 =C2=A0 2.66 =C2=A0 =C2=A0 5.15 =C2=A0 =C2=A0 3.03 =C2=
=A0 =C2=A03.8 =C2=A0 =C2=A0 cfq fairness=3D1 dd=3Dnice 19
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A02.79 =C2=A0=
 =C2=A0 4.73 =C2=A0 =C2=A0 2.79 =C2=A0 =C2=A0 4.02 =C2=A0 =C2=A0 2.50 =C2=
=A0 =C2=A03.3 =C2=A0 =C2=A0 cfq fairness=3D1 dd=3DSCHED_IDLE
>> >
>>
>> Hmm.., looks like average latency went down only in =C2=A0case of fa=
irness=3D1
>> and not in case of fairness=3D0. (Looking at previous mail, average =
vanilla
>> cfq latencies were around 12 seconds).
>
> Yup.
>
>> Are you running all this in root group or have you put writers and r=
eaders
>> into separate cgroups?
>
> No cgroups here.
>
>> If everything is running in root group, then I am curious why latenc=
y went
>> down in case of fairness=3D1. The only thing fairness=3D1 parameter =
does is
>> that it lets complete all the requests from previous queue before st=
art
>> dispatching from next queue. On top of this is valid only if no pree=
mption
>> took place. In your test case, konsole should preempt the writer so
>> practically fairness=3D1 might not make much difference.
>
> fairness=3D1 very definitely makes a very large difference. =C2=A0All=
 of those
> cfq numbers were logged in back to back runs.
>
>> In fact now Jens has committed a patch which achieves the similar ef=
fect as
>> fairness=3D1 for async queues.
>
> Yeah, I was there yesterday. =C2=A0I speculated that that would hurt =
my
> reader, but rearranging things didn't help one bit. =C2=A0Playing wit=
h merge,
> I managed to give dd ~7% more throughput, and injured poor reader eve=
n
> more. =C2=A0(problem analysis via hammer/axe not always most effectiv=
e;)
>
>> commit 5ad531db6e0f3c3c985666e83d3c1c4d53acccf9
>> Author: Jens Axboe <jens.axboe@oracle.com>
>> Date: =C2=A0 Fri Jul 3 12:57:48 2009 +0200
>>
>> =C2=A0 =C2=A0 cfq-iosched: drain device queue before switching to a =
sync queue
>>
>> =C2=A0 =C2=A0 To lessen the impact of async IO on sync IO, let the d=
evice drain of
>> =C2=A0 =C2=A0 any async IO in progress when switching to a sync cfqq=
 that has idling
>> =C2=A0 =C2=A0 enabled.
>>
>>
>> If everything is in separate cgroups, then we should have seen laten=
cy
>> improvements in case of fairness=3D0 case also. I am little perplexe=
d here..
>>
>> Thanks
>> Vivek
>
>

Thanks,
Corrado


--=20
_______________________________________________________________________=
___

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.co=
m
PhD - Department of Computer Science - University of Pisa, Italy
-----------------------------------------------------------------------=
---
The self-confidence of a warrior is not the self-confidence of the aver=
age
man. The average man seeks certainty in the eyes of the onlooker and ca=
lls
that self-confidence. The warrior seeks impeccability in his own eyes a=
nd
calls that humbleness.
                               Tales of Power - C. Castaneda
