Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5811C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 17:44:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4C758613A1
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 17:44:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4C758613A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-ItU5EbiHNNy-MYl0LZI8mg-1; Wed, 17 Nov 2021 12:44:52 -0500
X-MC-Unique: ItU5EbiHNNy-MYl0LZI8mg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A656C19057A2;
	Wed, 17 Nov 2021 17:44:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E5C01017CF2;
	Wed, 17 Nov 2021 17:44:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 660F64E58F;
	Wed, 17 Nov 2021 17:44:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHHijI5002787 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 12:44:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E9DD52166B3F; Wed, 17 Nov 2021 17:44:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E4BC92166B2D
	for <dm-devel@redhat.com>; Wed, 17 Nov 2021 17:44:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC6421066684
	for <dm-devel@redhat.com>; Wed, 17 Nov 2021 17:44:41 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
	[209.85.210.171]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-512-e0RMj5mYPQ-VwiFvbZlw2g-1; Wed, 17 Nov 2021 12:44:39 -0500
X-MC-Unique: e0RMj5mYPQ-VwiFvbZlw2g-1
Received: by mail-pf1-f171.google.com with SMTP id g18so3356779pfk.5
	for <dm-devel@redhat.com>; Wed, 17 Nov 2021 09:44:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=+uFdsysPKBJg8+GUKCjjrR+fu42d0RKVIlJ5p5O3Gqw=;
	b=fe+yzZvXhWUYT43yOb7B4sQQ9UqZMkYTJR4ukrTeIcaXH8NZ9liCY+neLPHPVZD3Sq
	xsJfbSw50Up7vbRfkz36XbL9CsoIRTvs3asdSh5ODasv4R5IyV9Q8Eo6yXFQ+LycSsT+
	CuWaYOTiIDiZ+xR+yeTUKEKNFQJconTEkkXDt6YfkvhZUtWBiFK1wrOA4siBeiztM8xB
	K6YOkwmHyDVXkwLPRSoTuugCfjINvsil55GG/zEoB4ZJO9gDjGozWD9/3OLWGMoxUweD
	Jgyihi22JRRS+vPCAnzWZ3tICqDHer2yxq+uPjptKj3LByxOVvEa+DkBdx9xrBrq7dH1
	ju1Q==
X-Gm-Message-State: AOAM530DUwt0OEQEsPfvZ5fhTFxdM1UHHP9EGxHFQFh6gROrBTpTvqjN
	vV85/PRKbX90kYzhYuYO2r5rJ6nAAplFBlwNbGy42g==
X-Google-Smtp-Source: ABdhPJxiiB8Ak1RjXFinVMdC+8Tb3rrtEkfJ8k6NlxRhm42dcgWCdDR0kkUYUFwrF8G9DBBrfo1Xmvo4+uUGPt+QmE4=
X-Received: by 2002:aa7:8d0a:0:b0:4a2:82d7:1695 with SMTP id
	j10-20020aa78d0a000000b004a282d71695mr37260918pfe.86.1637171078758;
	Wed, 17 Nov 2021 09:44:38 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-2-hch@lst.de>
In-Reply-To: <20211109083309.584081-2-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Nov 2021 09:44:25 -0800
Message-ID: <CAPcyv4ijKTcABMs2tZEuPWo1WDOux+4XWN=DNF5v8SrQRSbfDg@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 01/29] nvdimm/pmem: move dax_attribute_group
	from dax to pmem
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> dax_attribute_group is only used by the pmem driver, and can avoid the
> completely pointless lookup by the disk name if moved there.  This
> leaves just a single caller of dax_get_by_host, so move dax_get_by_host
> into the same ifdef block as that caller.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Link: https://lore.kernel.org/r/20210922173431.2454024-3-hch@lst.de
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

This one already made v5.16-rc1.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

