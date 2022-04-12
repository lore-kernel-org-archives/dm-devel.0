Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C947C433FE
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 11:17:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-jOyqnL5wOPiaNPx-DJkd9Q-1; Thu, 14 Apr 2022 07:17:29 -0400
X-MC-Unique: jOyqnL5wOPiaNPx-DJkd9Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F862811E83;
	Thu, 14 Apr 2022 11:17:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9A75D416141;
	Thu, 14 Apr 2022 11:17:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 638B21940344;
	Thu, 14 Apr 2022 11:17:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F2E2A1947BBF
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 12:05:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E439A145B99D; Tue, 12 Apr 2022 12:05:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DF7DD1454559
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 12:05:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C19E71014A63
 for <dm-devel@redhat.com>; Tue, 12 Apr 2022 12:05:48 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com
 [66.111.4.26]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-ceve60fdMMaqy95VVlWuGA-1; Tue, 12 Apr 2022 08:05:47 -0400
X-MC-Unique: ceve60fdMMaqy95VVlWuGA-1
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
 by mailout.nyi.internal (Postfix) with ESMTP id 108A95C026B;
 Tue, 12 Apr 2022 07:58:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute5.internal (MEProxy); Tue, 12 Apr 2022 07:58:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:date:date:from:from
 :in-reply-to:in-reply-to:message-id:mime-version:references
 :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
 :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1649764736; x=
 1649851136; bh=NloEnDJnrAKSyagIdYjGlawgykbvA1QT6E78uS6cnwY=; b=I
 TLM3ojwwc5m2F3a6iMb9ab9vuyaXjGizTNWqAVOsTK0tgpoDIUjdT0RYy0xTuY7Z
 l8qqvQ89h3YrijrgOek9/z1I8UF3qYbpOAP7nn7+DOpa38En2YDVoq5ffoZ7cZEA
 Y8TrvSVDEizUnbafJ+CQApXtOXLUHNmUeKM4phjpoIm4JQAE2A18aAIqaKXRrJz9
 24bmlOOQacW1byDqavawrZiVdtG2Htb9APLIUIwOIvF4noNfgIM7+ugr/dtw1XcR
 o6KYMzabnz8FLufV/3YHA4yUvQZyMT4bPsOk/yXgRfScxu0k9hjRMRvuC0n1xzjH
 sbod5pQI6j5EeoK61J7KQ==
X-ME-Sender: <xms:f2lVYqtqm98JDaTYYIwMtsVemddZpySx0JyzNDFAm25T9xSG_70d3Q>
 <xme:f2lVYvconL5RE32VoW3pDvDfFbPJrobgPlOb-_gJ3eXTue19yfsrJcjBjTqNTo3zl
 CNeAHVUYkz9Iv8>
X-ME-Received: <xmr:f2lVYlyzX2J7PjHGIZe8zjAsmYVLOv8bluDhybJIIM7TI9srPBJk1giCY5udmweL2Bh8nw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekkedggeehucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhepkfffgggfvfhfhffujggtsehgtderredtfeejnecuhfhrohhmpeffvghmihcu
 ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
 hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeefhfevgfffvdehvefhleeukefgueej
 tdduleeuleefkeegtdejtdfhudffvdfhleenucffohhmrghinhepghhithhhuhgsrdgtoh
 hmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepuggv
 mhhisehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:f2lVYlNyl0OwM1HgM_hQ6tUjIc5HYc3LbSiC4kRp3nkw-0pag3Ribg>
 <xmx:f2lVYq8D-nLRCo2KQoGN_DFPVX40EsU9HaYRqIgTvaMM1RdfcnGxbg>
 <xmx:f2lVYtVn_Tt521oz9iz1Zn7Ft712mzwpZhaS0kBlkjSe60oM1dKWCA>
 <xmx:gGlVYglV3fROrky98tcVaBotIHm4vKLQL2hZ36OL3oZPUwjd9wZseQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Apr 2022 07:58:55 -0400 (EDT)
Message-ID: <bef5869f-69f2-62e4-cd3d-f7b036c894b1@invisiblethingslab.com>
Date: Tue, 12 Apr 2022 07:58:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To: Zdenek Kabelac <zkabelac@redhat.com>, Joe Thornber <ejt@redhat.com>,
 David Teigland <teigland@redhat.com>
