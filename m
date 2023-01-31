Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9B4C636CD
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 07:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675151247;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tEnrLyimCRoN0KA8lexRTBjt5oY8ePHeAK+Odc9DjlI=;
	b=TrHGEE4IG6a+5uvx2u4Qi+DZj+rJonlXUBcNiuVW8cW8C+lBz+I8XLUMD5DnD0twZrqYGo
	2TAeOXSGnyPfx0saLqc/OT6Fruj5Rs6VC3oKOClL4TwWYSQ/OkQACkPE7H4mi4tn52jOaO
	8VoWhv6SY6VUJ117T+2pmtVbtt0Uxb8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-1uzWuGQrNri_lI9A9_hRWA-1; Tue, 31 Jan 2023 02:47:23 -0500
X-MC-Unique: 1uzWuGQrNri_lI9A9_hRWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1146F2932481;
	Tue, 31 Jan 2023 07:47:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id F248E40C2004;
	Tue, 31 Jan 2023 07:47:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0EC9B1946A69;
	Tue, 31 Jan 2023 07:47:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B8E531946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 Jan 2023 02:01:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9C9DD40C2004; Tue, 31 Jan 2023 02:01:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 94B9740C2064
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 02:01:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7A428101A52E
 for <dm-devel@redhat.com>; Tue, 31 Jan 2023 02:01:39 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-516-nzwr5s-eOn-lDUc1GOkXAg-1; Mon, 30 Jan 2023 21:01:37 -0500
X-MC-Unique: nzwr5s-eOn-lDUc1GOkXAg-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4P5SXb36BQz4f3jLM;
 Tue, 31 Jan 2023 09:44:47 +0800 (CST)
Received: from [10.174.176.117] (unknown [10.174.176.117])
 by APP2 (Coremail) with SMTP id Syh0CgBXSOaOcthjisG2Cg--.29955S2;
 Tue, 31 Jan 2023 09:44:49 +0800 (CST)
To: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>
References: <20221216042353.3132139-1-houtao@huaweicloud.com>
 <e7fcd9fd-a882-2a97-a072-faf09441efbe@huawei.com>
From: Hou Tao <houtao@huaweicloud.com>
Message-ID: <5d93f5fc-05fa-906e-b2e9-0e9abcdf16f6@huaweicloud.com>
Date: Tue, 31 Jan 2023 09:44:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <e7fcd9fd-a882-2a97-a072-faf09441efbe@huawei.com>
X-CM-TRANSID: Syh0CgBXSOaOcthjisG2Cg--.29955S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJr13CrWkury7uFy5Wr1kGrg_yoW8ZF4xpr
 1FgrW3urWkJFsF9r4jvanruF9Igw1YkrWUGryxKa4Y93WDu348WayUGFWxXFyrAF97AF4Y
 gF4xW3y5Ca1DA37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
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
 c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Tue, 31 Jan 2023 07:47:16 +0000
Subject: Re: [dm-devel] [PATCH] dm: remove unnecessary check when using
 dm_get_mdptr()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Hou Tao <houtao1@huawei.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

ping ? Any comments on this clean up patch ?

On 1/18/2023 9:16 PM, Hou Tao wrote:
> ping ?
>
> On 12/16/2022 12:23 PM, Hou Tao wrote:
>> From: Hou Tao <houtao1@huawei.com>
>>
>> __hash_remove() removes hash_cell with _hash_lock locked, so acquiring
>> _hash_lock can guarantee no-NULL hc returned from dm_get_mdptr() must
>> have not been removed and hc->md must still be md.
>>
>> __hash_remove() also acquires dm_hash_cells_mutex before setting mdptr
>> as NULL, so in dm_copy_name_and_uuid() after acquiring
>> dm_hash_cells_mutex and ensuring returned hc is not NULL, the returned
>> hc must still be alive and hc->md must still be md.
>>
>> So removing these unnecessary hc->md != md checks when using
>> dm_get_mdptr() with _hash_lock or dm_hash_cells_mutex acquired.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> ---
>>  drivers/md/dm-ioctl.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
>> index 3bfc1583c20a..2a86524661d1 100644
>> --- a/drivers/md/dm-ioctl.c
>> +++ b/drivers/md/dm-ioctl.c
>> @@ -772,7 +772,7 @@ static struct dm_table *dm_get_inactive_table(struct mapped_device *md, int *src
>>  
>>  	down_read(&_hash_lock);
>>  	hc = dm_get_mdptr(md);
>> -	if (!hc || hc->md != md) {
>> +	if (!hc) {
>>  		DMERR("device has been removed from the dev hash table.");
>>  		goto out;
>>  	}
>> @@ -1476,7 +1476,7 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
>>  	/* stage inactive table */
>>  	down_write(&_hash_lock);
>>  	hc = dm_get_mdptr(md);
>> -	if (!hc || hc->md != md) {
>> +	if (!hc) {
>>  		DMERR("device has been removed from the dev hash table.");
>>  		up_write(&_hash_lock);
>>  		r = -ENXIO;
>> @@ -2128,7 +2128,7 @@ int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid)
>>  
>>  	mutex_lock(&dm_hash_cells_mutex);
>>  	hc = dm_get_mdptr(md);
>> -	if (!hc || hc->md != md) {
>> +	if (!hc) {
>>  		r = -ENXIO;
>>  		goto out;
>>  	}

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

