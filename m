Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CB03A1D3
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 02:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709259143; cv=none; b=VfRF2WcObQlRncJnDOEhJIg/fkEJ9QCbyCvq6CP6vVacORCfZyIJ7uG7ugQ1BNMTGrzNRonUDsGRthghytZe6UjJtxGLmQwcSAYd/KysTPTBdVVpaxdvEOyV7mRM6bm3XGdOxUZFLNxYzzoIxyCxMg9IksuFB5/j8eJtW9Ajcz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709259143; c=relaxed/simple;
	bh=SGp2hD8EISDncXGfu3w5lJALQfwFA0Zn0uKq8MJOej4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=s9SovP2a7xv+IgKVhPTJybn/DC5gwQYflzYSkUYdFkzPDUhZw7QksM2C84omHgk9v4Xzz4wOt+KcnLKrF6Btu9FYgEK92bMxg363C9yBralWOkF5XDucYJVydjvohoYMSQcgdD+z8U1UyV3T0g/JLIDqRviutzOcTF+YJ9nfvYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TmBRm6wwDz4f3kFS
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 10:12:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 42C1B1A10F3
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 10:12:10 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgCXaBF1OeFlINZMFg--.10426S3;
	Fri, 01 Mar 2024 10:12:07 +0800 (CST)
Subject: Re: [PATCH 0/6] Fix dmraid regression bugs
To: Xiao Ni <xni@redhat.com>, song@kernel.org
Cc: yukuai1@huaweicloud.com, bmarzins@redhat.com, heinzm@redhat.com,
 snitzer@kernel.org, ncroxon@redhat.com, linux-raid@vger.kernel.org,
 dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <20240229154941.99557-1-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e884fd5d-aec2-f2f2-6b22-583576d3106f@huaweicloud.com>
Date: Fri, 1 Mar 2024 10:12:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240229154941.99557-1-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXaBF1OeFlINZMFg--.10426S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kry8uw4kur1kXF4kur47CFg_yoW8Ww4xpa
	9xJ3W3X3y8Aryagrs3Ja18XF15C34xJFy5Gr12gw1vqry5ZF93Kr48tr48WFyUAFyfGa12
	vF4DGa4DuF1Yv37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWr
	Zr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUZa9-UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/02/29 23:49, Xiao Ni Ð´µÀ:
> Hi all
> 
> This patch set tries to fix dmraid regression problems when we recently.
> After talking with Kuai who also sent a patch set which is used to fix
> dmraid regression problems, we decide to use a small patch set to fix
> these regression problems. This patch is based on song's md-6.8 branch.
> 
> This patch set has six patches. It reverts three patches. The fourth one
> and the fifth one resolve deadlock problems. With these two patches, it
> can resolve most deadlock problem. The last one fixes the raid5 reshape
> deadlock problem.
> 
> I have run lvm2 regression test. There are 4 failed cases:
> shell/dmsetup-integrity-keys.sh
> shell/lvresize-fs-crypt.sh
> shell/pvck-dump.sh
> shell/select-report.sh

You might need to run the test suite in a loop to make sure there are no
tests that will fail occasionally.

Thanks,
Kuai

> 
> And lvconvert-raid-reshape.sh can fail sometimes. But it fails in 6.6
> kernel too. So it can return back to the same state with 6.6 kernel.
> 
> Xiao Ni (6):
>    Revert "md: Don't register sync_thread for reshape directly"
>    Revert "md: Make sure md_do_sync() will set MD_RECOVERY_DONE"
>    Revert "md: Don't ignore suspended array in md_check_recovery()"
>    dm-raid/md: Clear MD_RECOVERY_WAIT when stopping dmraid
>    md: Set MD_RECOVERY_FROZEN before stop sync thread
>    md/raid5: Don't check crossing reshape when reshape hasn't started
> 
>   drivers/md/dm-raid.c |  2 ++
>   drivers/md/md.c      | 22 +++++++++----------
>   drivers/md/raid10.c  | 16 ++++++++++++--
>   drivers/md/raid5.c   | 51 ++++++++++++++++++++++++++++++++------------
>   4 files changed, 63 insertions(+), 28 deletions(-)
> 

