Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335864C7B;
	Wed, 22 May 2024 02:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716345975; cv=none; b=G3f6gOzE47/OVQkI1Emzy6fdhQL7VE0+Z/l0BHE0wKAIvJ1RDgKsCZikftxGKDRc6kJXlZV1OV54EvlR5Jly5Cf1DzDGL/KaqdoGRTSP4+2nV/piQ3oX3CtESOqir+B1i2/2ZDcofZmGfQpkKw18T4vliSZV+VT0Wwq9S7knIXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716345975; c=relaxed/simple;
	bh=SERIfTUtjRLtnnTyu2LrMnGylfL7UiRq1W08iv8nLQM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=QD/kKGQuLG0qrF/c/S8UXNPXsD3PDNNRhI8vRQxiQ/0cIymDe1tazKHfI1VXrySSrqdmIIr7rkIbyNAaBg2Nqu4qsxBgTMtMniG8w6AW/joRi5pNo3LGw2MsRtwWYhLeWaUh1wDBTAK9IKiJ7bONf6kxT6+D64O/D6u3xWCCOwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VkbK30j0Bz4f3m7V;
	Wed, 22 May 2024 10:45:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 8FECB1A01D2;
	Wed, 22 May 2024 10:46:09 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX6RFrXE1mMDtTNQ--.18221S3;
	Wed, 22 May 2024 10:46:05 +0800 (CST)
Subject: Re: [PATCH md-6.10 5/9] md: replace sysfs api sync_action with new
 helpers
To: Xiao Ni <xni@redhat.com>, Oliver Sang <oliver.sang@intel.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, oe-lkp@lists.linux.dev, lkp@intel.com,
 linux-raid@vger.kernel.org, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <202405202204.4e3dc662-oliver.sang@intel.com>
 <c9406496-7b97-a3c5-b48c-32f8248cee39@huaweicloud.com>
 <ZkwOpD8rjYeb+4eT@xsang-OptiPlex-9020>
 <CALTww29kyA71WVRxh32W0NkOwZbHkFcs=fTCL5in=e5OhtJ-HA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ef9e7de5-9ae5-faae-1c4c-9d6357fb6ae2@huaweicloud.com>
Date: Wed, 22 May 2024 10:46:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CALTww29kyA71WVRxh32W0NkOwZbHkFcs=fTCL5in=e5OhtJ-HA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX6RFrXE1mMDtTNQ--.18221S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKr15Cr18XF45ZFWkAry3CFg_yoW7Xr45pw
	48J3Z8tF4rJ3Z5AFW8Ka10qa4Fqw4fJry5W34DG340yF4qyr1Svr1Syr1akryqkrZ0k3y2
	v3yxXr9xWw4jg3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9214x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWr
	Zr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUQvtAUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/05/21 11:21, Xiao Ni 写道:
> Hi Kuai
> 
> I've tested 07reshape5intr with the latest upstream kernel 15 times
> without failure. So it's better to have a try with 07reshape5intr with
> your patch set.

I just discussed with Xiao on slack, for conclusion here:

The test 07reshape5intr will add a new disk to array, then start
reshape:

mdadm /dev/md0 --add /dev/xxx
mdadm --grow /dev/md0 -n 3

However, the grow will fail:
mdadm: Failed to initiate reshape!

Root cause is that in kernel, action_store() will return -EBUSY
if MD_RECOVERY_RUNNING is set:

// mdadm add
add_bound_rdev
  set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);

// daemon thread
md_check_recovery
  set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
  // do nothing
		// mdadm grow
		action_store
		 if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
		  return -EBUSY
  clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery)

This is a long term problem, and we need new synchronization in kernel
to make sure the grow won't fail.

Thanks,
Kuai

