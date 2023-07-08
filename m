Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D66DCC001B0
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jul 2023 04:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688790194;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZN9J/27g324Wh+A2QqXcekSKtzjMsueFZBDS7yQBZKE=;
	b=h8cLRE0hTHyh6L2EseGfqww93npjhRNAWbuIV+ottPvLxzzXdOnaPnHtXUm8fJDOHF5O3W
	Vp2VbHG5yohey1mzdIYUfS3QXhgITCoceGM1dNeQgD/hvy6N+8rXcpSH3tHc0oheHuf4Pt
	PrRj/93VrVCmnSRQ4IONHeKHafQfjbc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646--eN9Fr7VONSdzPicFrO1aA-1; Sat, 08 Jul 2023 00:23:13 -0400
X-MC-Unique: -eN9Fr7VONSdzPicFrO1aA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 985C438041EB;
	Sat,  8 Jul 2023 04:23:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 82376F66A2;
	Sat,  8 Jul 2023 04:23:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 720F61946A71;
	Sat,  8 Jul 2023 04:23:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2B1221946A61
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Jul 2023 04:23:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 17E7D207B2DA; Sat,  8 Jul 2023 04:23:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 106A7207B315
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 04:23:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA5D728237D7
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 04:23:08 +0000 (UTC)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-MPETKYl6O3K0LRf1uO4DxA-1; Sat, 08 Jul 2023 00:23:05 -0400
X-MC-Unique: MPETKYl6O3K0LRf1uO4DxA-1
Received: by mail-qk1-f175.google.com with SMTP id
 af79cd13be357-76595a7b111so232927285a.2
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 21:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688790184; x=1691382184;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=tGA1GMuiBFLQbBC9Kx/aFBaGS7w0xHkPHFkJJNA2iSI=;
 b=a9fyK3n0FIo/ZL/tyQ2gEVg2UbgoE3Ww62IoOKV79BTiYGnijXleLRaL5KrGcA0fUS
 WHn/OSb1wDM/nnAs6BpgCoJ1oiWbifRMQ3fuj0Zq7u39oASk8qzcTWuFdfLu3WPVYo2+
 cNMJ6AduLh0gQ+EV0m6GP64HGLe5vx3BM4+brNEvjg/5AsB9oWVPkhWrwao0qA5iqdbW
 nGLnGH1ORJZemY2sQMCfdvm+3w8EMR9mV5mC8c3TKYuPJIJReRU9Pg+WpCuWfIvntNPn
 p77R2NZ58RnrxoJtJq4MUkBgV8V6uBd2U5QCbjhKRSrbNgWXbsdNAyzbliXpGATR4Mrq
 KVIA==
X-Gm-Message-State: ABy/qLZ7uSyzBlLQkmFR9WYySxIuzGBkhgOcEDfASk2nSXLbDC8sy9i6
 Sok6H+BfKwZidasO+HMvTSo5
X-Google-Smtp-Source: APBJJlGxWlU5zocT/PpO5XTLqSL3VMNhda6cmnflMBJu2pajHjmBGIr/SrrJ3ymYVbhkX/eeBD8tkA==
X-Received: by 2002:a05:620a:2903:b0:767:261d:1ef6 with SMTP id
 m3-20020a05620a290300b00767261d1ef6mr8087348qkp.59.1688790184537; 
 Fri, 07 Jul 2023 21:23:04 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 u15-20020a05620a120f00b007671678e325sm2432817qkj.88.2023.07.07.21.23.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 21:23:04 -0700 (PDT)
Date: Sat, 08 Jul 2023 00:23:03 -0400
Message-ID: <80ae988288d2ac277a4429e85524a9bb.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
References: <1687986571-16823-7-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-7-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH RFC v10 6/17] security: add new securityfs
 delete function
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
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: paul-moore.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> When deleting a directory in the security file system, the existing
> securityfs_remove requires the directory to be empty, otherwise
> it will do nothing. This leads to a potential risk that the security
> file system might be in an unclean state when the intentded deletion
> did not happen.
> 
> This commit introduces a new function securityfs_recursive_remove
> to recursively delete a directory without leaving an unclean state.
> 
> Co-developed-by: "Christian Brauner (Microsoft)" <brauner@kernel.org>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  include/linux/security.h |  1 +
>  security/inode.c         | 25 +++++++++++++++++++++++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index e2734e9e44d5..a88076ebc7b1 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1971,6 +1971,7 @@ struct dentry *securityfs_create_symlink(const char *name,
>  					 const char *target,
>  					 const struct inode_operations *iops);
>  extern void securityfs_remove(struct dentry *dentry);
> +extern void securityfs_recursive_remove(struct dentry *dentry);
>  
>  #else /* CONFIG_SECURITYFS */
>  
> diff --git a/security/inode.c b/security/inode.c
> index 6c326939750d..13358e8547e8 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -313,6 +313,31 @@ void securityfs_remove(struct dentry *dentry)
>  }
>  EXPORT_SYMBOL_GPL(securityfs_remove);
>  
> +static void remove_one(struct dentry *victim)
> +{
> +	simple_release_fs(&mount, &mount_count);
> +}
> +
> +/**
> + * securityfs_recursive_remove - recursively removes a file or directory from the securityfs filesystem

I really want to see lines less than or equal to 80 characters; I
would suggest this:

"securityfs_recursive_remove - recursively removes a file or directory"

> + * @dentry: a pointer to a the dentry of the file or directory to be removed.
> + *
> + * This function recursively removes a file or directory in securityfs that was
> + * previously created with a call to another securityfs function (like
> + * securityfs_create_file() or variants thereof.)
> + */
> +void securityfs_recursive_remove(struct dentry *dentry)
> +{
> +	if (IS_ERR_OR_NULL(dentry))
> +		return;
> +
> +	simple_pin_fs(&fs_type, &mount, &mount_count);
> +	simple_recursive_removal(dentry, remove_one);
> +	simple_release_fs(&mount, &mount_count);
> +}
> +EXPORT_SYMBOL_GPL(securityfs_recursive_remove);
> +
>  #ifdef CONFIG_SECURITY
>  static struct dentry *lsm_dentry;
>  static ssize_t lsm_read(struct file *filp, char __user *buf, size_t count,
> -- 
> 2.25.1

--
paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

