Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019CB168487
	for <dm-devel@lists.linux.dev>; Fri,  9 Aug 2024 22:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723243924; cv=none; b=Ur+IKflzaPqzSwYPB9/oIJcNnF9txLKFZf0RDKRs1AXmdLYxzUQJ9l7XT8Na2cxlziVm4Eamizub0Bm22JxLBJqXvdPGTYJaP7+MBoiQLqX2fEescuyx+wmDjx0hYmi0J+bsK8ED+ijPy3NThjFRj4gxPL1kvdx8+g4Kvmm1py4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723243924; c=relaxed/simple;
	bh=4DKSeb6TG3TjjkAFwetl4Fka0WPYAYIXgXx/Do4sN3Q=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=Smra2jRQlC4yfnkZ2+YJlnCp6NH6Ok4z0x7HgNsLycuyEnrZQKrlgs3pOsIYSJ3hn7UtomNx1k+Yu3nqPmXv7f4DZzwNrD3l5BXAzEpeGNGhxXFCuylNz6ImsqHBdGGcJe8Aer14HWHnRABwGVZRpoJTQIckIT8MC2nkWagzDmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 57B6E1E121;
	Fri,  9 Aug 2024 18:51:55 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id E8D05A08C6; Fri,  9 Aug 2024 18:51:54 -0400 (EDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Message-ID: <26294.40330.924457.532299@quad.stoffel.home>
Date: Fri, 9 Aug 2024 18:51:54 -0400
From: "John Stoffel" <john@stoffel.org>
To: Christian Theune <ct@flyingcircus.io>
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
    John Stoffel <john@stoffel.org>,
    "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
    dm-devel@lists.linux.dev,
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
In-Reply-To: <30D680B2-F494-42F5-8498-6ED586E05766@flyingcircus.io>
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
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Christian" =3D=3D Christian Theune <ct@flyingcircus.io> writes:

> Hi,
>> On 9. Aug 2024, at 03:13, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>=20
>>=20
>> Yes, for sure IO are stuck in md127 and never get dispatched to nvme=
,
>> for now I'll say this is a raid5 problem.

> Note, that this is raid6, not raid5! Sorry, I never explicitly
> mentioned that and it was buried in the mdstat output.

That's good info. =20

I wonder if you could setup some loop devices, build a RAID6 array,
put XFS on it and try to replicate the problem by rsyncing a bunch of
files.=20



> Not sure whether that code is internally the same anyway=E2=80=A6

>> Can you describe in steps how do you reporduce this problem? We must=

>> figure out where are those IO and why they're not dispatched. I'll b=
e
>> easier to debug if I can reporduce it. Otherwise I'll have to give y=
ou
>> a debug patch.

> My workload is pretty simple IMHO:

> 1. This is on an XFS volume:

> meta-data=3D/dev/mapper/backy      isize=3D512    agcount=3D112, agsi=
ze=3D268435328 blks
>          =3D                       sectsz=3D4096  attr=3D2, projid32b=
it=3D1
>          =3D                       crc=3D1        finobt=3D1, sparse=3D=
1, rmapbt=3D0
>          =3D                       reflink=3D1    bigtime=3D1
> data     =3D                       bsize=3D4096   blocks=3D3000158720=
0, imaxpct=3D1
>          =3D                       sunit=3D128    swidth=3D1024 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=
=3D1
> log      =3Dinternal log           bsize=3D4096   blocks=3D521728, ve=
rsion=3D2
>          =3D                       sectsz=3D4096  sunit=3D1 blks, laz=
y-count=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtexten=
ts=3D0

> 2. I=E2=80=99m rsyncing a large number of files using:

> rsync -avz =E2=80=9C<remote-machine>:/<remote-folder>" .

> Specific aspects of the data that might come into play:

> After 5-6 tries of syncing and locking up, I now have a directory on =
that volume that contains 154.820 files directly and 1.828.933 files re=
cursively. The recursive structure uses a /year/<hash prefix>/<hash>-fi=
lename structure to spread out the 1.8 million files more evenly.

> The total amount of data is 1.0 TiB at the moment. The smallest files=
 are empty or just a few kilobytes. The mode of the filesizes is 180.98=
4 bytes.

> There is a second workload on the machine that has been running smoot=
hly for a few weeks which backs up virtual machine images and creates a=
 somewhat similarly (but more consistent) hashed structure but doesn=E2=
=80=99t use rsync but a more complex diff + content hashing + compressi=
on approach. However, that other tool does emit write barriers here and=
 there -wWhich rsync doesn=E2=80=99t AFAIK.

> I double checked, but the other workload was not active during my las=
t lockup.

> Happy to apply a debug patch to help diagnosing this.

> Cheers,
> Christian

> --=20
> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io=

> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theu=
ne, Christian Zagrodnick


