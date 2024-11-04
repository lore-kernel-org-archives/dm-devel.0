Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA82469D
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 12:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730723438; cv=none; b=OwAEA9pT/RWHaSHR81VsDrZRvOu/g5Qx/hhMOnfpS0SDk9DyaloKe3yiDgtCLgfCvgGTBShiXLDIYFK1LjSogccJAbEwWi9yufrWqzSfRoUVHeMeb1rIpZ0uBLvTYOzBacb/ujaAkIlg1mzc20fRDueUV3IwfmpurHmzFzlajfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730723438; c=relaxed/simple;
	bh=b2MfhD9KIiPnphu+dh7YaqSWUxlYORQHqdmvpxM5KeY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hNRsLsg4CKEmdYs3iy0HvWycrpC/CE+k1Q1Gv6QElsr4XtjM23DtOUkNht4jo3X5saArcqHEd5WTH+t6aCpn44QhjJMfFo0mzvc6kz3/deiadYlkYt8QlsMdYkeA2eyeufM9PBJTgbg+PKU8qo9DqWyLsSO4Xjli4L+oQOCrbgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XhrQY6Z0Vz4f3n5q
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 20:30:13 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AB7AD1A0568
	for <dm-devel@lists.linux.dev>; Mon,  4 Nov 2024 20:30:32 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHY4dmvihndnNRAw--.27010S3;
	Mon, 04 Nov 2024 20:30:32 +0800 (CST)
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: John Stoffel <john@stoffel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 dm-devel@lists.linux.dev, =?UTF-8?Q?Dragan_Milivojevi=c4=87?=
 <galileo@pkm-inc.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
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
 <c30c8bcf-30dc-0680-8640-151c2efd3917@huaweicloud.com>
 <96E6B48F-223B-489F-8E80-1E66968CDA49@flyingcircus.io>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <29319c6a-8f30-3736-5809-16ebe6cd76f3@huaweicloud.com>
Date: Mon, 4 Nov 2024 20:30:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <96E6B48F-223B-489F-8E80-1E66968CDA49@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHY4dmvihndnNRAw--.27010S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKr4xKr4xAr18ArWkAw1xAFb_yoWDCrg_Z3
	WrZ34rCa17Jr48tanFqrn5ur1DW3WDXF98Gr17G3saywn5XFnakFWUKr93Wr45K3yfKrnx
	Cr9FvF45ur1a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VU18sqtUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/04 19:51, Christian Theune 写道:
> Hi,
> 
>> On 4. Nov 2024, at 12:29, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>>>> On 1. Nov 2024, at 08:56, Christian Theune <ct@flyingcircus.io> wrote:
>>>>
>>>> Hi,
>>>>
>>>> ok, so the journal didn’t have that because it was way too much. Looks like I actually need to stick with the serial console logging after all.
>>>>
>>>> I dug out a different one that goes back longer but even that one seems like something was missing early on when I didn’t have the serial console attached.
>>>>
>>>> I’m wondering whether this indicates an issue during initialization? I’m going to reboot the machine and make sure i get the early logs with those numbers.
>>
>> I can add a checking and trigger a BUG_ON() if you're fine, this way log
>> should be much less.
> 
> Yeah, I can work with that if it helps.
> 
> Liebe Grüße,
> Christian Theune
> 

Please try the other patch that I hope can fix this problem, there is no
need for more debugging if the problem can be fixed. :)

Thanks,
Kuai