> 
> Regards
> Xiao
> 
> 
> 
> 
> On Tue, May 21, 2024 at 11:02 AM Oliver Sang <oliver.sang@intel.com> wrote:
>>
>> hi, Yu Kuai,
>>
>> On Tue, May 21, 2024 at 10:20:54AM +0800, Yu Kuai wrote:
>>> Hi,
>>>
>>> 在 2024/05/20 23:01, kernel test robot 写道:
>>>>
>>>>
>>>> Hello,
>>>>
>>>> kernel test robot noticed "mdadm-selftests.07reshape5intr.fail" on:
>>>>
>>>> commit: 18effaab5f57ef44763e537c782f905e06f6c4f5 ("[PATCH md-6.10 5/9] md: replace sysfs api sync_action with new helpers")
>>>> url: https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-rearrange-recovery_flage/20240509-093248
>>>> base: https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git for-next
>>>> patch link: https://lore.kernel.org/all/20240509011900.2694291-6-yukuai1@huaweicloud.com/
>>>> patch subject: [PATCH md-6.10 5/9] md: replace sysfs api sync_action with new helpers
>>>>
>>>> in testcase: mdadm-selftests
>>>> version: mdadm-selftests-x86_64-5f41845-1_20240412
>>>> with following parameters:
>>>>
>>>>      disk: 1HDD
>>>>      test_prefix: 07reshape5intr
>>>>
>>>>
>>>>
>>>> compiler: gcc-13
>>>> test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4790T CPU @ 2.70GHz (Haswell) with 16G memory
>>>>
>>>> (please refer to attached dmesg/kmsg for entire log/backtrace)
>>>>
>>>>
>>>>
>>>>
>>>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>>>> the same patch/commit), kindly add following tags
>>>> | Reported-by: kernel test robot <oliver.sang@intel.com>
>>>> | Closes: https://lore.kernel.org/oe-lkp/202405202204.4e3dc662-oliver.sang@intel.com
>>>>
>>>> 2024-05-14 21:36:26 mkdir -p /var/tmp
>>>> 2024-05-14 21:36:26 mke2fs -t ext3 -b 4096 -J size=4 -q /dev/sda1
>>>> 2024-05-14 21:36:57 mount -t ext3 /dev/sda1 /var/tmp
>>>> sed -e 's/{DEFAULT_METADATA}/1.2/g' \
>>>> -e 's,{MAP_PATH},/run/mdadm/map,g'  mdadm.8.in > mdadm.8
>>>> /usr/bin/install -D -m 644 mdadm.8 /usr/share/man/man8/mdadm.8
>>>> /usr/bin/install -D -m 644 mdmon.8 /usr/share/man/man8/mdmon.8
>>>> /usr/bin/install -D -m 644 md.4 /usr/share/man/man4/md.4
>>>> /usr/bin/install -D -m 644 mdadm.conf.5 /usr/share/man/man5/mdadm.conf.5
>>>> /usr/bin/install -D -m 644 udev-md-raid-creating.rules /lib/udev/rules.d/01-md-raid-creating.rules
>>>> /usr/bin/install -D -m 644 udev-md-raid-arrays.rules /lib/udev/rules.d/63-md-raid-arrays.rules
>>>> /usr/bin/install -D -m 644 udev-md-raid-assembly.rules /lib/udev/rules.d/64-md-raid-assembly.rules
>>>> /usr/bin/install -D -m 644 udev-md-clustered-confirm-device.rules /lib/udev/rules.d/69-md-clustered-confirm-device.rules
>>>> /usr/bin/install -D  -m 755 mdadm /sbin/mdadm
>>>> /usr/bin/install -D  -m 755 mdmon /sbin/mdmon
>>>> Testing on linux-6.9.0-rc2-00012-g18effaab5f57 kernel
>>>> /lkp/benchmarks/mdadm-selftests/tests/07reshape5intr... FAILED - see /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for detail
>>> [root@fedora mdadm]# ./test --dev=loop --tests=07reshape5intr
>>> test: skipping tests for multipath, which is removed in upstream 6.8+
>>> kernels
>>> test: skipping tests for linear, which is removed in upstream 6.8+ kernels
>>> Testing on linux-6.9.0-rc2-00023-gf092583596a2 kernel
>>> /root/mdadm/tests/07reshape5intr... FAILED - see /var/tmp/07reshape5intr.log
>>> and /var/tmp/fail07reshape5intr.log for details
>>>    (KNOWN BROKEN TEST: always fails)
>>>
>>> So, since this test is marked BROKEN.
>>>
>>> Please share the whole log, and is it possible to share the two logs?
>>
>>
>> we only captured one log as attached log-18effaab5f.
>> also attached parent log FYI.
>>
>>
>>>
>>> Thanks,
>>> Kuai
>>>
>>>>
>>>>
>>>>
>>>> The kernel config and materials to reproduce are available at:
>>>> https://download.01.org/0day-ci/archive/20240520/202405202204.4e3dc662-oliver.sang@intel.com
>>>>
>>>>
>>>>
>>>
> 
> 
> .
> 

