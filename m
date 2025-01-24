Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926A01D6DC8
	for <dm-devel@lists.linux.dev>; Fri, 24 Jan 2025 06:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737700548; cv=none; b=mpTDX3EVdirOR1ms0SqHkTVhoWiEGTdA72ZKOcQ8CKar2PB/3muVyCgkcGGu6am4J3wcnN0aQn9ObZ8/Ygz9v64SAn3vA/Nfg1F4KC2ogPj83ICcVn9TrgbSwDz9BdoG1sh71tYWyBPDRCsQIzqSwGnKHdj/HK4XjIOmNKMpv5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737700548; c=relaxed/simple;
	bh=QRbO1a73i93at0tdCPBxrLHYvQCyfsXFHGbNc73r/4U=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=tW6aF5RRQXS3IEoEOdDjBE2XgXbsa3NE0Pzj/Sl6sKD+YVGroglpQ0FSJX2jJc1qb8eqsO/K85rA222GiuZIuRASo162KBsgIlLhH4y8RtAGknd8AOEuPJBKtsIaFj3/MR1x/3ojtv6/T5YD/9aHimM5opPC6TarRpaW7+9Nd84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YfSjh6Dmnz4f3kvV
	for <dm-devel@lists.linux.dev>; Fri, 24 Jan 2025 14:35:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id D221C1A06D7
	for <dm-devel@lists.linux.dev>; Fri, 24 Jan 2025 14:35:42 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP3 (Coremail) with SMTP id _Ch0CgD3SsW9NJNnsng8Bw--.2340S3;
	Fri, 24 Jan 2025 14:35:42 +0800 (CST)
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Xiao Ni <xni@redhat.com>, John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev, =?UTF-8?Q?Dragan_Milivojevi=c4=87?=
 <galileo@pkm-inc.com>, "yangerkun@huawei.com" <yangerkun@huawei.com>,
 David Jeffery <djeffery@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <37602da9-5b97-d2b8-b12a-8203a4090171@huaweicloud.com>
Date: Fri, 24 Jan 2025 14:35:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <D0D9694F-E8F3-4D83-9628-8FA89B061AB9@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgD3SsW9NJNnsng8Bw--.2340S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYt7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2js
	IEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE
	5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeV
	CFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxG
	xcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrw
	CF54CYxVCY1x0262kKe7AKxVWUtVW8ZwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd
	HUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/01/24 14:22, Christian Theune 写道:
> Hi,
> 
> I’ve been running 6.13 with those patches[1] successfully with production load for about 3 days now - this looks like it’s fixed!

Thanks for the test!

> 
> I’d appreciate a backport to 6.6 … is there anyone specific I should notify about that?

This is enough, I'll do that. However, Spring Festival is coming, I'll
rebase patches to 6.6 after about two weeks, if you don't mind. :)

BTW, those patches are merged in v6.14-rc1.

Thanks,
Kuai

> 
> Thank’s a lot!
> Christian

