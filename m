Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189258F55
	for <dm-devel@lists.linux.dev>; Fri, 17 May 2024 02:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715914171; cv=none; b=tAdocyRqw3b7UAdBXCr4Fx9IURN2GMJ+/4V2OJNqRRV8gnUMPY1APwiCAy5ufvFltdzCOi6vwWbs+D5JSPk0+x5cc02fU8wScE25/h0DpLe1gN+IcUP1YQBvCem8FNimPJ10c9ULw2VLiDPGThSPZBgjm/yXnolxYC0Pz31gtX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715914171; c=relaxed/simple;
	bh=Hu0Z7Z74ARQaFc+pSG+MQ95/TdU0ICNCHEmYuoT959o=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PJe0hZ+ql31a2iFuUo/YxP1QHpUHcXAGf+qkIcqYt1dqCppPQIZbUcTYPwQCHVQdyFyOLIl9TBTd/B8/s6pzqBjovKGE+UfXpPUhpqVWqAyat6I/Lg5mCXqVl0pCzMApNdZ+0phV0tKJwxqqlTyK6Q8QorQ3J6TDZ/gQlaLJn0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VgWd83FkGz4f3jHc
	for <dm-devel@lists.linux.dev>; Fri, 17 May 2024 10:49:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 32CB71A0845
	for <dm-devel@lists.linux.dev>; Fri, 17 May 2024 10:49:25 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ6xxUZmeyKDMw--.21200S3;
	Fri, 17 May 2024 10:49:23 +0800 (CST)
Subject: Re: [bug report] INFO: task mdX_resync:42168 blocked for more than
 122 seconds
To: Changhui Zhong <czhong@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ming Lei <ming.lei@redhat.com>,
 Linux Block Devices <linux-block@vger.kernel.org>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 Xiao Ni <xni@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
 <ZkXsOKV5d4T0Hyqu@fedora>
 <9b340157-dc0c-6e6a-3d92-f2c65b515461@huaweicloud.com>
 <CAGVVp+XtThX7=bZm441VxyVd-wv_ycdqMU=19a2pa4wUkbkJ3g@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1b35a177-670a-4d2f-0b68-6eda769af37d@huaweicloud.com>
Date: Fri, 17 May 2024 10:49:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAGVVp+XtThX7=bZm441VxyVd-wv_ycdqMU=19a2pa4wUkbkJ3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHZQ6xxUZmeyKDMw--.21200S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XFW7CryDJrWxXr47WF1rZwb_yoW3CrWfp3
	4rta1jgr4UWwsYyay29w129FyUtanxXr1UWrZxKr18AF1vkF4fXFZxJw1UuasrKryDua10
	gw15JrZrXw1jgwUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
	3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/05/17 10:25, Changhui Zhong 写道:
> On Thu, May 16, 2024 at 7:42 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/05/16 19:21, Ming Lei 写道:
>>> Cc raid and dm list.
>>>
>>> On Thu, May 16, 2024 at 06:24:18PM +0800, Changhui Zhong wrote:
>>>> Hello,
>>>>
>>>> when create lvm raid1, the command hang on for a long time.
>>>> please help check it and let me know if you need any info/testing for
>>>> it, thanks.
>>
>> Is this a new test, or a new problem?
> 
> it is a new problem, I am not hit this issue on 6.9.0-rc4+

There is just one patch for raid1 applied since v6.9-rc4, and I think
it's not related. Perhaps can you try to bisect?

> 
>>>>
>>>> repo:https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
>>>> branch:for-next
>>>> commit: 59ef8180748269837975c9656b586daa16bb9def
>>>>
>>>> reproducer:
>>>> dd if=/dev/zero bs=1M count=2000 of=file0.img
>>>> dd if=/dev/zero bs=1M count=2000 of=file1.img
>>>> dd if=/dev/zero bs=1M count=2000 of=file2.img
>>>> dd if=/dev/zero bs=1M count=2000 of=file4.img
>>>> losetup -fP --show file0.img
>>>> losetup -fP --show file1.img
>>>> losetup -fP --show file2.img
>>>> losetup -fP --show file3.img
>>
>> above dd creat file4, here is file3.
> 
> yeah，this is my spelling mistake, I created 4 files, file0/1/2/3
> 
>>
>>>> pvcreate -y  /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
>>>> vgcreate  black_bird  /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
>>>> lvcreate --type raid1 -m 3 -n non_synced_primary_raid_3legs_1   -L 1G
>>>> black_bird        /dev/loop0:0-300     /dev/loop1:0-300
>>>> /dev/loop2:0-300  /dev/loop3:0-300
>>
>> I don't understand what /dev/loopx:0-300 means, and I remove them, fix
>> the above file4 typo, test on a xfs filesystem, and I can't reporduce
>> the problem.
>>
> 
> I want to specify the space from disk blocks 0 to 300 of the loop
> device to create raid1，not all space of loop device，
> follow reproducer setps I can reproduced it 100%

