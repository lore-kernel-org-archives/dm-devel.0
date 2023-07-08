Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A10CC00528
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jul 2023 05:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688794631;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sqeJUVH+7eOae5JtNp9/BLkgEmw05MZpA6YpifTPwe8=;
	b=Jr4OxEsRskO4CxoR7jSMRpwgAVK4QfwZNMplZIwPA7n45P+5y/lLCNFcwmsSN+choTWCSn
	5ByP5DpIdqsf0SWZVSUQWS7wIrXFRNkOL6fTNVdi3L/kY/y8OGXIDy/vAA48HV81wkG2Sn
	hasB5pxhH53cXxLNC5ixabj9gtkULlU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-GO9x8hsmNci_os8CWiXN-A-1; Sat, 08 Jul 2023 01:37:07 -0400
X-MC-Unique: GO9x8hsmNci_os8CWiXN-A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09E392A59542;
	Sat,  8 Jul 2023 05:37:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC96E200B402;
	Sat,  8 Jul 2023 05:37:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D6CA51946A70;
	Sat,  8 Jul 2023 05:37:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1869019451C4
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Jul 2023 05:37:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EEA242166B25; Sat,  8 Jul 2023 05:37:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E67FB2166B26
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 05:37:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CAA0B3C0ED5C
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 05:37:04 +0000 (UTC)
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com
 [209.85.219.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-_-2trn8OMNOPl0mzJOnAMA-2; Sat, 08 Jul 2023 01:37:03 -0400
X-MC-Unique: _-2trn8OMNOPl0mzJOnAMA-2
Received: by mail-qv1-f52.google.com with SMTP id
 6a1803df08f44-636274ce31eso17013546d6.1
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 22:37:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688794623; x=1691386623;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=+Hz3LNSJIA32LS0w6BjIcScwNW8naJ0tmp1lMEgiYII=;
 b=Sn+6komwamuzN3sReBYLSdYIVSoobAj1ovDlyTs3xm6tu1JSiHqWDI07xAlPP5HVXt
 cfl1W6zYltVZlibegVGzDmS6v/oDaz/bsr9mzalZ9HIukGnJuEyEJ8tPU2vB4KCoNJWd
 nyAD15CX5dlG8rZwMZ+pRYCOfKYi8LAJ9a64MWexYA791KZBxEPVFNVDuGFAB6ODnqLM
 JChlONscK0ZjCGO/1EfUj2z5t1dJ9ZmXeuHhnwGqtZC7xydIy0ZxG9uILdSc5/mErlTl
 55HoHn5zDBQK4khnYu3UUhvFw62RArjI/yBBtOS5O89yAJ0bH4m9hZ5GQq8v9eQuHcFT
 4QRw==
X-Gm-Message-State: ABy/qLbRWvV0Fe0qKzGRTOy5UrI3aqduNpdE52dOvtwdkmBmC+Qs+poC
 RQT/YVa01ZpVP9Dtu46ERqu8
X-Google-Smtp-Source: APBJJlGE5kRrswBX0Y9fpwcc9M53MKX/WP5JEebgbuewEsG3HG+C8bw51ha3b43wJWNhFgxWAHSXSg==
X-Received: by 2002:a0c:9a06:0:b0:631:e696:7b6 with SMTP id
 p6-20020a0c9a06000000b00631e69607b6mr6291591qvd.53.1688794622811; 
 Fri, 07 Jul 2023 22:37:02 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 a6-20020a0cca86000000b0062df126ca11sm2943746qvk.21.2023.07.07.22.37.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 22:37:02 -0700 (PDT)
Date: Sat, 08 Jul 2023 01:37:02 -0400
Message-ID: <f1e5890316985ff642d17201e28e9d11.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
References: <1687986571-16823-13-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-13-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
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