References: <YlNUhtXltj8vgvcZ@itl-email>
 <e65dbacc-f241-22ba-62a9-a6f522cce9dc@redhat.com>
 <YlRjvp7SH3To0pHe@itl-email>
 <cc43900d-35a3-14ae-73ef-919ab02e01ff@redhat.com>
 <YlSsMlcE5x2B58hc@itl-email>
 <6a6c09ad-73c9-2450-f1fb-0e3e4ba438e6@redhat.com>
From: Demi Marie Obenour <demi@invisiblethingslab.com>
In-Reply-To: <6a6c09ad-73c9-2450-f1fb-0e3e4ba438e6@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Thu, 14 Apr 2022 11:17:24 +0000
Subject: Re: [dm-devel] Potential enhancements to dm-thin v2
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Content-Type: multipart/mixed; boundary="===============4478554971896701971=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============4478554971896701971==
Content-Language: en-US
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------miQRKzzrL27akEzv4vI0D6k9"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------miQRKzzrL27akEzv4vI0D6k9
Content-Type: multipart/mixed; boundary="------------iDb0fvFJdriulBRmzzQPD7s3";
 protected-headers="v1"
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Zdenek Kabelac <zkabelac@redhat.com>, Joe Thornber <ejt@redhat.com>,
 David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com
Message-ID: <bef5869f-69f2-62e4-cd3d-f7b036c894b1@invisiblethingslab.com>
Subject: Re: [dm-devel] Potential enhancements to dm-thin v2
References: <YlNUhtXltj8vgvcZ@itl-email>
 <e65dbacc-f241-22ba-62a9-a6f522cce9dc@redhat.com>
 <YlRjvp7SH3To0pHe@itl-email>
 <cc43900d-35a3-14ae-73ef-919ab02e01ff@redhat.com>
 <YlSsMlcE5x2B58hc@itl-email>
 <6a6c09ad-73c9-2450-f1fb-0e3e4ba438e6@redhat.com>
In-Reply-To: <6a6c09ad-73c9-2450-f1fb-0e3e4ba438e6@redhat.com>

--------------iDb0fvFJdriulBRmzzQPD7s3
Content-Type: multipart/mixed; boundary="------------lSoBhXqgxLzMQsBuvbSgkLQn"

--------------lSoBhXqgxLzMQsBuvbSgkLQn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 4/12/22 05:32, Zdenek Kabelac wrote:
> Dne 12. 04. 22 v 0:30 Demi Marie Obenour napsal(a):
>> On Mon, Apr 11, 2022 at 10:16:43PM +0200, Zdenek Kabelac wrote:
>>> Dne 11. 04. 22 v 19:22 Demi Marie Obenour napsal(a):
>>>> On Mon, Apr 11, 2022 at 10:16:02AM +0200, Zdenek Kabelac wrote:
>>>>> Dne 11. 04. 22 v 0:03 Demi Marie Obenour napsal(a):
>>>>>
>>>>> Your proposal actually breaks this sequence and would move things t=
o the
>>>>> state of=C2=A0 'guess at which states we are now'. (and IMHO presen=
ts much more
>>>>> risk than virtual problem with suspend from user-space - which is o=
nly a
>>>>> problem if you are using suspended device as 'swap' and 'rootfs' - =
so there
>>>>> are very easy ways how to orchestrate your LVs to avoid such proble=
ms).
>>>> The intent is less =E2=80=9Cguess what states we are now=E2=80=9D an=
d more =E2=80=9CIt looks
>>>> like dm-thin already has the data structures needed to store some
>>>> per-thin metadata, and that could make writing a simple userspace vo=
lume
>>>> manager FAR FAR easier=E2=80=9D.  It appears to me that the only cha=
nge needed
>>>
>>> I do not spend hours explaining all the details - but running just th=
e
>>> suspend alone may result in many differnt problem where the things li=
ke
>>> running thin-pool out-of-data space is one of the easiest.
>>>
>>> Basically each step must be designed with=C2=A0 'power-off' happen du=
ring the
>>> operation. For each step you need to know how the recovery step looks=
 like
>>> and how the lvm2 & kernel metadata c/would match together.
>> That is absolutely the case, and is in fact the reason I proposed this=

