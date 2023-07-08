Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF9B5EB64DA
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jul 2023 05:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688794629;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZN9J/27g324Wh+A2QqXcekSKtzjMsueFZBDS7yQBZKE=;
	b=SdXOyNsqbFPDxk6csuwLKxEG5Ttn/WXHeoA1nuDSLM/ee5s7MO8Vufzm1yj83A2FYdusy+
	+1EXHP2FhR94cVYZD0ZbT7EgWTHHwM2plomxT1fm0CNmEghfF6u/7rQaGIldR7kwcysfYX
	MuO94/D4xuwWqK+CQDCiRbiu/5y1Wno=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-BbfAAPpWMZWnV-reDcJ22g-1; Sat, 08 Jul 2023 01:37:06 -0400
X-MC-Unique: BbfAAPpWMZWnV-reDcJ22g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C43491C041A8;
	Sat,  8 Jul 2023 05:37:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF09F492B02;
	Sat,  8 Jul 2023 05:37:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7E4931946A70;
	Sat,  8 Jul 2023 05:37:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 05A151946A5E
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Jul 2023 05:37:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E17A340C6CD3; Sat,  8 Jul 2023 05:37:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D863140C6CD1
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 05:37:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A4AA185A7A8
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 05:37:01 +0000 (UTC)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com
 [209.85.160.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-XNBQN0YcM3KToD40-I7ajQ-1; Sat, 08 Jul 2023 01:37:00 -0400
X-MC-Unique: XNBQN0YcM3KToD40-I7ajQ-1
Received: by mail-qt1-f182.google.com with SMTP id
 d75a77b69052e-3ff24a193dbso20893501cf.3
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 22:36:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688794619; x=1691386619;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=tGA1GMuiBFLQbBC9Kx/aFBaGS7w0xHkPHFkJJNA2iSI=;
 b=croPqVUeBjb7T9HRzYmvzagWqCj8Z5JGqJPotfdgVWkpZaxGPHuqPHsVlQVc89Q8hC
 XY1nL9f7RdmF8LvXo6qKJ6DErvxJPdXu1V/vu4QEsqpn0xiDlxU5gexlPzZfYkSmXwn1
 ndMY1U5pQikmJdn+LOcaDcVJkAQaV8bnkX7IudpHsQj8VH8Ya0hbUtv25cslEwgKpP/Z
 OUXaAvLTcQKXZJg6D6SJ+xNGA9nuiwAJYhiQGQrDlJt2ehpyMljpUI/ISaaOixDDL0eK
 89lHucViH8tIuuVWoAZoGr3VG192YXe7s0l4O8h/uKF04WOHxlywu6yjAh4/wPZ6OErM
 wguQ==
X-Gm-Message-State: ABy/qLakmE/wuGlxRwshT6KojICG5dgPHnYhcFLQsOIDqnaQas/Og/aD
 d4Oe0RfcoViO04E7jHUkNW2F
X-Google-Smtp-Source: APBJJlFF68xKBlrT8ZUzDF7hUpibBBTXCy89LqgKEgf14OWs8qrR4aAL2DMHEseMAEOpXtlRbrYnOQ==
X-Received: by 2002:ac8:7dc6:0:b0:3ff:2088:79d8 with SMTP id
 c6-20020ac87dc6000000b003ff208879d8mr9453816qte.4.1688794619449; 
 Fri, 07 Jul 2023 22:36:59 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 a6-20020a0cca86000000b0062df126ca11sm2943696qvk.21.2023.07.07.22.36.59
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 22:36:59 -0700 (PDT)
Date: Sat, 08 Jul 2023 01:36:58 -0400
Message-ID: <2edaa73fc9457f4a051115863d94b4ff.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
References: <1687986571-16823-7-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-7-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

