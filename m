Return-Path: <SRS0=mcEr=MU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC808C4338F
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 08:45:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5F08560F9D
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 08:45:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5F08560F9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-PaxsbRmuO1CJCrewERu__w-1; Wed, 28 Jul 2021 04:45:02 -0400
X-MC-Unique: PaxsbRmuO1CJCrewERu__w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D317801B3C;
	Wed, 28 Jul 2021 08:44:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A515910016F7;
	Wed, 28 Jul 2021 08:44:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E8CC04BB7C;
	Wed, 28 Jul 2021 08:44:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16S8bqLY016253 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Jul 2021 04:37:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BD0FA1013289; Wed, 28 Jul 2021 08:37:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B5E3E1014605
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 08:37:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A25F800882
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 08:37:50 +0000 (UTC)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
	[209.85.128.50]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-316-2aoJTXnVNXCNCwpaktNWXg-1; Wed, 28 Jul 2021 04:37:44 -0400
X-MC-Unique: 2aoJTXnVNXCNCwpaktNWXg-1
Received: by mail-wm1-f50.google.com with SMTP id n11so866305wmd.2;
	Wed, 28 Jul 2021 01:37:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:user-agent:mime-version:in-reply-to:content-language
	:content-transfer-encoding;
	bh=A1L2Jchg5OdnAOILbniN0YQs16Gjlig7fJyJCi+ceF0=;
	b=fWYftWSyi/oMz+YER1QuYNCVZA1n8XW05x8QW75NgQD7hKPNhaeyJUXshZG1UpUrkj
	+0Ysoqpkq+Vf2NF+znIYA/C5LbY3DFtScX7zHtzBSVaY5cJanwreId5iGEev+HylSTw1
	zXOD22+g4PXB2UJDV5Ofo0QVVV7eaPZ+YZ6GPTKp05gbhl2i/2SmhOgAl51YeJexY8A3
	FtkWaRWqzPyyLRBX9ljb21dFtZz3XCVst4FTpUq+2D6lMUKC93nD1+BBIm/8yVF8kNb6
	cSNc7Tl1lT6vSUTIBeiWX+tCbFPYZgsyeYOOcMoTfE0dQsC85KeP8F0dtdO6PICy2OR3
	iisw==
X-Gm-Message-State: AOAM532wUJXUfoOkmhoYxH+MdP9CqwTg78IVGDlR3s1efeoBIaswM0c7
	sjsEpCr8oP/GORiwmViG9DK8A36mpig=
X-Google-Smtp-Source: ABdhPJzAA5mCJ7kdYgSW/P7puft4HReSjV75uDDD8Jty59N9zXYfieg1muOkeW/1Jok3hSGNcwimwA==
X-Received: by 2002:a1c:a510:: with SMTP id o16mr8127946wme.162.1627461463178; 
	Wed, 28 Jul 2021 01:37:43 -0700 (PDT)
Received: from [172.22.36.87] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
	by smtp.gmail.com with ESMTPSA id h8sm4845588wmb.35.2021.07.28.01.37.42
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 28 Jul 2021 01:37:42 -0700 (PDT)
To: Christoph Hellwig <hch@lst.de>
References: <20210725055458.29008-1-hch@lst.de> <YQAtNkd8T1w/cSLc@redhat.com>
	<20210727160226.GA17989@lst.de> <YQAxyjrGJpl7UkNG@redhat.com>
	<9c719e1d-f8da-f1f3-57a9-3802aa1312d4@gmail.com>
	<20210728070655.GA5086@lst.de>
From: Milan Broz <gmazyland@gmail.com>
Message-ID: <9e668239-78cc-55ad-8998-b7e39f573c34@gmail.com>
Date: Wed, 28 Jul 2021 10:37:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728070655.GA5086@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] use regular gendisk registration in device mapper
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 28/07/2021 09:06, Christoph Hellwig wrote:
> On Tue, Jul 27, 2021 at 10:38:16PM +0200, Milan Broz wrote:
>> BTW it would be also nice to run cryptsetup testsuite as root - we do a lot
>> of DM operations there (and we depend on sysfs on some places).
> 
> It already doesn't seem very happy in current mainline for me:
> 
> =======================
> 13 of 17 tests failed
> (12 tests were not run)
> =======================
> 
> but this series doesn't seem to change anything.
> 
> A lot of the not run tests seem to be due to broken assumptions
> that some code must be modular.  E.g. my kernel has scsi_debug built
> in, but it complains like this:
> 
> modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/module'
> modprobe: FATAL: Module scsi_debug not found in directory /lib/modules/5.14.0-rc3+

Hi,

there should not be many assumptions, but yes, we depend on modular scsi_debug in some tests because we simulate
very specific hw attributes. So you have one emulated device compiled-in?

Or there is another way how to configure scsi_debug if compiled-in? (we use module parameters, I think it is
the same was how util-linux testsute works with scsi_debug).

Anyway, this is a bug, tests should be skipped (the same way if scsi_debug is not available).

I forgot to say - there is a list of packages that should be installed for make check mentioned
in README.md - I guess this was the reason some other tests were skipped.

(BTW could you send me output of the failed test run? I run it over Linus' tree and ti works so it is perhaps another
assumption that should be fixed.)

Thanks,
Milan

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

