Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E571ABEDC
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 11:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730721110; cv=none; b=VwhNDkk9/efqqokSQXEAcv7JfDxCrntLw5GwD9Acq38IFsUzjPOD3MJGdtVypVNConSa4s+AanSqasK599SnLD+9K/ZlEmPnyognsnJz0AmzI7nu3HmSL1TOrSTV40y13Rf/0kHSluAuB9YhyGZHjfds+UohT6u3PEf0kMcMApI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730721110; c=relaxed/simple;
	bh=7nh+AKR11GQiKAXi+rM/d+SW8vAMgHHn8/BSbjDgQ5o=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=sll2qo5uhFljpEKwWJ0YhwL+7KbbFn5QuBVxFHPQu2zVPhr16pgUMPprPAPV/JswaH/5MT7TrFbVV1BRNbuLjrSp2lwP+yFL09d6cSSuQYxCbY0Ea+tjlRqbbZc6mzaa0ra4wgYHcNFqYmXs9vPYj4XZH/qZr2V7o63DldRY49E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=mUkg+jDW; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="mUkg+jDW"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1730721105;
	bh=7nh+AKR11GQiKAXi+rM/d+SW8vAMgHHn8/BSbjDgQ5o=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=mUkg+jDWw2o0y7YP4/DUtscplvbzytPWIX0XvykcObXH6N8HP0v5UUfyrRLQL7DBP
	 OoNTuuGCETSsUvgLQHKZOXcNCVk8Vm22Eea75IXO+XY25U0HdqlJqD8XiWKCVnxegU
	 TaYYDgSneB3ePoZJYMvrgN2LiaiYNtqOVJA0A0Oo=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <c30c8bcf-30dc-0680-8640-151c2efd3917@huaweicloud.com>
Date: Mon, 4 Nov 2024 12:51:23 +0100
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <96E6B48F-223B-489F-8E80-1E66968CDA49@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <CALtW_agiOj2PJ_vsWym0qR8w1Q9iotHKPGuP5RohktkqeXt2mw@mail.gmail.com>
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
 <c30c8bcf-30dc-0680-8640-151c2efd3917@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

> On 4. Nov 2024, at 12:29, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
>>> On 1. Nov 2024, at 08:56, Christian Theune <ct@flyingcircus.io> =
wrote:
>>>=20
>>> Hi,
>>>=20
>>> ok, so the journal didn=E2=80=99t have that because it was way too =
much. Looks like I actually need to stick with the serial console =
logging after all.
>>>=20
>>> I dug out a different one that goes back longer but even that one =
seems like something was missing early on when I didn=E2=80=99t have the =
serial console attached.
>>>=20
>>> I=E2=80=99m wondering whether this indicates an issue during =
initialization? I=E2=80=99m going to reboot the machine and make sure i =
get the early logs with those numbers.
>=20
> I can add a checking and trigger a BUG_ON() if you're fine, this way =
log
> should be much less.

Yeah, I can work with that if it helps.

Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