Okay, I add the 0-300 and I still can't reporduce it, have no clue yet.
> 
>>>>
>>>>
>>>> console log:
>>>> May 21 21:57:41 dell-per640-04 journal: Create raid1
>>>> May 21 21:57:41 dell-per640-04 kernel: device-mapper: raid:
>>>> Superblocks created for new raid set
>>>> May 21 21:57:42 dell-per640-04 kernel: md/raid1:mdX: not clean --
>>>> starting background reconstruction
>>>> May 21 21:57:42 dell-per640-04 kernel: md/raid1:mdX: active with 4 out
>>>> of 4 mirrors
>>>> May 21 21:57:42 dell-per640-04 kernel: mdX: bitmap file is out of
>>>> date, doing full recovery
>>>> May 21 21:57:42 dell-per640-04 kernel: md: resync of RAID array mdX
>>>> May 21 21:57:42 dell-per640-04 systemd[1]: Started Device-mapper event daemon.
>>>> May 21 21:57:42 dell-per640-04 dmeventd[42170]: dmeventd ready for processing.
>>>> May 21 21:57:42 dell-per640-04 dmeventd[42170]: Monitoring RAID device
>>>> black_bird-non_synced_primary_raid_3legs_1 for events.
>>>> May 21 21:57:45 dell-per640-04 restraintd[1446]: *** Current Time: Tue
>>>> May 21 21:57:45 2024  Localwatchdog at: Tue May 21 22:56:45 2024
>>>> May 21 21:58:45 dell-per640-04 restraintd[1446]: *** Current Time: Tue
>>>> May 21 21:58:45 2024  Localwatchdog at: Tue May 21 22:56:45 2024
>>>> May 21 21:59:45 dell-per640-04 restraintd[1446]: *** Current Time: Tue
>>>> May 21 21:59:45 2024  Localwatchdog at: Tue May 21 22:56:45 2024
>>>> May 21 21:59:53 dell-per640-04 kernel: INFO: task mdX_resync:42168
>>>> blocked for more than 122 seconds.
>>>> May 21 21:59:53 dell-per640-04 kernel:      Not tainted 6.9.0+ #1
>>>> May 21 21:59:53 dell-per640-04 kernel: "echo 0 >
>>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>> May 21 21:59:53 dell-per640-04 kernel: task:mdX_resync      state:D
>>>> stack:0     pid:42168 tgid:42168 ppid:2      flags:0x00004000
>>>> May 21 21:59:53 dell-per640-04 kernel: Call Trace:
>>>> May 21 21:59:53 dell-per640-04 kernel: <TASK>
>>>> May 21 21:59:53 dell-per640-04 kernel: __schedule+0x222/0x670
>>>> May 21 21:59:53 dell-per640-04 kernel: ? blk_mq_flush_plug_list+0x5/0x20
>>>> May 21 21:59:53 dell-per640-04 kernel: schedule+0x2c/0xb0
>>>> May 21 21:59:53 dell-per640-04 kernel: raise_barrier+0x107/0x200 [raid1]
>>
>> Unless this is a deadlock, raise_barrier() should be waiting for normal
>> IO that is issued to underlying disk to return. If you can reporduce the
>> problem, can you check IO from underlying loop disks?
>>
>> cat /sys/block/loopx/inflight
> 
> when this issue was triggered, the log I collected：
> 
> [root@storageqe-103 ~]# cat /sys/block/loop0/inflight
>         0        0
> [root@storageqe-103 ~]# cat /sys/block/loop1/inflight
>         0        0
> [root@storageqe-103 ~]# cat /sys/block/loop2/inflight
>         0        0
> [root@storageqe-103 ~]# cat /sys/block/loop3/inflight
>         0        0
> [root@storageqe-103 ~]#

