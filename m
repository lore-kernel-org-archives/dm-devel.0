Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F2FC38147
	for <dm-devel@archiver.kernel.org>; Wed, 18 Jan 2023 13:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674049575;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fe/5nlK55XRcGWycvHfi/b6O7xZYxMwEZ7E6QzcaHPE=;
	b=V9QgJ0bQ7CeNDX/ZF2AV8nwqDQWI4LWjZ6JoNvVfwT0F42JXo1tgR+vQGqQXPLABiUgZ8I
	jYNQPcdbIbLD5OhX7CRgrYtdUsavkO8YyPGqG5GrYsFQ/F4GankZxnWZLX6ZVztj7kPoPP
	fqOXyg8r7Cgkcel48y/E9iMgjgrURg0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-hVtMBv4CM-6ZT82G0BUDtQ-1; Wed, 18 Jan 2023 08:46:14 -0500
X-MC-Unique: hVtMBv4CM-6ZT82G0BUDtQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BA1F1C189A0;
	Wed, 18 Jan 2023 13:46:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 83D1040C6EC4;
	Wed, 18 Jan 2023 13:46:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 32FF91946A6B;
	Wed, 18 Jan 2023 13:46:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 13B4919465B7
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 Jan 2023 13:33:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id ED9961121318; Wed, 18 Jan 2023 13:33:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E58DB1121315
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 13:33:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7C561010455
 for <dm-devel@redhat.com>; Wed, 18 Jan 2023 13:33:05 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-wXNr5pYwOAm_XXeee0cKYg-1; Wed, 18 Jan 2023 08:33:03 -0500
X-MC-Unique: wXNr5pYwOAm_XXeee0cKYg-1
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NxmSn0FNRzRrff;
 Wed, 18 Jan 2023 21:14:49 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 18 Jan 2023 21:16:41 +0800
To: Hou Tao <houtao@huaweicloud.com>, <dm-devel@redhat.com>
References: <20221216042353.3132139-1-houtao@huaweicloud.com>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <e7fcd9fd-a882-2a97-a072-faf09441efbe@huawei.com>
Date: Wed, 18 Jan 2023 21:16:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20221216042353.3132139-1-houtao@huaweicloud.com>
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
Cc: Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

ping ?

On 12/16/2022 12:23 PM, Hou Tao wrote:
> From: Hou Tao <houtao1@huawei.com>
>
> __hash_remove() removes hash_cell with _hash_lock locked, so acquiring
> _hash_lock can guarantee no-NULL hc returned from dm_get_mdptr() must
> have not been removed and hc->md must still be md.
>
> __hash_remove() also acquires dm_hash_cells_mutex before setting mdptr
> as NULL, so in dm_copy_name_and_uuid() after acquiring
> dm_hash_cells_mutex and ensuring returned hc is not NULL, the returned
> hc must still be alive and hc->md must still be md.
>
> So removing these unnecessary hc->md != md checks when using
> dm_get_mdptr() with _hash_lock or dm_hash_cells_mutex acquired.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  drivers/md/dm-ioctl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 3bfc1583c20a..2a86524661d1 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -772,7 +772,7 @@ static struct dm_table *dm_get_inactive_table(struct mapped_device *md, int *src
>  
>  	down_read(&_hash_lock);
>  	hc = dm_get_mdptr(md);
> -	if (!hc || hc->md != md) {
> +	if (!hc) {
>  		DMERR("device has been removed from the dev hash table.");
>  		goto out;
>  	}
> @@ -1476,7 +1476,7 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
>  	/* stage inactive table */
>  	down_write(&_hash_lock);
>  	hc = dm_get_mdptr(md);
> -	if (!hc || hc->md != md) {
> +	if (!hc) {
>  		DMERR("device has been removed from the dev hash table.");
>  		up_write(&_hash_lock);
>  		r = -ENXIO;
> @@ -2128,7 +2128,7 @@ int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid)
>  
>  	mutex_lock(&dm_hash_cells_mutex);
>  	hc = dm_get_mdptr(md);
> -	if (!hc || hc->md != md) {
> +	if (!hc) {
>  		r = -ENXIO;
>  		goto out;
>  	}

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

