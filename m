Return-Path: <SRS0=tK5J=PU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F4FC433F5
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 16:19:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 823C9610E5
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 16:19:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 823C9610E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635783547;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sF0qge2XmSd3Wj8O3q+7HMAXSF4jm2Ns4jA9NtPzEFI=;
	b=YAF47pJMRV+MfZzeiV+af7F9Wb5d23jXuvJpBTn364hbNTGFsQBV7BR4dTkQYySHvd6tUX
	uSZqavfFE8VX+3FRLR6l5KHzFDsvBKoOJeV5JXm0K5K34G0YERP/m5pbvnmAYdFzDCSZso
	DdWrYpdDV47z6n84oPnTZSRjkFiE5VE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-xOlAzEPjO_WXEYZF8xR6rA-1; Mon, 01 Nov 2021 12:19:06 -0400
X-MC-Unique: xOlAzEPjO_WXEYZF8xR6rA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A5FA5074C;
	Mon,  1 Nov 2021 16:19:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B42D101E7F4;
	Mon,  1 Nov 2021 16:19:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E41FD1806D03;
	Mon,  1 Nov 2021 16:19:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A1GIwJc003328 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Nov 2021 12:18:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CC4302026D64; Mon,  1 Nov 2021 16:18:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C7CE82026D67
	for <dm-devel@redhat.com>; Mon,  1 Nov 2021 16:18:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B30C18A016A
	for <dm-devel@redhat.com>; Mon,  1 Nov 2021 16:18:53 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
	[209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-517-00QeLlyPOO2a-vZIyYtJ7g-1; Mon, 01 Nov 2021 12:18:52 -0400
X-MC-Unique: 00QeLlyPOO2a-vZIyYtJ7g-1
Received: by mail-qv1-f72.google.com with SMTP id
	kc11-20020a056214410b00b003886a263a48so13488965qvb.12
	for <dm-devel@redhat.com>; Mon, 01 Nov 2021 09:18:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=+PlMFyDlSdyotYZmkf9Kx/3zxEQEZ+hPS+mrYwQmhsg=;
	b=5Bt9CHBEo09DXEzakQM1IddOuJOtCeXRP+X5ALm0ARHUXbcLlXfy6AF0658ouNUkPw
	cPgP+7mTkRJIPK0P1rkJv09cmBn7us91LARmoV0M7s6QOVXLrj7cpaZCYaJ18snyn+hI
	Pz+ZTuCttp3DAzb4YmgKhlKB9PIQWOYsgwFoqeCJGz/VBo1RJXTnNnjCP5gvQi6rVdxj
	UQOep0KM0V3rYQIpOMCVk8S0bQUEeEBqhKAJaP9y9hSvd916P3ImVf7Skkm5LzUYPEDF
	jojjmmvsakYeluPoQBsxA5cEC7ZJrsc0S089CeoPPexxqecMy2ntZfkGUoRDXLyeonNi
	LmvA==
X-Gm-Message-State: AOAM532qFF7zy/lukPK8MPjZYCdwlfnm4klhBrx7BuGMF231RnUSNi0p
	PplMf4PiQeJyZuYhsOuWAJsNV1QVlfjLP+GSdjmI+YWzf7qZ6VlnHyOBJXTSeakRqXvse1QlaVB
	Vso9vnkRf7Kj5Ag==
X-Received: by 2002:ac8:183:: with SMTP id x3mr31456929qtf.270.1635783531653; 
	Mon, 01 Nov 2021 09:18:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx06c4hivJwjfQA8DeAKPNXipJ/hNPI/8Dli7abowyJqKsKBWURc5Mk5ISYlLWlJ3N1kL0ucw==
X-Received: by 2002:ac8:183:: with SMTP id x3mr31456902qtf.270.1635783531462; 
	Mon, 01 Nov 2021 09:18:51 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	q20sm10701041qkl.53.2021.11.01.09.18.50
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 01 Nov 2021 09:18:51 -0700 (PDT)
Date: Mon, 1 Nov 2021 12:18:50 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <YYATamEnd6imRSxt@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
	<20211018044054.1779424-9-hch@lst.de>
	<CAPcyv4iK-Op9Nxoq91YLv0aRj6PkGF64UY0Z_kfovF0cpuJ_JQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iK-Op9Nxoq91YLv0aRj6PkGF64UY0Z_kfovF0cpuJ_JQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 08/11] dm-linear: add a linear_dax_pgoff
	helper
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 27 2021 at  9:32P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Add a helper to perform the entire remapping for DAX accesses.  This
> > helper open codes bdev_dax_pgoff given that the alignment checks have
> > already been done by the submitting file system and don't need to be
> > repeated.
> 
> Looks good.
> 
> Mike, ack?

Acked-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

