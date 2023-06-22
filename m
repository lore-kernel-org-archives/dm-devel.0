Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11565EB64D8
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 17:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687455196;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j+mz62KGfB9sdFSaoayO6ya7kVnCkuxXf6yAwYlDe/Y=;
	b=iOGuaL51e/EIB7a3CEqYOraY+CWTfBocaOmZQP3FUro5XWzyP1szlDwyOVKu5v3j7iX5OC
	/evyqacSHOvWPw9KgC3I/DPU1QTv/j+M5W4GI6AyunPFSgIUS2dswVm8/np3K8GRIA4DXA
	oitpll2m8kyRfctwoqRmo+8h5bV3qJ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-824J6depOrGqC7ncfP0z6A-1; Thu, 22 Jun 2023 13:33:01 -0400
X-MC-Unique: 824J6depOrGqC7ncfP0z6A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97CB88ED042;
	Thu, 22 Jun 2023 17:31:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 86628C00049;
	Thu, 22 Jun 2023 17:31:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4FDC71946588;
	Thu, 22 Jun 2023 17:31:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2A35F1946595
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 17:31:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 21D012166B33; Thu, 22 Jun 2023 17:31:28 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown
 [10.11.5.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 11C002166B25;
 Thu, 22 Jun 2023 17:31:28 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix,
 from userid 12668)
 id 0BC4130C0457; Thu, 22 Jun 2023 17:31:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
 by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id
 0ACF83F7CF; Thu, 22 Jun 2023 19:31:28 +0200 (CEST)
Date: Thu, 22 Jun 2023 19:31:28 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>
In-Reply-To: <20230603145244.1538-4-demi@invisiblethingslab.com>
Message-ID: <c0c36fe0-41cf-abf-727c-bbef17b6face@redhat.com>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
 <20230603145244.1538-1-demi@invisiblethingslab.com>
 <20230603145244.1538-4-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v2 3/6] device-mapper: structs and parameter
 strings must not overlap
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
Cc: stable@vger.kernel.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On Sat, 3 Jun 2023, Demi Marie Obenour wrote:

> The NUL terminator for each target parameter string must precede the
> following 'struct dm_target_spec'.  Otherwise, dm_split_args() might
> corrupt this struct.  Furthermore, the first 'struct dm_target_spec'
> must come after the 'struct dm_ioctl', as if it overlaps too much
> dm_split_args() could corrupt the 'struct dm_ioctl'.
> 
> Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  drivers/md/dm-ioctl.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 64e8f16d344c47057de5e2d29e3d63202197dca0..da6ca26b51d0953df380582bb3a51c2ec22c27cb 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1391,7 +1391,7 @@ static inline fmode_t get_mode(struct dm_ioctl *param)
>  	return mode;
>  }
>  
> -static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
> +static int next_target(struct dm_target_spec *last, uint32_t next, const char *end,
>  		       struct dm_target_spec **spec, char **target_params)
>  {
>  	static_assert(_Alignof(struct dm_target_spec) <= 8,
> @@ -1404,7 +1404,7 @@ static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
>  	 * sizeof(struct dm_target_spec) or more, as otherwise *last was
>  	 * out of bounds already.
>  	 */
> -	size_t remaining = (char *)end - (char *)last;
> +	size_t remaining = end - (char *)last;
>  
>  	/*
>  	 * There must be room for both the next target spec and the
> @@ -1423,10 +1423,7 @@ static int next_target(struct dm_target_spec *last, uint32_t next, void *end,
>  	*spec = (struct dm_target_spec *) ((unsigned char *) last + next);
>  	*target_params = (char *) (*spec + 1);
>  
> -	if (*spec < (last + 1))
> -		return -EINVAL;
> -
> -	return invalid_str(*target_params, end);
> +	return 0;
>  }
>  
>  static int populate_table(struct dm_table *table,
> @@ -1436,8 +1433,9 @@ static int populate_table(struct dm_table *table,
>  	unsigned int i = 0;
>  	struct dm_target_spec *spec = (struct dm_target_spec *) param;
>  	uint32_t next = param->data_start;
> -	void *end = (void *) param + param_size;
> +	const char *const end = (const char *) param + param_size;
>  	char *target_params;
> +	size_t min_size = sizeof(struct dm_ioctl);
>  
>  	if (!param->target_count) {
>  		DMERR("%s: no targets specified", __func__);
> @@ -1445,6 +1443,13 @@ static int populate_table(struct dm_table *table,
>  	}
>  
>  	for (i = 0; i < param->target_count; i++) {
> +		const char *nul_terminator;
> +
> +		if (next < min_size) {
> +			DMERR("%s: next target spec (offset %u) overlaps %s",
> +			      __func__, next, i ? "previous target" : "'struct dm_ioctl'");
> +			return -EINVAL;
> +		}
>  
>  		r = next_target(spec, next, end, &spec, &target_params);
>  		if (r) {
> @@ -1452,6 +1457,15 @@ static int populate_table(struct dm_table *table,
>  			return r;
>  		}
>  
> +		nul_terminator = memchr(target_params, 0, (size_t)(end - target_params));
> +		if (nul_terminator == NULL) {
> +			DMERR("%s: target parameters not NUL-terminated", __func__);
> +			return -EINVAL;
> +		}
> +
> +		/* Add 1 for NUL terminator */
> +		min_size = (size_t)(nul_terminator - (const char *)spec) + 1;
> +
>  		r = dm_table_add_target(table, spec->target_type,
>  					(sector_t) spec->sector_start,
>  					(sector_t) spec->length,
> -- 
> Sincerely,
> Demi Marie Obenour (she/her/hers)
> Invisible Things Lab
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

