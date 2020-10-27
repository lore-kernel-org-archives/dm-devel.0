Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F5EC55178
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 11:49:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 64A65207C3
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 11:49:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64A65207C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-ZGQdMHoqOE6wnjNaM-DEVA-1; Tue, 27 Oct 2020 07:49:51 -0400
X-MC-Unique: ZGQdMHoqOE6wnjNaM-DEVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F2F6803F5E;
	Tue, 27 Oct 2020 11:49:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E5B71002388;
	Tue, 27 Oct 2020 11:49:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5C5D8CF41;
	Tue, 27 Oct 2020 11:49:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09RBfjmD010782 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 27 Oct 2020 07:41:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D3C6B2157F24; Tue, 27 Oct 2020 11:41:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF10E2166B44
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 11:41:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 76A0D811E79
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 11:41:43 +0000 (UTC)
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com
	[209.85.128.68]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-156-5-uT-CGxNVK7aG46xB0nrg-1; Tue, 27 Oct 2020 07:41:39 -0400
X-MC-Unique: 5-uT-CGxNVK7aG46xB0nrg-1
Received: by mail-wm1-f68.google.com with SMTP id k21so896533wmi.1;
	Tue, 27 Oct 2020 04:41:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=/ope9nTMHg6/q+yBglGeHzv+UvnGM+wEwl2DLYiPOxM=;
	b=mfazVfyG9fs+1i143lcf1R6ubkOMDdJcPbQfi6p3YXMj9Cn0NGn0WzXLZ7w0jbhPPF
	rJxWGjI1F2czKEI4DVH2SDz+tPagBA3rcfhCfbJOQVfQbQQmuC2B8kEgN4hBXTMHPg8N
	nhv2qPyzMgqnqhOhYDrxas0KFXZGhltblb9QsakTJoIYFytkgMUIb48bFEzELSXZfDQE
	pyo5gvFhfUf4du1k96Qe0Ma0LBP64HbRBYxPP97swTE3VdoyI1sUhMiRc7b5d33srZfj
	9Gm9EP0P8zIHHomtVrqUnCbFVTdxk/8Zr0MZv2IdtGsA84uZ4sLK5F24GmejW7v++Fjr
	p35Q==
X-Gm-Message-State: AOAM533cB9El/8arJqHxjMJ+bssivP5A1sZ5DCeHCGmbarfBgCH/OIkK
	EOS9BCYbi0WaGE2Pm8srPcQvURZW/Q==
X-Google-Smtp-Source: ABdhPJxRR602OPbT2w0wh9FuMlx8iUOgd89Rd5ROjVvLM0dRcKsHTu5onSTiuPzB1PcM6bubUP3/hA==
X-Received: by 2002:a1c:e154:: with SMTP id y81mr2318945wmg.111.1603798897386; 
	Tue, 27 Oct 2020 04:41:37 -0700 (PDT)
Received: from localhost (174.red-176-87-1.dynamicip.rima-tde.net.
	[176.87.1.174])
	by smtp.gmail.com with ESMTPSA id x21sm1564705wmi.3.2020.10.27.04.41.36
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Tue, 27 Oct 2020 04:41:37 -0700 (PDT)
To: mwilck@suse.com, Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
References: <20200812113232.25962-1-mwilck@suse.com>
	<20200812113232.25962-2-mwilck@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <0c9cb804-17ed-48b1-c550-60f36ee98485@gmail.com>
Date: Tue, 27 Oct 2020 12:41:35 +0100
MIME-Version: 1.0
In-Reply-To: <20200812113232.25962-2-mwilck@suse.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 08/35] libmultipath: create bitfield
 abstraction
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 8/12/20 1:32 PM, mwilck@suse.com wrote:

> From: Martin Wilck <mwilck@suse.com>
> 
> In e32d521d ("libmultipath: coalesce_paths: fix size mismatch handling"),
> we introduced simple bitmap handling functions. We can do better. This
> patch introduces a bitfield type with overflow detection and a
> find_first_set() method.
> 
> Use this in coalesce_paths(), and adapt the unit tests. Also, add
> unit tests for "odd" bitfield sizes; so far we tested only multiples
> of 64.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   libmultipath/configure.c |   9 +-
>   libmultipath/util.c      |  22 ++++
>   libmultipath/util.h      |  56 +++++++++-
>   tests/util.c             | 231 ++++++++++++++++++++++++++++++++++-----
>   4 files changed, 281 insertions(+), 37 deletions(-)
> [...]
> diff --git a/libmultipath/util.h b/libmultipath/util.h
> index df75c4f..7ed30c7 100644
> --- a/libmultipath/util.h
> +++ b/libmultipath/util.h
> [...]
> -static inline bool is_bit_set_in_array(unsigned int bit, const uint64_t *arr)
> +/*
> + * ffsll() is also available on glibc < 2.27 if _GNU_SOURCE is defined.
> + * But relying on that would require that every program using this header file
> + * set _GNU_SOURCE during compilation, because otherwise the library and the
> + * program would use different types for bitfield_t, causing errors.
> + * That's too error prone, so if in doubt, use ffs().
> + */
> +#if __GLIBC_PREREQ(2, 27)
> +typedef unsigned long long int bitfield_t;
> +#define _ffs(x) ffsll(x)
> +#else
> +typedef unsigned int bitfield_t;
> +#define _ffs(x) ffs(x)
> +#endif
> [...]

musl-libc shows a warning(missing binary operator):

make[1]: Entering directory 'multipath-tools/libmultipath'
[...]
musl-gcc --std=gnu99  -O2 -g -fstack-protector-strong --param=ssp-buffer-size=4 -Werror -Wall -Wextra -Wformat=2 -Werror=implicit-int -Werror=implicit-function-declaration -Werror=format-security 
-Wno-clobbered -Wno-error=clobbered -Werror=cast-qual -Werror=discarded-qualifiers -pipe -DBIN_DIR=\"/sbin\" -DLIB_STRING=\"lib64\" -DRUN_DIR=\"run\" -MMD -MP -fPIC -I../libmpathcmd 
-I../libmpathpersist -I../libmultipath/nvme -DUSE_SYSTEMD=246 -DLIBDM_API_FLUSH -D_GNU_SOURCE -DLIBDM_API_COOKIE -DLIBUDEV_API_RECVBUF -DLIBDM_API_DEFERRED -DLIBDM_API_HOLD_CONTROL 
-Wp,-D_FORTIFY_SOURCE=2  -c -o devmapper.o devmapper.c
In file included from devmapper.c:19:
util.h:65:19: error: missing binary operator before token "("
    65 | #if __GLIBC_PREREQ(2, 27)
       |                   ^
make[1]: *** [../Makefile.inc:138: devmapper.o] Error 1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