>> change to begin with.  By having dm-thin store a small amount of
>> userspace-provided metadata for each thin volume, and by providing an
>> API to enumerate the thin volumes in a pool, I can store all of the
>> metadata I need in the thin pool itself.  This is much simpler than
>> having to store metadata outside of the pool.
>=20
> Hi
>=20
> Here is actually the fundamental problem with your proposal - our desig=
n was=20
> about careful split between user-space and kernel 'who is the owner/hol=
der of=20
> information'=C2=A0 - your proposal unfortunately does not fit the model=
 where lvm2=20
> is the authoritative owner of info about devices - =C2=A0 note - we als=
o tried the=20
> 'model' where the info is held within target - our mdraid=C2=A0 dm wrap=
per - but it=20
> has more troubles compared with very clear thin logic.=C2=A0 So from th=
e lvm2=20
> position - we do not have any plans to change this proven model.

This does not surprise me.  lvm2 already has the infrastructure to
store its own metadata and update it in a crash-safe way, so having the
kernel be able to store additional metadata would be of no benefit to
lvm2.  The intended use-case for this feature is tools that are dm-thin
specific, and which do not already have such infrastructure.

> What you are asking for is - that 'kernel' module is doing all the job =
- and=20
> lvm2 would be obtaining info from the kernel metadata - and eventually =
you=20
> would be able to command everything with ioctl() interface and letting =
the=20
> complexity sit completely in kernel - but as explained our design is he=
ading=20
> in opposite direction - what can be done in user-space stays in user sp=
ace and=20
> kernel does the necessary minimum, which can be then much easier develo=
ped and=20
> traced.
Not at all.  I just want userspace to be able to stash some data in
each thin and retrieve it later.  The complex logic would still remain
in userspace.  That=E2=80=99s why I dropped the =E2=80=9Clookup thin by b=
lob=E2=80=9D
functionality: it requires a new data structure in the kernel, and
userspace can achieve almost the same effect with a cache.  Qubes OS
has a persistent daemon that has exclusive ownership of the storage,
so there are no cache invalidation problems.  The existing thin
pool already has a btree that could store the blob, so no new data
structures are required on the kernel side.

