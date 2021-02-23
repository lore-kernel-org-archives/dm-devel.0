Return-Path: <SRS0=Sgdu=HZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3974DC433DB
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 09:14:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 96AD264E4D
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 09:14:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96AD264E4D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-ydCoHbjMN72oEeqBoRA-lw-1; Tue, 23 Feb 2021 04:14:39 -0500
X-MC-Unique: ydCoHbjMN72oEeqBoRA-lw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66477107ACE6;
	Tue, 23 Feb 2021 09:14:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38E6A5D9D0;
	Tue, 23 Feb 2021 09:14:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9BE6A18095CB;
	Tue, 23 Feb 2021 09:14:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11N9EUMA022099 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 04:14:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 11D432026D13; Tue, 23 Feb 2021 09:14:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CBAC2026D36
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 09:14:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C479E9291A9
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 09:14:27 +0000 (UTC)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com
	[209.85.218.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-251-J9dKwRURNiitms5W3jb3vA-1; Tue, 23 Feb 2021 04:14:23 -0500
X-MC-Unique: J9dKwRURNiitms5W3jb3vA-1
Received: by mail-ej1-f41.google.com with SMTP id r17so7067642ejy.13;
	Tue, 23 Feb 2021 01:14:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=b5MtT/ZdRPwH3IHGkszx0Ejluf/ndHyk503G2Rm9ils=;
	b=EJ9AT7SiKLkdH7MF3E9hNTYcoynZPlWkH3Iw+ZBFhn7kenMA9zdAzOTBwVQFnkDPIi
	OyrkOM7lq772T8i3eYvvtAT5gD4J2XbRNpKAYs/wU7X3BNBzvy6vbkBs7tFM5TjPwi1+
	C2JBmlqn2B1evKDQNxhanVlOpd/HrBZvwgBybgvK/GheYdNj6GncaXbyNDynDqki90ub
	gSLVE52yHLAXS6QYLzMLHiHFn9mw5phV2GzqiRvW/2l0Noq5ounwYLa0pazgD3Tnu6pX
	K7NNZmNF5f5RYk1qKpVI72Z5vPvOJDqv0dCrrDMb0MPHKHeHoGFKB+Y/gsgpcQAZfV5B
	RwGg==
X-Gm-Message-State: AOAM530duu0K7AudfW7uN2u3XN8PHWLt8BkzUrrUv0/U0+QbtsPAyItM
	JK/PKjo7Bn2/RhXoOjIdkX0sDo0rzEgW5k6rSxc=
X-Google-Smtp-Source: ABdhPJz4R4ZgmznPz2GNNWvnywZAr4uBgUpJfEA7xJHHLpa6gxqaLqhgwSOdWYHkRTdp4nIUPMj6SIo3LCG1a0yXTfY=
X-Received: by 2002:a17:906:2a06:: with SMTP id
	j6mr23964456eje.164.1614071662110; 
	Tue, 23 Feb 2021 01:14:22 -0800 (PST)
MIME-Version: 1.0
References: <CGME20210219124555epcas5p1334e7c4d64ada5dc4a2ca0feb48c1d44@epcas5p1.samsung.com>
	<20210219124517.79359-1-selvakuma.s1@samsung.com>
	<20210221235248.GZ4626@dread.disaster.area>
In-Reply-To: <20210221235248.GZ4626@dread.disaster.area>
From: Selva Jove <selvajove@gmail.com>
Date: Tue, 23 Feb 2021 14:44:08 +0530
Message-ID: <CAHqX9vbG-cB0h25y4OhcdOEegn-_E=HwHJtkPFGaurEF9-KXPw@mail.gmail.com>
To: Dave Chinner <david@fromorbit.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, Damien Le Moal <damien.lemoal@wdc.com>, kch@kernel.org,
	SelvaKumar S <selvakuma.s1@samsung.com>, sagi@grimberg.me,
	snitzer@redhat.com, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, nj.shetty@samsung.com,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, joshi.k@samsung.com,
	javier.gonz@samsung.com, Keith Busch <kbusch@kernel.org>,
	joshiiitr@gmail.com, hch@lst.de
Subject: Re: [dm-devel] [RFC PATCH v5 0/4] add simple copy support
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Dave,

copy_file_range() is work under progress.  FALLOC_FL_UNSHARE of fallocate()
use case sounds interesting. I will try to address both of them in the
next series.

Adding SCSI_XCOPY() support is not in the scope of this patchset. However
blkdev_issue_copy() interface is made generic so that it is possible to extend
to cross device XCOPY in future.


Thanks,
Selva

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

