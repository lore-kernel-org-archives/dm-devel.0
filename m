Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B011D90A7
	for <dm-devel@lists.linux.dev>; Fri, 24 Jan 2025 06:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737700760; cv=none; b=seHbqWxES9G2dL+XdptZtfyFkxFD8EZgFcDLuKOatZwhpdeTKdIQVLfZv3GcZ8LZkU+Iy36ViAAGoYdNm+wBK9B84m1IbLvnWb4UUICDfcdhl/80LRALlSxHau3Bdws5SQBJNZ8xTKWFrfoOQDCkUrxDDo8DBcitGeT8NZFWKD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737700760; c=relaxed/simple;
	bh=12UzY9teQ9ZK9LZBdoJmZRX97RjmMTx/V+ESxoIn3Qg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=hPLktC52X311dZde0h0hYZZTyK5HfaZjMAxV3Rbf5krpt+jB+thDKWYY27ilsmHZ1wO929FwoapMFp7Wcr0lrRoKRgArin7h7zBhwY67GEyOhG0PfT2p65X0H7Uyt0RFgn+qmGkXtnVieQLxOJwKLHtjfeTOHas299CQ55qHg1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=HtjeoLfI; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="HtjeoLfI"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1737700756;
	bh=12UzY9teQ9ZK9LZBdoJmZRX97RjmMTx/V+ESxoIn3Qg=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=HtjeoLfIk/tHeOxyFyLX0Hs+do8gaaNlztcPdChvBce+/0WXVrYKrNjxBUYqU9sfd
	 gXfbn/t7Gs5ypRX21KGNIN0R0DK/LCswNmOKqh+sCC8ivzhg4d19CvzANmDw1uDq2K
	 +5nLO7yTUc9IeOTNCOY9E36TXwxbCQhMoKhi4jUU=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <37602da9-5b97-d2b8-b12a-8203a4090171@huaweicloud.com>
Date: Fri, 24 Jan 2025 07:38:55 +0100
Cc: Xiao Ni <xni@redhat.com>,
 John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 David Jeffery <djeffery@redhat.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <257055F5-8A93-4782-9419-81FC35C82B17@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <12295067-fc9a-8847-b370-7d86b2b66426@huaweicloud.com>
 <CALTww28iP_pGU7jmhZrXX9D-xL5Xb6w=9jLxS=fvv_6HgqZ6qw@mail.gmail.com>
 <09338D11-6B73-4C4B-A19A-6BDC6489C91D@flyingcircus.io>
 <C3A9A473-0F0E-4168-BB96-5AB140C6A9FC@flyingcircus.io>
 <0B1D29D1-523C-4E42-95F9-62B32B741930@flyingcircus.io>
 <4DA6F1FE-D465-40C7-A116-F49CF6A2CFF0@flyingcircus.io>
 <CALTww292Dwduh=k1W4=u+N2K6WYK7RXQyPWG3Yn-JpLY9QDbDQ@mail.gmail.com>
 <362DFCF4-14C5-464C-A73F-72C9A3871E2F@flyingcircus.io>
 <CALTww280ztWNUW23-Y+8w_S4ZAR4UYdtAmZU4b_wLHjjpTRPJQ@mail.gmail.com>
 <DD7FDB11-1BC5-4FA9-9398-23434CBDB6F8@flyingcircus.io>
 <F9738805-DB6B-4249-A4B0-EC989AD6C399@flyingcircus.io>
 <FE6CA342-7C31-4280-A62B-EFA222675DAD@flyingcircus.io>
 <f34b49b2-6be2-3a5f-d8b2-ea49f5249dd6@huaweicloud.com>
 <A32F4D73-B034-4927-B783-22F2E79EE711@flyingcircus.io>
 <4F13648A-8444-4C5E-B2F4-FF7643CD8427@flyingcircus.io>
 <D0D9694F-E8F3-4D83-9628-8FA89B061AB9@flyingcircus.io>
 <37602da9-5b97-d2b8-b12a-8203a4090171@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

> On 24. Jan 2025, at 07:35, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> Hi,
>=20
> =E5=9C=A8 2025/01/24 14:22, Christian Theune =E5=86=99=E9=81=93:
>> Hi,
>> I=E2=80=99ve been running 6.13 with those patches[1] successfully =
with production load for about 3 days now - this looks like it=E2=80=99s =
fixed!
>=20
> Thanks for the test!
>=20
>> I=E2=80=99d appreciate a backport to 6.6 =E2=80=A6 is there anyone =
specific I should notify about that?
>=20
> This is enough, I'll do that. However, Spring Festival is coming, I'll
> rebase patches to 6.6 after about two weeks, if you don't mind. :)

Thanks a lot - I=E2=80=99m patient enough and can keep the affected =
hosts running on my patched 6.13 for the time being. I=E2=80=99d =
appreciate a little ping when you=E2=80=99re ready.

Enjoy your festival!

Cheers,
Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

