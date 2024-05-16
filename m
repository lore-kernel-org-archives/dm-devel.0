Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC07926AD0
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 11:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715859769; cv=none; b=pUCsRWfrlad/v+8xaMEDCuVO+FdeInWYmee1+kw8H6FAUNN6M/DSZ93bM4Xi/ecV625CsdFxC1MnC346C+IIkx4tBeiyKPL3BWQJIsjVAojYyINfzdsp7EWYSlhvdg0lFiwG6y1Ehg4vH936kvDzUkJyx/dEsyTRTh89A6NHc00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715859769; c=relaxed/simple;
	bh=8PoB/1AukG0IWjEr46ZG8YoVRRdfpbnhgv+spB0XfKU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=IsyD/d8/ypDECIV73ZoXPJCiJt7dGpjl3Qw3Q6SnsJcZq5Q2+9ysAq2MWjX+SHq2x5lDUayDNwl4+g8EvZ3eYgIzx2ARHunbOF6WUDipP3bA/MY0WMYn7FdgJp9NQviCF28UBB3KBqfrxOQgVqM3BO0Jb4qZU82k9M3Xu3iY2g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vg7Vq3ppLz4f3jYN
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 19:42:27 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 410621A0A01
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 19:42:36 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgCXaBEp8UVm14FIMw--.44720S3;
	Thu, 16 May 2024 19:42:35 +0800 (CST)
Subject: Re: [bug report] INFO: task mdX_resync:42168 blocked for more than
 122 seconds
To: Ming Lei <ming.lei@redhat.com>, Changhui Zhong <czhong@redhat.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, Xiao Ni <xni@redhat.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
 <ZkXsOKV5d4T0Hyqu@fedora>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9b340157-dc0c-6e6a-3d92-f2c65b515461@huaweicloud.com>
Date: Thu, 16 May 2024 19:42:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZkXsOKV5d4T0Hyqu@fedora>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXaBEp8UVm14FIMw--.44720S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCFW5Zw1DGryfAr4Uuw4DJwb_yoWrKF4fp3
	4Fqr40qr17Ww4vva429w429ryUJa13Xrn8urZxKry0yF1IkFsaqFZxJw17WasrtFyqka10
	gw13Jr4jqw1jgrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
	07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
	GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE
	14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
	9x07UWE__UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/05/16 19:21, Ming Lei Ð´µÀ:
> Cc raid and dm list.
> 
> On Thu, May 16, 2024 at 06:24:18PM +0800, Changhui Zhong wrote:
>> Hello,
>>
>> when create lvm raid1, the command hang on for a long time.
>> please help check it and let me know if you need any info/testing for
>> it, thanks.

Is this a new test, or a new problem?
>>
>> repo:https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
>> branch:for-next
>> commit: 59ef8180748269837975c9656b586daa16bb9def
>>
>> reproducer:
>> dd if=/dev/zero bs=1M count=2000 of=file0.img
>> dd if=/dev/zero bs=1M count=2000 of=file1.img
>> dd if=/dev/zero bs=1M count=2000 of=file2.img
>> dd if=/dev/zero bs=1M count=2000 of=file4.img
>> losetup -fP --show file0.img
>> losetup -fP --show file1.img
>> losetup -fP --show file2.img
>> losetup -fP --show file3.img

above dd creat file4, here is file3.

>> pvcreate -y  /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
>> vgcreate  black_bird  /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
>> lvcreate --type raid1 -m 3 -n non_synced_primary_raid_3legs_1   -L 1G
>> black_bird        /dev/loop0:0-300     /dev/loop1:0-300
>> /dev/loop2:0-300  /dev/loop3:0-300

I don't understand what /dev/loopx:0-300 means, and I remove them, fix
the above file4 typo, test on a xfs filesystem, and I can't reporduce
the problem.

