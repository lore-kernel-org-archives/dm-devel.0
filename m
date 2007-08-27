From: Hannes Reinecke <hare@suse.de>
Subject: Re: Designing a new prio_callout
Date: Mon, 27 Aug 2007 17:09:29 +0200
Message-ID: <46D2E929.4080905@suse.de>
References: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>	<46A735E1.4070206@suse.de>	<d61540a40707290903q359cc7c8g52f07627b4b9fba7@mail.gmail.com>	<46AD85A5.1060609@suse.de>	<d61540a40708091055u725fa5e4wa182ac1d778323be@mail.gmail.com>	<46BC7F14.80302@suse.de>	<d61540a40708100840m541e198dg88c12d031febf968@mail.gmail.com>
	<d61540a40708141005n4eb06cebx14559f055b0df3d6@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d61540a40708141005n4eb06cebx14559f055b0df3d6@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Ethan John wrote:
> For the record, setting rr_min_io to something extremely large (we're u=
sing
> 2 billion now, since I'm assuming it's a C integer) solves the immediat=
e
> problem that we're having (overhead in path switching causing poor
> performance). Telling people to use mpath_prio_random is still less tha=
n
> ideal for any small number of iSCSI targets, but it a better short-term
> solution for us than nothing.
>=20
In setting rr_min_io to something extremely large you effectively
disable the round-robin scheduler in multipathing.
That's okay for the failover scenario you have (as you only have
one path per group), but whenever you have more than one path
in a group that wouldn't work anymore.

> On 8/10/07, Ethan John <ethan.john@gmail.com> wrote:
>> Hannes, thanks again for your help with this.
>>
>> I haven't noticed that failback does the right thing, but I'll try it =
out
>> again. Could be something we're doing wrong. In any case, there's very
>> little documentation on all this, and I'm trying to develop some kind =
of
>> strategy for our Linux customers to use until we get ALUA implemented.
>>
>> Being able to set path priorities manually would be ideal, but it seem=
s
>> like this is impossible, right?
>>
>> Here's the situation we have right now. I initiate two connections to =
one
>> target, across two sessions with two different IPs, with two LUs. Mult=
ipath
>> looks like this:
>> mpath45 (20002c9020020001a00151b6b46bb57b0) dm-1 company,iSCSI target
>> [size=3D15G][features=3D0][hwhandler=3D0]
>> \_ round-robin 0 [prio=3D1][active]
>>  \_ 22:0:0:1 sdc 8:32  [active][ready]
>> \_ round-robin 0 [prio=3D1][enabled]
>>  \_ 23:0:0:1 sde 8:64  [active][ready]
>> mpath44 (20002c9020020001200151b6b46bb57ae) dm-0 company,iSCSI target
>> [size=3D15G][features=3D0][hwhandler=3D0]
>> \_ round-robin 0 [prio=3D1][enabled]
>>  \_ 22:0:0:0 sdb 8:16  [active][ready]
>> \_ round-robin 0 [prio=3D1][enabled]
>>  \_ 23:0:0:0 sdd 8:48  [active][ready]
>>
>> Note that there are only two active sessions:
>> # iscsiadm -m session
>> tcp: [20] 10.53.152.22:3260 ,1 iqn.2001-07.com.company:qaiscsi2:blah1
>> tcp: [21] 10.53.152.23:3260,2 iqn.2001-07.com.company:qaiscsi2:blah1
>>
>> So the result is that all activity is routed to the first session that=
 was
>> initiated. I want to change the priorities of the paths to allow for t=
raffic
>> to go to the first IP for mpath45 and the second IP for mpath46.
>>
That's a matter of the IP routing. Having both target on the same (sub-) =
net
doesn't work very well with multipathing. Please setup your system with
each iSCSI Target port in a different subnet eg

10.53.152.22:3260,1 iqn.2001-07.com.company:qaiscsi2:blah1
10.53.153.22:3260,2 iqn.2001-07.com.company:qaiscsi2:blah1

then you'll have one iSCSI target port per subnet and you can actually
do failover etc.

>> Obviously ALUA is the way to go for this in the future, but we won't h=
ave
>> the resources to implement that, so I'm looking for an interim solutio=
n that
>> will scale to thousands of clients. Right now, the only thing I can te=
ll
>> people is to manually initiate connections to certain targets through
>> certain IP addresses -- basically, doing the load balancing themselves=
. Is
>> there a better way?
>>
No, not really. But I'm not a network guru. You may want to ask on
the open-iscsi mailing list.

And you can get all information you need via sysfs, so it should
be possible to create a script like Stefan Bader suggested.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
