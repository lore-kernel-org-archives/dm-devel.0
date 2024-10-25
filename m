Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC561D1F75
	for <dm-devel@lists.linux.dev>; Fri, 25 Oct 2024 08:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729845596; cv=none; b=tqQwQNDjgyG9Q1FsVHAMvNpzhF8ds/gK2SmFhr0XrcjpxJ9zAHlDZOX3soPlG/lfIe5v5mDObsVNGDs1YwWkbC83PWS4auJaOBzTG7GOqCenP6bVGPSCsynPPW0HcToI39oskeG5H4uDEehuWb5nBz0MV8dcww7R2JQJifgRa4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729845596; c=relaxed/simple;
	bh=R6GHyH9U2cMshwXWcFn+6azMy++FbUoojOQ5RLQO0fo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=m1Zl3GGXUa7M+w/pE+25rS6HQrv/0segXMiOkpMxBLSUzyTYsTc65jBYBjZYL4MUX+qTKnkfK/O+PSiSFZmGS9wJhGDj0StPcqLBH17k1y2nc9y4kFGO6KOaUDnzhnD6l/Wuh077ml6MehOdfOibvXyubr11jlLfkoJoCGfbuTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=ZnTLa2nx; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="ZnTLa2nx"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1729845584;
	bh=e1nGVsKBGJgAFVw1bHuub6qw2HMdhEONIpuW4xybpWc=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=ZnTLa2nx4w8FuwY+8cr2NWgQcHXqUqLIzuFbpg1YmtDAtYZq84zjSVGSjrAyQ4qH/
	 CVwoNrfQ4K860qcGCurhMWWHcyEqmvDNsDGVkTWD1hFNIeg9jXEYYCJ/MdGv7r5kI7
	 8VgdsgRuw40veYNGQhICvpJ7AWVem9zWG/T3vfnY=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
Date: Fri, 25 Oct 2024 10:39:22 +0200
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io>
 <22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
 <26291.57727.410499.243125@quad.stoffel.home>
 <2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
 <1dfc4792-02b2-5b3c-c3d1-bf1b187a182e@huaweicloud.com>
 <4363F3A3-46C2-419E-B43A-4CDA8C293CEB@flyingcircus.io>
 <C832C22B-E720-4457-83C6-CA259AD667B2@flyingcircus.io>
 <e92ccf15-be2a-a1aa-5ea2-a88def82e681@huaweicloud.com>
 <30D680B2-F494-42F5-8498-6ED586E05766@flyingcircus.io>
 <26294.40330.924457.532299@quad.stoffel.home>
 <C9A9855D-B0A2-4B13-947E-01AF5BA6DF04@flyingcircus.io>
 <26298.22106.810744.702395@quad.stoffel.home>
 <EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io>
 <CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
 <2F5F9789-1827-4105-934F-516582018540@flyingcircus.io>
 <adee77ef-f785-acd6-485a-fe2d0a1b9a92@huaweicloud.com>
 <143E09BF-BD10-43EB-B0F1-7421F8200DB1@flyingcircus.io>
 <1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

I=E2=80=99m working on getting a test without bitmap. To make things =
simple for myself: is it helpful if I just use =E2=80=9Cmdadm --grow =
--bitmap=3Dnone=E2=80=9D to disable it or is that futile?

Christian

