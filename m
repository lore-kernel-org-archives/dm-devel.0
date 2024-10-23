Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3494912FB34
	for <dm-devel@lists.linux.dev>; Wed, 23 Oct 2024 06:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729663439; cv=none; b=Qg92hWYLHMqCHUD0JzYhNdfVDvUG88gNBSAMiqU7t0sj7LdVz8qUCr3a8Xletp1tM/KNqbM+iGuMi1R9AYVrBjNu7LA/VPvLbsFLrqEBDPSwX1dG+fx8/NARcxpbeZ1U1JrpuqyWIYIOB5k+H9sz82UoJ2Yv0PxqeO9YKbaIZdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729663439; c=relaxed/simple;
	bh=V74AF3HS0cvqWgPfks8S0tLHZaAW7SghmZ6nQZ+ajlI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lGF1bIEwg4SBrXuDBASW5xK/xOnDGqNHvzYzxiCwAvd48JoA683AWTG1AsYML2csCusDyiyC3DnMOXte29eqGwlwZ4rC4CDICTBe6q/NBnpUTHrj83yioPTzJ+zgVWCZ8jO9AwgrhElJ1dQdq0HqTJ5STnke3EV5w39pwBwzuYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=hiyZq6xO; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="hiyZq6xO"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1729663434;
	bh=V74AF3HS0cvqWgPfks8S0tLHZaAW7SghmZ6nQZ+ajlI=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=hiyZq6xO7CQo8fiyOmBXTrnQi4aWBlT0GGxP6UT0rMrm5HTsRNYq378PwlKGRSLBr
	 czWdMPzTerm9xC4hlprISAIf5/uKrGCDhafTG7F4I9jmCBvEVObyqD73PFMRSNsKKw
	 vy2ZT6DOdcLdtHl7BMTBmUv9J0y266XeXyi7pfbo=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <1bbc86a8-1abf-11a1-e724-b6868a8d9f88@huaweicloud.com>
Date: Wed, 23 Oct 2024 08:03:32 +0200
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <81BFBF12-0361-45B9-8FC3-517E61B0F84E@flyingcircus.io>
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
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

> On 23. Oct 2024, at 03:13, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> Hi,
>=20
> =E5=9C=A8 2024/10/22 23:02, Christian Theune =E5=86=99=E9=81=93:
>> Hi,
>> I had to put this issue aside and as Yu indicated he was busy I =
didn=E2=80=99t follow up yet.
>> @Yu: I don=E2=80=99t have new insights, but I have a basically =
identical machine that I will start adding new data with a similar =
structure soon.
>> I couldn=E2=80=99t directly reproduce the issue there - likely =
because the network is a bit slower as it=E2=80=99s connected from a =
remote side and has only 1G instead of 10G, due to the long distances.
>> Let me know if you=E2=80=99re interested in following up here and =
I=E2=80=99ll try to make room on my side to get you more input as =
needed.
>=20
> Yes, sorry that I was totally busy with other things. :(
>=20
> BTW, what is the result after bypassing bitmap(disable bitmap by
> kernel hacking)?

I couldn=E2=80=99t follow up on this as the machine that I can reproduce =
this with has production data. I hope that I can trigger the issue again =
with the new machine (didn=E2=80=99t happen so far) and then apply the =
patch before it has production data.

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

