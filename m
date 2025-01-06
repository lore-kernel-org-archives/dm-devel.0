Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDDD155330
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 09:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736156351; cv=none; b=mX8HBUlXITd2v5aL22JaWMo4OaFpM83pLhaqBGBJdehr44GMAkk9U8IoNnmoTU4lD1SZ3GtehmUhucn7bOjzYz2+GXNrfFW1vbW3xLfJ0mfmQ49KxSeIpJp/fRXVHHlESDO82l4pN6lqf2/kE0x4bCkwIUqHizljqby78nGzSKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736156351; c=relaxed/simple;
	bh=OminO38S2oHHc+mh0VePEbr0ctS5XXLR6JznQopQFVo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=f37l8+8FQk2Rkgz/dlG38Spb4IIbgfb0MZamftFaIxV9eBOWWvBZcriZB68u+EZ9ugyGn6aEhMO/mLOrTY/XFJB0OBDaqf3VfmOEksV0jxGWbIBTfz+EREpFFipgRYrLXGkbl+RM+nFUF4oUbBaOetgg8PBEFS7ozpAn8QVUrwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YRTdb4tr7z4f3lVg
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 17:38:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id F17511A0A81
	for <dm-devel@lists.linux.dev>; Mon,  6 Jan 2025 17:39:04 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP3 (Coremail) with SMTP id _Ch0CgCH28W3pHtn1w3AAA--.62587S3;
	Mon, 06 Jan 2025 17:39:04 +0800 (CST)
Subject: Re: [discussion] proposal to bypass zero data for dm-crypt
To: Milan Broz <gmazyland@gmail.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev, lkml <linux-kernel@vger.kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <73152f2b-2a3e-37a7-4578-9a4ae7ec903f@huaweicloud.com>
 <3181bbd4-40df-eecf-c9b2-45b09018b8af@redhat.com>
 <4351b4fa-2558-4b73-8604-81a4b1eef9dc@gmail.com>
 <34ddb616-63c7-5423-b20f-4ccd61bc4a66@huaweicloud.com>
 <97f09f1a-7ee0-43da-8569-e0a949df31ad@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <dc470b49-1d92-80eb-9db0-4902315707c0@huaweicloud.com>
Date: Mon, 6 Jan 2025 17:39:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <97f09f1a-7ee0-43da-8569-e0a949df31ad@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgCH28W3pHtn1w3AAA--.62587S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWry7tFy8Gry5Zw4UKr1DGFg_yoWrGFy3pr
	y5tFW5Kw4DJFyrCwn2yr1xur1rKrWFqr15Wry5JryDCFn8Krn0q3y2yr1Y9FyDuF45Gr1j
	vFW0vry3Zr1qyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/01/06 17:09, Milan Broz 写道:
> On 1/6/25 2:43 AM, Yu Kuai wrote:
>>> On 1/3/25 5:25 PM, Mikulas Patocka wrote:
>>>> Milan, what do you think about this from a cryptographic point of view?
>>>> Does it make sense to add an option that would detect zero data and 
>>>> skip
>>>> decryption in this case?
>>>
>>> It is a very dangerous thing.
>>>
>>> Disk encryption is a length-preserving encryption, so it cannot prevent
>>> decryption of modified ciphertext. However, such ciphertext modification
>>> (without key knowledge) will cause a pseudorandom plaintext output
>>> (IOW attacker cannot easily flip bits or whole sectors by ciphertext
>>> modification).
>>>
>>> If you allow the zeroed sector to transform to valid plaintext directly,
>>> the attacker can wipe arbitrary plaintext sector. It can lead to fatal
>>> issues (for example, wiping filesystem metadata bitmaps on some known
>>> location).
>>
>> Will there be difference if the attacher wipe the data to zero data or
>> random data? And AFAIK, for this case, should user consider dm-integrity
>> to prevent such attack?
> 
> I think I just explained this - you can directly set specific data with
> zeroed plaintext. With pseudorandom decrypted data, you can only destroy
> it and hope it will do something useful.

Ok, I got it, the difference is the possibility, thanks for the
explanation.

> 
> (I did not mention side channels as "decryption" will be much faster.)
> 
> With such a feature, it will not be full disk encryption but a weakened 
> variant.
> Even if it is ok for your threat model, someone can later use it 
> improperly.
> 
> Just use encryption that suits your intended use case (perhaps filesystem
> encryption orproperly configure your storage stack, dunno).
>>> Stack FDE (dm-crypt) below the filesystem or other storage layer
>>> (like thin provision) that supports sparse data, and you will get
>>> the expected behavior without such tricks.
>>
>> All we want to do is to offer an additional option for user, to enable
>> dm-crypt or not. And if we stack dm-crypt below our storage layer, then
>> all users will have to use dm-crypt. In order to prevent that, the
>> storage layer will have to be much complex, and it will be impossible
>> to perform a hot upgrade without affecting existing use cases. :(
> 
> This is not a reason for weakening encryption in dm-crypt.
> You can always have a virtual volume per user that is optionally encrypted.

Yes, and we'll evaluate the risk in our use cases and then decide if we
still want to do this downstream, by an additional option that user must
enable manually.

Thanks,
Kuai
> 
> Milan
> 
>>
>> Thanks,
>> Kuai
>>
>>>
>>> Milan
>>>
>>>
>>>>
>>>> Mikulas
>>>>
>>>> On Sat, 21 Dec 2024, Yu Kuai wrote:
>>>>
>>>>> Background
>>>>>
>>>>> We provide virtual machines for customers to use, which include an
>>>>> important
>>>>> feature: in the initial state, the disks in the virtual machine do
>>>>> not occupy
>>>>> actual storage space, and the data read by users is all zeros until
>>>>> the user
>>>>> writes data for the first time. This can save a large amount of 
>>>>> storage.
>>>>>
>>>>> Problem
>>>>>
>>>>> However, after introducing dm-crypt, this feature has failed. 
>>>>> Because we
>>>>> expect the data read by users in the initial state to be zero, we
>>>>> have to
>>>>> write all zeros from dm-crypt.
>>>>>
>>>>> Hence we'd like to propose to bypass zero data for dm-crypt, for
>>>>> example:
>>>>>
>>>>> before:
>>>>> zero data -> encrypted zero data
>>>>> decrypted zero data -> zero data
>>>>> others
>>>>>
>>>>> after:
>>>>> zero data -> zero data
>>>>> decrypted zero data -> encrypted zero data
>>>>> others(doesn't change)
>>>>>
>>>>> We'd like to hear from the community for suggestions first, before we
>>>>> start. :)
>>>>>
>>>>> Thanks,
>>>>> Kuai
>>>>>
>>>>
>>>
>>> .
>>>
>>
> 
> .
> 

