Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7C2C76196
	for <dm-devel@archiver.kernel.org>; Thu, 23 Mar 2023 14:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679583434;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EGWKYAJfAPFNANbC5I264gB+oy++LyaBLl71+inVBeo=;
	b=jKjlNzpgcFcrauTzi/9QkVZ7qUBVDTcpMSq6EGKfpfYm1C8L3g18WwdA01CWZ/1Mnz8Wa+
	tEj8To9xoNjktL0NiUJqlY/qMHCM2QV/Nr3GT4eVNBqehal47k9b6W/f4sl92+bSetUn/y
	asG2u0HDsGSwaPj8P/Yigcl8dsYM094=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399--E8JqovKPuOCTVDzqp2o0g-1; Thu, 23 Mar 2023 10:57:13 -0400
X-MC-Unique: -E8JqovKPuOCTVDzqp2o0g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8ADA1049BAB;
	Thu, 23 Mar 2023 14:57:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CC96940CF8F2;
	Thu, 23 Mar 2023 14:57:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A2AFC19465B7;
	Thu, 23 Mar 2023 14:57:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 26E3D1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Mar 2023 14:57:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D3BB440CF916; Thu, 23 Mar 2023 14:57:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CC10340CF8F2
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 14:57:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B0E571C17425
 for <dm-devel@redhat.com>; Thu, 23 Mar 2023 14:57:08 +0000 (UTC)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-YgWPGaqAOzCbBL_MRarNBQ-1; Thu, 23 Mar 2023 10:57:07 -0400
X-MC-Unique: YgWPGaqAOzCbBL_MRarNBQ-1
Received: by mail-wm1-f48.google.com with SMTP id
 v20-20020a05600c471400b003ed8826253aso1983642wmo.0; 
 Thu, 23 Mar 2023 07:57:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679583425;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:mime-version:date:message-id
 :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=wJNgYNORmdTvEUAT0/YgWnrd/HZ7rT9XPnsF+afGo2k=;
 b=5eJLXAjXIE5m0Y54teFTD4eNhDP9WwKxlwRsMQpzXBVHFEKa1dRlikYQXNIsAYIiR9
 5UxHDPoWIQXVC9Ty1BFz4I9slGnSgWhlT0ktyUzbnxI7wEocNvxKoKSumXQ+bfpxcPze
 v87jxLq4RdCAPp4aHLsSdvjMCd7XAV+4tM5Kg1DBLF6GTSaDklbrjiNkqLBB9BAZM2PH
 579k+CTpv8zmRpOfdxHXWuiSoOJVAEserndmaV5ZGmmdWqrJjplpptYaqAYUMKbIKB43
 ShPIMiqe6lb4FZMrP0zBxzz0ZDg+0NvsmTv5Bcyhkm5wCXDm2UzGMN+OlyuWqrxICcqk
 WN1g==
X-Gm-Message-State: AO0yUKVHR2Irz86M4Da6EQN+1Rn/ilzlout+kkhRMCTB3IKDWXRzEhAn
 1lITH2TaE26guWrgyzRf4w==
X-Google-Smtp-Source: AK7set9601+lZfdRKUYYCBRMTwLOVYX2yvSrbnz2bq0mPc1TzOtFb9H1UwkWRwCJIfb6R0yRHi8xiw==
X-Received: by 2002:a7b:c7c6:0:b0:3ed:c84c:7efe with SMTP id
 z6-20020a7bc7c6000000b003edc84c7efemr2825556wmk.7.1679583425467; 
 Thu, 23 Mar 2023 07:57:05 -0700 (PDT)
Received: from localhost (131.red-81-44-151.dynamicip.rima-tde.net.
 [81.44.151.131]) by smtp.gmail.com with ESMTPSA id
 23-20020a05600c229700b003ee53e3e98asm2035690wmf.47.2023.03.23.07.57.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 23 Mar 2023 07:57:05 -0700 (PDT)
Message-ID: <f0d79ba3-6cfc-934e-6bf0-2148c975eb8b@gmail.com>
Date: Thu, 23 Mar 2023 15:57:04 +0100
MIME-Version: 1.0
To: Martin Wilck <mwilck@suse.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20230320155550.7326-1-mwilck@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20230320155550.7326-1-mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH] multipath-tools Makefiles: handle dependency
 files correctly
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/20/23 16:55, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Some generated .d files were not correctly included, and not
> removed with "make dep_clean". Fix it.
> 
> Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

> ---
>   libmultipath/Makefile | 4 ++--
>   multipathd/Makefile   | 4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/Makefile b/libmultipath/Makefile
> index 61aa611..85767ab 100644
> --- a/libmultipath/Makefile
> +++ b/libmultipath/Makefile
> @@ -71,7 +71,7 @@ uninstall:
>   clean: dep_clean
>   	$(Q)$(RM) core *.a *.o *.so *.so.* *.abi nvme-ioctl.c nvme-ioctl.h autoconfig.h $(NV_VERSION_SCRIPT)
>   
> -include $(wildcard $(OBJS:.o=.d))
> +include $(wildcard $(OBJS:.o=.d) $(OBJS-T:.o=.d))
>   
>   dep_clean:
> -	$(Q)$(RM) $(OBJS:.o=.d)
> +	$(Q)$(RM) $(OBJS:.o=.d) $(OBJS-T:.o=.d)
> diff --git a/multipathd/Makefile b/multipathd/Makefile
> index 9d53132..dca8e10 100644
> --- a/multipathd/Makefile
> +++ b/multipathd/Makefile
> @@ -81,7 +81,7 @@ uninstall:
>   clean: dep_clean
>   	$(Q)$(RM) core *.o $(EXEC) $(CLI)
>   
> -include $(wildcard $(OBJS:.o=.d))
> +include $(wildcard $(OBJS:.o=.d) $(CLI_OBJS:.o=.d))
>   
>   dep_clean:
> -	$(Q)$(RM) $(OBJS:.o=.d)
> +	$(Q)$(RM) $(OBJS:.o=.d) $(CLI_OBJS:.o=.d)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

