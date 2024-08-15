Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3C47710F
	for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 19:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723749253; cv=none; b=Ma4K3qTy5ysCoG7LI1cRZR5oKPQbzZ54YnzF/nPz8ZSU951HZ46YjOYMk4NJ/e306XxE2RhN6p2tHxei6C60+emwhWf2Tznk10OXKq0FMvYFpw7YLpj/HjO01OmbGuNJ8fihlFRkQxHuBIGAeSUvTvebYyo22TTlkw8YskBDjpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723749253; c=relaxed/simple;
	bh=UGZV3OukQZKvsMC8djRzItj9V3PdXHsNHMvc0L2SUuA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=EaNw54QmkGnu99U4FAOHgHibJAmQMb6q9jLNUXJh/wQm+8PwuMhGtOqFHWDwmMMIPlr9qt5hztVFG3NmvpPMuLSx8TmASuBDbMu91u+zFZ6rRGraRJA0nUyILn9u8z7tdXqc9Js9CwqkhTbGdKY/0CilX5eTLVR5XQZLLcthhk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=lg7a4wc4; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="lg7a4wc4"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1723749246;
	bh=EEcSABiUxGD3spP/wvpCYYBF4BdMlzeZqEw2yB9OmaU=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=lg7a4wc4N11rc+ePISoepQpyxd+tmk1Cg/Nw1c+9I6gHQtQtbVMG4/naC1NRwEJCs
	 l/NjpBLzP3MmLwecp7thzXngJwvEHUXpju7f+qWJAUNVexSWk8tRWY69u+Sy0/od9H
	 n+R9xyuYvCnJDC5ajC3mhhbkHXNelaFY8zEHNnKI=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <26302.9357.226392.717562@quad.stoffel.home>
Date: Thu, 15 Aug 2024 21:13:44 +0200
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D7998E5E-4FC1-40E1-A308-4A0E8A87950A@flyingcircus.io>
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
 <EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io>
 <CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
 <26302.9357.226392.717562@quad.stoffel.home>
To: John Stoffel <john@stoffel.org>

Hi,

> On 15. Aug 2024, at 17:53, John Stoffel <john@stoffel.org> wrote:
>=20
>> I=E2=80=99m not making progress here. I can=E2=80=99t reproduce those =
on in-memory
>> loopback raid 6. However: i can=E2=80=99t fully produce the rsync. =
For me
>> this only triggered after around 1.5hs of progress on the NVMe which
>> resulted in the hangup. I can only create around 20 GiB worth of
>> raid 6 volume on this machine. I=E2=80=99ve tried running rsync until =
it
>> exhausts the space, deleting the content and running rsync again,
>> but I feel like this isn=E2=80=99t suffient to trigger the issue. :(
>=20
> You're running on the older 5.13.x kernel or the newer 6.x kernel? =20

6.10.3. I can reproduce reliably on the stack of dm-crypt/mdraid/xfs, =
but not on in memory things at the moment. =46rom my perspective, =
because my test case on there isn=E2=80=99t big enough.

>> I=E2=80=99m trying to find whether any specific pattern in the files =
around
>> the time it locks up might be relevant here and try to run the rsync
>> over that portion.
>=20
> That's a good idea.  Do you have highly compressed files which are
> maybe exploding in size when put into LUKS encrypted partitions?  Just
> a random thought, not a real idea.

Nope. No encryption in the files, also it wasn=E2=80=99t true that I =
could reproduce on specific portions. When restarting from =E2=80=9Cfresh=E2=
=80=9D it kept going to different points until it crashed and it needed =
to churn through around 200-300GiB until it finally caved in.

>> On the plus side, I have a script now that can create the various
>> loopback settings quickly, so I can try out things as needed. Not
>> that valuable without a reproducer, yet, though.
>=20
> Yay!  Please share it.

Will do next week after a bit of cleanup.

Thanks for helping so far - I=E2=80=99ll keep pulling this thread until =
it becomes loose, I hope =E2=80=A6 ;)

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

