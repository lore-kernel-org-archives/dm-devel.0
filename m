Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B467C237B67
	for <dm-devel@lists.linux.dev>; Mon, 25 Mar 2024 02:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711334518; cv=none; b=EBDt2E0k86MCKfGne0mQxzsHVLn47/IUIkmVwzI7YI2xWkshXiFVdzPJ6isyFRVUVSkiLemET2pzMDtKaTv34Ras2uRN/6JD5G1GeehHznHT6p5TM5eeKXK09oufGMq5mQSH2UW5VnxtRIdvuPNT251UjOPZouzMCqXr5r/IxUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711334518; c=relaxed/simple;
	bh=HANO1Fr/0LtGzrnMtpBEdCcyk5VFzbSLY7XTNimlMtY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FnGjKduqf9D8N3gty1nz7LpzAS8CFWN+OmR2Lr7HAYavxyXQf1zWkhgu6dRV2DL+57PHalzyDoOOqi1ZKRO2leI54fnTvncxi1NIJLCz8yNucub08QovVQNaHiYLNlp+B/tSGquWdmYsECl5XaUi/dOeWdjOyEl6V4i42HC/ycE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4V2xyy1GRsz4f3jJL
	for <dm-devel@lists.linux.dev>; Mon, 25 Mar 2024 10:41:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2C4221A017A
	for <dm-devel@lists.linux.dev>; Mon, 25 Mar 2024 10:41:50 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgCXaBFr5ABmdLT9Hw--.8973S3;
	Mon, 25 Mar 2024 10:41:48 +0800 (CST)
Subject: Re: regression: mdadm detects dm-device as partition
To: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>,
 DM-devel-linux <dm-devel@lists.linux.dev>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <35e0eae0-7fb0-4029-8445-997e22c21482@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c7db2443-06d4-a199-02ac-f58204118cb6@huaweicloud.com>
Date: Mon, 25 Mar 2024 10:41:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <35e0eae0-7fb0-4029-8445-997e22c21482@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXaBFr5ABmdLT9Hw--.8973S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw47GrWxZr4DCF1fZFyxKrg_yoW8KFyrpF
	Z5Jr4DZrWUKrn7W3yUAa129a45Grs3Jw15tr18GFWIya1UCF1jqFWF9rWa9ry5trWkJry2
	vr1DXrZ0vrsrAaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/03/21 17:17, Mateusz Kusiak 写道:
> Hello,
> We discovered an issue when trying to create imsm container with mdadm 
> on dm-device.
> 
> The scenario is as follows:
> 
> 1. Create dm device
> # echo -e '0 195312 linear /dev/nvme2n1 0' | dmsetup create nvme2n1DM
> 
> 2. Create IMSM container.
> # dmdev=$(readlink -f /dev/mapper/nvme2n1DM)
> # export IMSM_DEVNAME_AS_SERIAL=1 IMSM_NO_PLATFORM=1; mdadm --create 
> /dev/md/container --metadata=imsm --raid-disks=1 $dmdev --force
> 
> Result:
> 
> Error message is displayed
> # mdadm: imsm: /dev/dm-0 is a partition, cannot be used in IMSM
> 
> Mdadm's function for checking "if partition" looks like so.
> 
> int test_partition(int fd)
> {
>      /* Check if fd is a whole-disk or a partition.
>       * BLKPG will return EINVAL on a partition, and BLKPG_DEL_PARTITION
>       * will return ENXIO on an invalid partition number.
>       */
>      struct blkpg_ioctl_arg a;
>      struct blkpg_partition p;
>      a.op = BLKPG_DEL_PARTITION;
>      a.data = (void*)&p;
>      a.datalen = sizeof(p);
>      a.flags = 0;
>      memset(a.data, 0, a.datalen);
>      p.pno = 1<<30;
>      if (ioctl(fd, BLKPG, &a) == 0)
>          /* Very unlikely, but not a partition */
>          return 0;
>      if (errno == ENXIO || errno == ENOTTY)
>          /* not a partition */
>          return 0;
> 
>      return 1;
> }
> 
> I plugged in with debugger and established that when ioctl is run on 
> dm-device errno is EINVAL, as if it was a partition.

This is a known regression, reported here:

https://lore.kernel.org/all/CAOYeF9VsmqKMcQjo1k6YkGNujwN-nzfxY17N3F-CMikE1tYp+w@mail.gmail.com/

please try this patch:

https://lore.kernel.org/all/20240118130401.792757-1-lilingfeng@huaweicloud.com/

Thanks,
Kuai

> 
> The issue is reproducible only with newer kernels which leads me te 
> believe there is a regression in device mapper. This code has been 
> working stable for last 10+ years, which is another reason. I tested 
> this on RHEL 8.9 with inbox 5.14 kernel and 6.5.7-1 I happen to have 
> installed. The issue reproduced only on 6.5.7-1 kernel. I also observed 
> same regression on stock Ubuntu 24.04 with inbox 6.6.0 kernel.
> 
> Can you please point me to when it was introduced and are there any 
> plans for fixing it?
> 
> Thanks,
> Mateusz
> 
> .
> 

