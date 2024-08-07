Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D081B8E86
	for <dm-devel@lists.linux.dev>; Wed,  7 Aug 2024 06:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723013213; cv=none; b=VUdpCzJs9r8JpqKDD/txuXfP6OeXhmUVYxtImb2iMpkI5gsiK+4GanVn7dHxeWEqYJ/YI2kUn6YU+JnHhHFAnB4HsIJYKi/G5LvxSwNWmdux0ypSOlw+el3Ildwk9qtbaJLhxme9LBCoX+B5Tw9ER2z5Jl5kfASDsOdhwhdd33k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723013213; c=relaxed/simple;
	bh=jduOgRWw7IBpOQ63wYYlVE0p2Au/aEZ2e6P12Fz+W1g=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YvbQFHMIhzp+UY0C4QiCBmMu0GfZ/alVgEUgV0NS29PeAr3hsmBoq5JKoPvP042/PxLUrNSRkSZe/05u2wTIg2l5HNpGDrtP5ilTXfBQv0FcZy2H0a95qgZ6r0fge94q+CxpCHEUiqlNdaFJhzlM1xUQvnYpJqMr6s2B1dWOcbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=imZ4gWTw; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="imZ4gWTw"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1723013207;
	bh=jduOgRWw7IBpOQ63wYYlVE0p2Au/aEZ2e6P12Fz+W1g=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=imZ4gWTwq8Y4FV8RokhysiD2jKNPtZQdOdaTGHQr9BUYMQ+Rf519AH1UJ9dmlcwDc
	 KmKL+2qxwDopzKD0b0R6W/Rmm03xVrvcccuV1lcEO1niXRfnqOSqUSmx1sfzXfrOJy
	 aR/C6baMdhu98tyyIW1/uhhE5yY1fytloachVEQk=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
Date: Wed, 7 Aug 2024 08:46:26 +0200
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com>
 <58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
To: Yu Kuai <yukuai1@huaweicloud.com>

I tried updating to 5.15.164, but have to struggle against our config =
management as some options have been shifted that I need to filter out: =
NFSD_V3 and NFSD2_ACL are now fixed and cause config errors if set - I =
guess that=E2=80=99s a valid thing to happen within an LTS release. =
I=E2=80=99ll try again on Friday

> On 7. Aug 2024, at 07:31, Christian Theune <ct@flyingcircus.io> wrote:
>=20
> Sure,
>=20
> would you prefer me testing on 5.15.x or something else?
>=20
>> On 7. Aug 2024, at 04:55, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>=20
>> Hi,
>>=20
>> =E5=9C=A8 2024/08/06 22:10, Christian Theune =E5=86=99=E9=81=93:
>>> we are seeing an issue that can be triggered with relative ease on a =
server that has been working fine for a few weeks. The regular workload =
is a backup utility that copies off data from virtual disk images in =
4MiB (compressed) chunks from Ceph onto a local NVME-based RAID-6 array =
that is encrypted using LUKS.
>>> Today I started a larger rsync job from another server (that has a =
couple of million files with around 200-300 gib in total) to migrate =
data and we=E2=80=99ve seen the server suddenly lock up twice. Any IO =
that interacts with the mountpoint (/srv/backy) will hang indefinitely. =
A reset is required to get out of this as the machine will hang trying =
to unmount the affected filesystem. No other messages than the hung =
tasks are being presented - I have no indicator for hardware faults at =
the moment.
>>> I=E2=80=99m messaging both dm-devel and linux-raid as I=E2=80=99m =
suspecting either one or both (or an interaction) might be the cause.
>>> Kernel:
>>> Linux version 5.15.138 (nixbld@localhost) (gcc (GCC) 12.2.0, GNU ld =
(GNU Binutils) 2.40) #1-NixOS SMP Wed Nov 8 16:26:52 UTC 2023
>>=20
>> Since you can trigger this easily, I'll suggest you to try the latest
>> kernel release first.
>>=20
>> Thanks,
>> Kuai
>>=20
>>> See the kernel config attached.
>=20
>=20
> Liebe Gr=C3=BC=C3=9Fe,
> Christian Theune
>=20
> --=20
> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>=20
>=20

Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

