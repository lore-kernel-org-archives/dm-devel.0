Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32401509BF
	for <dm-devel@lists.linux.dev>; Mon, 12 Aug 2024 06:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723445918; cv=none; b=Ad/3vRdxRjo0mneh1y13neYHOR4WKxxrkAHa6FLnu3QDTuA4+SpHX2SXJ2VZj2MIr3VRkQoTh37kcp5oTAEzE4vDMW7RACo27d1ZhYjQz6HCIOMaWm1MB5RVscptJzbC/yIyygRfN8WgQh+EkgDiFpYJIrlu1sXzIA//HDAMsNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723445918; c=relaxed/simple;
	bh=ted9cOlCIvstDVE8stNtvqfrsmrHGXy1hBW2/+RcTDw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Ihr9PDXm1jH1QpKXjo5Cl3qSbR0QNVWDBAivlCfZXwzM5PxjP7BuinAWEiBxN7AeDM89eV3hyu49oAtzaRVo6gepGRjpaigfUHeS+TScsOti4GbgMHPTBieHF/aIzP/ymW+sEoQj2L+OIC86ttLAITK/SUzS8slmlfZ4tuu4e7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=July5Vvv; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="July5Vvv"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1723445906;
	bh=ted9cOlCIvstDVE8stNtvqfrsmrHGXy1hBW2/+RcTDw=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=July5Vvv3lGmK4vHAflgOqdgB0rue+U1k5BzF2KpxVXtPcFCR//HlVlTQa+6hXUIe
	 fFQ19GQbbJDvOzZrHUH4YGhnRI9ecL3Wf5ffs00xhiR5ENiqU/4g1arDuLSn4FdJCf
	 VjzJvbCrKFRX8zHebT8q7dPH3cGON6asc9Ub0mPg=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <26294.40330.924457.532299@quad.stoffel.home>
Date: Mon, 12 Aug 2024 08:58:05 +0200
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C9A9855D-B0A2-4B13-947E-01AF5BA6DF04@flyingcircus.io>
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
To: John Stoffel <john@stoffel.org>

Hi John,
Hi Yu,

> On 10. Aug 2024, at 00:51, John Stoffel <john@stoffel.org> wrote:
>=20
>>>>>> "Christian" =3D=3D Christian Theune <ct@flyingcircus.io> writes:
>=20
>> Hi,
>>> On 9. Aug 2024, at 03:13, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>=20
>>>=20
>>> Yes, for sure IO are stuck in md127 and never get dispatched to =
nvme,
>>> for now I'll say this is a raid5 problem.
>=20
>> Note, that this is raid6, not raid5! Sorry, I never explicitly
>> mentioned that and it was buried in the mdstat output.
>=20
> That's good info. =20
>=20
> I wonder if you could setup some loop devices, build a RAID6 array,
> put XFS on it and try to replicate the problem by rsyncing a bunch of
> files.=20

I was about to try this, but I=E2=80=99m wondering what backing devices =
you had in mind here? If I place images for loop on the original =
(defective) RAID 6 setup then this wouldn=E2=80=99t give us much info.

However, I could take the hot spare and run a sequence of tests against =
that, first with a newer and potentially with an older kernel if it =
doesn=E2=80=99t reproduce in its final form:

- xfs directly on the nvme drive
- xfs on encrypted nvme drive
- xfs on raid 1 on nvme drive, split into two partitions
- xfs on raid 5 on nvme drive, split into a few partitions
- xfs on raid 6 on nvme drive, split into a few partitions
- repeat the tests with raid1/5//6 with encrypted partitions

As that will take some time and effort, I=E2=80=99d like to double check =
whether that sounds sensible to you as well?

Cheers,
Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

