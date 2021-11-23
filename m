Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92255C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 03:59:54 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-yijlhr4WPXCAXu3_cgTWMg-1; Mon, 22 Nov 2021 22:59:50 -0500
X-MC-Unique: yijlhr4WPXCAXu3_cgTWMg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 83AA0806688;
	Tue, 23 Nov 2021 03:59:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6060629403;
	Tue, 23 Nov 2021 03:59:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 771B51832E7F;
	Tue, 23 Nov 2021 03:59:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AN3xhnl013406 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Nov 2021 22:59:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2F8872166B26; Tue, 23 Nov 2021 03:59:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A2872166B25
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 03:59:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6052D8007B1
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 03:59:40 +0000 (UTC)
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com
	[209.85.215.179]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-188-PyDQ_3PuMP2XAedSSoyu3A-1; Mon, 22 Nov 2021 22:59:37 -0500
X-MC-Unique: PyDQ_3PuMP2XAedSSoyu3A-1
Received: by mail-pg1-f179.google.com with SMTP id g28so17096778pgg.3
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 19:59:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=g/ky7DkMfynxz93Jg1Thyokk1eZpzUf1Xl2rDhRoyWA=;
	b=mvIrKWd5LycRdPqpRqDYpuYtYd87ED7povYaVIpPNRv3gZEqYWF8kMK4hXGNw+eaUW
	OnvYq894rC3ByjtPzKxlKOreZwYMhHVirVgZ4WWslpnSFh06pg7C78cS5NCqUQoBgLg7
	Yk+BFoca71sbOaOQTJhJYLKtG5eVI/jEoHTIHUafn0dzdzMyAy8bc9t6cz+xciqW+W5O
	SNMydAt4UwwagfPCjISM+dCiSyaLVr2TocU1vbz0+Ej3axHxVs7PA9gUeN8AXlh3iR23
	vuwlOcMI4P5SxYucpbrfled8GvD2Ck6Gr+0C1nf15O58v9xAcEZ9LuAXkU+2sqC1H2mu
	/JtQ==
X-Gm-Message-State: AOAM533nqfB+MW1huK5Ea3tUTKV1LC4GOI6cNCLpGEXHD/Y1TjuSVovT
	SW77KIhJjvvQSNBOgjmyBMDjZxH9aY+yAI6+aYWvWg==
X-Google-Smtp-Source: ABdhPJwGHnABHnUK3lJPgD02NSEK0H2EfeyLizUEIRr93I6wp+H8p3N47d3IhUfBHGyYAjrqraEpCA3HamH0r9lHbyI=
X-Received: by 2002:a63:85c6:: with SMTP id u189mr1546658pgd.377.1637639976375;
	Mon, 22 Nov 2021 19:59:36 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-10-hch@lst.de>
In-Reply-To: <20211109083309.584081-10-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Nov 2021 19:59:25 -0800
Message-ID: <CAPcyv4igxMdMA0XpjZt0aXahef5Worvz663ynd5i4=HeKJAqKw@mail.gmail.com>
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
Subject: Re: [dm-devel] [PATCH 09/29] dm-linear: add a linear_dax_pgoff
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Add a helper to perform the entire remapping for DAX accesses.  This
> helper open codes bdev_dax_pgoff given that the alignment checks have
> already been done by the submitting file system and don't need to be
> repeated.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Mike Snitzer <snitzer@redhat.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