>> Combining many
>>> steps together into a single 'kernel' call just increases already lar=
ge
>>> range of errors.=C2=A0 So in many case we simply do favour to keep op=
eration more
>>> 'low-level-atomic' even at slight higher performance price (as said -=
 we've
>>> never seen a creation of snapshot to be 'msec' critical operation - a=
s=C2=A0 the
>>> 'suspend' with implicit flush & fsfreeze itself might be far more exp=
ensive
>>> operation.
>> Qubes OS should never be snapshotting an in-use volume of any kind.
>> Right now, there is one case where it does so, but that is a bug, and =
I
>> am working on fixing it.  A future API might support snapshotting to a=
n
>> in-use volume, but that would likely require a way to tell the VM to
>> freeze its own filesystem.
>=20
>=20
> Yeah - you have very unusual use case=C2=A0 - in fact lvm2 goal is usua=
lly to=20
> support as much things as we can while devices are in-use so user does =
not=20
> need to take them offline - which surely complicates everything a lot -=
=C2=A0 also=20
> there was basically never any user demand to operate with offline devic=
e in=20
> very quick way - so admittedly not the focused area of development.

I wouldn=E2=80=99t exactly say my use case is *that* unusual.  My
understanding is that Docker has the same one, and they too resorted to
bypassing lvm2 and using raw dm-thin.  Docker does have the advantage
that the filesystem is assumed to be trusted, so they do not need eager
zeroing.  Stratis also uses dm-thin, and it, too, avoids using LVM.

>>>>> But IMHO creation and removal of thousands of devices in very short=
 period
>>>>> of time rather suggest there is something sub-optimal in your origi=
nal
>>>>> software design as I'm really having hard time imagining why would =
you need
>>>>> this ?
>>>> There very well could be (suggestions for improvement welcome).
>>>>
>>>>> If you wish to operate lots of devices - keep them simply created a=
nd ready
>>>>> - and eventually blkdiscard them for next device reuse.
>>>> That would work for volatile volumes, but those are only about 1/3 o=
f
>>>> the volumes in a Qubes OS system.  The other 2/3 are writable snapsh=
ots.
>>>> Also, Qubes OS has found blkdiscard on thins to be a performance
>>>> problem.  It used to lock up entire pools until Qubes OS moved to do=
ing
>>>> the blkdiscard in chunks.
>>> Always make sure you use recent Linux kernels.
>> Should the 5.16 series be recent enough?
>>
>>> Blkdiscard should not differ from lvremove too much=C2=A0 - also expe=
riment how
>>> the=C2=A0 'lvchange --discards=C2=A0 passdown|nopassdown poolLV' work=
s.
>> I believe this was with passdown on, which is the default in Qubes OS.=

>> The bug was tracked down by Jinoh Kang in
>> https://github.com/QubesOS/qubes-issues/issues/5426#issuecomment-76159=
5524
>> and found to be due to dm-thin deleting B-tree nodes one at a time,
>> causing large amounts of time to be wasted on btree rebalancing and no=
de
>> locking.
>>
>>>>> I'm also unsure from where would arise any special need to instanti=
ate=C2=A0 that
>>>>> many snapshots -=C2=A0 if there is some valid & logical purpose -=C2=
=A0=C2=A0 lvm2 can have
>>>>> extended user space API to create multiple snapshots at once maybe =
(so
>>>>> i.e.=C2=A0=C2=A0=C2=A0 create=C2=A0 10 snapshots=C2=A0=C2=A0 with=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 name-%d=C2=A0 of a single thinLV)
>>>> This would be amazing, and Qubes OS should be able to use it.  That
>>>> said, Qubes OS would prefer to be able to choose the name of each vo=
lume
>>>> separately.  Could there be a more general batching operation?  Just=

>>>> supporting =E2=80=98lvm lvcreate=E2=80=99 and =E2=80=98lvm lvs=E2=80=
=99 would be great, but support for
>>>> =E2=80=98lvm lvremove=E2=80=99, =E2=80=98lvm lvrename=E2=80=99, =E2=80=
=98lvm lvextend=E2=80=99, and =E2=80=98lvm lvchange
>>>> --activate=3Dy=E2=80=99 as well would be even better.
>>> There is kind of 'hidden' plan inside command line processing to allo=
w
>>> 'grouped'=C2=A0 processing.
>>>
>>> lvcreate --snapshot=C2=A0 --name lv1=C2=A0 --snapshot --name lv2 vg/o=
rigin
>>>
>>> However there is currently no man power to proceed further on this pa=
rt as
>>> we have other parts of code needed enhancements.
>>>
>>> But we may put this on our TODO plans...
>> That would be great, thanks!
>=20
> Although the main reason to support this kind of API was the request to=
=20
> support an atomic snapshot of multiple LVs at once - but so far not a h=
igh=20
> priority.

Still, it will be useful if it becomes available.

>>>>> Not to mentioning operating that many thin volumes from a single th=
in-pool
>>>>> is also nothing close to high performance goal you try to reach...
>>>> Would you mind explaining?  My understanding, and the basis of
>>>> essentially all my feature requests in this area, was that virtually=
 all
>>>> of the cost of LVM is the userspace metadata operations, udev syncin=
g,
>>>> and device scanning.  I have been assuming that the kernel does not =
have
>>>> performance problems with large numbers of thin volumes.
>>>
>>> The main idea behind the comment is -=C2=A0 when there is increased d=
isk usage -
>>> the manipulation with thin-pool metadata and locking will soon start =
to be a
>>> considerable performance problem.
>>>
>>> So while it's easy to have active=C2=A0 1000 thinLVs from a single th=
in-pool that
>>> are UNUSED, situation is dramatically different when there LVs would =
be in
>>> some heavy use load.=C2=A0 There you should keep the active thinLV at=
 low number
>>> of=C2=A0 tens=C2=A0 LVs, especially if you are performance oriented.=C2=
=A0 The lighter
>>> usage and less provisioning and especially bigger block size - improv=
e
>> I can try to modify the storage pool so that LVs are not activated by
>> default.  That said, Qubes OS will always be provisioning-heavy.  With=

>> the notable exception of volatile volumes, qubesd always snapshots a
>=20
>=20
> You definitely should keep active ONLY LVs you need to have active - it=
's=20
> impacting many other kernel areas and consumes system resources to keep=
=20
> 'unused' LVs active.

Thank you.  There has already been work done in that direction and I
will see if I can finish it now that R4.1 is out.

>> volume at startup and then provides the snapshot to the VM.  After
>> shutdown, the original volume is renamed to be a backup, and the
>> snapshot gets the name of the original volume.  Bigger block sizes wou=
ld
>> substantially increase write amplification, as turning off zeroing is
>> not an option for security reasons.
>=20
> For 'snapshot' heavy loads -=C2=A0 smaller chunks are usually better - =
but it comes=20
> with price.
>=20
>=20
>> Is this just a workload that dm-thin is ill-suited for?  Qubes OS does=

>> support storing VM images on either BTRFS or XFS files, and it could b=
e
>> that this is a better plan going forward.
>=20
>=20
> Not knowing the details - but as mentioned=C2=A0 'zeroing'=C2=A0 is not=
 needed for=20
> 'filesystem' security - modern filesystem will never let you read unwri=
tten=20
> data - as it keeps its own map of written data=C2=A0 - but of course if=
 the user=20
> has root access to device=C2=A0 with 'dd'=C2=A0 it could read some 'unw=
ritten' data on=20
> that device...

Qubes OS aims to defend against an attacker with kernel privilege
in a VM, so zeroing is indeed necessary.  The only way to avoid the
overhead would be for dm-thin=E2=80=99s chunk size to match the block siz=
e
of the paravirtualized disks, so that there are only full-chunk writes.
The reflink storage pool does not have this problem because it works on
4K blocks natively.

>>>> How much of a performance win can I expect from only activating the
>>>> subset of volumes I actually use?
>>>
>>> I can only advice benchmark with some good approximation of your expe=
cted
>>> workload.
>> That=E2=80=99s already on the Qubes OS team=E2=80=99s (very long) to-d=
o list.
>>
> I'd prioritize this - to get the best balance for performance=C2=A0 - i=
=2Ee. slightly=20
> bigger chunks could give you much better numbers - if your 'snapshot' w=
orkload=20
> is focused on small 'areas' so you know exactly where the focus should =
go=C2=A0 =C2=A0=20
> (too many cooks spoll the broth)...
>=20
> So even jump 64k -> 256K can be significant

I will try to do a proper benchmark at some point.

--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
--------------lSoBhXqgxLzMQsBuvbSgkLQn
Content-Type: application/pgp-keys; name="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB288B55FFF9C22C1.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
=3Dx+Ro
-----END PGP PUBLIC KEY BLOCK-----

--------------lSoBhXqgxLzMQsBuvbSgkLQn--

--------------iDb0fvFJdriulBRmzzQPD7s3--

--------------miQRKzzrL27akEzv4vI0D6k9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmJVaX0ACgkQsoi1X/+c
IsHe+Q/+PO/txpEw3q+tfUqQ/JxGG0UX+00uwwO0CF6Bt0Zg5hdWQLTYqXB0UNQc
iFGk6WyK6t+2xs8vo3OhlMaIKq/k3BBHZWXzYkSP/SiQqRzyq7vunnrubTC5fLll
EvgcR8pbM2XE/GZ6z576dpHfxQCY49ZmO65XdeHLuhpNyhQBHX7F8v52p73dYErE
KzGu3WYenFneBQXoGO3oQYSeom5qU8OZrVKoxOkG2pPvNYZP7vwCxcle79H/4mVE
hWDv0cQfBO0diwLTKuKdCWTrQmIRpX7lT2Lt2Mr6b1sRaCenCN/uveg5pzTL0ulK
01e42BCuYe2toKxum1Qq7eOngVKdpJf/wjMSCHseFGHQi1b5BAO5vX4l9qzm2UEv
W55pCzhGt8LMpRf8/26CXDupBexouOciZwJeW6rJvOWwelu4l0x6Yl66I+Jg1J/U
TWkQcp2ktooWlOxKOF+UN5gyCL8RboESvd6RASI0s9afvznaF1ooKz7tewt04zPW
va93DPxC/Y8lVE/LuNPEq5g0/4T3ac3Z9QffbA3fXm74WN/XrkJMZZEkxDtSsIgW
k8bQiNmds9RmE0lMo25Ys4u/iOS7EAZnt0J2UnvoqWzgToo4yY8Qyod3h/ZXqJbg
XQd1Zu9TBXHys9vip3KV9TdOHCuouQtcP2jA/LSZebkZvIVrsg0=
=hozU
-----END PGP SIGNATURE-----

--------------miQRKzzrL27akEzv4vI0D6k9--


--===============4478554971896701971==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4478554971896701971==--

