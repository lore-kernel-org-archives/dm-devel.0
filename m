Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8B7EB64DA
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jul 2023 19:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689017780;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=23shWbYDUcTSD3yBZV0iAnH4xi4v5jEErRQYVMqm0rg=;
	b=SXkEYByK9uc6a74iIsBluCtjYUxkHKrSPNslkaCtN5uGMGj743ZcgZOauOuCaC2L6Ir2qS
	VaZ7+CKcuerSHKDv9nkZKGOQUCO54lG+ZN410HW5r/F9N/qGHgVBft/9uCp46XH+0fQj8q
	nI2RmI2bU9bacZlEUtDHiNLgySwuBzI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-JNLXhgAeNU2uKuv-eq16Cg-1; Mon, 10 Jul 2023 15:36:17 -0400
X-MC-Unique: JNLXhgAeNU2uKuv-eq16Cg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 554ED1C07820;
	Mon, 10 Jul 2023 19:36:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD225492B01;
	Mon, 10 Jul 2023 19:36:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9829B19465B9;
	Mon, 10 Jul 2023 19:36:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8E58F19465B8
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Jul 2023 19:36:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 124D02166B26; Mon, 10 Jul 2023 19:36:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A3BC2166B28
 for <dm-devel@redhat.com>; Mon, 10 Jul 2023 19:36:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C26113C0FC83
 for <dm-devel@redhat.com>; Mon, 10 Jul 2023 19:36:11 +0000 (UTC)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-214-XbMs9FgnM0CJJziV8fsgPw-1; Mon, 10 Jul 2023 15:36:05 -0400
X-MC-Unique: XbMs9FgnM0CJJziV8fsgPw-1
Received: by mail-pj1-f43.google.com with SMTP id
 98e67ed59e1d1-262e66481c4so2308805a91.1; 
 Mon, 10 Jul 2023 12:36:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1689017764; x=1691609764;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=0B3XSLLjuEjtNYqEZBG77mA0gS4vthVHEe/V5yRqvhA=;
 b=QMgGtTUxBG4R5XB43zjNjpG3+TH2aeru8J/suGXrCmZEiVbeKylZ1A9H3IxuPb7drS
 1ZCkiPT3h8h06YShmCoepKY7EEummS4ucLPbKGxb7B20npJJJ8jckTU4cg+4jTj3Xj6p
 +dsbxGdR/I0/1fo45kicVvpyvLVXqdOp/i1JdrARdPVWCswCBTn0rlxymfWRl94Osagv
 3PWCskRxY1ak8Tfzana/RkdRa+b/BGnJUuhJb9zugEOcXyBMCelhWzxMR5/ZEBH2yh6q
 tNkY9ey5yFLhaLEfEQnhLz4aiE0lltxBX2niMjWi+WDba0K8vppa2nFpovGNspXrSBya
 K9Og==
X-Gm-Message-State: ABy/qLYd81mVwRCaaK8xNLQOuZnswKjEc8q+PJdVjnOK65fVzCb5qAel
 2cgREjkDe0xWTUlfTDHDmiJKEJsAUX05WA==
X-Google-Smtp-Source: APBJJlFzyIkD31skLQBh/rVvud9fMUns8jkA0cORhGdx1hvMjEDc+DGtv1tFdkuQC6BUAF8giphvPA==
X-Received: by 2002:a17:90a:88b:b0:262:ff1c:bc37 with SMTP id
 v11-20020a17090a088b00b00262ff1cbc37mr10796761pjc.2.1689017764300; 
 Mon, 10 Jul 2023 12:36:04 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:e2fe])
 by smtp.gmail.com with ESMTPSA id
 l130-20020a633e88000000b0055b5f206ea2sm82536pga.39.2023.07.10.12.36.03
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 10 Jul 2023 12:36:03 -0700 (PDT)
Date: Mon, 10 Jul 2023 09:36:02 -1000
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <ZKxdosGfpQxRxdYp@slm.duckdns.org>
References: <20230301032904.3561641-1-yangerkun@huaweicloud.com>
 <b96155f3-0f6c-273d-4e0a-24fe05bb618a@huaweicloud.com>
 <7f1f7798-dd56-919f-cd59-22cfcafae342@huaweicloud.com>
 <ZKhbclN3V8taEStt@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZKhbclN3V8taEStt@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v2] dm-crypt: reexport sysfs of kcryptd
 workqueue
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
Cc: yangerkun <yangerkun@huaweicloud.com>, dm-devel@redhat.com,
 mpatocka@redhat.com, jefflexu@linux.alibaba.com, yukuai3@huawei.com,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello, Mike.

On Fri, Jul 07, 2023 at 02:37:38PM -0400, Mike Snitzer wrote:
> I certainly would like the ability to allow control over the
> workqueues using WQ_SYSFS.  But with Tejun's latest WQ_UNBOUND changes
> (just merged during 6.5 merge window) I think we'd do well to audit

That part didn't get merged yet. I'm still waiting on some benchmark results
to verify that the change won't cause regressions which are difficult to
work around. The target is the next merge window.

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

