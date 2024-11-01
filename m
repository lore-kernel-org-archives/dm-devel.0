Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FF2126BF9
	for <dm-devel@lists.linux.dev>; Fri,  1 Nov 2024 02:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730426562; cv=none; b=FA/7p5R9Zi16V1eQNIDKlrNjWD7B9vtE7ku8cl+3vtvSzMVk4xBXPR+DlUlaYHswjfBEU/kmQrspQJRX3yG1UBPyFyo71NrQCkxHgSOLBZq1W612v4HFvb2QMrgkooU+fVHZvyar123Mt54TI/sjdURhNI3Fo/7BLymfpALy/ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730426562; c=relaxed/simple;
	bh=UPKzxKl+Owx0xxbbOKXiJ4GF/nx20EYNn1O3J2J6w3U=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Ffn6iiCTUXTgyFZ+8RLpIBfx5IkEcSLT4poYFpXyHKsnlBR9RswubyRluHSzu12Or1AKv4srD/haYmiKLGoxN+mCfmshgHWmu9k1/yQ/4MfSjEC724aBEmLf2h6j1A0FhHuIIPizNZrODI0IBwZwM+8hEc+8bDUmp62jtWQDefc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XfkdL2vgxz4f3jMP
	for <dm-devel@lists.linux.dev>; Fri,  1 Nov 2024 10:02:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2F4881A0359
	for <dm-devel@lists.linux.dev>; Fri,  1 Nov 2024 10:02:32 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXc4e2NiRnq5QNAg--.23378S3;
	Fri, 01 Nov 2024 10:02:32 +0800 (CST)
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: John Stoffel <john@stoffel.org>, Christian Theune <ct@flyingcircus.io>
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev, =?UTF-8?Q?Dragan_Milivojevi=c4=87?=
 <galileo@pkm-inc.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
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
 <78517565-B1AB-4441-B4F8-EB380E98EB0F@flyingcircus.io>
 <26403.59789.480428.418012@quad.stoffel.home>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5fb0a6f0-066d-c490-3010-8a047aae2c29@huaweicloud.com>
Date: Fri, 1 Nov 2024 10:02:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <26403.59789.480428.418012@quad.stoffel.home>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXc4e2NiRnq5QNAg--.23378S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuF1xCw48XF43Gr45ZFWUurg_yoWrurWkp3
	4xGayfCr43Ja4Fqw1rZa4Yk3yIka98Zws3GF45Grn5tw1rWF45tr13Xw1fCr1YgrWrua45
	Xw4DAwn2g34kA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/11/01 4:33, John Stoffel Ð´µÀ:
>>>>>> "Christian" == Christian Theune <ct@flyingcircus.io> writes:
> 
>> Hi,
>> the system has been running under stress for a while on 6.11.5 with the debugging. I have two observations so far:
> 
>> 1. The bitmap_counts are sometimes low and sometimes very high and intermingled like this:
> 
>> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721bf1db20000(29009381448+8) 7
>> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721bf9d6fbf80(29009382168+8) 5
>> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721beec896f20(29009381928+8) 4294967242

For this 'sh', can you grep "ff2721beec896f20" for the whole log and
show the results? Looks like bitmap_startwrite and endwrite is not
balanced for this 'sh', and this might be a real problem.

You can also do the same for some other 'sh'.

Thanks,
Kuai

>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c108f26f20(29009374480+8) 3
>> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721bfb083df40(29009381456+8) 7
>> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721bfc92a2fa0(29009381936+8) 5
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c108f26f20(29009374480+8) 2
>> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721c074f8df40(29009381464+8) 7
>> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721bfa3b2df40(29009381944+8) 5
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c108f26f20(29009374480+8) 1
>> Oct 31 20:41:27 barbrady09 kernel: __add_stripe_bio: md127: start ff2721beec219fc0(29009381472+8) 4294967268
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c108f26f20(29009374480+8) 0
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967247
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967246
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967245
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967244
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967243
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967242
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721beec030000(29009374488+8) 4294967241
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 6
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 5
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 4
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 3
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 2
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 1
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721bf21496f20(29009374496+8) 0
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c1aa216f20(29009374504+8) 6
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c1aa216f20(29009374504+8) 5
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c1aa216f20(29009374504+8) 4
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c1aa216f20(29009374504+8) 3
>> Oct 31 20:41:27 barbrady09 kernel: handle_stripe_clean_event: md127: end ff2721c1aa216f20(29009374504+8) 2
> 
>> Is the high number an indicator of something weird?
> 
> Is this number wrapping around and not being detected?  Maybe a
> signed/unsigned issue?  Total wild ass guess on my part...
> 
> .
> 