Thanks for the test, this do look like a deadlock, beside
raise_barrier(), is there any other victim? I can't reporduce this,
and I have no clue yet. The possible next step might be bisect to
locate the blame commit first. Maybe related to dm-raid1.

Thanks,
Kuai

> 
> 
> and the command "lvs" hang on also，
> 
> [root@storageqe-103 ~]# lvs
> ^C  Interrupted...
>    Giving up waiting for lock.
>    Can't get lock for black_bird.
>    Cannot process volume group black_bird
>    LV   VG                 Attr       LSize    Pool Origin Data%  Meta%
>   Move Log Cpy%Sync Convert
>    home rhel_storageqe-103 -wi-ao---- <368.43g
>    root rhel_storageqe-103 -wi-ao----   70.00g
>    swap rhel_storageqe-103 -wi-ao----    7.70g
> [root@storageqe-103 ~]#
> 
> [ 1352.761630] INFO: task mdX_resync:1547 blocked for more than 1105 seconds.
> [ 1352.769336]       Not tainted 6.9.0+ #1
> [ 1352.773629] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 1352.782372] task:mdX_resync      state:D stack:0     pid:1547
> tgid:1547  ppid:2      flags:0x00004000
> [ 1352.782380] Call Trace:
> [ 1352.782382]  <TASK>
> [ 1352.782386]  __schedule+0x222/0x670
> [ 1352.782396]  schedule+0x2c/0xb0
> [ 1352.782402]  raise_barrier+0x107/0x200 [raid1]
> [ 1352.782415]  ? __pfx_autoremove_wake_function+0x10/0x10
> [ 1352.782423]  raid1_sync_request+0x12d/0xa50 [raid1]
> [ 1352.782435]  ? prepare_to_wait_event+0x5f/0x190
> [ 1352.782442]  md_do_sync+0x660/0x1040
> [ 1352.782449]  ? __pfx_autoremove_wake_function+0x10/0x10
> [ 1352.782457]  md_thread+0xad/0x160
> [ 1352.782462]  ? __pfx_md_thread+0x10/0x10
> [ 1352.782465]  kthread+0xdc/0x110
> [ 1352.782470]  ? __pfx_kthread+0x10/0x10
> [ 1352.782474]  ret_from_fork+0x2d/0x50
> [ 1352.782481]  ? __pfx_kthread+0x10/0x10
> [ 1352.782485]  ret_from_fork_asm+0x1a/0x30
> [ 1352.782491]  </TASK>
> 
> Thanks，
> Changhui
> 
>>
>> Thanks,
>> Kuai
>>
>>>> May 21 21:59:53 dell-per640-04 kernel: ?
>>>> __pfx_autoremove_wake_function+0x10/0x10
>>>> May 21 21:59:53 dell-per640-04 kernel: raid1_sync_request+0x12d/0xa50 [raid1]
>>>> May 21 21:59:53 dell-per640-04 kernel: ?
>>>> __pfx_raid1_sync_request+0x10/0x10 [raid1]
>>>> May 21 21:59:53 dell-per640-04 kernel: md_do_sync+0x660/0x1040
>>>> May 21 21:59:53 dell-per640-04 kernel: ?
>>>> __pfx_autoremove_wake_function+0x10/0x10
>>>> May 21 21:59:53 dell-per640-04 kernel: md_thread+0xad/0x160
>>>> May 21 21:59:53 dell-per640-04 kernel: ? __pfx_md_thread+0x10/0x10
>>>> May 21 21:59:53 dell-per640-04 kernel: kthread+0xdc/0x110
>>>> May 21 21:59:53 dell-per640-04 kernel: ? __pfx_kthread+0x10/0x10
>>>> May 21 21:59:53 dell-per640-04 kernel: ret_from_fork+0x2d/0x50
>>>> May 21 21:59:53 dell-per640-04 kernel: ? __pfx_kthread+0x10/0x10
>>>> May 21 21:59:53 dell-per640-04 kernel: ret_from_fork_asm+0x1a/0x30
>>>> May 21 21:59:53 dell-per640-04 kernel: </TASK>
>>>>
>>>>
>>>> --
>>>> Best Regards,
>>>>        Changhui
>>>>
>>>
>>
>>
> 
> .
> 

