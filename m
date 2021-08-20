Return-Path: <SRS0=Iac5=NL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0457AC4338F
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 16:07:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8765561213
	for <dm-devel@archiver.kernel.org>; Fri, 20 Aug 2021 16:07:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8765561213
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-fYVqgkUdNBmjKROFSMz_uA-1; Fri, 20 Aug 2021 12:07:54 -0400
X-MC-Unique: fYVqgkUdNBmjKROFSMz_uA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9BD1802936;
	Fri, 20 Aug 2021 16:07:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9806D1B5C0;
	Fri, 20 Aug 2021 16:07:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0BA7D4BB7C;
	Fri, 20 Aug 2021 16:07:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17KG7laI032417 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Aug 2021 12:07:47 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8F5FF107286; Fri, 20 Aug 2021 16:07:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8AE5F42ADC
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 16:07:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41F56801005
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 16:07:44 +0000 (UTC)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
	[209.85.210.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-300-N46eVVZrPLaqFsnn3cfQfg-1; Fri, 20 Aug 2021 12:07:42 -0400
X-MC-Unique: N46eVVZrPLaqFsnn3cfQfg-1
Received: by mail-pf1-f169.google.com with SMTP id w68so8991896pfd.0
	for <dm-devel@redhat.com>; Fri, 20 Aug 2021 09:07:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=epIvCzmEqd8lfEkp+zSX1z8FhC6G4rECGu8AkMD5cjk=;
	b=g59AF/YHImWYD5JF8wTUqGCH88JXfjh0p290w4tFZELWemfLEhovFkHIi2o7qodOBh
	WkraZkg6xWcWBZakv98lKhdusjDnr3i2OEkygSgIksPEjcq9I0sdvLqtLmURFrxZuRRY
	r6kLokoO4zvqQun0b1X5x5THS3NkbSnqrlB9rNsOZsMxv6vT1+85FmQuBwCi1977IMaO
	Cc6xrY1bKQmlNTJe9eaf0DvtCee8zbb9YnDJdHtVn115r5INm/Xu/zBwH27kHSrgAF6G
	KtxPjuFlS/VTraR8GSA1SORDaedm4lSgMYTvSErdfNO4JhnIypFkdhTFbDpNLx/qGPc3
	rPEA==
X-Gm-Message-State: AOAM530LJ80iOzQ7A5lBhewlzaBJsW6pcA5+/hvcgKHYi6JdLamHaFJm
	CnSOxjtXkryeOsmcIO4VFWGcHnIQL7p7/tT87xOKUA==
X-Google-Smtp-Source: ABdhPJxyfy7kK0en0qSo4G5Lluu8ZezasgOhs9PpGIhkynMyXLeeasrkdLx8NF/nNzuMhI/nhpOTrwat9vU59+Lgzvc=
X-Received: by 2002:a05:6a00:9a4:b0:3e2:f6d0:c926 with SMTP id
	u36-20020a056a0009a400b003e2f6d0c926mr13253034pfg.31.1629475661105;
	Fri, 20 Aug 2021 09:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
	<20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210730100158.3117319-2-ruansy.fnst@fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 09:07:30 -0700
Message-ID: <CAPcyv4h0p+zD5tsT8HDUpNq_ZDCqo249KsmPLX-U8ia146r2Tg@mail.gmail.com>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v6 1/9] pagemap: Introduce
	->memory_failure()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Jul 30, 2021 at 3:02 AM Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
>
> When memory-failure occurs, we call this function which is implemented
> by each kind of devices.  For the fsdax case, pmem device driver
> implements it.  Pmem device driver will find out the filesystem in which
> the corrupted page located in.  And finally call filesystem handler to
> deal with this error.
>
> The filesystem will try to recover the corrupted data if necessary.

This patch looks good to me, but I would fold it into the patch that
first populates ->memory_failure().

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

