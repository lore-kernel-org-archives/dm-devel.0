Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C5213E02A
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 01:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747705518; cv=none; b=LQKIJpdHiCnoU+ALSZFpWJDfcLVR/GNOUw0aUjlYEnzK2SZnGOUG7ApLcVpmIVXt5YKDTxkiUguG2QePVZvcqSs/S0HOnTt0dSwu8Dz/uMWGysS1nMaV8ZT23hi9kV10KMF19npoIKWlruJgoZ9oAX7ljExCMF5a7+QoYpx7xfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747705518; c=relaxed/simple;
	bh=GZb+ILFELZ5vP3JRFRCht3uxiabg8Ol3CGujPDCBwpU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YHa2Ew44DBpzwv7bQXyRNtkR3/IJSdtkRh5WvI5Ee62NkaxKEMFFPoqMCF4HhlL1T8r3yAT2bJ90zJDc//holWS6znNvPpAw65jtMLh8nEbu0s/eB4SKOTyPLijkaY1xK7SzHRSKSI/usH0FNY2nKYFbpZSsxGIUxVdAyJis0Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4b1cmt2MW0z4f3jq5
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 09:44:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 24E141A07BB
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 09:45:06 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnC2Cg3itocgS7Mw--.47759S3;
	Tue, 20 May 2025 09:45:06 +0800 (CST)
Subject: Re: LVM2 test breakage
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
 Yu Kuai <yukuai1@huaweicloud.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <34fa755d-62c8-4588-8ee1-33cb1249bdf2@redhat.com>
 <98ac5772-9931-17fd-1fc4-18d2c737b079@huaweicloud.com>
 <73ff7f5f-6f09-66d8-9061-7840bc72d0df@huaweicloud.com>
 <0be9be18-9488-1edc-00bb-5a1b0414fd15@redhat.com>
 <81c5847a-cfd8-4f9f-892c-62cca3d17e63@redhat.com>
 <2ec7a2fd-13bd-08d7-8e8d-71ef83c3aa45@huaweicloud.com>
 <28d561ba-a4d4-4a16-a6f9-5d39a344cd06@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <db63fa48-b4bc-b5bc-c374-82422096a264@huaweicloud.com>
Date: Tue, 20 May 2025 09:45:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <28d561ba-a4d4-4a16-a6f9-5d39a344cd06@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnC2Cg3itocgS7Mw--.47759S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Gw4DtFWUCry8Ww1UAF1kXwb_yoW7Ar1xpF
	y7JF1j9r1fCrn7G39rKw4DG3W0qFyUArWFva4Yk34rCrsFqry3AFsxJr4jgF9rKFZ8Wry7
	Zay8XrW7AF15Zw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

