Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA0EC15B;
	Tue, 21 May 2024 02:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716258067; cv=none; b=AJgIpauX7gFTkq2/7l9OQFrIU9DgTur+pxy48PaMLPQgoaSI6wcFHNi9vSC+ZWARFloeo9slqSaDiq6CzvAKZVAVCu/2MPiLqgzEgFs/hhNwp7ROcazIGk4eQc2uGvO4yRsDbPI8ileQfni6qIrPkuJtqmnndIfTuPEZQqziyXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716258067; c=relaxed/simple;
	bh=/BeO9hMos7UNImzu/E+YX89R+mqzXMBXTshZYQsGyrQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Zkst0iWLLtD8swaFWjDxu118Kfw2kpLvRkfGXyE5qDlKJtfGkRWdmPpeHPYL92U0k5dD0+TsjlbMZ1W9MEjG4pjZLDELJ0VRbskYwhpjCwRtEaoYy1C/S6xM+MQjVQksA0AmiYLcPoe0qFAi7092TI7w9zO5/aWTo2Bdw4iiaOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VjypZ2Pk2z4f3jjs;
	Tue, 21 May 2024 10:20:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 167771A0181;
	Tue, 21 May 2024 10:21:00 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBnOBEGBUxmrkD1NA--.31413S3;
	Tue, 21 May 2024 10:20:56 +0800 (CST)
Subject: Re: [PATCH md-6.10 5/9] md: replace sysfs api sync_action with new
 helpers
To: kernel test robot <oliver.sang@intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-raid@vger.kernel.org,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 xni@redhat.com, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <202405202204.4e3dc662-oliver.sang@intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c9406496-7b97-a3c5-b48c-32f8248cee39@huaweicloud.com>
Date: Tue, 21 May 2024 10:20:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <202405202204.4e3dc662-oliver.sang@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBnOBEGBUxmrkD1NA--.31413S3
X-Coremail-Antispam: 1UD129KBjvJXoWxArW7ZryDGFW5Zr1kAF47Jwb_yoW5tw1xpw
	48G3Z0kF4rJFnYyFW8Gay0va4Yqan3Jw15G34DG340yF4jkr1Syr1Sqrya9rnFkrZ093yS
	v397Xry5Kw4qg3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

ÔÚ 2024/05/20 23:01, kernel test robot Ð´µÀ:
> 
> 
> Hello,
> 
> kernel test robot noticed "mdadm-selftests.07reshape5intr.fail" on:
> 
> commit: 18effaab5f57ef44763e537c782f905e06f6c4f5 ("[PATCH md-6.10 5/9] md: replace sysfs api sync_action with new helpers")
> url: https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-rearrange-recovery_flage/20240509-093248
> base: https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git for-next
> patch link: https://lore.kernel.org/all/20240509011900.2694291-6-yukuai1@huaweicloud.com/
> patch subject: [PATCH md-6.10 5/9] md: replace sysfs api sync_action with new helpers
> 
> in testcase: mdadm-selftests
> version: mdadm-selftests-x86_64-5f41845-1_20240412
> with following parameters:
> 
> 	disk: 1HDD
> 	test_prefix: 07reshape5intr
> 
> 
> 
> compiler: gcc-13
> test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4790T CPU @ 2.70GHz (Haswell) with 16G memory
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202405202204.4e3dc662-oliver.sang@intel.com
> 
> 2024-05-14 21:36:26 mkdir -p /var/tmp
> 2024-05-14 21:36:26 mke2fs -t ext3 -b 4096 -J size=4 -q /dev/sda1
> 2024-05-14 21:36:57 mount -t ext3 /dev/sda1 /var/tmp
> sed -e 's/{DEFAULT_METADATA}/1.2/g' \
> -e 's,{MAP_PATH},/run/mdadm/map,g'  mdadm.8.in > mdadm.8
> /usr/bin/install -D -m 644 mdadm.8 /usr/share/man/man8/mdadm.8
> /usr/bin/install -D -m 644 mdmon.8 /usr/share/man/man8/mdmon.8
> /usr/bin/install -D -m 644 md.4 /usr/share/man/man4/md.4
> /usr/bin/install -D -m 644 mdadm.conf.5 /usr/share/man/man5/mdadm.conf.5
> /usr/bin/install -D -m 644 udev-md-raid-creating.rules /lib/udev/rules.d/01-md-raid-creating.rules
> /usr/bin/install -D -m 644 udev-md-raid-arrays.rules /lib/udev/rules.d/63-md-raid-arrays.rules
> /usr/bin/install -D -m 644 udev-md-raid-assembly.rules /lib/udev/rules.d/64-md-raid-assembly.rules
> /usr/bin/install -D -m 644 udev-md-clustered-confirm-device.rules /lib/udev/rules.d/69-md-clustered-confirm-device.rules
> /usr/bin/install -D  -m 755 mdadm /sbin/mdadm
> /usr/bin/install -D  -m 755 mdmon /sbin/mdmon
> Testing on linux-6.9.0-rc2-00012-g18effaab5f57 kernel
> /lkp/benchmarks/mdadm-selftests/tests/07reshape5intr... FAILED - see /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for detail
[root@fedora mdadm]# ./test --dev=loop --tests=07reshape5intr
test: skipping tests for multipath, which is removed in upstream 6.8+ 
kernels
test: skipping tests for linear, which is removed in upstream 6.8+ kernels
Testing on linux-6.9.0-rc2-00023-gf092583596a2 kernel
/root/mdadm/tests/07reshape5intr... FAILED - see 
/var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for details
   (KNOWN BROKEN TEST: always fails)

So, since this test is marked BROKEN.

Please share the whole log, and is it possible to share the two logs?

Thanks,
Kuai

> 
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20240520/202405202204.4e3dc662-oliver.sang@intel.com
> 
> 
> 

