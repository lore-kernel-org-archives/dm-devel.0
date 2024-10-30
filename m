Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DE71D27A5
	for <dm-devel@lists.linux.dev>; Wed, 30 Oct 2024 06:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730269778; cv=none; b=e+stPgV3BjZL2asbgeZ22RMm7N7e4XEx2OAgHayHIhBsNXCaaR5c8cv3PyGs3c4IxFdM7om9hhdXjMUV5w3f6i/0ewgzAIO+UAipzEP2J91MeQixM38RUJx16u20/IC/WqEAYIqJqDvMnaFhU+p9DDxn9+OTSBKc6T11U071O4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730269778; c=relaxed/simple;
	bh=UidSTKbx5bGZs7HozVquxb60pw6wA3M0lI6vThFjJGU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=NgyPsmHWdar47XoX08Ysbn6Tj8P87x3+1/zl94G0PmMvZP/hxWE7hWYLYtfKa7nPzxYWL9wmZ95mlrBXfBYWuzG9yAVSzCAbNxnzP9n72LkimM/sTEV3lsQrTPKJ8ZjE+7IFuckJRyRo86IDI0omvaA+w3HpBVbk8EODW30ptk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=a1Owvtun; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="a1Owvtun"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1730269767;
	bh=Xoo34ROKQc9iuj5REFG0Tj7tp0xzQfno75q28tBsYVs=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=a1OwvtunJzOsEbQZzgS6aEh+NuMzW020rkHavC6iPzWK0bhoEBG5EyFM1bKLQLDDH
	 evmWLeFg0MHODsvPO60rPw41VBRHhCc5TFSyKd6dNqVeoVx4X9D8aC6ON18+CdVhLz
	 85OewZp5lPKn5DUetmcqKYKFD2PfDbdfjmCNkGeg=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <1f2c74f4-8ba9-1a9f-0c11-018a25e785e5@huaweicloud.com>
Date: Wed, 30 Oct 2024 07:29:04 +0100
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <22A202B1-A802-406F-8F38-F4F486A92F81@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
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
 <69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io>
 <CALtW_agiOj2PJ_vsWym0qR8w1Q9iotHKPGuP5RohktkqeXt2mw@mail.gmail.com>
 <E893A1D9-4042-4515-88AE-C69B078A3E43@flyingcircus.io>
 <A74EC4F5-2FF8-4274-A1EB-28D527F143F1@flyingcircus.io>
 <2d85e9ab-1d0f-70a1-fab2-1e469764ef28@huaweicloud.com>
 <3CF4B28B-52D7-414E-96A1-FDFA5A5EF172@flyingcircus.io>
 <3DB33849-56C5-4C5C-BF56-F54205BEFCF2@flyingcircus.io>
 <1f2c74f4-8ba9-1a9f-0c11-018a25e785e5@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

> On 30. Oct 2024, at 02:25, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> Hi,
>=20
> =E5=9C=A8 2024/10/26 20:11, Christian Theune =E5=86=99=E9=81=93:
>>> On 26. Oct 2024, at 14:07, Christian Theune <ct@flyingcircus.io> =
wrote:
>>>=20
>>> Hi,
>>>=20
>>> I can=E2=80=99t apply this on 6.10.5 and trying to manually =
reconstruct your patch lets me directly stumble into:
>> 6.11.5 of course
>=20
> I cooked this based on v6.12-rc5, it's right there will be conflict =
for
> 6.11, can you manual adapta it in you version?

I will try, but I=E2=80=99m not sure. I don=E2=80=99t have a deep enough =
understanding to resolve some of the conflicts. In my previous mail I =
wasn=E2=80=99t sure which change would be the right one:

I guess if 6.12 doesn=E2=80=99t have this line at all:

-               atomic_set(&sh->count, 1);

=E2=80=A6 then setting it to 0 is fine?

+               atomic_set(&sh=E2=86=92count, 0);

But again, I have no idea what=E2=80=99s actually going on there =E2=80=A6=
 ;)

If you want I can try to wade through and give you a list of questions =
where the patch doesn=E2=80=99t obviously apply and you can let me know =
=E2=80=A6

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

