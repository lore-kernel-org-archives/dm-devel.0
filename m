Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD7C1D357B
	for <dm-devel@lists.linux.dev>; Sat, 26 Oct 2024 12:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729944699; cv=none; b=QkZIIWkYc/UOOzoXvWwY4DmAkMAAQWiNO5EkZ+cF6H3FVrXxIgp1MYlA54SU7dVsZoEwtase4mdW60AiL88k3K2rmfkkQw8hgjnxW5cedC/jhy/1VC8bbJ+L+EHwbEGh1/b/gCILlADPSjuiPNeqz6NIyvz9oGdJoxYhsl+MUyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729944699; c=relaxed/simple;
	bh=GRVougec6yTJyFkH6kfC4zumHWETkUftmhzKl9MlSF0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=JiarhBEelJz5fPbsEns88pBRYu4HW7jQt6HsKJJ8vv3bFeDiKP3aqgP0ik+Ta6VuZv48rkrAF3DzaqFetlaux/5dNOwFd76yNbWKhXCn7/yH4nFJYlUH6uoUjikHjDtUGjGvRkV/Ab/NFE/Dt3Z0AiEaX1heYS4dNMc+AWPIFq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=EVhYEOKl; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="EVhYEOKl"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1729944695;
	bh=GRVougec6yTJyFkH6kfC4zumHWETkUftmhzKl9MlSF0=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=EVhYEOKlgILdYf24FQUmuz7Yh5xEekFZFWdV7U5r5dZ25osDf4RVKjbExakwBb7sS
	 sg/bbcixIbMniCimkAIQV7ScIiN0+2eApz+UwNluaFPueRYbL7h8dF6TYFFBDNNRss
	 XENvfHDSqW89PVum6I0MW5ZLx8iuJlvXe2OCHExo=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <3CF4B28B-52D7-414E-96A1-FDFA5A5EF172@flyingcircus.io>
Date: Sat, 26 Oct 2024 14:11:14 +0200
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3DB33849-56C5-4C5C-BF56-F54205BEFCF2@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
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
 <E893A1D9-4042-4515-88AE-C69B078A3E43@flyingcircus.io>
 <A74EC4F5-2FF8-4274-A1EB-28D527F143F1@flyingcircus.io>
 <2d85e9ab-1d0f-70a1-fab2-1e469764ef28@huaweicloud.com>
 <3CF4B28B-52D7-414E-96A1-FDFA5A5EF172@flyingcircus.io>
To: Yu Kuai <yukuai1@huaweicloud.com>



> On 26. Oct 2024, at 14:07, Christian Theune <ct@flyingcircus.io> =
wrote:
>=20
> Hi,
>=20
> I can=E2=80=99t apply this on 6.10.5 and trying to manually =
reconstruct your patch lets me directly stumble into:

6.11.5 of course

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

