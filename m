Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B0C70802
	for <dm-devel@lists.linux.dev>; Fri, 25 Oct 2024 14:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729864988; cv=none; b=EChNz9NWG8MXowXl6vyFgiT5uYcQXRUXPBJZthbhidXQ3FD5YT/xr49Tyl2LZke39iQ9GSRtD3B7RLJujqJcyi7VW5drvwPAqcugeqXr33yf3qKhShLOKzdfr+YAyoLnQ84A1W5uH0XpORUfEthFG7AorDk0qwKDjepAY65nC10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729864988; c=relaxed/simple;
	bh=CtCpXlyBQiM74vutT7KETUkiz7TorjsXNWVM5Yc33NI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=G2hQAUYiUyjbXsHwjTkuQWZEiRdiRD420VnV5LvhF8MOS8TZqTO+MTnlH1DChWC5l7SLXiigV0uuOowNEdRl+4G8KTmTg2WTI1e2NG4GnXZ6P8rb0iek2azEbAmLAMIHJG3dasQAudzWndH1R1qGr7thSNDvh0fVylRvq8dgplY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=XEdfc8Qa; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="XEdfc8Qa"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1729864983;
	bh=CtCpXlyBQiM74vutT7KETUkiz7TorjsXNWVM5Yc33NI=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=XEdfc8QaBTixRCJOFj36R8/Sr84nanByJKyBO1Ho714dfmPJctgTLEWNi2HmX1LcT
	 oUnyI/GIvLGXdxrE+4NUM56R7W0GM7jpgJ3RpLVMAMEHuO7/RdCGcYe0CMuCWyLvWB
	 Fltlg4xwS/t41P5YY60soetRx02ZBMIYnhMQvCUg=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <CALtW_agiOj2PJ_vsWym0qR8w1Q9iotHKPGuP5RohktkqeXt2mw@mail.gmail.com>
Date: Fri, 25 Oct 2024 16:02:40 +0200
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
 John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E893A1D9-4042-4515-88AE-C69B078A3E43@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
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
 <143E09BF-BD10-43EB-B0F1-7421F8200DB1@flyingcircus.io>
 <1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
 <69D8A311-E619-40C2-985A-FB15D0336ADE@flyingcircus.io>
 <CALtW_agiOj2PJ_vsWym0qR8w1Q9iotHKPGuP5RohktkqeXt2mw@mail.gmail.com>
To: =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>

Hi,

> On 25. Oct 2024, at 15:31, Dragan Milivojevi=C4=87 =
<galileo@pkm-inc.com> wrote:
>=20
> Take this with a grain of salt,
> since I'm not a kernel developer:
>=20
> If you can trigger the issue with bitmap=3Dnone
> I would say that is a valuable data point.

Yeah, this was more directed towards the question whether Yu needs me to =
run the patch that he posted earlier.

So. The current status is: previously this crashed within 2-3 hours. =
Both machines are now running with the bitmap turned off as described =
above and have been syncing data for about 7 hours. This seems to =
indicate that the bitmap is involved here.

@Yu: let me know what next step you=E2=80=99d like to get from me.

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

