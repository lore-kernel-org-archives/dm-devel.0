Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC52CE7AB4
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 18:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695665026;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uLS33dUzdsAfgO/almBx2139f655LdItBRj7cvXAh8Y=;
	b=eXgCly1cwzYWCdUT2Qz/D8G6oZ6VrSc5/eomwqNxdS4bGauwjO18f5LQ4wMndD1HT4t5Fw
	lbXUzpzVJwf+bn/vuCMGh0VcbqLMy4arGF5Tc+d1jYab0ajbIdcxNlQ9D5LxAC380LoWzl
	tW1OTU7LwERS5CvdzMm85Rx+tHnzPFk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-nmPVjgF6MpGkNN2JXlXWEw-1; Mon, 25 Sep 2023 14:03:43 -0400
X-MC-Unique: nmPVjgF6MpGkNN2JXlXWEw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7549E29AB40B;
	Mon, 25 Sep 2023 18:03:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2CF7AC15BB8;
	Mon, 25 Sep 2023 18:03:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EE24519465A3;
	Mon, 25 Sep 2023 18:03:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 94DB0194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 18:03:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6F16BC158BA; Mon, 25 Sep 2023 18:03:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 67FE4C15BB8
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 18:03:39 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B3FB101A529
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 18:03:39 +0000 (UTC)
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com
 [209.85.214.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-DsHBA_L2PFSHSymMJMzZHw-1; Mon, 25 Sep 2023 14:03:37 -0400
X-MC-Unique: DsHBA_L2PFSHSymMJMzZHw-1
Received: by mail-pl1-f178.google.com with SMTP id
 d9443c01a7336-1c60f1a2652so20364015ad.0
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 11:03:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695665016; x=1696269816;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=+9RYuMzpMZ1Kjw8xCG6ScZcw+CG8cVN4DnPu5iQzw9Q=;
 b=JImldQlJBahaH3+RcABDslnRxAj+5gNnHIwtcg1YYO69PmWillx8K+QcGnT49EqUJT
 wP8/hn6/BNIvID7cmq922j8vKkqN8DlopYD1/z6zVhAo/r3K/rNYLNhHGeXAVZ8dXPY4
 NyymjU4/eWhT66j4w+o7AJagvyKV959jvqvOFcTPQH48poRLbtegSep6aKc+zRVeq1lu
 Fsr7IoaKHeccGl1rUPlNEeBtXSMyWbb8hZAP1Ghe/d1CnkXOcD6M1Gzc7IDb1skcECSD
 jf90FyeLQJCMYlwLt8dwXB7eiKahsvxckM4szyRHtTdoMJjXUL2FPBAYR/L855OSaQRl
 SO/w==
X-Gm-Message-State: AOJu0YzY1PCvGEA7cjDCPKDq2hWSzE04aUq9sBhZ7A8ETLPLKs1Fr5q5
 s8R2ml0COEhWs7A9TxfzHT4EaA==
X-Google-Smtp-Source: AGHT+IG74UKbEkY1JQiaqOtSpDzma/IThI+ed1OjvWcjV2tlvk545e9MyWcqQ9MZpxR309voDZttjg==
X-Received: by 2002:a17:902:ce8b:b0:1c5:7d49:570e with SMTP id
 f11-20020a170902ce8b00b001c57d49570emr558074plg.29.1695665016096; 
 Mon, 25 Sep 2023 11:03:36 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 kb14-20020a170903338e00b001bb3beb2bc6sm9184421plb.65.2023.09.25.11.03.35
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 25 Sep 2023 11:03:35 -0700 (PDT)
Date: Mon, 25 Sep 2023 11:03:34 -0700
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Message-ID: <202309251103.4FBC42C4@keescook>
References: <20230925-strncpy-drivers-md-dm-cache-metadata-c-v1-1-4b75c7db0cfe@google.com>
MIME-Version: 1.0
In-Reply-To: <20230925-strncpy-drivers-md-dm-cache-metadata-c-v1-1-4b75c7db0cfe@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] dm cache metadata: replace deprecated
 strncpy with strscpy
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 linux-hardening@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 25, 2023 at 06:13:12AM +0000, Justin Stitt wrote:
> `strncpy` is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> It seems `cmd->policy_name` is intended to be NUL-terminated based on a
> now changed line of code from Commit (c6b4fcbad044e6ff "dm: add cache
> target"):
> |       if (strcmp(cmd->policy_name, policy_name)) { // ...
> 
> However, now a length-bounded strncmp is used:
> |       if (strncmp(cmd->policy_name, policy_name, sizeof(cmd->policy_name)))
> ... which means NUL-terminated may not strictly be required. However, I
> believe the intent of the code is clear and we should maintain
> NUL-termination of policy_names.
> 
> Moreover, __begin_transaction_flags() zero-allocates `cmd` before
> calling read_superblock_fields():
> |       cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> 
> Also, `disk_super->policy_name` is zero-initialized
> |       memset(disk_super->policy_name, 0, sizeof(disk_super->policy_name));
> ... therefore any NUL-padding is redundant.
> 
> Considering the above, a suitable replacement is `strscpy` [2] due to
> the fact that it guarantees NUL-termination on the destination buffer
> without unnecessarily NUL-padding.
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Agreed about the %NUL termination and padding assessment.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

