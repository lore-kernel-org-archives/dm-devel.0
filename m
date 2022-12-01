Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78943C43217
	for <dm-devel@archiver.kernel.org>; Thu,  1 Dec 2022 16:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669911197;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8UUvjRRvvxQS7Vz+vWRaTkc/2kLVtDWFjZbUxZKBpi8=;
	b=c3Dj1tSFewo2/zSBi58Yw3+x6N1dRztpnCZvGlsT/v/ku4+KJUvU5ge4Zb6eoD4M7xZdsn
	K5FMrfq0Bghku7kpMySbzM80zHOMeHLqYNsmQe4x7Ir8EtHCBWDFQ9L3iuxD6LJQjuRY0D
	bHmU8vpR/8QWpiz+gtqNXmTxho8ak4A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-e-6PmcrCOaatC6y0BQJyGw-1; Thu, 01 Dec 2022 11:13:16 -0500
X-MC-Unique: e-6PmcrCOaatC6y0BQJyGw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA60E293248F;
	Thu,  1 Dec 2022 16:13:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A4533C15BB4;
	Thu,  1 Dec 2022 16:13:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 81AA819465A8;
	Thu,  1 Dec 2022 16:13:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5D71019465A0
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Dec 2022 16:13:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 192E86352D; Thu,  1 Dec 2022 16:13:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 118684EA4D
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 16:13:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4CD5811E7A
 for <dm-devel@redhat.com>; Thu,  1 Dec 2022 16:13:07 +0000 (UTC)
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-336-ReUmm9zEPImwSeVFgau7og-1; Thu, 01 Dec 2022 11:13:06 -0500
X-MC-Unique: ReUmm9zEPImwSeVFgau7og-1
Received: by mail-qt1-f198.google.com with SMTP id
 cj6-20020a05622a258600b003a519d02f59so5192385qtb.5
 for <dm-devel@redhat.com>; Thu, 01 Dec 2022 08:13:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=7NtmBt2XLW56n9Pizpkytb9HHu4eAhTVDM8oBjT5kVc=;
 b=f0bX8jjj/Dnjuw9GI6jx3jLH37E+GPHfKQlpS9ciIqj2v3GnhLRQ8vIces+e7DFuLc
 1jImt8B78YH5NhArHjZkkdwY9MCr+C9LRHYXmvqaGiPYkBGY6WJQ+KZLJyih503KExVQ
 2FbYFAXvfqsy496YWwGNlT+ZnITOyUhlsixmVwrFhubX6EsJBe3vQofJRy9Rq4xu9lRd
 UvJqt45W6eSvuDLWKaxbQ9YVGWIBh/e9zXm9O7A+lLMbR8kS8Prtt/BdcooV/5ViuhQE
 OU2AvyWOd5NuS8ZoT2ywcheeTLuszoASAoZnIBS4aK1kUUV8yDk8ZiW7hbQpJRNo7bfn
 H8ew==
X-Gm-Message-State: ANoB5pm36Z3k2+9vyeKfLJet+rg1jBp05I4s37Q5HgqAdG8m8+zt6wau
 X9go5SHc7wKIuVWmg7rnj9PszBkwvgSk+CFTNdtOsAa5aAKEmMXSb6PCcpJLpufmyJMW71Cl5Mx
 rjZgbYnU8EBetwA==
X-Received: by 2002:a37:bc01:0:b0:6fb:c812:4b24 with SMTP id
 m1-20020a37bc01000000b006fbc8124b24mr59694443qkf.356.1669911186145; 
 Thu, 01 Dec 2022 08:13:06 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6eMD9BYIV2I/k8iJJlmFZ7hixbetMHEXw+d1Ao/Rlk/DPSHuwrtZdHZL98Z1V8r7SdQg1v0Q==
X-Received: by 2002:a37:bc01:0:b0:6fb:c812:4b24 with SMTP id
 m1-20020a37bc01000000b006fbc8124b24mr59694420qkf.356.1669911185888; 
 Thu, 01 Dec 2022 08:13:05 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 f10-20020a05620a280a00b006a6ebde4799sm3514206qkp.90.2022.12.01.08.13.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 01 Dec 2022 08:13:05 -0800 (PST)
Date: Thu, 1 Dec 2022 11:13:04 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Peter Korsgaard <peter@korsgaard.com>
Message-ID: <Y4jSkNJzTtRZSbrg@redhat.com>
References: <20221116061656.2345538-1-peter@korsgaard.com>
 <877czkhc7u.fsf@dell.be.48ers.dk> <Y4fiQvg9OOATD5Cv@redhat.com>
 <87bkond1mi.fsf@dell.be.48ers.dk>
MIME-Version: 1.0
In-Reply-To: <87bkond1mi.fsf@dell.be.48ers.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2] dm init: add dm-mod.waitfor to wait for
 asynchronously probed block devices
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
Cc: Jonathan Corbet <corbet@lwn.net>, Mike Snitzer <snitzer@kernel.org>,
 Helen Koike <helen.koike@collabora.com>, fabio.aiuto@amarulasolutions.com,
 dm-devel@redhat.com, michael@amarulasolutions.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 01 2022 at  2:28P -0500,
Peter Korsgaard <peter@korsgaard.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Hi,
> 
>  > On Thu, Nov 24 2022 at  5:35P -0500,
>  > Peter Korsgaard <peter@korsgaard.com> wrote:
> 
>  >> > +	if (waitfor[0])
>  >> > +		DMINFO("all devices available");
>  >> > +
> 
>  > Why 20?  Also, why is waiting indefinitely OK?  Would really like to
>  > hear from other consumers of dm-init that this module param is useful
>  > and needed.
> 
> Mainly because of checkpatch.pl ;) prepare_namespace() uses msleep(5)
> but checkpatch complains about it, so I made it 20 instead. It doesn't
> really matter much, as long as it is small enough to not delay boots too
> much (E.G. this is typically used for embedded system where boot time is
> critical).
> 
> I would say that it DOES make sense to wait forever, similar to how it
> is done in prepare_namespace() when rootwait is passed. This waitfor
> bootargs is used for root-on-dm, so we cannot continue until the
> underlying devices are available.
> 
> As mentioned,
> https://lore.kernel.org/all/20220406154631.277107-1-fabio.aiuto@amarulasolutions.com/
> is an alternatively (less nice) approach to solve the same issue, so yes
> - It is useful and needed.

OK, so it should be easy for others to say so, right?

My hesitation is that it feels like something that could be papering
over device specific issues with their async initialization?  Even if
that is the case, it'd be nice to know _why_ this change is needed.
IMHO, the patch header stops short of offering compelling and informed
justification.

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

