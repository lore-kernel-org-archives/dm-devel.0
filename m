Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7C01AC8A2
	for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 11:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723721081; cv=none; b=lLG6/sCNPIIr1Vg4X0FypSS8hq+OkPJJgbJWS/cF6pb1tqAX20xhsiIsANnSdfd0pFt2jHUsDzpxN5wumnACvz9bS9+C16nE/gEZCHCxQbD2mrQ/dO/lj3n5AFk7NFMK7Lfw5GSshHnpd+MZmhOvtlJOHiPS3HbQGV20sSH7Ueg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723721081; c=relaxed/simple;
	bh=QXM9bbegmhO0xHfxENapu5aWvpRjyKz3/EXn2DQZ4S0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=rZQQ1DvMwuM+8Sp8GGqB9hVlFyxXRB8YGV/rYgchLkUI6hh6JTZmUBR8hoIjqfbKhH6I9u+PFG3lyTrUCs5wFfStm4ciY84vU6T/QeW4794qVOYMjrVCAEkJTOOaAuVDvun2bD2mwBHYVuJ9pBbqVD7UTQHcneEJkvvnV8Fqz90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=KB4T9z5c; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="KB4T9z5c"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1723721076;
	bh=QXM9bbegmhO0xHfxENapu5aWvpRjyKz3/EXn2DQZ4S0=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=KB4T9z5cUfIEcMkMwgDkUwDRzY76qfMKnDz3EwGdI043rqvoY35ixopxSHxQvKUsD
	 i7KAHU+Am4i96hRDP06gt5bQ5RohMurWXVaa6ycLaDWopPSHE3A/vepSczQgpQG6Y/
	 c5omQaKQG3NEl8k/n1Pd5KoUN2HcXdlAF8qi5/hg=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <adee77ef-f785-acd6-485a-fe2d0a1b9a92@huaweicloud.com>
Date: Thu, 15 Aug 2024 13:24:14 +0200
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CE700ADA-6AEF-4881-8F4F-85354E5F8C12@flyingcircus.io>
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
 <2F5F9789-1827-4105-934F-516582018540@flyingcircus.io>
 <adee77ef-f785-acd6-485a-fe2d0a1b9a92@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

> On 15. Aug 2024, at 13:14, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> Hi,
>=20
> =E5=9C=A8 2024/08/15 18:03, Christian Theune =E5=86=99=E9=81=93:
>> Hi,
>> small insight: even given my dataset that can reliably trigger this =
(after around 1.5 hours of rsyncing) it does not trigger on a specific =
set of files. I=E2=80=99ve deleted the data and started the rsync on a =
fresh directory (not a fresh filesystem, I can=E2=80=99t delete that as =
it carries important data) but it doesn=E2=80=99t always get stuck on =
the same files, even though rsync processes them in a repeatable order.
>> I=E2=80=99m wondering how to generate more insights from that. Maybe =
keeping a blktrace log might help?
>> It sounds like the specific pattern relies on XFS doing a specific =
thing there =E2=80=A6
>> Wild idea: maybe running the xfstest suite on an in-memory raid 6 =
setup could reproduce this?
>> I=E2=80=99m guessing that the xfs people do not regularly run their =
test suite on a layered setup like mine with encryption and software =
raid?
>=20
> That sounds greate.

Alright. I will try that.

>>> @Yu: you mentioned that you might be able to provide me a kernel =
that produces more error logging to diagnose this? Any chance we could =
try that route?
>=20
> Yes, however, I still need some time to sort out the internal process =
of
> raid5. I'm quite busy with some other work stuff and I'm familiar with
> raid1/10, but not too much about raid5. :(
>=20
> Main idea is to figure out why IO are not dispatched to underlying
> disks.

Sure, thanks - I=E2=80=99m happy to be patient. :)

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

