Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801A3315AF
	for <dm-devel@lists.linux.dev>; Wed,  6 Dec 2023 11:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Slb2t5nKJz4f3lD9
	for <dm-devel@lists.linux.dev>; Wed,  6 Dec 2023 19:36:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 88C681A0916
	for <dm-devel@lists.linux.dev>; Wed,  6 Dec 2023 19:36:43 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgDn6hDJXHBlrr2VCw--.32227S3;
	Wed, 06 Dec 2023 19:36:43 +0800 (CST)
Subject: Re: [PATCH -next] md: split MD_RECOVERY_NEEDED out of mddev_resume
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 dm-devel@lists.linux.dev, janpieter.sollie@edpnet.be,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20231204031703.3102254-1-yukuai1@huaweicloud.com>
 <CAPhsuW4sF=jAyA+Q=2tFBBAApjcW=gWXndDNX6t3nrAfnk_zZA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <269ac5cb-aa09-02ca-4150-c90cd5a72e06@huaweicloud.com>
Date: Wed, 6 Dec 2023 19:36:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CAPhsuW4sF=jAyA+Q=2tFBBAApjcW=gWXndDNX6t3nrAfnk_zZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDn6hDJXHBlrr2VCw--.32227S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZFWxWw45tryrWr13tF18Zrb_yoWrJF1kpa
	yxtF95Wr4kZa93ZrWUG3WkWa48Zw4jgrZrtrW3Wa4kA3s5K34fGF15ur1UJrWDt34SqFsx
	ta15Za1kAryrKFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
	3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2023/12/06 16:30, Song Liu 写道:
> On Sun, Dec 3, 2023 at 7:18 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> New mddev_resume() calls are added to synchroniza IO with array
>> reconfiguration, however, this introduce a regression while adding it in
>> md_start_sync():
>>
>> 1) someone set MD_RECOVERY_NEEDED first;
>> 2) daemon thread grab reconfig_mutex, then clear MD_RECOVERY_NEEDED and
>>     queue a new sync work;
>> 3) daemon thread release reconfig_mutex;
>> 4) in md_start_sync
>>     a) check that there are spares that can be added/removed, then suspend
>>        the array;
>>     b) remove_and_add_spares may not be called, or called without really
>>        add/remove spares;
>>     c) resume the array, then set MD_RECOVERY_NEEDED again!
>>
>> Loop between 2 - 4, then mddev_suspend() will be called quite often, for
>> consequence, normal IO will be quite slow.
>>
>> Fix this problem by spliting MD_RECOVERY_NEEDED out of mddev_resume(), so
>> that md_start_sync() won't set such flag and hence the loop will be broken.
> 
> I hope we don't leak set_bit MD_RECOVERY_NEEDED to all call
> sites of mddev_resume().

There are also some other mddev_resume() that is added later and don't
need recovery, so md_start_sync() is not the only place:

  - md_setup_drive
  - rdev_attr_store
  - suspend_lo_store
  - suspend_hi_store
  - autorun_devices
  - md_ioct
  - r5c_disable_writeback_async
  - error path from new_dev_store(), ...

I'm not sure add a new helper is a good idea, because all above apis
should use new helper as well.

> 
> How about something like the following instead?
> 
> Please also incorporate feedback from Paul in the next version.

Of course.

Thanks,
Kuai

> 
> Thanks,
> Song
> 
> diff --git i/drivers/md/md.c w/drivers/md/md.c
> index c94373d64f2c..2d53e1b57070 100644
> --- i/drivers/md/md.c
> +++ w/drivers/md/md.c
> @@ -490,7 +490,7 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
>   }
>   EXPORT_SYMBOL_GPL(mddev_suspend);
> 
> -void mddev_resume(struct mddev *mddev)
> +static void __mddev_resume(struct mddev *mddev, bool recovery_needed)
>   {
>          lockdep_assert_not_held(&mddev->reconfig_mutex);
> 
> @@ -507,12 +507,18 @@ void mddev_resume(struct mddev *mddev)
>          percpu_ref_resurrect(&mddev->active_io);
>          wake_up(&mddev->sb_wait);
> 
> -       set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +       if (recovery_needed)
> +               set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>          md_wakeup_thread(mddev->thread);
>          md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
> 
>          mutex_unlock(&mddev->suspend_mutex);
>   }
> +
> +void mddev_resume(struct mddev *mddev)
> +{
> +       __mddev_resume(mddev, true);
> +}
>   EXPORT_SYMBOL_GPL(mddev_resume);
> 
>   /*
> @@ -9403,7 +9409,9 @@ static void md_start_sync(struct work_struct *ws)
>                  goto not_running;
>          }
> 
> -       suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
> +       mddev_unlock(mddev);
> +       if (suspend)
> +               __mddev_resume(mddev, false);
>          md_wakeup_thread(mddev->sync_thread);
>          sysfs_notify_dirent_safe(mddev->sysfs_action);
>          md_new_event();
> @@ -9415,7 +9423,9 @@ static void md_start_sync(struct work_struct *ws)
>          clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
>          clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
>          clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> -       suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
> +       mddev_unlock(mddev);
> +       if (suspend)
> +               __mddev_resume(mddev, false);
> 
>          wake_up(&resync_wait);
>          if (test_and_clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
> 
> .
> 

