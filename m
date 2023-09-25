Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BE21CE7AB9
	for <dm-devel@archiver.kernel.org>; Mon, 25 Sep 2023 18:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695665087;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Fmtd+DwLBjmld7rt+maOl7iCN31mPTt73RkuYuewKlA=;
	b=JvsyYngFg5ZwhbfVUwtDE+BtfsZg1gwSEh1WrRJi/P+YI3J4CmxTJ1ymlAjaUDDcbesK3g
	NFa8zvislw/igrqwtE6nd79Cq/9+Ivv4TjXi0bz80MK+Dnm5OQm5GePNHHkmnJkrGkFYP9
	MKPTpG6G6jeB4kyilgx57veSJFPOGd0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-W8MbjHGrNYyHtDZFe3I1gw-1; Mon, 25 Sep 2023 14:04:42 -0400
X-MC-Unique: W8MbjHGrNYyHtDZFe3I1gw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 928B51C294B4;
	Mon, 25 Sep 2023 18:04:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7ED08711286;
	Mon, 25 Sep 2023 18:04:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 58818194658F;
	Mon, 25 Sep 2023 18:04:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CA558194658C
 for <dm-devel@listman.corp.redhat.com>; Mon, 25 Sep 2023 18:04:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5E477C154CB; Mon, 25 Sep 2023 18:04:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 57311C154CA
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 18:04:38 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37B90181960E
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 18:04:38 +0000 (UTC)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com
 [209.85.219.174]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-KAIAl3GzMq-LhTJoXqiVuQ-1; Mon, 25 Sep 2023 14:04:34 -0400
X-MC-Unique: KAIAl3GzMq-LhTJoXqiVuQ-1
Received: by mail-yb1-f174.google.com with SMTP id
 3f1490d57ef6-d8164e661abso8094702276.1
 for <dm-devel@redhat.com>; Mon, 25 Sep 2023 11:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1695665074; x=1696269874;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=XftFOjpvnqBOvm+GyG7dS3QneDyHgJbjgRAoI+rP2Vc=;
 b=WQkH0Ek4SRGN7Qjw6nLZ5BTeBDrpWP9iO8Hq/7d2M6jeE2vXbK5hpnlCkDfOx8cjll
 73isisFqZv3GaIT3zWJttUMaFp6uCgRUCTkT95/SP/FzhBCZcq01hC9C8M3iGEygR3ek
 +CjozaukYwmeh4vMxNQ5g6y6EEhrZNYvtVHaDXaVQGwuKlVYOgQf37i04Twr7JqoI31d
 h+tUhYJP2I4B9G0NjsovEKFcdh9F6j3cNyh5okYAXQcP7Jeb7vaZbDzYuM16HqBx7rzJ
 TvsReQtVX/7HXyhe0cv8hI532/Pf/gX8VsfowlQiBbh0UjfG8sBx1x6fYx7JzNr4vHCa
 LIsQ==
X-Gm-Message-State: AOJu0YwZ4FbEJqAWCRyMXkb3bo6/59wEge1jPtoCq60ro3OB9LbuJtcj
 z6gRTTNS9cg+h+ViqZRkDF6/yQ==
X-Google-Smtp-Source: AGHT+IHLxOCMidSuiT5VuJdY2s//GNKCUPI3HgEunXnWS6HNGof+bL6k1SeyWqZzqivG9gVlZPGyJQ==
X-Received: by 2002:a25:838e:0:b0:d7f:e578:58d5 with SMTP id
 t14-20020a25838e000000b00d7fe57858d5mr6401728ybk.41.1695665073996; 
 Mon, 25 Sep 2023 11:04:33 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net.
 [198.0.35.241]) by smtp.gmail.com with ESMTPSA id
 j19-20020a633c13000000b00565009a97f0sm8168514pga.17.2023.09.25.11.04.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 25 Sep 2023 11:04:33 -0700 (PDT)
Date: Mon, 25 Sep 2023 11:04:32 -0700
From: Kees Cook <keescook@chromium.org>
To: Justin Stitt <justinstitt@google.com>
Message-ID: <202309251104.2039A045E@keescook>
References: <20230925-strncpy-drivers-md-dm-crypt-c-v1-1-eef875e4f9b2@google.com>
MIME-Version: 1.0
In-Reply-To: <20230925-strncpy-drivers-md-dm-crypt-c-v1-1-eef875e4f9b2@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] dm crypt: replace open-coded kmemdup_nul
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: chromium.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 25, 2023 at 06:35:54AM +0000, Justin Stitt wrote:
> kzalloc() followed by strncpy() on an expected NUL-terminated string is
> just kmemdup_nul(). Let's simplify this code (while also dropping a
> deprecated strncpy() call [1]).
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Justin Stitt <justinstitt@google.com>

This looks correct to me. Thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

