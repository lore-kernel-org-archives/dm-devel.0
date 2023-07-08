Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D86C2EB64DC
	for <dm-devel@archiver.kernel.org>; Sat,  8 Jul 2023 05:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688794630;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cMVwz5o5fapIMYJVAC5ftdQH5dCA0MedteKkxvs+Xxw=;
	b=Jm1q3/gcNhoqRHLZb/E+sF+5KGoM254mdJ0RaFIjlFypeZ0mqkgLxszXxS1vIjExcO+2W0
	a1jR6JHGndkSvGp8jKHW+Pz58ms6lR+emK8fEATJNtqXo/FaoGgXurgjkn5OpWuPGF6b63
	xgLUNhugmT8KkEUl3hcTYIp8Jot3+QE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-AuGgvbllOPe8Y-8gqbVyBQ-1; Sat, 08 Jul 2023 01:37:06 -0400
X-MC-Unique: AuGgvbllOPe8Y-8gqbVyBQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BAD138041EF;
	Sat,  8 Jul 2023 05:37:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E2D44C54FBA;
	Sat,  8 Jul 2023 05:37:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A6C7419452C8;
	Sat,  8 Jul 2023 05:37:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 28D881946A5E
 for <dm-devel@listman.corp.redhat.com>; Sat,  8 Jul 2023 05:37:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 173111121333; Sat,  8 Jul 2023 05:37:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1016B1121331
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 05:37:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E909828237D9
 for <dm-devel@redhat.com>; Sat,  8 Jul 2023 05:37:03 +0000 (UTC)
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com
 [209.85.219.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-gW6mbyGnOXCAJupbyHjA-w-1; Sat, 08 Jul 2023 01:37:02 -0400
X-MC-Unique: gW6mbyGnOXCAJupbyHjA-w-1
Received: by mail-qv1-f50.google.com with SMTP id
 6a1803df08f44-6355e774d0aso16489296d6.1
 for <dm-devel@redhat.com>; Fri, 07 Jul 2023 22:37:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688794622; x=1691386622;
 h=in-reply-to:references:subject:cc:to:from:message-id:date
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Z6/SL5QIc9OziszvZ8u03wi1DZHVgI7E++JsfeAk1ow=;
 b=BBZeRV3h8eAv/BDK73Tgp+ylboI5FvP8B/HvHCVekQWI/CZRdBxjjTpVgeuVVPrLH4
 oPem3Vemti9/XfEFlR0oxHreOFNAgfmnFt7ICwSqVOjuyDNBmHkqvfDRnww/wIuNkFjo
 K1xBffUjb5zxpjQYwy6OEi90/888POwvpEPgfQfb41dkW2FF5RsEADz0peyCYi22gGBs
 JnotxVjJFLYv9WA6TwZmdwpDzq1L2B3yGi5r2Hwb3w9PUjna7T23shhwqJSKpMI6wtWi
 zmR3e+7h7Uf2c/gPa2GaVYeDb4sMEF2c7kkIGv/1umgL1pw93Elr7dl6pFo1+YhJu8Wy
 IAYA==
X-Gm-Message-State: ABy/qLb4FJNhfM/oPYHbCWkr9UMNYX9BNKIKHXKyww/2F8bkZSBQpgFS
 eQWZKxfopGv2DjoWbI8bZLOy
X-Google-Smtp-Source: APBJJlHqj9++w6WHE9OOS1x/EIvxFYkNoud1COXwqkUYSG2/gyokLAhEcbs9dBviEyfunYwBG/R77Q==
X-Received: by 2002:a0c:da14:0:b0:636:e4f:6b9a with SMTP id
 x20-20020a0cda14000000b006360e4f6b9amr6374783qvj.17.1688794621936; 
 Fri, 07 Jul 2023 22:37:01 -0700 (PDT)
Received: from localhost ([70.22.175.108]) by smtp.gmail.com with ESMTPSA id
 m6-20020a0cdb86000000b006362c5760f8sm2952651qvk.139.2023.07.07.22.37.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Jul 2023 22:37:01 -0700 (PDT)
Date: Sat, 08 Jul 2023 01:37:01 -0400
Message-ID: <b7334846cb475edd0e9b970a2bb011d7.paul@paul-moore.com>
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
References: <1687986571-16823-10-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-10-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH RFC v10 9/17] ipe: add permissive toggle
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
> IPE, like SELinux, supports a permissive mode. This mode allows policy
> authors to test and evaluate IPE policy without it effecting their
> programs. When the mode is changed, a 1404 AUDIT_MAC_STATUS
> be reported.
> 
> This patch adds the following audit records:
> 
>     audit: MAC_STATUS enforcing=0 old_enforcing=1 auid=4294967295
>       ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
>     audit: MAC_STATUS enforcing=1 old_enforcing=0 auid=4294967295
>       ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
> 
> The audit record only emit when the value from the user input is
> different from the current enforce value.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
>  security/ipe/audit.c | 22 ++++++++++++++
>  security/ipe/audit.h |  1 +
>  security/ipe/eval.c  |  9 ++++++
>  security/ipe/eval.h  |  1 +
>  security/ipe/fs.c    | 69 ++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 102 insertions(+)

...

> diff --git a/security/ipe/fs.c b/security/ipe/fs.c
> index 6bd2aa84831b..1761d39e4d04 100644
> --- a/security/ipe/fs.c
> +++ b/security/ipe/fs.c
> @@ -16,6 +16,7 @@ static struct dentry *np __ro_after_init;
>  static struct dentry *root __ro_after_init;
>  struct dentry *policy_root __ro_after_init;
>  static struct dentry *audit_node __ro_after_init;
> +static struct dentry *enforce_node __ro_after_init;
>  
>  /**
>   * setaudit - Write handler for the securityfs node, "ipe/success_audit"
> @@ -68,6 +69,61 @@ static ssize_t getaudit(struct file *f, char __user *data,
>  	return simple_read_from_buffer(data, len, offset, result, 1);
>  }
>  
> +/**
> + * setenforce - Write handler for the securityfs node, "ipe/enforce"
> + * @f: Supplies a file structure representing the securityfs node.
> + * @data: Supplies a buffer passed to the write syscall.
> + * @len: Supplies the length of @data.
> + * @offset: unused.
> + *
> + * Return:
> + * * >0	- Success, Length of buffer written
> + * * <0	- Error
> + */
> +static ssize_t setenforce(struct file *f, const char __user *data,
> +			  size_t len, loff_t *offset)
> +{
> +	int rc = 0;
> +	bool new_value, old_value;
> +
> +	if (!file_ns_capable(f, &init_user_ns, CAP_MAC_ADMIN))
> +		return -EPERM;
> +
> +	old_value = READ_ONCE(enforce);
> +	new_value = old_value;

Why set @new_value equal to @old_value here?

> +	rc = kstrtobool_from_user(data, len, &new_value);
> +	if (rc)
> +		return rc;
> +
> +	if (new_value != old_value) {
> +		ipe_audit_enforce(new_value, old_value);
> +		WRITE_ONCE(enforce, new_value);
> +	}
> +
> +	return len;
> +}

--
paul-moore.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