> On 23. Oct 2024, at 03:13, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> Hi,
>=20
> =E5=9C=A8 2024/10/22 23:02, Christian Theune =E5=86=99=E9=81=93:
>> Hi,
>> I had to put this issue aside and as Yu indicated he was busy I =
didn=E2=80=99t follow up yet.
>> @Yu: I don=E2=80=99t have new insights, but I have a basically =
identical machine that I will start adding new data with a similar =
structure soon.
>> I couldn=E2=80=99t directly reproduce the issue there - likely =
because the network is a bit slower as it=E2=80=99s connected from a =
remote side and has only 1G instead of 10G, due to the long distances.
>> Let me know if you=E2=80=99re interested in following up here and =
I=E2=80=99ll try to make room on my side to get you more input as =
needed.
>=20
> Yes, sorry that I was totally busy with other things. :(
>=20
> BTW, what is the result after bypassing bitmap(disable bitmap by
> kernel hacking)?
>=20
> Thanks,
> Kuai
>=20
>> Christian
>>> On 15. Aug 2024, at 13:14, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>=20
>>> Hi,
>>>=20
>>> =E5=9C=A8 2024/08/15 18:03, Christian Theune =E5=86=99=E9=81=93:
>>>> Hi,
>>>> small insight: even given my dataset that can reliably trigger this =
(after around 1.5 hours of rsyncing) it does not trigger on a specific =
set of files. I=E2=80=99ve deleted the data and started the rsync on a =
fresh directory (not a fresh filesystem, I can=E2=80=99t delete that as =
it carries important data) but it doesn=E2=80=99t always get stuck on =
the same files, even though rsync processes them in a repeatable order.
>>>> I=E2=80=99m wondering how to generate more insights from that. =
Maybe keeping a blktrace log might help?
>>>> It sounds like the specific pattern relies on XFS doing a specific =
thing there =E2=80=A6
>>>> Wild idea: maybe running the xfstest suite on an in-memory raid 6 =
setup could reproduce this?
>>>> I=E2=80=99m guessing that the xfs people do not regularly run their =
test suite on a layered setup like mine with encryption and software =
raid?
>>>=20
>>> That sounds greate.
>>>>  Christian
>>>>> On 15. Aug 2024, at 08:19, Christian Theune <ct@flyingcircus.io> =
wrote:
>>>>>=20
>>>>> Hi,
>>>>>=20
>>>>>> On 14. Aug 2024, at 10:53, Christian Theune <ct@flyingcircus.io> =
wrote:
>>>>>>=20
>>>>>> Hi,
>>>>>>=20
>>>>>>> On 12. Aug 2024, at 20:37, John Stoffel <john@stoffel.org> =
wrote:
>>>>>>>=20
>>>>>>> I'd probably just do the RAID6 tests first, get them out of the =
way.
>>>>>>=20
>>>>>> Alright, those are running right now - I=E2=80=99ll let you know =
what happens.
>>>>>=20
>>>>> I=E2=80=99m not making progress here. I can=E2=80=99t reproduce =
those on in-memory loopback raid 6. However: i can=E2=80=99t fully =
produce the rsync. For me this only triggered after around 1.5hs of =
progress on the NVMe which resulted in the hangup. I can only create =
around 20 GiB worth of raid 6 volume on this machine. I=E2=80=99ve tried =
running rsync until it exhausts the space, deleting the content and =
running rsync again, but I feel like this isn=E2=80=99t suffient to =
trigger the issue. :(
>>>>>=20
>>>>> I=E2=80=99m trying to find whether any specific pattern in the =
files around the time it locks up might be relevant here and try to run =
the rsync over that
>>>>> portion.
>>>>>=20
>>>>> On the plus side, I have a script now that can create the various =
loopback settings quickly, so I can try out things as needed. Not that =
valuable without a reproducer, yet, though.
>>>>>=20
>>>>> @Yu: you mentioned that you might be able to provide me a kernel =
that produces more error logging to diagnose this? Any chance we could =
try that route?
>>>=20
>>> Yes, however, I still need some time to sort out the internal =
process of
>>> raid5. I'm quite busy with some other work stuff and I'm familiar =
with
>>> raid1/10, but not too much about raid5. :(
>>>=20
>>> Main idea is to figure out why IO are not dispatched to underlying
>>> disks.
>>>=20
>>> Thanks,
>>> Kuai
>>>=20
>>>>>=20
>>>>> Christian
>>>>>=20
>>>>> --=20
>>>>> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
>>>>> Flying Circus Internet Operations GmbH =C2=B7 =
https://flyingcircus.io
>>>>> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
>>>>> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>>>> Liebe Gr=C3=BC=C3=9Fe,
>>>> Christian Theune
>> Liebe Gr=C3=BC=C3=9Fe,
>> Christian Theune


Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