在 2025/05/19 21:55, Zdenek Kabelac 写道:
> Dne 19. 05. 25 v 13:07 Yu Kuai napsal(a):
>> Hi,
>>
>> 在 2025/05/19 18:45, Zdenek Kabelac 写道:
>>> Dne 19. 05. 25 v 12:10 Mikulas Patocka napsal(a):
>>>> On Mon, 19 May 2025, Yu Kuai wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> 在 2025/05/19 9:11, Yu Kuai 写道:
>>>>>> Hi,
>>>>>>
>>>>>> 在 2025/05/17 0:00, Mikulas Patocka 写道:
>>>>>>> Hi
>>>>>>>
>>>>>>> The commit e879a0d9cb086c8e52ce6c04e5bfa63825a6213c breaks the test
>>>>>>> shell/lvcreate-large-raid.sh in the lvm2 testsuite.
>>>>>>>
>>>>>>> The breakage is caused by removing the line "read_bio->bi_opf = op |
>>>>>>> do_sync;"
>>>>>>>
>>>>> Do I need some special setup to run this test? I got following
>>>>> result in my VM, and I don't understand why it failed.
>>>>>
>>>>> Ask Zdenek Kabelac - he is expert in the testsuite.
>>>>>
>>>>> Mikulas
>>>
>>>
>>> Hi
>>>
>>>
>>> Lvm2 test suite is creating 'virtual' disk setup - it usually tries 
>>> first build something with 'brd' - if this device is 'in-use' it 
>>> fallback to create some files in LVM_TEST_DIR.
>>>
>>> This dir however must allow creation of device - by default nowdays 
>>> /dev/shm & /tmp are mounted with  'nodev' mount option.
>>>
>>> So a dir which does allow dev creation must be passed to the test - 
>>> so either remount dir without 'nodev' or set LVM_TEST_DIR to the 
>>> filesystem which allows creation of devices.
>>
>> Yes, I know that, and I set LVM_TEST_DIR to a new mounted nvme, as use
>> can see in the attached log:
>>
>> [ 0:02.335] ## DF_H:    /dev/nvme0n1     98G   64K   93G   1% /mnt/test
> 
> Hi
> 
> Please  check the output of 'mount' command whether your mount point 
> /mnt/test
> allows creation of devices  (i.e. does not use 'nodev' as setting for 
> this mountpoint)
> 
> 
>>
>>>
>>> In 'lvm2/test'   run  'make help'  to see all possible settings - 
>>> useful one could be LVM_TEST_AUX_TRACE  to expose shell traces from 
>>> test internals - helps with debugging...
>> The log do have shell trace, I think, it stoped here, I just don't know
>> why :(
>>
>> [ 0:01.709] ## - /root/lvm2/test/shell/lvcreate-large-raid.sh:31
>> [ 0:01.710] ## 1 STACKTRACE() called from 
>> /root/lvm2/test/shell/lvcreate- large-raid.sh:31
>>
> 
> 
> Run:
> 
>    'make check_local T=lvcreate-large-raid LVM_TEST_AUX_TRACE=1  VERBOSE=1'
> 
> for more closer look why it is failing when preparing devices.
> My best guess is the use of 'nodev' flag   (thus mount with '-o dev')

nodev is not the cause here, and other tests like lvcreate-large-raid10
can pass. Following is the results after adding LVM_TEST_AUX_TRACE=1
VERBOSE=1:

[ 0:04.201] + local slash
[ 0:04.201] + test -f LOOP
[ 0:04.201] + echo -n '## preparing loop device...'
[ 0:04.201] ## preparing loop device...+ test -f SCSI_DEBUG_DEV
[ 0:04.201] + test '!' -e LOOP
[ 0:04.206] + test -n /mnt/test/LVMTEST4022.LI2unegZz8/dev
[ 0:04.206] + for i in 0 1 2 3 4 5 6 7
[ 0:04.206] + test -e /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop0
[ 0:04.206] + mknod /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop0 b 7 0
[ 0:04.206] + for i in 0 1 2 3 4 5 6 7
[ 0:04.266] + test -e /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop1
[ 0:04.267] + mknod /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop1 b 7 1
[ 0:04.267] + for i in 0 1 2 3 4 5 6 7
[ 0:04.300] + test -e /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop2
[ 0:04.300] + mknod /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop2 b 7 2
[ 0:04.301] + for i in 0 1 2 3 4 5 6 7
[ 0:04.351] + test -e /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop3
[ 0:04.351] + mknod /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop3 b 7 3
[ 0:04.351] + for i in 0 1 2 3 4 5 6 7
[ 0:04.405] + test -e /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop4
[ 0:04.405] + mknod /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop4 b 7 4
[ 0:04.407] + for i in 0 1 2 3 4 5 6 7
[ 0:04.452] + test -e /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop5
[ 0:04.453] + mknod /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop5 b 7 5
[ 0:04.453] + for i in 0 1 2 3 4 5 6 7
[ 0:04.503] + test -e /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop6
[ 0:04.503] + mknod /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop6 b 7 6
[ 0:04.505] + for i in 0 1 2 3 4 5 6 7
[ 0:04.555] + test -e /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop7
[ 0:04.555] + mknod /mnt/test/LVMTEST4022.LI2unegZz8/dev/loop7 b 7 7
[ 0:04.558] + echo -n .
[ 0:04.607] .+ local LOOPFILE=/mnt/test/LVMTEST4022.LI2unegZz8/test.img
[ 0:04.607] + rm -f /mnt/test/LVMTEST4022.LI2unegZz8/test.img 
 
                                                                [ 
0:04.608] + dd if=/dev/zero of=/mnt/test/LVMTEST4022.LI2unegZz8/test.img 
bs=1048576 count=0 seek=5000000003
[ 0:04.650] set +vx; STACKTRACE; set -vx
[ 0:04.702] ##lvcreate-large-raid.sh:31+ set +vx
[ 0:04.703] ## - /root/lvm2/test/shell/lvcreate-large-raid.sh:31
[ 0:04.705] ## 1 STACKTRACE() called from 
/root/lvm2/test/shell/lvcreate-large-raid.sh:31

Then I tried the dd cmd myself:

dd if=/dev/zero of=/mnt/test/test.img bs=1048576 count=0 seek=5000000003
dd: failed to truncate to 5242880003145728 bytes in output file 
'/mnt/test/test.img': File too large

And this is because ext4 has hard limit of file size, 2^48:

fs/ext4/super.c:        sb->s_maxbytes = 
ext4_max_size(sb->s_blocksize_bits, has_huge_files);

So, I can't use ext4 for this testcase. :(

Thanks,
Kuai

> 
> Regards
> 
> Zdenek
> 
> .
> 

