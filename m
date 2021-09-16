Return-Path: <SRS0=t70f=OG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MALFORMED_FREEMAIL,MISSING_HEADERS,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B6FC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 09:47:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E06FC60F6C
	for <dm-devel@archiver.kernel.org>; Thu, 16 Sep 2021 09:47:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E06FC60F6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-E39CkIVbPnWt_a5xWEFd5A-1; Thu, 16 Sep 2021 05:47:34 -0400
X-MC-Unique: E39CkIVbPnWt_a5xWEFd5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29DCC1084684;
	Thu, 16 Sep 2021 09:47:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB4405C25A;
	Thu, 16 Sep 2021 09:47:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 85A671800FE4;
	Thu, 16 Sep 2021 09:47:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18G9lRM7030147 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 16 Sep 2021 05:47:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C5228FC74B; Thu, 16 Sep 2021 09:47:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFE62FC758
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 09:47:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49CDC18A01A9
	for <dm-devel@redhat.com>; Thu, 16 Sep 2021 09:47:24 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
	[209.85.221.51]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-283-H7rmWj8jNMOnqfP41Dc06w-1; Thu, 16 Sep 2021 05:47:20 -0400
X-MC-Unique: H7rmWj8jNMOnqfP41Dc06w-1
Received: by mail-wr1-f51.google.com with SMTP id d6so8410558wrc.11;
	Thu, 16 Sep 2021 02:47:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:subject
	:content-language:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=OWAf1GkSUF//cYSq3dGZ3c+Pd+5EKaIPUPaGbByoWes=;
	b=f2TvT6XephagmobMKN6ldBwebLRBJLL6JfGXiN0u2SRqQiZ/B4Re/TWGbv/S0uUNHB
	RO8vPF6b+AP8AanOT4Xm/6PpEl008TjtOf6nCQcph45TxVg7HEU1q9lHSlbY1aL3H2xY
	Ho9K5IZhPCFBmIggqkDoF3gqVbgS8tNwxTpDuQytEV1G9LpoGY2OpdjBhnUDnnXV5FdM
	f0H2fAQYnjEBlJO9y2L/ma5+Y5FR/O5OuCKT4XAh4gNwC0OQZvn8kkl8HnSODYXz2uQ2
	yMnGL2/lM1sXJFIHmHGq7flpZjNIoSYk7yufpIJO56xthLfaaJC8vDUIVyDVEcEfUIzQ
	zBtA==
X-Gm-Message-State: AOAM531gn9SaY90jbckXLUkmOA6EzgBfhwKe+hyr2m5M9N5+NVniTwf1
	j6YyKsqcTS8zP9ASbpyeV5TarxoT9Q==
X-Google-Smtp-Source: ABdhPJwOjLHI4rb7h/utODvnRwGbX8frIlHNjm4MyHADZ1TMOn3UMwMB4hXl2s6V0mCwkvntnpAl1Q==
X-Received: by 2002:a05:6000:1562:: with SMTP id
	2mr2284317wrz.36.1631785639185; 
	Thu, 16 Sep 2021 02:47:19 -0700 (PDT)
Received: from localhost (227.red-83-37-137.dynamicip.rima-tde.net.
	[83.37.137.227]) by smtp.gmail.com with ESMTPSA id
	d17sm2727455wrp.57.2021.09.16.02.47.18
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Thu, 16 Sep 2021 02:47:18 -0700 (PDT)
Message-ID: <02deedd8-c188-9bc7-9677-2440c4340da9@gmail.com>
Date: Thu, 16 Sep 2021 11:47:17 +0200
MIME-Version: 1.0
References: <20210915234105.17955-1-xose.vazquez@gmail.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20210915234105.17955-1-xose.vazquez@gmail.com>
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
Cc: Martin Wilck <mwilck@suse.com>, DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: fix emc info from
	multipath.conf.5
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 2
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 9/16/21 01:41, Xose Vazquez Perez wrote:

> Add PNR info and remove "Unity" from emc prio, path_checker and hardware_handler.
> Unity series does not support PNR mode, just ALUA.
> 113 and 153: https://www.delltechnologies.com/asset/en-us/products/storage/technical-support/docu5128.pdf

DROP this one, path_checker should be emc.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

