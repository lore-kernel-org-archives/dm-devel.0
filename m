Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E126C25B0C
	for <dm-devel@archiver.kernel.org>; Wed, 10 Aug 2022 03:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1660102569;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hY67SNP+miLMQJWKSTvHgmoYqP9C5eXyyfb6NcnZKtQ=;
	b=e6NukWiVGGUhDwU78AiqZE7X1xCqc2gUNhCoa8eLjW8oh9ssd7zSR+E/6+dLbzoAo9HfVV
	b3mNkJ94NC4HnV47o0OVtIwd9eiFR7VqBGY6uzPe3qMl0TqB/8Tvt7Mp1ULnHRE/656SYn
	sy7HazQLcz00GUbi6BjYwcvNPEoCD7U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-L-vHU3MeM7Cuc7OjJt13nw-1; Tue, 09 Aug 2022 23:36:06 -0400
X-MC-Unique: L-vHU3MeM7Cuc7OjJt13nw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF7E9858EEE;
	Wed, 10 Aug 2022 03:36:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DBBBE2166B29;
	Wed, 10 Aug 2022 03:36:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D8FF194F843;
	Wed, 10 Aug 2022 03:36:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4D7321946A41
 for <dm-devel@listman.corp.redhat.com>; Tue,  9 Aug 2022 15:58:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D6F171121319; Tue,  9 Aug 2022 15:58:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D2B601121315
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 15:58:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF77129AA2EE
 for <dm-devel@redhat.com>; Tue,  9 Aug 2022 15:58:16 +0000 (UTC)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com
 [209.85.167.170]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-jIRpVePuMiG-qqtl64sPnw-1; Tue, 09 Aug 2022 11:58:09 -0400
X-MC-Unique: jIRpVePuMiG-qqtl64sPnw-1
Received: by mail-oi1-f170.google.com with SMTP id u9so14296689oiv.12
 for <dm-devel@redhat.com>; Tue, 09 Aug 2022 08:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=HUXaYVwE6orHodeBsCAxKkSFqqLupHxNZ2roYGcQJ3U=;
 b=7DUQJu6kCVAIJt+llzVYj4hlpFHyBhRi1+3dwbzMShWj2snD3887CUi4F1yjdZAqPi
 ZqKjxjPFxZQMfyr5dObzkRElpiqq9j0A7IcNLEXIrN5zovZJ95jvKd+48ZIf9i2PcPV0
 RWGZapSEowCSxkjzw+tQpyITG74IUk06CUCWpxvGM4hB7f/v1ChYOptG/cn8TcEd+gea
 z7HWnzLuco+pcZjQxq3rggvXFD1RcJKf8M6YHeTLPH1eR2m2lgL/YKPrUqXrHHc7Q1yG
 gZorzSkTk4bihxRjZwd1+MhoxjCfiNRBUKATUcn3iSFAo57nMvudh1xI9vUGzZKBgIBF
 vvuQ==
X-Gm-Message-State: ACgBeo1YvX9ZTEii2EFxhE4E+dIeN1IWSOHEqbayzIF3ueiCPPxzl/YS
 ak19ChkdrrAWsWR5oF+38zgM2Q==
X-Google-Smtp-Source: AA6agR5yALJSQiqpyuDxfVXadUjpSlKzadaxwr3uRwJCazGWMfl76Mg96IgJ2CaNNqe5ceJ+1WIb5A==
X-Received: by 2002:a05:6808:1889:b0:33b:2f70:cca0 with SMTP id
 bi9-20020a056808188900b0033b2f70cca0mr10801550oib.253.1660060688904; 
 Tue, 09 Aug 2022 08:58:08 -0700 (PDT)
Received: from sequoia (162-237-133-238.lightspeed.rcsntx.sbcglobal.net.
 [162.237.133.238]) by smtp.gmail.com with ESMTPSA id
 c4-20020a056870c08400b0010e81e27b99sm3179258oad.17.2022.08.09.08.58.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 09 Aug 2022 08:58:08 -0700 (PDT)
Date: Tue, 9 Aug 2022 10:57:50 -0500
From: Tyler Hicks <code@tyhicks.com>
To: Deven Bowers <deven.desai@linux.microsoft.com>
Message-ID: <20220809155737.GA39351@sequoia>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
 <1654714889-26728-8-git-send-email-deven.desai@linux.microsoft.com>
MIME-Version: 1.0
In-Reply-To: <1654714889-26728-8-git-send-email-deven.desai@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Wed, 10 Aug 2022 03:36:02 +0000
Subject: Re: [dm-devel] [RFC PATCH v8 07/17] ipe: add auditing support
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
Cc: axboe@kernel.dk, linux-security-module@vger.kernel.org, tytso@mit.edu,
 paul@paul-moore.com, corbet@lwn.net, roberto.sassu@huawei.com,
 linux-doc@vger.kernel.org, snitzer@kernel.org, jmorris@namei.org,
 zohar@linux.ibm.com, linux-kernel@vger.kernel.org, ebiggers@kernel.org,
 dm-devel@redhat.com, linux-audit@redhat.com, linux-block@vger.kernel.org,
 eparis@redhat.com, linux-fscrypt@vger.kernel.org,
 linux-integrity@vger.kernel.org, agk@redhat.com, serge@hallyn.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2022-06-08 12:01:19, Deven Bowers wrote:
> +/**
> + * getaudit: Read handler for the securityfs node, "ipe/success_audit"
> + * @f: Supplies a file structure representing the securityfs node.
> + * @data: Supplies a buffer passed to the read syscall
> + * @len: Supplies the length of @data
> + * @offset: unused.
> + *
> + * Return:
> + * >0 - Success, Length of buffer written
> + * <0 - Error
> + */
> +static ssize_t getaudit(struct file *f, char __user *data,
> +			size_t len, loff_t *offset)
> +{
> +	const char *result;
> +	struct ipe_context *ctx;
> +
> +	ctx = ipe_current_ctx();
> +
> +	rcu_read_lock();
> +	result = ((READ_ONCE(ctx->success_audit)) ? "1" : "0");
> +	rcu_read_unlock();
> +
> +	ipe_put_ctx(ctx);
> +	return simple_read_from_buffer(data, len, offset, result, 2);

While doing some internal testing, I noticed that some of the IPE files
in securityfs (ipe/audit, ipe/enforce, and ipe/policies/*/active) are
including the NULL terminator (size of 2) in the securityfs file
contents. This is not common to do and this busybox build that my test
machine is using even has some trouble when displaying those files with
cat. I see all three instances of this pattern with this command:

 $ git grep simple_read_from_buffer\(.*,\ 2\) security/ipe

I think going to a length of 1 would be best.

Tyler

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

