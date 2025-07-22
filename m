Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074822D373A
	for <dm-devel@lists.linux.dev>; Tue, 22 Jul 2025 08:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753173001; cv=none; b=AhUzvse86uKKltkPFjFurHKN+zPBYVJnYHODUvaeAfi+RjROQRP/iJPfipByMUOH7I/pAEB5EXUlRc03lucqrKVtSKYL/UgPiLZMmGIKN46TWMW5dtvPAdCyBRa8AJEpn9i3lXTqxvTiSyZySUepwofcqxwnUOe8n56d7crq95A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753173001; c=relaxed/simple;
	bh=dijSbF5TgUCZOZmfbIuovzO+IaPCj3LNBI05XaAR3jA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SPbt6uvezowHe1xa5CHv8FhOBbx2TiwkX5e6nR29seWnRu7wqhVvmFCFZAh68VoClzLUjyhVmLRU2/yjlBn1H9nvwD2CEUVEDgeI7uPp50pbx2qAxem85lFOKNo91JqiEWAhBVxFpuQXB8Q43X9c5VRH3zzfPDqgnQqVyE95Pu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bmVnH6mQlzYQvHh
	for <dm-devel@lists.linux.dev>; Tue, 22 Jul 2025 16:29:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A639C1A0BB8
	for <dm-devel@lists.linux.dev>; Tue, 22 Jul 2025 16:29:54 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgDXUxQATH9oJeFhBA--.54737S3;
	Tue, 22 Jul 2025 16:29:54 +0800 (CST)
Message-ID: <2c943ca4-7bd2-4c2e-8b7a-8f7edee4adff@huaweicloud.com>
Date: Tue, 22 Jul 2025 16:29:52 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 00/11] md/llbitmap: md/md-llbitmap: introduce a new
 lockless bitmap
To: Yu Kuai <yukuai@kernel.org>, corbet@lwn.net, agk@redhat.co,
 snitzer@kernel.org, mpatocka@redhat.com, hch@lst.de, song@kernel.org,
 hare@suse.de
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yukuai3@huawei.com,
 yangerkun@huawei.com, yi.zhang@huawei.com, johnny.chenyi@huawei.com
References: <20250721171557.34587-1-yukuai@kernel.org>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250721171557.34587-1-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXUxQATH9oJeFhBA--.54737S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KF48CF1ktF1xGryxCF15Arb_yoW8Xr48pa
	4kK34ru343Ar17XF13ZryUAFyrJan7JrZrKr1xCw1F9a4DZF98Gr18K3WDtwn3Wr13JF1q
	qr15K3s3Wr1rXaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBSb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E
	8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82
	IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC2
	0s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMI
	IF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF
	0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87
	Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwb18UUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/7/22 1:15, Yu Kuai 写道:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Changes from v3:
>   - fix redundant setting mddev->bitmap_id in patch 6;
>   - add explanation of bitmap attributes in Documentation;
>   - add llbitmap/barrier_idle in patch 11;
>   - add some comments in patch 11;

[...]

Patches 01–10 look good:

Reviewed-by: Li Nan <linan122@huawei.com>

> 
> Yu Kuai (11):
>    md: add a new parameter 'offset' to md_super_write()
>    md: factor out a helper raid_is_456()
>    md/md-bitmap: support discard for bitmap ops
>    md: add a new mddev field 'bitmap_id'
>    md/md-bitmap: add a new sysfs api bitmap_type
>    md/md-bitmap: delay registration of bitmap_ops until creating bitmap
>    md/md-bitmap: add a new method skip_sync_blocks() in bitmap_operations
>    md/md-bitmap: add a new method blocks_synced() in bitmap_operations
>    md: add a new recovery_flag MD_RECOVERY_LAZY_RECOVER
>    md/md-bitmap: make method bitmap_ops->daemon_work optional
>    md/md-llbitmap: introduce new lockless bitmap
> 
>   Documentation/admin-guide/md.rst |   86 +-
>   drivers/md/Kconfig               |   11 +
>   drivers/md/Makefile              |    1 +
>   drivers/md/md-bitmap.c           |   15 +-
>   drivers/md/md-bitmap.h           |   45 +-
>   drivers/md/md-llbitmap.c         | 1598 ++++++++++++++++++++++++++++++
>   drivers/md/md.c                  |  288 ++++--
>   drivers/md/md.h                  |   20 +-
>   drivers/md/raid5.c               |    6 +
>   9 files changed, 1963 insertions(+), 107 deletions(-)
>   create mode 100644 drivers/md/md-llbitmap.c
> 

-- 
Thanks,
Nan

