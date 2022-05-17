Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16FBBC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 03:38:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-OCYvjg6iP3e4dH0agQGQwg-1; Mon, 16 May 2022 23:38:31 -0400
X-MC-Unique: OCYvjg6iP3e4dH0agQGQwg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1050785A5BC;
	Tue, 17 May 2022 03:38:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 41FE0C27E83;
	Tue, 17 May 2022 03:38:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2D57F1947060;
	Tue, 17 May 2022 03:38:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 600EE194705F
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 May 2022 03:38:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 178D97ADD; Tue, 17 May 2022 03:38:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1387B7AD5
 for <dm-devel@redhat.com>; Tue, 17 May 2022 03:38:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C16129ABA34
 for <dm-devel@redhat.com>; Tue, 17 May 2022 03:38:19 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-595-avysIqgfMx6hMCxOatcw_w-1; Mon, 16 May 2022 23:38:15 -0400
X-MC-Unique: avysIqgfMx6hMCxOatcw_w-1
Received: by mail-pf1-f176.google.com with SMTP id i24so15770990pfa.7
 for <dm-devel@redhat.com>; Mon, 16 May 2022 20:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=8rb5YAnT4q61r5OFUKyY8/kc8YnIY9p2tTz3G6h+GnI=;
 b=Pr/EirS6HkG2rYjYbWVbilnJV0ZHjtvvEVkqwnc/KY5YYYl144Vj3da5NPaPcJhgz+
 OotTo62FpHlPLzmgopFEaji9Zde9O88WFT5c0ECsIbxCbgGRFiZ4QR8oVHXFU1WC8674
 Yhigaxbvb6+xkARJW8/1nu5garcS2K/7N8H0GfyaV/aMe5Sm6jIfX5SXTSEtUIgl1xqH
 ANzDzbmxLwsM3V/8xSMQ1S6GZe+1hzblGkaHJ9z5u0OAer4Ymav4qZBEYPuDd4evTrWX
 Bg8O/P/iFQr7GdfHVuLXFgYiDrhUB65a7S7obtjNySvUT5NKdAie5I+LpNb3df4DDjI4
 V5Gg==
X-Gm-Message-State: AOAM5315KlIGRSmoQ5uG13th/YxsxWyqeh6YPqSkNnAoNM6TTUz2vmUv
 rDg4QaCvcHDbNUkk9FBmB7E79PiFhV7kgw==
X-Google-Smtp-Source: ABdhPJyIsPDpWnvy/XwAKF70PpFSrTdafFUxvd2g6pCcfojmxhOeRGWOV4pPfIMZkiY5fzkbYDiRnA==
X-Received: by 2002:a05:6a02:10d:b0:381:f4c8:ad26 with SMTP id
 bg13-20020a056a02010d00b00381f4c8ad26mr17570035pgb.135.1652758693846; 
 Mon, 16 May 2022 20:38:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
 by smtp.gmail.com with ESMTPSA id
 i7-20020a17090332c700b0015e8d4eb27esm7802065plr.200.2022.05.16.20.38.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 16 May 2022 20:38:13 -0700 (PDT)
Date: Mon, 16 May 2022 20:38:12 -0700
From: Kees Cook <keescook@chromium.org>
To: Matthias Kaehlcke <mka@chromium.org>
Message-ID: <202205162035.CABA5B2C6@keescook>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <02028CEA-5704-4A51-8CAD-BEE53CEF7CCA@chromium.org>
 <YoKdSrjVf/tHGoa5@google.com>
MIME-Version: 1.0
In-Reply-To: <YoKdSrjVf/tHGoa5@google.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v3 1/3] dm: Add verity helpers for LoadPin
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, May 16, 2022 at 11:51:54AM -0700, Matthias Kaehlcke wrote:
> 'targets' are different types of DM mappings like 'linear' or 'verity'. A
> device mapper table contains has one or more targets that define the mapping
> of the blocks of the mapped device.
> 
> Having spelled that out I realize that the above check is wrong. It would
> consider a device like this trusted:
> 
> 0 10000000 linear 8:1
> 10000000 10001000 verity <params>
> 
> In the above case only a small part of the DM device would be backed by verity.
> 
> I think we want a table with a single entry that is a verity target.

Ah-ha! Okay, that's what I was worried about. Yes, a device made up
of only trusted verity targets should be the only trusted device. (So,
technically it could be more than 1 verity target, but each would need
to be trusted. Supporting that arrangement, though, may be overkill --
I would expect a 1:1 mapping as you suggest.

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

