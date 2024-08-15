Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64F71B3756
	for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723737238; cv=none; b=YXi5USeJARvTJMbx86rSkpwVNlazdeVNiRWiyb3PJk/J4wRo4osQ7nBuw3M4QQ+3U2Wr8UE45RY2zNCh8eRI8n3jl3a2Rs4SHJhANd4B5Qbnau42Bt1ne3rK9CdUklpnyey+kEjZDc7GnUC/AMrQgKO2pynGcJroHBCh/9IUP2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723737238; c=relaxed/simple;
	bh=HxZvPXGHChfqPPAp3vcALChpZLgg1uRGLUO2mD8rneE=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=fEHZxiqnSHEqOF/u5jZvt3rGAZzOsAwq9/ahaRKrsFpt2IPz48B8xAM1CecOFEkJMTwZbPDG/eVWILcpxRCpmMju+2pkZsqIu4xf73GZk1p68N1EO4WDHrGGPkxmm+IuakDO+8GVyLchLoejsBHMIb45/dEkmpa/a8YqhPUvYNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 47F501F3D7;
	Thu, 15 Aug 2024 11:53:50 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 3CE1DA08E2; Thu, 15 Aug 2024 11:53:49 -0400 (EDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Message-ID: <26302.9357.226392.717562@quad.stoffel.home>
Date: Thu, 15 Aug 2024 11:53:49 -0400
From: "John Stoffel" <john@stoffel.org>
To: Christian Theune <ct@flyingcircus.io>
Cc: John Stoffel <john@stoffel.org>,
    Yu Kuai <yukuai1@huaweicloud.com>,
    "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
    dm-devel@lists.linux.dev,
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
In-Reply-To: <CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
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
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Christian" =3D=3D Christian Theune <ct@flyingcircus.io> writes:

> Hi,
>> On 14. Aug 2024, at 10:53, Christian Theune <ct@flyingcircus.io> wro=
te:
>>=20
>> Hi,
>>=20
>>> On 12. Aug 2024, at 20:37, John Stoffel <john@stoffel.org> wrote:
>>>=20
>>> I'd probably just do the RAID6 tests first, get them out of the way=
. =20
>>=20
>> Alright, those are running right now - I=E2=80=99ll let you know wha=
t happens.

> I=E2=80=99m not making progress here. I can=E2=80=99t reproduce those=
 on in-memory
> loopback raid 6. However: i can=E2=80=99t fully produce the rsync. Fo=
r me
> this only triggered after around 1.5hs of progress on the NVMe which
> resulted in the hangup. I can only create around 20 GiB worth of
> raid 6 volume on this machine. I=E2=80=99ve tried running rsync until=
 it
> exhausts the space, deleting the content and running rsync again,
> but I feel like this isn=E2=80=99t suffient to trigger the issue. :(

You're running on the older 5.13.x kernel or the newer 6.x kernel? =20

> I=E2=80=99m trying to find whether any specific pattern in the files =
around
> the time it locks up might be relevant here and try to run the rsync
> over that portion.

That's a good idea.  Do you have highly compressed files which are
maybe exploding in size when put into LUKS encrypted partitions?  Just
a random thought, not a real idea.

> On the plus side, I have a script now that can create the various
> loopback settings quickly, so I can try out things as needed. Not
> that valuable without a reproducer, yet, though.

Yay!  Please share it.

