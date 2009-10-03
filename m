From: Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: IO scheduler based IO controller V10
Date: Sat, 3 Oct 2009 11:01:35 +0200
Message-ID: <4e5e476b0910030201k23760da4ke7d6d08662382cf1@mail.gmail.com>
References: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	 <20091002172046.GA2376@elte.hu> <20091002172554.GJ31616@kernel.dk>
	 <20091002172842.GA4884@elte.hu> <20091002173732.GK31616@kernel.dk>
	 <1254507215.8667.7.camel@marge.simson.net>
	 <20091002181903.GN31616@kernel.dk>
	 <1254548931.8299.18.camel@marge.simson.net>
	 <20091003072021.GB21407@elte.hu> <20091003072540.GW31616@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754261AbZJCJBd@vger.kernel.org>
In-Reply-To: <20091003072540.GW31616@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>, Linus Torvalds <torvalds@linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com, akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com, riel@redhat.com
List-Id: dm-devel.ids

Hi Jens,
On Sat, Oct 3, 2009 at 9:25 AM, Jens Axboe <jens.axboe@oracle.com> wrot=
e:
> On Sat, Oct 03 2009, Ingo Molnar wrote:
>>
>> * Mike Galbraith <efault@gmx.de> wrote:
>>
>> > =C2=A0 =C2=A0 unsigned int cfq_desktop;
>> > + =C2=A0 unsigned int cfq_desktop_dispatch;
>>
>> > - =C2=A0 if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_=
RW_ASYNC])
>> > + =C2=A0 if (cfq_cfqq_idle_window(cfqq) && cfqd->rq_in_driver[BLK_=
RW_ASYNC]) {
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cfqd->desktop_dispatch_ts =3D=
 jiffies;
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
>> > + =C2=A0 }
>>
>> btw., i hope all those desktop_ things will be named latency_ pretty
>> soon as the consensus seems to be - the word 'desktop' feels so wron=
g in
>> this context.
>>
>> 'desktop' is a form of use of computers and the implication of good
>> latencies goes far beyond that category of systems.
>
> I will rename it, for now it doesn't matter (lets not get bogged down=
 in
> bike shed colors, please).
>
> Oh and Mike, I forgot to mention this in the previous email - no more
> tunables, please. We'll keep this under a single knob.

Did you have a look at my http://patchwork.kernel.org/patch/47750/ ?
It already introduces a 'target_latency' tunable, expressed in ms.

If we can quantify the benefits of each technique, we could enable
them based on the target latency requested by that single tunable.

Corrado

>
> --
> Jens Axboe
>
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
