Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6964A16D303
	for <dm-devel@lists.linux.dev>; Fri,  9 Aug 2024 06:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723183843; cv=none; b=lbTd2I3CyzY1yX/NFEGNchGrHem0OYNrAVjUcA7VuyOUa4wQXUuYDq+uQLfSJ+BZbbm6FvAxp/dwKrGIcVYB/WTXeBlYuk80bI76k/BZx4ChpBWhMAkvEO/gZcWezdhsW+GHgDXoGLJbVQEU86dsHK6tRvOfAJMMq15dMqN65cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723183843; c=relaxed/simple;
	bh=9PRB1LOR89+RfEuoW+DiUlepXyrCWKWqLdX9G5v64Y4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=mcXnz5/uq53ALteag3alvp4bX1JeYhDkLHZhBeNf2YzwHKfgumUCWNahE5iy54SgjHLXh35uoVixRermWPKEk0/sDNbsD5hyYWJoXTFSidqQGBblx6auOTPEWsqAzvqur5HsBqRVvVF2u7r5WoNPbdktTodj0x+v96XdtPSFkO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=VDFXN0eu; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="VDFXN0eu"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1723183830;
	bh=p2jvhv/oj93NpLdOU4mJMRm2x7IFfYmZ3KtGJ5AKYHs=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=VDFXN0euMkNkdNU5c5e2hvMEjVXM9ziYraxL78YEEacbgFvISqwJ/dPx4n1uZW1rv
	 G0AiGVLpOcL71hQrf4jukEuattXsrkfTPD4IIzyJEteUUOIpwicpuYwDd9n0LoCLDk
	 fAoeSme7p/cdkES5Gx1O0evdOCXxjd5Sca8mGTCc=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <e92ccf15-be2a-a1aa-5ea2-a88def82e681@huaweicloud.com>
Date: Fri, 9 Aug 2024 08:10:07 +0200
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <30D680B2-F494-42F5-8498-6ED586E05766@flyingcircus.io>
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
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

> On 9. Aug 2024, at 03:13, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
>=20
> Yes, for sure IO are stuck in md127 and never get dispatched to nvme,
> for now I'll say this is a raid5 problem.

Note, that this is raid6, not raid5! Sorry, I never explicitly mentioned =
that and it was buried in the mdstat output.

Not sure whether that code is internally the same anyway=E2=80=A6

> Can you describe in steps how do you reporduce this problem? We must
> figure out where are those IO and why they're not dispatched. I'll be
> easier to debug if I can reporduce it. Otherwise I'll have to give you
> a debug patch.

My workload is pretty simple IMHO:

1. This is on an XFS volume:

meta-data=3D/dev/mapper/backy      isize=3D512    agcount=3D112, =
agsize=3D268435328 blks
         =3D                       sectsz=3D4096  attr=3D2, =
projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, =
rmapbt=3D0
         =3D                       reflink=3D1    bigtime=3D1
data     =3D                       bsize=3D4096   blocks=3D30001587200, =
imaxpct=3D1
         =3D                       sunit=3D128    swidth=3D1024 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D4096   blocks=3D521728, =
version=3D2
         =3D                       sectsz=3D4096  sunit=3D1 blks, =
lazy-count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0

2. I=E2=80=99m rsyncing a large number of files using:

rsync -avz =E2=80=9C<remote-machine>:/<remote-folder>" .

Specific aspects of the data that might come into play:

After 5-6 tries of syncing and locking up, I now have a directory on =
that volume that contains 154.820 files directly and 1.828.933 files =
recursively. The recursive structure uses a /year/<hash =
prefix>/<hash>-filename structure to spread out the 1.8 million files =
more evenly.

The total amount of data is 1.0 TiB at the moment. The smallest files =
are empty or just a few kilobytes. The mode of the filesizes is 180.984 =
bytes.

There is a second workload on the machine that has been running smoothly =
for a few weeks which backs up virtual machine images and creates a =
somewhat similarly (but more consistent) hashed structure but doesn=E2=80=99=
t use rsync but a more complex diff + content hashing + compression =
approach. However, that other tool does emit write barriers here and =
there -wWhich rsync doesn=E2=80=99t AFAIK.

I double checked, but the other workload was not active during my last =
lockup.

Happy to apply a debug patch to help diagnosing this.

Cheers,
Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

