Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F01192B60
	for <dm-devel@lists.linux.dev>; Wed,  6 Nov 2024 06:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730875237; cv=none; b=LbOKIO3jHo0oeIZKrVrXvN0q3COnJmTYxzYMjqQorG247B7X2869qKuqUySuIFcudum7bZLTNAFI8IEXFEH8wthBgigRkJg+li85AUPUQpC8DGAnTs0lLQvlhJ5agiIuEBC0crD2Q6G8l6CKV87dHu71TQMar2GZEnrF0WLsQzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730875237; c=relaxed/simple;
	bh=bpuH4doxst/8b8Sn56ZtckVLGhyBoI5RU7GcdqyH1bw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fKflsInhxYW6N4jHrIhVOQa3biuKKOkgMJwU5mHOEolpx7eRu7R+53kYwxKsGttx6VsYimwnjahSgu8ZGwK9/8BdkQ3iknfjpeqJwA05njJXdf8HBj1GZTCfm8H9BzocV97koR0nsfZ6+Jfu0fIQXUM7rBlCGuc93QDt4ryMASg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=iO/91pZa; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="iO/91pZa"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1730875226;
	bh=bpuH4doxst/8b8Sn56ZtckVLGhyBoI5RU7GcdqyH1bw=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=iO/91pZaUQcs8R/so+Ol8qPbhiIxALXKRmXvHMPXj9wYgZm7ieYHTz3eGtfadbGxa
	 J4yuZDRt7J8m4vovxiZZiu/HQkl5X4AC36e+hnTJIwUszyCImd5cDpCSmMWQMBBiL3
	 4sa36q8vWLxqfQADTRbZ8P1+wdTBiYWUC+VEMuMA=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <b2a654e7-6c71-a44e-645c-686eed9d5cd8@huaweicloud.com>
Date: Wed, 6 Nov 2024 07:40:04 +0100
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <240E3553-1EDD-49C8-88B8-FB3A7F0CE39C@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
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
 <63DE1813-C719-49B7-9012-641DB3DECA26@flyingcircus.io>
 <F8A5ABD5-0773-414D-BBBC-538481BCD0F4@flyingcircus.io>
 <753611d4-5c54-ee0d-30ab-9321274fd749@huaweicloud.com>
 <9A0AE411-B4B8-424A-B9F6-AF933F6544F9@flyingcircus.io>
 <BE85CBCF-1B09-48D0-9931-AA8D298F1D6B@flyingcircus.io>
 <b2a654e7-6c71-a44e-645c-686eed9d5cd8@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

> On 6. Nov 2024, at 07:35, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> Hi,
>=20
> =E5=9C=A8 2024/11/05 18:15, Christian Theune =E5=86=99=E9=81=93:
>> Hi,
>> after about 2 hours it stalled again. Here=E2=80=99s the full blocked =
process dump. (Tell me if this isn=E2=80=99t helpful, otherwise I=E2=80=99=
ll keep posting that as it=E2=80=99s the only real data I can show)
>=20
> This is bad news :(

Yeah. But: the good new is that we aren=E2=80=99t eating any data so far =
=E2=80=A6 ;)

> While reviewing related code, I come up with a plan to move bitmap
> start/end write ops to the upper layer. Make sure each write IO from
> upper layer only start once and end once, this is easy to make sure
> they are balanced and can avoid many calls to improve performance as
> well.

Sounds like a plan!

> However, I need a few days to cooke a patch after work.

Sure thing! I=E2=80=99ll switch off bitmaps for that time - I=E2=80=99m =
happy we found a workaround so we can take time to resolve it cleanly. =
:)

Thanks a lot for your help!
Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

