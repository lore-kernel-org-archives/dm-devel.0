From: Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: IO scheduler based IO controller V10
Date: Sun, 27 Sep 2009 19:00:08 +0200
Message-ID: <4e5e476b0909271000u69d79346s27cccad219e49902@mail.gmail.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	 <4ABC28DE.7050809@datenparkplatz.de>
	 <20090925202636.GC15007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753406AbZI0RAH@vger.kernel.org>
In-Reply-To: <20090925202636.GC15007@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com, jens.axboe@oracle.com
List-Id: dm-devel.ids

Hi Vivek,
On Fri, Sep 25, 2009 at 10:26 PM, Vivek Goyal <vgoyal@redhat.com> wrote=
:
> On Fri, Sep 25, 2009 at 04:20:14AM +0200, Ulrich Lukas wrote:
>> Vivek Goyal wrote:
>> > Notes:
>> > - With vanilla CFQ, random writers can overwhelm a random reader.
>> > =C2=A0 Bring down its throughput and bump up latencies significant=
ly.
>>
>>
>> IIRC, with vanilla CFQ, sequential writing can overwhelm random read=
ers,
>> too.
>>
>> I'm basing this assumption on the observations I made on both OpenSu=
se
>> 11.1 and Ubuntu 9.10 alpha6 which I described in my posting on LKML
>> titled: "Poor desktop responsiveness with background I/O-operations"=
 of
>> 2009-09-20.
>> (Message ID: 4AB59CBB.8090907@datenparkplatz.de)
>>
>>
>> Thus, I'm posting this to show that your work is greatly appreciated=
,
>> given the rather disappointig status quo of Linux's fairness when it
>> comes to disk IO time.
>>
>> I hope that your efforts lead to a change in performance of current
>> userland applications, the sooner, the better.
>>
> [Please don't remove people from original CC list. I am putting them =
back.]
>
> Hi Ulrich,
>
> I quicky went through that mail thread and I tried following on my
> desktop.
>
> ##########################################
> dd if=3D/home/vgoyal/4G-file of=3D/dev/null &
> sleep 5
> time firefox
> # close firefox once gui pops up.
> ##########################################
>
> It was taking close to 1 minute 30 seconds to launch firefox and dd g=
ot
> following.
>
> 4294967296 bytes (4.3 GB) copied, 100.602 s, 42.7 MB/s
>
> (Results do vary across runs, especially if system is booted fresh. D=
on't
> =C2=A0know why...).
>
>
> Then I tried putting both the applications in separate groups and ass=
ign
> them weights 200 each.
>
> ##########################################
> dd if=3D/home/vgoyal/4G-file of=3D/dev/null &
> echo $! > /cgroup/io/test1/tasks
> sleep 5
> echo $$ > /cgroup/io/test2/tasks
> time firefox
> # close firefox once gui pops up.
> ##########################################
>
> Now I firefox pops up in 27 seconds. So it cut down the time by 2/3.
>
> 4294967296 bytes (4.3 GB) copied, 84.6138 s, 50.8 MB/s
>
> Notice that throughput of dd also improved.
>
> I ran the block trace and noticed in many a cases firefox threads
> immediately preempted the "dd". Probably because it was a file system
> request. So in this case latency will arise from seek time.
>
> In some other cases, threads had to wait for up to 100ms because dd w=
as
> not preempted. In this case latency will arise both from waiting on q=
ueue
> as well as seek time.

I think cfq should already be doing something similar, i.e. giving
100ms slices to firefox, that alternate with dd, unless:
* firefox is too seeky (in this case, the idle window will be too small=
)
* firefox has too much think time.

To rule out the first case, what happens if you run the test with your
"fairness for seeky processes" patch?
To rule out the second case, what happens if you increase the slice_idl=
e?

Thanks,
Corrado

>
> With cgroup thing, We will run 100ms slice for the group in which fir=
efox
> is being launched and then give 100ms uninterrupted time slice to dd.=
 So
> it should cut down on number of seeks happening and that's why we pro=
bably
> see this improvement.
>
> So grouping can help in such cases. May be you can move your X sessio=
n in
> one group and launch the big IO in other group. Most likely you shoul=
d
> have better desktop experience without compromising on dd thread outp=
ut.

> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>



--=20
_______________________________________________________________________=
___

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.co=
m
PhD - Department of Computer Science - University of Pisa, Italy
-----------------------------------------------------------------------=
---
