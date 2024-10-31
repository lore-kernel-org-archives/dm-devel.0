Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908F81CBEBE
	for <dm-devel@lists.linux.dev>; Thu, 31 Oct 2024 19:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404030; cv=none; b=b79PEX8t8rFn8l/su0u1X6feZHrB1+mzErFXxwkZXrcfjp6wSnIodo5sbtSu7q9DXmMCMf1LbtHboFRDND0P5UB638/Cv6Ku5ckIiB6jEej0A1glTN1/v4J3fmZI371OU1OgPo8pVFkIv0f5GYPiizimlJ1dh7ocYRcok/tlXl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404030; c=relaxed/simple;
	bh=DTsc7WU31gfn1iO7mlnpCmuYyrTRN+pR3mMFgZLttJg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=IaWI04pWDRcdTpNBRMl+OUGKj417QLCjpRpCDXX1YkfEqKRTgjRGJLHv8pTjmnzEY647AbY39MVNXIeoHgATsi+5db8cN28nL3YoJ/IjGGaOWBMuamsajkId+tyKT0YG9UeVEMwUsKB7O5QM/CKQqN8Ngf4EuItkjjgpJI1Fl+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=BSEPODt7; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="BSEPODt7"
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1730404024;
	bh=DTsc7WU31gfn1iO7mlnpCmuYyrTRN+pR3mMFgZLttJg=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To;
	b=BSEPODt733K0nCPmtCNKpqtWzsARLNzTF4iWrcXjIuk/os3yrJw9XnXMMkm66MnZl
	 yalSsTyyN1ZBLz/zVnZz1rDWRKywm4zpDT8yq9hYT+CIsIO0gozva5vkN2tiDOMZ1x
	 Dd+ET+KIb7metHT4gNTbtiqFYKmZbbq/0SeYJlkQ=
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
From: Christian Theune <ct@flyingcircus.io>
In-Reply-To: <DD99A1F0-56E7-473D-B917-66885810233E@flyingcircus.io>
Date: Thu, 31 Oct 2024 20:46:42 +0100
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev,
 =?utf-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <78517565-B1AB-4441-B4F8-EB380E98EB0F@flyingcircus.io>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
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
 <3DB33849-56C5-4C5C-BF56-F54205BEFCF2@flyingcircus.io>
 <1f2c74f4-8ba9-1a9f-0c11-018a25e785e5@huaweicloud.com>
 <22A202B1-A802-406F-8F38-F4F486A92F81@flyingcircus.io>
 <45d44ed5-da7c-6480-9143-f611385b2e92@huaweicloud.com>
 <9C03DED0-3A6A-42F8-B935-6EB500F8BCE2@flyingcircus.io>
 <DD99A1F0-56E7-473D-B917-66885810233E@flyingcircus.io>
To: Yu Kuai <yukuai1@huaweicloud.com>

Hi,

the system has been running under stress for a while on 6.11.5 with the =
debugging. I have two observations so far:

1. The bitmap_counts are sometimes low and sometimes very high and =
intermingled like this:

Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start =
ff2721bf1db20000(29009381448+8) 7
Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start =
ff2721bf9d6fbf80(29009382168+8) 5
Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start =
ff2721beec896f20(29009381928+8) 4294967242
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721c108f26f20(29009374480+8) 3
Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start =
ff2721bfb083df40(29009381456+8) 7
Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start =
ff2721bfc92a2fa0(29009381936+8) 5
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721c108f26f20(29009374480+8) 2
Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start =
ff2721c074f8df40(29009381464+8) 7
Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start =
ff2721bfa3b2df40(29009381944+8) 5
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721c108f26f20(29009374480+8) 1
Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start =
ff2721beec219fc0(29009381472+8) 4294967268
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721c108f26f20(29009374480+8) 0
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721beec030000(29009374488+8) 4294967247
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721beec030000(29009374488+8) 4294967246
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721beec030000(29009374488+8) 4294967245
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721beec030000(29009374488+8) 4294967244
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721beec030000(29009374488+8) 4294967243
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721beec030000(29009374488+8) 4294967242
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721beec030000(29009374488+8) 4294967241
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721bf21496f20(29009374496+8) 6
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721bf21496f20(29009374496+8) 5
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721bf21496f20(29009374496+8) 4
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721bf21496f20(29009374496+8) 3
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721bf21496f20(29009374496+8) 2
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721bf21496f20(29009374496+8) 1
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721bf21496f20(29009374496+8) 0
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721c1aa216f20(29009374504+8) 6
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721c1aa216f20(29009374504+8) 5
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721c1aa216f20(29009374504+8) 4
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721c1aa216f20(29009374504+8) 3
Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end =
ff2721c1aa216f20(29009374504+8) 2

Is the high number an indicator of something weird?

2. The printk seems expensive - it might be because there=E2=80=99s a =
serial console attached, I=E2=80=99m trying to detach it, but it seems =
things are stubborn in our config.=20

This results in constant high CPU of the md127_raid6 (full single core =
at 100% accounted as sys time of course) as well as intermittent RCU =
stalls on printk.

I=E2=80=99m wondering whether this will limit the ability to reproduce =
this =E2=80=A6=20

I=E2=80=99ll keep the system running for a bit more and if it doesn=E2=80=99=
t lock up I=E2=80=99ll try harder to get rid of the serial console.

Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

