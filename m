Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB87D18D62D
	for <dm-devel@lists.linux.dev>; Thu, 15 Aug 2024 06:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723702808; cv=none; b=iaKtDEj+tVtgKR3899/9xkbsynA3rXzDrgG2hwP1TJ0yWxpeFvWaPPLi1oTOLI/hV55osPTrv0VE+wgb/QjHluEMzKQvPDmfMcYbjfDBXncGUVnyoqTLTw68qTce1gMTkZDW3Z/t2GGMuem21cj6Gi3c7YeMxb5w5hRs95P/uEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723702808; c=relaxed/simple;
	bh=Su63kxGYW2axwphAAUUDD1hgczgZ+W0UW1TzzJ1y76Q=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=SAqtS6jUURCmhefdlnz+15YUJXpSrnGMZJSSFhqJxHpVI44dgZFvRDLru7kR6GmWXXaJxqhIi+2Tme2AHz5kFGcddqwxq5/zCYs5UBpnHyJW6qYgI3mUDL6y2eeP7SrbPCBIpEyu4X6rqw4NObiTMeQvaKuprpPXtHonAanRVCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=dPzWmRiK; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="dPzWmRiK"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1723702802;
	bh=Su63kxGYW2axwphAAUUDD1hgczgZ+W0UW1TzzJ1y76Q=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=dPzWmRiKsTHHdmT9OvbnankfC1x2qpzDvVivZ0Ei9ElquPR79NuvKOzRuGnOyLC8D
	 LYIeTaG6kQZLhPUCdh1jW06nXGzLBsPNveEgd8dCfALEQEJX2JUqgndWprdeHz6IDm
	 BRBo3m2/VXIqwNP9/YjOXk7MdXfTOQgki/9BWldU=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <EBC67418-E60C-435A-8F63-114C67F07583@flyingcircus.io>
Date: Thu, 15 Aug 2024 08:19:41 +0200
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CEC90137-09B3-41AA-A115-1C172F9C6C4B@flyingcircus.io>
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
To: John Stoffel <john@stoffel.org>

Hi,

> On 14. Aug 2024, at 10:53, Christian Theune <ct@flyingcircus.io> =
wrote:
>=20
> Hi,
>=20
>> On 12. Aug 2024, at 20:37, John Stoffel <john@stoffel.org> wrote:
>>=20
>> I'd probably just do the RAID6 tests first, get them out of the way. =20=

>=20
> Alright, those are running right now - I=E2=80=99ll let you know what =
happens.

I=E2=80=99m not making progress here. I can=E2=80=99t reproduce those on =
in-memory loopback raid 6. However: i can=E2=80=99t fully produce the =
rsync. For me this only triggered after around 1.5hs of progress on the =
NVMe which resulted in the hangup. I can only create around 20 GiB worth =
of raid 6 volume on this machine. I=E2=80=99ve tried running rsync until =
it exhausts the space, deleting the content and running rsync again, but =
I feel like this isn=E2=80=99t suffient to trigger the issue. :(

I=E2=80=99m trying to find whether any specific pattern in the files =
around the time it locks up might be relevant here and try to run the =
rsync over that=20
portion.

On the plus side, I have a script now that can create the various =
loopback settings quickly, so I can try out things as needed. Not that =
valuable without a reproducer, yet, though.

@Yu: you mentioned that you might be able to provide me a kernel that =
produces more error logging to diagnose this? Any chance we could try =
that route?

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

