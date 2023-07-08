Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E542BEB64DA
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jul 2023 04:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688790198;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sqeJUVH+7eOae5JtNp9/BLkgEmw05MZpA6YpifTPwe8=;
	b=LvzF/OFROmt9YHaUj4JUOflfBap4oatbq7XgfXE7wfd+V3YLiYjmeKngztCpIJJQpW0jE9
	DhIH9FhNX159RgpBW4RfU5SHk1tRpd5vIoOmfDMgql5kn9KG5mGNYhl7wG52VBJNdwmbYv
	BaTPfXmIn87w8eoH23RPjPqmKVRCzag=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-RjjTcpOoNZaA9MwtP36nLQ-1; Sat, 08 Jul 2023 00:23:14 -0400
X-MC-Unique: RjjTcpOoNZaA9MwtP36nLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 780B23C0E205;
	Sat,  8 Jul 2023 04:23:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 66B10C09A09;
	Sat,  8 Jul 2023 04:23:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 41BEA1946A70;
	Sat,  8 Jul 2023 04:23:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E0BD11946A5A
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Jul 2023 04:23:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B5E231121339; Sat,  8 Jul 2023 04:23:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AE80F1121333
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 04:23:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 950B9830F46
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 04:23:10 +0000 (UTC)
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com
 [209.85.160.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-MR0equXNPKuT7fXLh8W8sQ-1; Sat, 08 Jul 2023 00:23:08 -0400
X-MC-Unique: MR0equXNPKuT7fXLh8W8sQ-1
Received: by mail-qt1-f179.google.com with SMTP id
 d75a77b69052e-40292285362so19791091cf.3
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 21:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688790188; x=1691382188;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=+Hz3LNSJIA32LS0w6BjIcScwNW8naJ0tmp1lMEgiYII=;
 b=RMaoZitVeDws6lSuCg9WV+n/Up4FD8bBjeOZ++DbchHkMSoDanlCLmuKGP9op68Q7G
 1KMxzgHLW06YhTzyZvcrbKkJHDbjWpF+cKjiPuHSrSfMaK/uwFOx7d6Tv3zSOOUB0R65
 exwmCoEuvx8Av/JWjNURbocEFBlrTmM0KrTkyosK8Rh5xoZJqmWNhyXfUm5qHLXxAOQG
 eBJRcy4/d4EynQ/bK2//2k9hwCmdHVERHTTc/mIjb9BlGOmb8w9B1I26YYkdEoEpDlS4
 I30+ExKalMQ5QjGaFUM4gsgOpNmSq+KDD4+pcVbCiyHcScTuV3h3HSsEWDE6SYj2QDV2
 mWaQ==
X-Gm-Message-State: ABy/qLZOuZXNOOQjihQV1Yw97fz1wFOgRF3PAK1ETgcFpReN7B+8BAJl
 UDQif6pe5gKpM2DTcMtgfKJL
X-Google-Smtp-Source: APBJJlF7ZdvOpye5Bi9nBRtHP5gbHB7zedNeZ207ssI0QYjswYk8C3ybGJ8VmbiZKLdIlvHd08nvYQ==
X-Received: by 2002:a05:622a:1010:b0:3f9:efa3:9e6f with SMTP id
 d16-20020a05622a101000b003f9efa39e6fmr9400841qte.27.1688790187997; 
 Fri, 07 Jul 2023 21:23:07 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 z23-20020ac81017000000b003f9efa2ddb4sm2383994qti.66.2023.07.07.21.23.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 21:23:07 -0700 (PDT)
Date: Sat, 08 Jul 2023 00:23:07 -0400
Message-ID: <1160e6ccbc06a59f243c3e4580f34194.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
References: <1687986571-16823-13-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-13-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH RFC v10 12/17] ipe: add support for dm-verity
 as a trust provider
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> Allows author of IPE policy to indicate trust for a singular dm-verity
> volume, identified by roothash, through "dmverity_roothash" and all
> signed dm-verity volumes, through "dmverity_signature".
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  security/ipe/Kconfig         |  18 +++++
>  security/ipe/Makefile        |   1 +
>  security/ipe/audit.c         |  25 ++++++
>  security/ipe/digest.c        | 142 +++++++++++++++++++++++++++++++++++
>  security/ipe/digest.h        |  26 +++++++
>  security/ipe/eval.c          | 101 ++++++++++++++++++++++++-
>  security/ipe/eval.h          |  13 ++++
>  security/ipe/hooks.c         |  51 +++++++++++++
>  security/ipe/hooks.h         |   8 ++
>  security/ipe/ipe.c           |  15 ++++
>  security/ipe/ipe.h           |   4 +
>  security/ipe/policy.h        |   3 +
>  security/ipe/policy_parser.c |  21 ++++++
>  13 files changed, 427 insertions(+), 1 deletion(-)
>  create mode 100644 security/ipe/digest.c
>  create mode 100644 security/ipe/digest.h

...

> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> index 6f94f5c8a0c3..9651e582791e 100644
> --- a/security/ipe/hooks.c
> +++ b/security/ipe/hooks.c
> @@ -192,3 +195,51 @@ void ipe_sb_free_security(struct super_block *mnt_sb)
>  {
>  	ipe_invalidate_pinned_sb(mnt_sb);
>  }
> +
> +#ifdef CONFIG_IPE_PROP_DM_VERITY
> +/**
> + * ipe_bdev_free_security - free IPE's LSM blob of block_devices.
> + * @bdev: Supplies a pointer to a block_device that contains the structure
> + *	  to free.
> + */
> +void ipe_bdev_free_security(struct block_device *bdev)
> +{
> +	struct ipe_bdev *blob = ipe_bdev(bdev);
> +
> +	kfree(blob->digest);
> +	kfree(blob->digest_algo);
> +}
> +
> +/**
> + * ipe_bdev_setsecurity - save data from a bdev to IPE's LSM blob.
> + * @bdev: Supplies a pointer to a block_device that contains the LSM blob.
> + * @key: Supplies the string key that uniquely identifies the value.
> + * @value: Supplies the value to store.
> + * @len: The length of @value.
> + */
> +int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
> +			 const void *value, size_t len)
> +{
> +	struct ipe_bdev *blob = ipe_bdev(bdev);

Before you can interpret the @key value, you need to first determine
which type of block device you have been handed.  It is possible that
multiple block device types could share the same key with very
different meanings for that key, yes?

> +	if (!strcmp(key, DM_VERITY_ROOTHASH_SEC_NAME)) {
> +		const struct dm_verity_digest *digest = value;
> +
> +		blob->digest = kmemdup(digest->digest, digest->digest_len, GFP_KERNEL);
> +		if (!blob->digest)
> +			return -ENOMEM;
> +
> +		blob->digest_algo = kstrdup_const(digest->algo, GFP_KERNEL);
> +		if (!blob->digest_algo)
> +			return -ENOMEM;
> +
> +		blob->digest_len = digest->digest_len;
> +		return 0;
> +	} else if (!strcmp(key, DM_VERITY_SIGNATURE_SEC_NAME)) {
> +		blob->dm_verity_signed = true;
> +		return 0;
> +	}
> +
> +	return -EOPNOTSUPP;
> +}
> +#endif /* CONFIG_IPE_PROP_DM_VERITY */

--
paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