>>
>>
>> console log:
>> May 21 21:57:41 dell-per640-04 journal: Create raid1
>> May 21 21:57:41 dell-per640-04 kernel: device-mapper: raid:
>> Superblocks created for new raid set
>> May 21 21:57:42 dell-per640-04 kernel: md/raid1:mdX: not clean --
>> starting background reconstruction
>> May 21 21:57:42 dell-per640-04 kernel: md/raid1:mdX: active with 4 out
>> of 4 mirrors
>> May 21 21:57:42 dell-per640-04 kernel: mdX: bitmap file is out of
>> date, doing full recovery
>> May 21 21:57:42 dell-per640-04 kernel: md: resync of RAID array mdX
>> May 21 21:57:42 dell-per640-04 systemd[1]: Started Device-mapper event daemon.
>> May 21 21:57:42 dell-per640-04 dmeventd[42170]: dmeventd ready for processing.
>> May 21 21:57:42 dell-per640-04 dmeventd[42170]: Monitoring RAID device
>> black_bird-non_synced_primary_raid_3legs_1 for events.
>> May 21 21:57:45 dell-per640-04 restraintd[1446]: *** Current Time: Tue
>> May 21 21:57:45 2024  Localwatchdog at: Tue May 21 22:56:45 2024
>> May 21 21:58:45 dell-per640-04 restraintd[1446]: *** Current Time: Tue
>> May 21 21:58:45 2024  Localwatchdog at: Tue May 21 22:56:45 2024
>> May 21 21:59:45 dell-per640-04 restraintd[1446]: *** Current Time: Tue
>> May 21 21:59:45 2024  Localwatchdog at: Tue May 21 22:56:45 2024
>> May 21 21:59:53 dell-per640-04 kernel: INFO: task mdX_resync:42168
>> blocked for more than 122 seconds.
>> May 21 21:59:53 dell-per640-04 kernel:      Not tainted 6.9.0+ #1
>> May 21 21:59:53 dell-per640-04 kernel: "echo 0 >
>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> May 21 21:59:53 dell-per640-04 kernel: task:mdX_resync      state:D
>> stack:0     pid:42168 tgid:42168 ppid:2      flags:0x00004000
>> May 21 21:59:53 dell-per640-04 kernel: Call Trace:
>> May 21 21:59:53 dell-per640-04 kernel: <TASK>
>> May 21 21:59:53 dell-per640-04 kernel: __schedule+0x222/0x670
>> May 21 21:59:53 dell-per640-04 kernel: ? blk_mq_flush_plug_list+0x5/0x20
>> May 21 21:59:53 dell-per640-04 kernel: schedule+0x2c/0xb0
>> May 21 21:59:53 dell-per640-04 kernel: raise_barrier+0x107/0x200 [raid1]

Unless this is a deadlock, raise_barrier() should be waiting for normal
IO that is issued to underlying disk to return. If you can reporduce the
problem, can you check IO from underlying loop disks?

cat /sys/block/loopx/inflight

Thanks,
Kuai

>> May 21 21:59:53 dell-per640-04 kernel: ?
>> __pfx_autoremove_wake_function+0x10/0x10
>> May 21 21:59:53 dell-per640-04 kernel: raid1_sync_request+0x12d/0xa50 [raid1]
>> May 21 21:59:53 dell-per640-04 kernel: ?
>> __pfx_raid1_sync_request+0x10/0x10 [raid1]
>> May 21 21:59:53 dell-per640-04 kernel: md_do_sync+0x660/0x1040
>> May 21 21:59:53 dell-per640-04 kernel: ?
>> __pfx_autoremove_wake_function+0x10/0x10
>> May 21 21:59:53 dell-per640-04 kernel: md_thread+0xad/0x160
>> May 21 21:59:53 dell-per640-04 kernel: ? __pfx_md_thread+0x10/0x10
>> May 21 21:59:53 dell-per640-04 kernel: kthread+0xdc/0x110
>> May 21 21:59:53 dell-per640-04 kernel: ? __pfx_kthread+0x10/0x10
>> May 21 21:59:53 dell-per640-04 kernel: ret_from_fork+0x2d/0x50
>> May 21 21:59:53 dell-per640-04 kernel: ? __pfx_kthread+0x10/0x10
>> May 21 21:59:53 dell-per640-04 kernel: ret_from_fork_asm+0x1a/0x30
>> May 21 21:59:53 dell-per640-04 kernel: </TASK>
>>
>>
>> --
>> Best Regards,
>>       Changhui
>>
> 

