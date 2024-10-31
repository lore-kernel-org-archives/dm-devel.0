Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355D61A257A
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 15:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730387258; cv=none; b=VUK77jBfZbHH225V40MkuW+iXx/8SkJ9iEv/fzHtrYJJ+0euFlWPhRCRVB6hBWMtvYy7pomkGAMykxis9NkjmsmtyLnylosJNYJLAyuGByrUtn5C8arGOcoatXHW2WLvb/fMPrCeGuS9B2wSSImtKnnW3iCK/Nb2YPQJavzov9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730387258; c=relaxed/simple;
	bh=cEqrU422vDP4geZRU4JgvEpAubZYeVVC35WZhn3qYDw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=rgc0E8smq5pMW9tGkpqG2KluMj0fwTKialYsmHpK+12zuF14OOVZeXOPVx/VQ70Mb+oSqoRkttEKVHeHRSu8jqnHonHH4ysKeSRK1bWoJZ0+KzUn2w+a/FG+ufJXvHaUjOiGt0L2qavic3KY9dHH7hRqCqRI4sH8svqFQxDm/ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=OwCHiSD6; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="OwCHiSD6"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1730387251;
	bh=g1g8oEwLVZ8CoK30i5NNQFxHr7txgEWlmH4CWg1qsTA=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=OwCHiSD6z2hLeawVbPXGqHAUJ/EKs0l37keuYPoKJkA/XhOzsy6BhzQQT2qZITUT9
	 4NqOab7kiUmb7ffsDEV7LbIkmLKypC5udBUM+b3xCnp0szfioX0dsUPwgNyUtJVolh
	 0k14kCPnEDA8tBVQ2+zeHnHLKZKmU5CdobZbMnig=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <9C03DED0-3A6A-42F8-B935-6EB500F8BCE2@flyingcircus.io>
Date: Thu, 31 Oct 2024 16:07:09 +0100
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DD99A1F0-56E7-473D-B917-66885810233E@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
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
 <22A202B1-A802-406F-8F38-F4F486A92F81@flyingcircus.io>
 <45d44ed5-da7c-6480-9143-f611385b2e92@huaweicloud.com>
 <9C03DED0-3A6A-42F8-B935-6EB500F8BCE2@flyingcircus.io>
To: Yu Kuai <yukuai1@huaweicloud.com>

I was able to build the patch and am putting the kernel under stress =
now.=20

> On 31. Oct 2024, at 09:04, Christian Theune <ct@flyingcircus.io> =
wrote:
>=20
> Hi,
>=20
>> On 31. Oct 2024, at 08:48, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>=20
>>> I will try, but I=E2=80=99m not sure. I don=E2=80=99t have a deep =
enough understanding to resolve some of the conflicts. In my previous =
mail I wasn=E2=80=99t sure which change would be the right one:
>>> I guess if 6.12 doesn=E2=80=99t have this line at all:
>>> -               atomic_set(&sh->count, 1);
>>> =E2=80=A6 then setting it to 0 is fine?
>>> +               atomic_set(&sh=E2=86=92count, 0);
>>=20
>> My patch doesn't touch this field at all, why make such change? This =
is
>> not OK.
>=20
> Yeah, patch didn=E2=80=99t think that=E2=80=99s OK either, that=E2=80=99=
s why I came back instead of trying to run that. ;)
>=20
> Here=E2=80=99s the part of the patch I extracted from the earlier =
emails:
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 58f71c3e1368..b2a75a904209 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2369,6 +2369,7 @@ static struct stripe_head *alloc_stripe(struct =
kmem_cache *sc, gfp_t gfp,
>               atomic_set(&sh->count, 1);
>               sh->raid_conf =3D conf;
>               sh->log_start =3D MaxSector;
> +               atomic_set(&sh->bitmap_counts, 0);
>=20
> =E2=80=A6 aaand I just noticed that patch got confused and tried to =
apply your change 3 lines early, so I ended up with a conflict - =
correctly! :)
>=20
>>> But again, I have no idea what=E2=80=99s actually going on there =E2=80=
=A6 ;)
>>> If you want I can try to wade through and give you a list of =
questions where the patch doesn=E2=80=99t obviously apply and you can =
let me know =E2=80=A6
>>=20
>> Perhaps can you try v6.12-rc5 directly? If not, I'll give a patch =
based
>> on v6.11 later.
>=20
> So. I=E2=80=99d like to avoid running 6.12rc5 and if it isn=E2=80=99t =
too much trouble I=E2=80=99d appreciate a 6.11 patch, but now that I =
understood what=E2=80=99s wrong I can try to create it myself in the =
next days.
>=20
> Cheers,
> Christian
>=20
> --=20
> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian =
Theune, Christian Zagrodnick
>=20

Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

