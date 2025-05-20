Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E031C6BE
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 06:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747721566; cv=none; b=kE57x/X5boJIg31HH41B1FEJIyJ8AR+Jl09QbUPK4T/0WC8tMjyzPL/9VvSN5IwquT5JheOgWuaur8anGABXKQk/QFA/7VmY2Tv82utozYiA8EFJ75I2cmcc66ydaZ60JIrJVKjAuoJMWWDBvL2kZ43HBjXdXIMVRQj4miC89E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747721566; c=relaxed/simple;
	bh=QaaeFhKLNLdQBZbvoJ23APvcgrri5Ui26qpIrD+MkHU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mm/KL0G/BNEwvwZxbmkeSQgr5kFjxIhsvrjVUq1Vm7aQoq3usptvVfRQhGmV4N9v3I1J6ZQF1Zn3ntwTUkNlz+gboTohb/My92ApCEcJVy6SjFLLcGYoIn+Ok51X3B7U9Dbb3IFA1OkpUabnpEUS9UJ/Np8iyN1QYVoV9fxTk+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4b1kjV4lqxz4f3jXJ
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 14:12:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A57971A0DFF
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 14:12:39 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl9VHSxoGHLNMw--.44911S3;
	Tue, 20 May 2025 14:12:39 +0800 (CST)
Subject: Re: LVM2 test breakage
To: Su Yue <l@damenly.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
 "yukuai (C)" <yukuai3@huawei.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com>
 <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com>
 <73ff7f5f-6f09-66d8-9061-7840bc72d0df@huaweicloud.com>
 <0be9be18-9488-1edc-00bb-5a1b0414fd15@redhat.com>
 <81c5847a-cfd8-4f9f-892c-62cca3d17e63@redhat.com>
 <2ec7a2fd-13bd-08d7-8e8d-71ef83c3aa45@huaweicloud.com>
 <28d561ba-a4d4-4a16-a6f9-5d39a344cd06@gmail.com>
 <db63fa48-b4bc-b5bc-c374-82422096a264@huaweicloud.com>
 <52577231-f4d3-84d1-ec5f-a197625a63c4@huaweicloud.com>
 <y0usaqq1.fsf@damenly.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8ae72246-00d1-4a8a-69f6-7c712812eccd@huaweicloud.com>
Date: Tue, 20 May 2025 14:12:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <y0usaqq1.fsf@damenly.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl9VHSxoGHLNMw--.44911S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF15uF1kJFy5Wr1rAF1fJFb_yoW8tFy3pF
	4rGF4Ykrn5GF1DG392q3yUAF1Dtry7ZryFyay3XFyxCF1Y9393ZanxGr1YgFsFqFZ7GrW0
	va1kKrZxZ3WYkaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

在 2025/05/20 11:47, Su Yue 写道:
> On Tue 20 May 2025 at 09:53, Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> Hi,
>>
>> 在 2025/05/20 9:45, Yu Kuai 写道:
>>> dd if=/dev/zero of=/mnt/test/test.img bs=1048576 count=0 seek=5000000003
>>> dd: failed to truncate to 5242880003145728 bytes in output file
>>> '/mnt/test/test.img': File too large
>>> And this is because ext4 has hard limit of file size, 2^48:
>>> fs/ext4/super.c:        sb->s_maxbytes = 
>>> ext4_max_size(sb->s_blocksize_bits,
>>> has_huge_files);
>>> So, I can't use ext4 for this testcase. :(
>>
>> Sadly, after switching to xfs, with 2^64 file size limit, I got a new
>> error:
>>
>> [ 0:10.980] # 200 TiB raid1
>> [ 0:10.980] lvcreate --type raid1 -m 1 -L 200T -n $lv1 $vg1 --nosync
>> [ 0:10.980] #lvcreate-large-raid.sh:51+ lvcreate --type raid1 -m 1 -L 
>> 200T -n
>> LV1 LVMTEST1868vg1 --nosync
>> [ 0:10.980] File descriptor 6 (/dev/pts/0) leaked on lvm invocation. 
>> Parent PID
>> 1868: bash
>> [ 0:11.226]   WARNING: New raid1 won't be synchronized. Don't read 
>> what you
>> didn't write!
>> [ 0:11.397]   Failed to deactivate LVMTEST1868vg1/LV1_rmeta_0.
>> [ 0:11.776]   Internal error: Removing still active LV
>> LVMTEST1868vg1/LV1_rmeta_0.
>> [ 0:11.966] /root/lvm2/test/shell/lvcreate-large-raid.sh: line 51:  
>> 2071 Aborted
>> (core dumped) lvcreate --type raid1 -m 1 -L 200T -n $lv1 $vg1 --nosync
>> [ 0:14.059] set +vx; STACKTRACE; set -vx
>> [ 0:14.061] ##lvcreate-large-raid.sh:51+ set +vx
>> [ 0:14.061] ## - /root/lvm2/test/shell/lvcreate-large-raid.sh:51
>> [ 0:14.065] ## 1 STACKTRACE() called from
>> /root/lvm2/test/shell/lvcreate-large-raid.sh:51
>>
>> Looks like lvcreate crashed.
>>
> Can't reproduce it on v6.15-rc7 and lvm2 HEAD 
> 37b28216fd029ffe2fac815b16645aeb9d352235:
> 
> /dev/vdc on /mnt type xfs 
> (rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,noquota)
> make check_local T=shell/lvcreate-large-raid.sh LVM_TEST_AUX_TRACE=1  
> VERBOSE=1 LVM_TEST_DIR=/mnt
> 
> What's your kernel and lvm versions?

Thanks for the notice, I just switched lvm to this commit, make
distclean, and them everything looks fine now. :)

Thanks,
Kuai

> 
> -- 
> Su
>> Thanks,
>> Kuai
> .
> 

