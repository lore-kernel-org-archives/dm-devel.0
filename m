From: Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: IO scheduler based IO controller V10
Date: Sat, 3 Oct 2009 11:12:45 +0200
Message-ID: <4e5e476b0910030212y50f97d97nc2e17c35d855cc63@mail.gmail.com>
References: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	<20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu>
	<20091002173732.GK31616@kernel.dk>
	<1254507215.8667.7.camel@marge.simson.net>
	<20091002181903.GN31616@kernel.dk>
	<1254548931.8299.18.camel@marge.simson.net>
	<1254549378.8299.21.camel@marge.simson.net>
	<20091003072401.GV31616@kernel.dk>
	<1254560434.17052.14.camel@marge.simson.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254560434.17052.14.camel@marge.simson.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Galbraith <efault@gmx.de>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, Jens Axboe <jens.axboe@oracle.com>, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>, mikew@google.com, jmoyer@redhat.com, nauman@google.com, Ingo Molnar <mingo@elte.hu>, Vivek Goyal <vgoyal@redhat.com>, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: dm-devel.ids

Hi,
On Sat, Oct 3, 2009 at 11:00 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Sat, 2009-10-03 at 09:24 +0200, Jens Axboe wrote:
>
>> After shutting down the computer yesterday, I was thinking a bit about
>> this issue and how to solve it without incurring too much delay. If we
>> add a stricter control of the depth, that may help. So instead of
>> allowing up to max_quantum (or larger) depths, only allow gradual buil=
d
>> up of that the farther we get away from a dispatch from the sync IO
>> queues. For example, when switching to an async or seeky sync queue,
>> initially allow just 1 in flight. For the next round, if there still
>> hasn't been sync activity, allow 2, then 4, etc. If we see sync IO que=
ue
>> again, immediately drop to 1.
>>

I would limit just async I/O. Seeky sync queues are automatically
throttled by being sync, and have already high latency, so we
shouldn't increase it artificially. I think, instead, that we should
send multiple seeky requests (possibly coming from different queues)
at once. They will help especially with raid devices, where the seeks
for requests going to different disks will happen in parallel.

>> It could tie in with (or partly replace) the overload feature. The key
>> to good latency and decent throughput is knowing when to allow queue
>> build up and when not to.
>
> Hm. =C2=A0Starting at 1 sounds a bit thin (like IDLE), multiple iterati=
ons to
> build/unleash any sizable IO, but that's just my gut talking.
>
On the other hand, sending 1 write first and then waiting it to
complete before submitting new ones, will help performing more merges,
so the subsequent requests will be bigger and thus more efficient.

Corrado

> =C2=A0 =C2=A0 =C2=A0 =C2=A0-Mike
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>



--=20
_________________________________________________________________________=
_

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
-------------------------------------------------------------------------=
-
