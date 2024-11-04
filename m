Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4542B18A6B6
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 11:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730720421; cv=none; b=MHLIcQ78zDnqTltOq9r/s3SCafikH9WevL9uK1OxKEVV8jW9K7MfzokBzhB7TYZdQUqsxELoB4/MNRmlfqYuEMwxtnu88UD4Ss8Wcs+HEIWaXsAg94FkzgyW0b67S+aTAEzIUNvZqOEUGeon/0FivC/S/CaEa8GKCK3MJlHcb5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730720421; c=relaxed/simple;
	bh=l3df35cFgEjpPepf6/2le8TYaIAuNL1aSxO4+RxqZYs=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Gd37y5uQpPCHXjUc6smkpr6Ny5qlMo8bIsBN0+ukEv43xSClrC7lbA8uLd2WwmHoKrdGQ/i7vKIrx2U6doFmVO1Pjfs88f8FmWBGdYKNHz641eA6cU0IwaOQMP5HUwbNvuphn9M0/uM0zKbECS9C4IdoT3wc8ym1kYU4XD/Hz94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XhqGv4zgtzyVH7;
	Mon,  4 Nov 2024 19:38:31 +0800 (CST)
Received: from kwepemk500007.china.huawei.com (unknown [7.202.194.92])
	by mail.maildlp.com (Postfix) with ESMTPS id 3DD241402C8;
	Mon,  4 Nov 2024 19:40:16 +0800 (CST)
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemk500007.china.huawei.com (7.202.194.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 4 Nov 2024 19:40:15 +0800
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>, Yu Kuai <yukuai1@huaweicloud.com>
CC: John Stoffel <john@stoffel.org>, "linux-raid@vger.kernel.org"
	<linux-raid@vger.kernel.org>, <dm-devel@lists.linux.dev>,
	=?UTF-8?Q?Dragan_Milivojevi=c4=87?= <galileo@pkm-inc.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
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
 <78517565-B1AB-4441-B4F8-EB380E98EB0F@flyingcircus.io>
 <26403.59789.480428.418012@quad.stoffel.home>
 <5fb0a6f0-066d-c490-3010-8a047aae2c29@huaweicloud.com>
 <F8CEEB15-0E3C-4F67-951D-12E165D6CC05@flyingcircus.io>
 <B6D76C57-B940-4BFD-9C40-D6E463D2A09F@flyingcircus.io>
From: Yu Kuai <yukuai3@huawei.com>
Message-ID: <5170f0d2-cb0f-2e0f-eb5e-31aa9d6ff65d@huawei.com>
Date: Mon, 4 Nov 2024 19:40:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <B6D76C57-B940-4BFD-9C40-D6E463D2A09F@flyingcircus.io>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemk500007.china.huawei.com (7.202.194.92)

Hi,

在 2024/11/01 16:33, Christian Theune 写道:
> I dug out a different one that goes back longer but even that one seems like something was missing early on when I didn’t have the serial console attached.
> 
> I’m wondering whether this indicates an issue during initialization? I’m going to reboot the machine and make sure i get the early logs with those numbers.
> 
> [  405.347345] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(22301786792+8) 4294967259

For this log, let's assume the firt start is from here.
> [  432.542465] __add_stripe_bio: md127: start ff2721beec8c2fa0(22837701992+8) 4294967260
> [  432.542469] __add_stripe_bio: md127: start ff2721beec8c2fa0(22837701992+8) 4294967261
> [  434.272964] __add_stripe_bio: md127: start ff2721beec8c2fa0(22837701992+8) 4294967262
> [  434.273175] __add_stripe_bio: md127: start ff2721beec8c2fa0(22837701992+8) 4294967263
> [  434.273189] __add_stripe_bio: md127: start ff2721beec8c2fa0(22837701992+8) 4294967264
> [  434.273285] __add_stripe_bio: md127: start ff2721beec8c2fa0(22837701992+8) 4294967265
> [  434.274063] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(22837701992+8) 4294967264
> [  434.274066] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(22837701992+8) 4294967263
> [  434.274070] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(22837701992+8) 4294967262
> [  434.274073] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(22837701992+8) 4294967261
> [  434.274078] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(22837701992+8) 4294967260
> [  434.274083] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(22837701992+8) 4294967259
> [  434.276609] __add_stripe_bio: md127: start ff2721beec8c2fa0(23374951848+8) 4294967260
> [  434.278939] __add_stripe_bio: md127: start ff2721beec8c2fa0(23374951848+8) 4294967261
> [  464.922354] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(23374951848+8) 4294967260
> [  464.931833] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(23374951848+8) 4294967259
> [  466.964557] __add_stripe_bio: md127: start ff2721beec8c2fa0(23912715112+8) 4294967260
> [  466.964616] __add_stripe_bio: md127: start ff2721beec8c2fa0(23912715112+8) 4294967261
> [  474.399930] __add_stripe_bio: md127: start ff2721beec8c2fa0(23912715112+8) 4294967262
> [  474.451451] __add_stripe_bio: md127: start ff2721beec8c2fa0(23912715112+8) 4294967263
> [  489.447079] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(23912715112+8) 4294967262
> [  489.456574] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(23912715112+8) 4294967261
> [  489.466069] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(23912715112+8) 4294967260
> [  489.475565] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(23912715112+8) 4294967259
> [  491.235517] __add_stripe_bio: md127: start ff2721beec8c2fa0(24448073512+8) 4294967260
> [  491.235602] __add_stripe_bio: md127: start ff2721beec8c2fa0(24448073512+8) 4294967261
> [  498.153108] __add_stripe_bio: md127: start ff2721beec8c2fa0(24716445096+8) 4294967262
> [  498.156307] __add_stripe_bio: md127: start ff2721beec8c2fa0(24716445096+8) 4294967263
> [  530.332619] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(24716445096+8) 4294967262
> [  530.342110] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(24716445096+8) 4294967261
> [  530.351595] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(24716445096+8) 4294967260
> [  530.361082] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(24716445096+8) 4294967259
> [  535.176774] __add_stripe_bio: md127: start ff2721beec8c2fa0(24985208424+8) 4294967260
> [  549.125326] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(24985208424+8) 4294967259

Then until now, everything is good, start and end is balanced for this
stripe head.
> [  549.635782] __add_stripe_bio: md127: start ff2721beec8c2fa0(25521770024+8) 4294967261
> [  590.875593] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(25521770024+8) 4294967260
> [  590.885081] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(25521770024+8) 4294967259
> [  596.973863] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(26057037928+8) 4294967263
> [  596.973866] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(26057037928+8) 4294967262
> [  596.973869] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(26057037928+8) 4294967261
> [  596.973871] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(26057037928+8) 4294967260
> [  596.973881] handle_stripe_clean_event: md127: end ff2721beec8c2fa0(26057037928+8) 4294967259

Then, oops, this 'sh' start just once here, and end lots of times. It's
unlikely that those end are corresponding to the log much earlier, so
I'm almost convinced that this problem is due to unbalanced start and
end. And the huge number is due to underflow.

Let me dig more. :)

Thanks,
Kuai

