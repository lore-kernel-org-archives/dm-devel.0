Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DC118C004
	for <dm-devel@lists.linux.dev>; Fri, 15 Nov 2024 08:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731660301; cv=none; b=UOJJUsOQhrUmdgBj/V0mtSmA8mV7AZcV2N9ri2mhymm4nxZdbeYlg6a60ueBVcVAUa3GMyu3rNlf7BZgt1RQ3OsHCVfYiyufRrJV7RLR5KAVsBGivTO7DwrjD/pZzrv2jN5zbWGNKWr0trpFM1cddybPfFTD/C0q5v/2OxWGNx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731660301; c=relaxed/simple;
	bh=XRosT/lXoBj/sFaKcO9beL7wk1+s6mpA2syk2T+RsSE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=goIuI0GZXW0cdt5toi0+xH7ePRWMCQ+bmSfEtkPaEmTqLKPhT3R+Z5pZidQZugFU6vRvd36KDv5yh3FqZxYB9CcKoH3d3nyTZtFQrVntUJfSjH12uEeKv//MV9f5ABGGSGGr0HVq4ZHAs2AP4HCCF8aO/XN4bqOgevFsaVZZqCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=cUHBDjVH; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="cUHBDjVH"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1731660295;
	bh=XRosT/lXoBj/sFaKcO9beL7wk1+s6mpA2syk2T+RsSE=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=cUHBDjVHD5gHDIPWGtMEeXklAtpZLMXdHCXNPnUMaSj39VAkkAiZVE2+0LT7Baofi
	 nPIXQqEuDwDHMakxruhIU8rHbiOWPQQ75/Ua8zxl8Xb5Dcyyj/VnXohGCgsAoj3DRa
	 aIAvfc4KGrgFG2xQOWcnQjA1T1md5Zm4wJiuUMfk=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <CALTww292Dwduh=k1W4=u+N2K6WYK7RXQyPWG3Yn-JpLY9QDbDQ@mail.gmail.com>
Date: Fri, 15 Nov 2024 09:44:34 +0100
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
 John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>,
 David Jeffery <djeffery@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <362DFCF4-14C5-464C-A73F-72C9A3871E2F@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
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
 <63DE1813-C719-49B7-9012-641DB3DECA26@flyingcircus.io>
 <F8A5ABD5-0773-414D-BBBC-538481BCD0F4@flyingcircus.io>
 <753611d4-5c54-ee0d-30ab-9321274fd749@huaweicloud.com>
 <9A0AE411-B4B8-424A-B9F6-AF933F6544F9@flyingcircus.io>
 <BE85CBCF-1B09-48D0-9931-AA8D298F1D6B@flyingcircus.io>
 <b2a654e7-6c71-a44e-645c-686eed9d5cd8@huaweicloud.com>
 <240E3553-1EDD-49C8-88B8-FB3A7F0CE39C@flyingcircus.io>
 <12295067-fc9a-8847-b370-7d86b2b66426@huaweicloud.com>
 <CALTww28iP_pGU7jmhZrXX9D-xL5Xb6w=9jLxS=fvv_6HgqZ6qw@mail.gmail.com>
 <09338D11-6B73-4C4B-A19A-6BDC6489C91D@flyingcircus.io>
 <C3A9A473-0F0E-4168-BB96-5AB140C6A9FC@flyingcircus.io>
 <0B1D29D1-523C-4E42-95F9-62B32B741930@flyingcircus.io>
 <4DA6F1FE-D465-40C7-A116-F49CF6A2CFF0@flyingcircus.io>
 <CALTww292Dwduh=k1W4=u+N2K6WYK7RXQyPWG3Yn-JpLY9QDbDQ@mail.gmail.com>
To: Xiao Ni <xni@redhat.com>

Hi,

> On 15. Nov 2024, at 09:07, Xiao Ni <xni@redhat.com> wrote:
>=20
> On Thu, Nov 14, 2024 at 11:07=E2=80=AFPM Christian Theune =
<ct@flyingcircus.io> wrote:
>>=20
>> Hi,
>>=20
>> just a followup: the system ran over 2 days without my workload being =
able to trigger the issue. I=E2=80=99ve seen there is another thread =
where this patch wasn=E2=80=99t sufficient and if i understand =
correctly, Yu and Xiao are working on an amalgamated fix?
>>=20
>> Christian
>=20
> Hi Christian
>=20
> Beside the bitmap stuck problem, the other thread has a new problem.
> But it looks like you don't have the new problem because you already
> ran without failure for 2 days. I'll send patches against 6.13 and
> 6.11.

Great, thanks!

What do I need to do to get patches towards 6.6?

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

