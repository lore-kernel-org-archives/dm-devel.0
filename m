Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5836B3597E
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 01:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752802121; cv=none; b=s+PrUwarL94Jc2v7EYI2itqDGlOTNxZfryXit2RbeidmeVsPmbDKTVOuVxSy1CBcIWfXbiv2c4udit08EiGxNbEdN3slKN95BIJJm0ITbmxUJymDuGT4Pm1EC2Bg8GH0xW2XcrsItVW/yj1A58HAIxRofZo56C0TMpuxkboLCD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752802121; c=relaxed/simple;
	bh=qmz0wOC1pPAxGW3UK5Z8ZLMTotEkFsfp8mMigSPO7zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Oh3My0aDVPGX7ETUGg/4k8y2MicHGcKr79wvxPNNw44LF4dc6bgTwyHg7uy6W869RKEI7tu52m1PWbKu4kzeb/JDJiUH/TK8NNCQ+7qNY2/jsIXPs/kY4AfO3vp3VjgrCG/jW3MSfLl2v/P/mkuP5IvBRuDQxxb5vQwmoaMNVSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bjsZY3hBYz2RVsC;
	Fri, 18 Jul 2025 09:26:29 +0800 (CST)
Received: from kwepemg500017.china.huawei.com (unknown [7.202.181.81])
	by mail.maildlp.com (Postfix) with ESMTPS id EA7FE140298;
	Fri, 18 Jul 2025 09:28:35 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 kwepemg500017.china.huawei.com (7.202.181.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 18 Jul 2025 09:28:34 +0800
Message-ID: <5d63f92f-1b48-445f-8cbb-a6ae148d36aa@huawei.com>
Date: Fri, 18 Jul 2025 09:28:34 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH] dm: introduce spinlocks to prevent concurrent usage and
 release of device_metadata and hash
To: Mikulas Patocka <mpatocka@redhat.com>, Hou Tao <houtao1@huawei.com>
CC: <dm-devel@lists.linux.dev>, <agk@redhat.com>, <snitzer@kernel.org>,
	<tusharsu@linux.microsoft.com>, <colin.i.king@gmail.com>,
	<linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
	<yangerkun@huawei.com>, <yukuai3@huawei.com>, <chengzhihao1@huawei.com>,
	<lilingfeng@huaweicloud.com>
References: <20250717140728.3221243-1-lilingfeng3@huawei.com>
 <5a29db22-13a9-f3ea-dbf2-13ce7f7aa649@huawei.com>
 <5be1fab4-192d-8327-b541-bb92d53313cc@redhat.com>
From: Li Lingfeng <lilingfeng3@huawei.com>
In-Reply-To: <5be1fab4-192d-8327-b541-bb92d53313cc@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemg500017.china.huawei.com (7.202.181.81)


在 2025/7/18 2:45, Mikulas Patocka 写道:
>
> On Thu, 17 Jul 2025, Hou Tao wrote:
>
>> Hi,
>>
>> On 7/17/2025 10:07 PM, Li Lingfeng wrote:
>>> There is a window between freeing md->ima.active_table.hash and setting
>>> md->ima.active_table.hash to NULL in dm_ima_measure_on_device_resume().
>>> If dm_ima_measure_on_device_remove() accesses md->ima.active_table.hash
>>> concurrently during this window, it could lead to a double free or UAF,
>>> as shown below:
>> The UAF is a problem. However, I think the order of
>> dm_ima_measure_on_device_remove() and dm_ima_measure_on_device_resume is
>> bigger problem. Is it possible to order these two invocations properly
>> by using suspend_lock ?
> That's a good point. The patch just papers over the problem. It will fix
> the UAF warning, but it won't fix the fact that
> dm_ima_measure_on_device_resume can race with
> dm_ima_measure_on_device_remove.
>
> The real fix would be to make sure that dm_ima_measure_* calls are never
> called concurrently on the same table - we should use existing device
> mapper locks for that.
>
> Mikukas
>
Thanks for your advice, I will send a new patch soon.

Thanks,

Lingfeng

