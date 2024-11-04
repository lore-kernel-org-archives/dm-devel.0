Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB5FF9E8
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 14:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730731575; cv=none; b=q6T/ZPNgqZ2j2scMNCGbT9DmlqO/cPAj2GxzSwawUQeq6GbQdmKoHcFf7H0qdjoBwM2lYD5rTrc42dS7GdGiN6uxHAw6YKfjO0uz/QRmzOYcZUF53pgtXCKak2mVg++lm3cqua2jdIOo/MrPmSh0yusZrRjw7u3RYvH1lf3QiOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730731575; c=relaxed/simple;
	bh=kD2ugnzOpA0R6/s9AruJ2MH9/DFJAeO7krksRDq4Lqk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=o6+SVpAXxkuWfKDpl/V9Kex+/5Pcte+GFpB/CBUy7wvnSPopKmxB20/cUpgAG/yw0bG8MWY4IYg73ki60eukdcyjTi+Q9e0kQXALOjfJOb38wXCWZm4mQmCM5gswj+668l5gLCyNcScpMkQiXemC0SKq16WAZ5fkCakJYiPrumw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=mxmm7eWT; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="mxmm7eWT"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1730731568;
	bh=kD2ugnzOpA0R6/s9AruJ2MH9/DFJAeO7krksRDq4Lqk=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=mxmm7eWT+HM/KhjOc+ptiHn4cKCqwHA/0T5601t30QxRYJhq40B7eOaji8JmqPnws
	 hJvqAHUtzIc3KQ6JDH8Tce3MQKSUELmyWIRl0Iim0bdrVunuM9m5tcQDxDGTDz4Imp
	 fjOR7aF8SyZmgNlWdTK0XFaVC9f24MgSMMlqHoQ8=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <2b093abc-cd9a-0b84-bcba-baec689fa153@huaweicloud.com>
Date: Mon, 4 Nov 2024 15:45:46 +0100
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <63DE1813-C719-49B7-9012-641DB3DECA26@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <E893A1D9-4042-4515-88AE-C69B078A3E43@flyingcircus.io>
 <A74EC4F5-2FF8-4274-A1EB-28D527F143F1@flyingcircus.io>
 <2d85e9ab-1d0f-70a1-fab2-1e469764ef28@huaweicloud.com>
 <3CF4B28B-52D7-414E-96A1-FDFA5A5EF172@flyingcircus.io>
 <3DB33849-56C5-4C5C-BF56-F54205BEFCF2@flyingcircus.io>
 <1f2c74f4-8ba9-1a9f-0c11-018a25e785e5@huaweicloud.com>
 <22A202B1-A802-406F-8F38-F4F486A92F81@flyingcircus.io>
 <45d44ed5-da7c-6480-9143-f611385b2e92@huaweicloud.com>
 <9C03DED0-3A6A-42F8-B935-6EB500F8BCE2@flyingcircus.io>
 <DD99A1F0-56E7-473D-B917-66885810233E@flyingcircus.io>
 <78517565-B1AB-4441-B4F8-EB380E98EB0F@flyingcircus.io>
 <26403.59789.480428.418012@quad.stoffel.home>
 <5fb0a6f0-066d-c490-3010-8a047aae2c29@huaweicloud.com>
 <F8CEEB15-0E3C-4F67-951D-12E165D6CC05@flyingcircus.io>
 <B6D76C57-B940-4BFD-9C40-D6E463D2A09F@flyingcircus.io>
 <5170f0d2-cb0f-2e0f-eb5e-31aa9d6ff65d@huawei.com>
 <2b093abc-cd9a-0b84-bcba-baec689fa153@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi

> On 4. Nov 2024, at 13:18, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
>=20
> I think I found a problem by code review, can you test the following
> patch? (Noted this is still from latest mainline).

Thanks - I can try that. I think I got the gist of it and adapted it to =
6.11.6:
https://github.com/flyingcircusio/linux-stable/pull/2/files

(I=E2=80=99m not properly tooled to apply embedded patches from the =
mailing lists, I need to improve my toolchain if I have to deep dive =
this far more often in the future.)

Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

