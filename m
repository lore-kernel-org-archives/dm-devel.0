Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0B17C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 14 Mar 2022 13:24:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-JA4fYeCdPaWwWVlU2PJMJg-1; Mon, 14 Mar 2022 09:24:06 -0400
X-MC-Unique: JA4fYeCdPaWwWVlU2PJMJg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED1608E7804;
	Mon, 14 Mar 2022 13:24:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BE37846503C;
	Mon, 14 Mar 2022 13:24:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6E9E31937126;
	Mon, 14 Mar 2022 13:24:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2F0381937125
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Mar 2022 13:23:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C9F322D476; Mon, 14 Mar 2022 13:23:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C57482EF8E
 for <dm-devel@redhat.com>; Mon, 14 Mar 2022 13:23:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B44F883397D
 for <dm-devel@redhat.com>; Mon, 14 Mar 2022 13:23:55 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-z3XMAB0cNqWWu2t0NhtYGA-1; Mon, 14 Mar 2022 09:23:53 -0400
X-MC-Unique: z3XMAB0cNqWWu2t0NhtYGA-1
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.54])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KHHJY0J4NzfYxD;
 Mon, 14 Mar 2022 21:22:21 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Mar 2022 21:23:47 +0800
Received: from [127.0.0.1] (10.174.177.249) by kwepemm600003.china.huawei.com
 (7.193.23.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 14 Mar
 2022 21:23:46 +0800
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
To: <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
References: <b0ec028e-bc9e-f705-9674-ffc4a01ee2f0@huawei.com>
Message-ID: <4b7e5e2c-a847-4e40-1f23-de71753fe9e8@huawei.com>
Date: Mon, 14 Mar 2022 21:23:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <b0ec028e-bc9e-f705-9674-ffc4a01ee2f0@huawei.com>
X-Originating-IP: [10.174.177.249]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH] md: remove unused dm_thin_remove_block()
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
Cc: lixiaokeng <lixiaokeng@huawei.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com,
 wuguanghao <wuguanghao3@huawei.com>, liuzhiqiang26@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

friendly ping..

On 2022/2/16 14:37, Zhiqiang Liu wrote:
> dm_thin_remove_block() is no longer unused, just remove it.
>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> ---
>  drivers/md/dm-thin-metadata.c | 12 ------------
>  drivers/md/dm-thin-metadata.h |  1 -
>  2 files changed, 13 deletions(-)
>
> diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
> index 1a96a07cbf44..986a2dc9a686 100644
> --- a/drivers/md/dm-thin-metadata.c
> +++ b/drivers/md/dm-thin-metadata.c
> @@ -1740,18 +1740,6 @@ static int __remove_range(struct dm_thin_device *td, dm_block_t begin, dm_block_
>  	return dm_btree_insert(&pmd->tl_info, pmd->root, keys, &value, &pmd->root);
>  }
>
> -int dm_thin_remove_block(struct dm_thin_device *td, dm_block_t block)
> -{
> -	int r = -EINVAL;
> -
> -	pmd_write_lock(td->pmd);
> -	if (!td->pmd->fail_io)
> -		r = __remove(td, block);
> -	pmd_write_unlock(td->pmd);
> -
> -	return r;
> -}
> -
>  int dm_thin_remove_range(struct dm_thin_device *td,
>  			 dm_block_t begin, dm_block_t end)
>  {
> diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
> index 7ef56bd2a7e3..4d7a2caf21d9 100644
> --- a/drivers/md/dm-thin-metadata.h
> +++ b/drivers/md/dm-thin-metadata.h
> @@ -166,7 +166,6 @@ int dm_pool_alloc_data_block(struct dm_pool_metadata *pmd, dm_block_t *result);
>  int dm_thin_insert_block(struct dm_thin_device *td, dm_block_t block,
>  			 dm_block_t data_block);
>
> -int dm_thin_remove_block(struct dm_thin_device *td, dm_block_t block);
>  int dm_thin_remove_range(struct dm_thin_device *td,
>  			 dm_block_t begin, dm_block_t end);
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

