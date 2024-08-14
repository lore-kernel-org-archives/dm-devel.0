Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C124136658
	for <dm-devel@lists.linux.dev>; Wed, 14 Aug 2024 08:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723625634; cv=none; b=eYSodF3ljKL6D+FUdDwD5x1W6pPQnCQc/Av+r7/1FAioobJ5Jdh0XbxCaYMGpwoSVJEaATZmwwGBKvfLckrUH01iCRTot0ArrjbfTLlFCiaL14wu64wuiRy3ywmakX0BXiCqoNQQUiyx23q/scJE1ms6U1Py1DjHiidv3Y0wjqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723625634; c=relaxed/simple;
	bh=n+ZdyjFAU3g/7V0oXofad1dQjArc6rjig3KsO9lS1Ks=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=p74bHxMquv6dSUufzVzGkcS9Ej0/eRcWh/w0Ha6xflVN3H9++rrrzIqZNJZ88Ck2aQ9S+/AkrTqv1vy0v9pBwsYl2BHFW53SKES6H0A3+HS/c8Otjvm4xuF3N9VCETFmBqg6LBopJZ/ayz91VqJT43b1+DEAKVNOD0onhZk0YT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=Q1x2wNB0; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="Q1x2wNB0"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1723625620;
	bh=5+GGU7syF0YgbK3HQi6a6LWoC+cGdja9bw9g89nM8Y4=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=Q1x2wNB0LUqeQxSnJoeDKKbciJVggUaYlJXCi7CVTMAYcTGh1rN7X0gTVwAvwtkmS
	 CY0VSy5VEBI9lwrb48Oj9zj/IzvFCYbq93S8eGivjwrE4HJlIwcPxZxBWdKF0BHRjE
	 lnE3w+hpa8r6GMisZ7/06cwywUPWXm/EVbOeQc6c=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <26298.22106.810744.702395@quad.stoffel.home>
Date: Wed, 14 Aug 2024 10:53:18 +0200
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io>
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
 <26298.22106.810744.702395@quad.stoffel.home>
To: John Stoffel <john@stoffel.org>

Hi,

> On 12. Aug 2024, at 20:37, John Stoffel <john@stoffel.org> wrote:
>=20
> Just try it in RAM at first, if you can make it work.  Or put the
> files in /tmp which should be a tmpfs filesystem backed by swap.  =20

Thanks, I kinda expected that, but wasn=E2=80=99t sure. I=E2=80=99ll see =
whether I can make this trigger (reliably) before I run out of RAM. If I =
do, I=E2=80=99ll have to see.=20

>> However, I could take the hot spare and run a sequence of tests
>> against that, first with a newer and potentially with an older
>> kernel if it doesn=E2=80=99t reproduce in its final form:
>=20
> That's one option of course. =20
>=20
>> - xfs directly on the nvme drive
>> - xfs on encrypted nvme drive
>> - xfs on raid 1 on nvme drive, split into two partitions
>> - xfs on raid 5 on nvme drive, split into a few partitions
>> - xfs on raid 6 on nvme drive, split into a few partitions
>> - repeat the tests with raid1/5//6 with encrypted partitions
>=20
> That's an awesome test setup to run through and might take a bunch of
> time. =20

I=E2=80=99ll try to prepare scripts to set this up. I currently have a =
specific fileset that I=E2=80=99m using here, I hope I can replicate it =
with a different fileset at some point =E2=80=A6 -_-

>> As that will take some time and effort, I=E2=80=99d like to double =
check
>> whether that sounds sensible to you as well?
>=20
> I'd probably just do the RAID6 tests first, get them out of the way. =20=


Alright, those are running right now - I=E2=80=99ll let you know what =
happens.

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

