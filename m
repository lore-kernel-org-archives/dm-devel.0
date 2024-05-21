Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1091078B;
	Tue, 21 May 2024 03:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716261131; cv=none; b=kVbvzQo3v5rGmCgI2BTu1uzLBzwVA9sA8iUd5IGpzwYT9QQ2u8m1b6IuJxGUbsWbk4IZ/zVRsJvoMt7DwsGm2TkUg9zh92y/MKN1vJsMMcqk4QqtyyC2Tb0bJlCr0zR8xxpzZ8Hp3C7OUvIGuiJSkgd6UGCsSQC0nOxG9SQw3aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716261131; c=relaxed/simple;
	bh=Ztp8tWwtYacrLH0tcn1Oo/H+gJbLpHCIaW8drioba/4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=MUz5DPiS1zFJbf2JKlJWcSR+uyzDyFaUuZFxm/HTv+rLbobmCpk4fxxAOUN/8jwUQbG9RqRqmNQqn2FrSugnUnbuzwf23s8CniEOHh04S/qujr3/e7lWE2mXif5dVPQjOA7h4gFdN2xRnUWcK2nl696YdmMLnrjlZjTaec08Fg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VjzxN43xvz4f3jkj;
	Tue, 21 May 2024 11:11:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 505E61A016E;
	Tue, 21 May 2024 11:11:58 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ75EExm7Yj4NA--.50760S3;
	Tue, 21 May 2024 11:11:55 +0800 (CST)
Subject: Re: [PATCH md-6.10 5/9] md: replace sysfs api sync_action with new
 helpers
To: Oliver Sang <oliver.sang@intel.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-raid@vger.kernel.org,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 xni@redhat.com, dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <202405202204.4e3dc662-oliver.sang@intel.com>
 <c9406496-7b97-a3c5-b48c-32f8248cee39@huaweicloud.com>
 <ZkwOpD8rjYeb+4eT@xsang-OptiPlex-9020>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e822d3bb-ec27-5bc8-e9c2-bef6d0454918@huaweicloud.com>
Date: Tue, 21 May 2024 11:11:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <ZkwOpD8rjYeb+4eT@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHZQ75EExm7Yj4NA--.50760S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCFW7CF45tFyDGFy8Wr1UAwb_yoWrWw45pw
	4kX3Z0yF4rJFn0yF48Kw40va4Yqa1fJrn8W34DG340ya1qyrySyr1Sqr1a9r9FkrZ093y2
	v3ykXry3Kw4qg3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
	JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3
	Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/05/21 11:01, Oliver Sang 写道:
> hi, Yu Kuai,
> 
> On Tue, May 21, 2024 at 10:20:54AM +0800, Yu Kuai wrote:
>> Hi,
>>
>> 在 2024/05/20 23:01, kernel test robot 写道:
>>>
>>>
>>> Hello,
>>>
>>> kernel test robot noticed "mdadm-selftests.07reshape5intr.fail" on:
>>>
>>> commit: 18effaab5f57ef44763e537c782f905e06f6c4f5 ("[PATCH md-6.10 5/9] md: replace sysfs api sync_action with new helpers")
>>> url: https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-rearrange-recovery_flage/20240509-093248
>>> base: https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git for-next
>>> patch link: https://lore.kernel.org/all/20240509011900.2694291-6-yukuai1@huaweicloud.com/
>>> patch subject: [PATCH md-6.10 5/9] md: replace sysfs api sync_action with new helpers
>>>
>>> in testcase: mdadm-selftests
>>> version: mdadm-selftests-x86_64-5f41845-1_20240412
>>> with following parameters:
>>>
>>> 	disk: 1HDD
>>> 	test_prefix: 07reshape5intr
>>>
>>>
>>>
>>> compiler: gcc-13
>>> test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4790T CPU @ 2.70GHz (Haswell) with 16G memory
>>>
>>> (please refer to attached dmesg/kmsg for entire log/backtrace)
>>>
>>>
>>>
>>>
>>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>>> the same patch/commit), kindly add following tags
>>> | Reported-by: kernel test robot <oliver.sang@intel.com>
>>> | Closes: https://lore.kernel.org/oe-lkp/202405202204.4e3dc662-oliver.sang@intel.com
>>>
>>> 2024-05-14 21:36:26 mkdir -p /var/tmp
>>> 2024-05-14 21:36:26 mke2fs -t ext3 -b 4096 -J size=4 -q /dev/sda1
>>> 2024-05-14 21:36:57 mount -t ext3 /dev/sda1 /var/tmp
>>> sed -e 's/{DEFAULT_METADATA}/1.2/g' \
>>> -e 's,{MAP_PATH},/run/mdadm/map,g'  mdadm.8.in > mdadm.8
>>> /usr/bin/install -D -m 644 mdadm.8 /usr/share/man/man8/mdadm.8
>>> /usr/bin/install -D -m 644 mdmon.8 /usr/share/man/man8/mdmon.8
>>> /usr/bin/install -D -m 644 md.4 /usr/share/man/man4/md.4
>>> /usr/bin/install -D -m 644 mdadm.conf.5 /usr/share/man/man5/mdadm.conf.5
>>> /usr/bin/install -D -m 644 udev-md-raid-creating.rules /lib/udev/rules.d/01-md-raid-creating.rules
>>> /usr/bin/install -D -m 644 udev-md-raid-arrays.rules /lib/udev/rules.d/63-md-raid-arrays.rules
>>> /usr/bin/install -D -m 644 udev-md-raid-assembly.rules /lib/udev/rules.d/64-md-raid-assembly.rules
>>> /usr/bin/install -D -m 644 udev-md-clustered-confirm-device.rules /lib/udev/rules.d/69-md-clustered-confirm-device.rules
>>> /usr/bin/install -D  -m 755 mdadm /sbin/mdadm
>>> /usr/bin/install -D  -m 755 mdmon /sbin/mdmon
>>> Testing on linux-6.9.0-rc2-00012-g18effaab5f57 kernel
>>> /lkp/benchmarks/mdadm-selftests/tests/07reshape5intr... FAILED - see /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for detail
>> [root@fedora mdadm]# ./test --dev=loop --tests=07reshape5intr
>> test: skipping tests for multipath, which is removed in upstream 6.8+
>> kernels
>> test: skipping tests for linear, which is removed in upstream 6.8+ kernels
>> Testing on linux-6.9.0-rc2-00023-gf092583596a2 kernel
>> /root/mdadm/tests/07reshape5intr... FAILED - see /var/tmp/07reshape5intr.log
>> and /var/tmp/fail07reshape5intr.log for details
>>    (KNOWN BROKEN TEST: always fails)
>>
>> So, since this test is marked BROKEN.
>>
>> Please share the whole log, and is it possible to share the two logs?
> 
> 
> we only captured one log as attached log-18effaab5f.
> also attached parent log FYI.
I mean please ignore the BROKEN test, and next time attach the two logs
if possible:

/var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log

Thanks for the test, we really need a per patch CI.
Kuai

> 
> 
>>
>> Thanks,
>> Kuai
>>
>>>
>>>
>>>
>>> The kernel config and materials to reproduce are available at:
>>> https://download.01.org/0day-ci/archive/20240520/202405202204.4e3dc662-oliver.sang@intel.com
>>>
>>>
>>>
>>

