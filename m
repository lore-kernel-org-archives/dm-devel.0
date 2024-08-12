Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3EC18951F
	for <dm-devel@lists.linux.dev>; Mon, 12 Aug 2024 18:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723487843; cv=none; b=IL3avx9WtbSc4BeRNCuXvTAxx/QVjv0I7peKg7HUPmThbhCooPjX/Ya29JAfhpa3r9liyN5JfF9B+bQBF5vf9XSscOIJX9fcIKXQnSC8oEp+Nxfd2Vj0nfBkpDrOmneZAi4bmIjO/+NJ80Om/72JJ7A2lZt2ZBJwqmoGVvjrJSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723487843; c=relaxed/simple;
	bh=N+6i5EwUSQ2uo26pWZiZNCy4GCz56QN66Udb1nfTArw=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=CqbRVOSAPk3P/Do9iRP/Ccsb6xLLdleaQmD/WncQIWufv2oBarcmPmSGyalybZEIpfKmtg3XxDYFkzmDyOi0KArYvcPRX+o4hUhvYFsvUXOnZ0teF2sLPKEECzLyAED03oUSUooK2vI+sNEH3oEHugg/i2KD0j7QjlkkTaM5eFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 25A181F3D6;
	Mon, 12 Aug 2024 14:37:15 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id CCCD3A08D2; Mon, 12 Aug 2024 14:37:14 -0400 (EDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Message-ID: <26298.22106.810744.702395@quad.stoffel.home>
Date: Mon, 12 Aug 2024 14:37:14 -0400
From: "John Stoffel" <john@stoffel.org>
To: Christian Theune <ct@flyingcircus.io>
Cc: John Stoffel <john@stoffel.org>,
    Yu Kuai <yukuai1@huaweicloud.com>,
    "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
    dm-devel@lists.linux.dev,
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
In-Reply-To: <C9A9855D-B0A2-4B13-947E-01AF5BA6DF04@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
	<316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com>
	<58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
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
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Christian" =3D=3D Christian Theune <ct@flyingcircus.io> writes:

> Hi John,
> Hi Yu,

>> On 10. Aug 2024, at 00:51, John Stoffel <john@stoffel.org> wrote:
>>=20
>>>>>>> "Christian" =3D=3D Christian Theune <ct@flyingcircus.io> writes=
:
>>=20
>>> Hi,
>>>> On 9. Aug 2024, at 03:13, Yu Kuai <yukuai1@huaweicloud.com> wrote:=

>>>>=20
>>>>=20
>>>> Yes, for sure IO are stuck in md127 and never get dispatched to nv=
me,
>>>> for now I'll say this is a raid5 problem.
>>=20
>>> Note, that this is raid6, not raid5! Sorry, I never explicitly
>>> mentioned that and it was buried in the mdstat output.
>>=20
>> That's good info. =20
>>=20
>> I wonder if you could setup some loop devices, build a RAID6 array,
>> put XFS on it and try to replicate the problem by rsyncing a bunch o=
f
>> files.=20

> I was about to try this, but I=E2=80=99m wondering what backing devic=
es you
> had in mind here? If I place images for loop on the original
> (defective) RAID 6 setup then this wouldn=E2=80=99t give us much info=
.

Just try it in RAM at first, if you can make it work.  Or put the
files in /tmp which should be a tmpfs filesystem backed by swap.  =20

> However, I could take the hot spare and run a sequence of tests
> against that, first with a newer and potentially with an older
> kernel if it doesn=E2=80=99t reproduce in its final form:

That's one option of course. =20

> - xfs directly on the nvme drive
> - xfs on encrypted nvme drive
> - xfs on raid 1 on nvme drive, split into two partitions
> - xfs on raid 5 on nvme drive, split into a few partitions
> - xfs on raid 6 on nvme drive, split into a few partitions
> - repeat the tests with raid1/5//6 with encrypted partitions

That's an awesome test setup to run through and might take a bunch of
time. =20

> As that will take some time and effort, I=E2=80=99d like to double ch=
eck
> whether that sounds sensible to you as well?

I'd probably just do the RAID6 tests first, get them out of the way. =20=


> --=20
> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io=

> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theu=
ne, Christian Zagrodnick


