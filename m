Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB2AB65D
	for <dm-devel@lists.linux.dev>; Sat, 28 Oct 2023 11:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ee87kYPy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698491478;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rCC7CNKsmr3D8pLSLOiSmLrn3XyQru48wsamhBhOqaQ=;
	b=ee87kYPyklCMGZmWcuylucUdQR4Fw3Ap0/FKKBFoHv7Sd7vDH+6D+/eLWKPHqle/CIx9b4
	q67jJ8fnJ5fOW2PXpkbGYuw/jS1jzXj20+GuweQUmhmG8jqNP619udOtji8BfdOiUolj7u
	4bcSjPO9EI0tZg7yAyhw4hxL5uHutKQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-kOGLsJMSPGe056dps7IWJA-1; Sat, 28 Oct 2023 07:11:17 -0400
X-MC-Unique: kOGLsJMSPGe056dps7IWJA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDD0C84B040
	for <dm-devel@lists.linux.dev>; Sat, 28 Oct 2023 11:11:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C5CDF1121319
	for <dm-devel@lists.linux.dev>; Sat, 28 Oct 2023 11:11:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 719291946595
	for <dm-devel@lists.linux.dev>; Sat, 28 Oct 2023 11:11:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 159DD1946587
 for <dm-devel@listman.corp.redhat.com>; Sat, 28 Oct 2023 11:11:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B3FAD492BE7; Sat, 28 Oct 2023 11:11:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC268492BE0
 for <dm-devel@redhat.com>; Sat, 28 Oct 2023 11:11:14 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D91F1C05AB5
 for <dm-devel@redhat.com>; Sat, 28 Oct 2023 11:11:14 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com
 [45.249.212.189]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-4cFUbOWAO4uLJ5tF98yGBg-1; Sat, 28 Oct 2023 07:11:11 -0400
X-MC-Unique: 4cFUbOWAO4uLJ5tF98yGBg-1
Received: from dggpemm500011.china.huawei.com (unknown [172.30.72.56])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4SHcDV4cW4zMmJW;
 Sat, 28 Oct 2023 19:06:50 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Sat, 28 Oct 2023 19:11:06 +0800
Message-ID: <ebb49e01-3a3b-29d9-eb92-2ca453993d5b@huawei.com>
Date: Sat, 28 Oct 2023 19:10:55 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101
 Thunderbird/104.0
Subject: Re: [PATCH] dm: remove dm_set_md_type()
To: <dm-devel@redhat.com>
References: <20230912122605.3487911-1-lilingfeng3@huawei.com>
From: Li Lingfeng <lilingfeng3@huawei.com>
In-Reply-To: <20230912122605.3487911-1-lilingfeng3@huawei.com>
X-Originating-IP: [10.174.179.155]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, snitzer@kernel.org,
 linux-kernel@vger.kernel.org, houtao1@huawei.com, yukuai3@huawei.com,
 hch@lst.de, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable

Friendly ping ...

Thanks

=E5=9C=A8 2023/9/12 20:26, Li Lingfeng =E5=86=99=E9=81=93:
> Commit ba30585936b0 ("dm: move setting md->type into dm_setup_md_queue")
> has removed the only reference to dm_set_md_type(), so remove
> dm_set_md_type() now.
>
> Signed-off-by: Li Lingfeng <lilingfeng3@huawei.com>
> ---
>   drivers/md/dm.c | 6 ------
>   drivers/md/dm.h | 1 -
>   2 files changed, 7 deletions(-)
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index f0f118ab20fa..6b9d04ca09d0 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2316,12 +2316,6 @@ void dm_unlock_md_type(struct mapped_device *md)
>   =09mutex_unlock(&md->type_lock);
>   }
>  =20
> -void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type)
> -{
> -=09BUG_ON(!mutex_is_locked(&md->type_lock));
> -=09md->type =3D type;
> -}
> -
>   enum dm_queue_mode dm_get_md_type(struct mapped_device *md)
>   {
>   =09return md->type;
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index f682295af91f..cc55ef3441be 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -76,7 +76,6 @@ bool dm_table_request_based(struct dm_table *t);
>  =20
>   void dm_lock_md_type(struct mapped_device *md);
>   void dm_unlock_md_type(struct mapped_device *md);
> -void dm_set_md_type(struct mapped_device *md, enum dm_queue_mode type);
>   enum dm_queue_mode dm_get_md_type(struct mapped_device *md);
>   struct target_type *dm_get_immutable_target_type(struct mapped_device *=
md);
>  =20

