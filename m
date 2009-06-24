From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] io-controller: Preempt a non-rt queue if a rt ioq is
 present in ancestor or sibling groups
Date: Wed, 24 Jun 2009 17:20:33 +0800
Message-ID: <4A41EFE1.5050101@cn.fujitsu.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <1245443858-8487-21-git-send-email-vgoyal@redhat.com> <4A3F3648.7080007@cn.fujitsu.com> <20090622172123.GE15600@redhat.com> <4A4079B8.4020402@cn.fujitsu.com> <20090623140250.GA4262@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754927AbZFXJU7@vger.kernel.org>
In-Reply-To: <20090623140250.GA4262@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
> On Tue, Jun 23, 2009 at 02:44:08PM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> On Mon, Jun 22, 2009 at 03:44:08PM +0800, Gui Jianfeng wrote:
>>>> Preempt the ongoing non-rt ioq if there are rt ioqs waiting for di=
spatching
>>>> in ancestor or sibling groups. It will give other group's rt ioq a=
n chance=20
>>>> to dispatch ASAP.
>>>>
>>> Hi Gui,
>>>
>>> Will new preempton logic of traversing up the hiearchy so that both=
 new
>>> queue and old queue are at same level to take a preemption decision=
 not
>>> take care of above scenario?
>> Hi Vivek,
>>
>> Would you explain a bit what do you mean about "both new queue and o=
ld queue=20
>> are at same level to take a preemption decision". I don't understand=
 it well.
>>
>=20
> Consider following hierarchy.
>=20
> 			root
> 			/ |=20
> 		       A  1  =20
> 		       |=20
> 		       2=20
> In the above diagram, A is the group and "1" and "2" are two io queue=
s=20
> associated with tasks.
>=20
> Now assume that queue "1" is being served and queue "2" gets backlogg=
ed.
> Should queue 2 preempt queue 1 now?
>=20
> To take that decision, we need to do the comparision between type of
> entity of group A and queue 1 (That is at the same level or IOW, the
> entities in question have the same parent). If group A is of class RT=
 and
> queue 1 is of type BE then queue 2 should preempt queue 1 otherwise n=
ot.
>=20
> Hence in hierarchical setups to take a preemption decision, compariso=
n
> should be done at same level.

  So what bfq_find_matching_entity has done is going to figure out the =
same
  level entities=EF=BC=8C in turn, taking the decision.

>=20
>>> Please have a look at bfq_find_matching_entity().
>>>
>>> At the same time we probably don't want to preempt the non-rt queue
>>> with an RT queue in sibling group until and unless sibling group is=
 an
>>> RT group.
>>>
>>> 		root
>>> 		/  \
>>> 	   BEgrpA  BEgrpB
>>> 	      |     |=09
>>> 	  BEioq1   RTioq2
>>>
>>> Above we got two BE group A and B and assume ioq in group A is bein=
g
>>> served and then an RT request in group B comes. Because group B is =
an
>>> BE class group, we should not preempt the queue in group A.
>>   Yes, i also have this concern. So, it does not allow non-rt group =
preempts
>>   another group. I'll check whether there is a way to address this i=
ssue.
>>
>=20
> So here also assume ioq1 is being served and ioq2 gets backlogged. To
> decide whether ioq2 should preempt ioq1 or not, one needs to go up th=
e=20
> hiearchy till two paths share the parent. That means one needs to go =
up
> at the BEgrpA and BEgrpB level where they have common parent "root". =
Now
> both the groups are of class BE hence ioq2 should not preempt ioq1.
>=20
> Hope it helps.

  Thanks, it's very helpful.

  I have a thought now. Whether we can maintain a rt ioq list in efqd, =
and=20
  elv_fq_select_ioq() travels this list to take preemtion decision for =
each
  available rt ioqs at the same level(by using bfq_find_matching_entity=
).
  I'd like to try it out.

>=20
> Thanks
> Vivek
>=20
>=20
>=20

--=20
Regards
Gui Jianfeng
