Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCB82C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 02:41:25 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530-tJs-u06kMHe2nGN7LYvjvg-1; Tue, 23 Nov 2021 21:41:21 -0500
X-MC-Unique: tJs-u06kMHe2nGN7LYvjvg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC5B381EE60;
	Wed, 24 Nov 2021 02:41:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F6331009962;
	Wed, 24 Nov 2021 02:41:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 142144BB7C;
	Wed, 24 Nov 2021 02:41:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AO2f10P016841 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 21:41:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4EEAE4047279; Wed, 24 Nov 2021 02:41:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AE5B4047272
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 02:41:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31396811E7A
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 02:41:01 +0000 (UTC)
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com
	[209.85.210.171]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-542-_UqH0PppPoy0Xn5dFIuk8A-1; Tue, 23 Nov 2021 21:40:59 -0500
X-MC-Unique: _UqH0PppPoy0Xn5dFIuk8A-1
Received: by mail-pf1-f171.google.com with SMTP id x131so1157305pfc.12
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 18:40:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=XY5RlfJ4wk969SAhdu0eeba/cRDcEGFX6BIC3EnLQt8=;
	b=poP+b5FSRYfAhH/nvL/nKIXgII7tJMiPQmfkbs9wTB8sGi8HWrPP6nuvsQdKljaaen
	Kk60ydqis6xE/Xb9EMmX9G1Nl/pMMTPnZVk9em20lcbgo9nYaBjsa/WxceQTDZ5aG3HD
	FRP0Xul9Ovv2QJd9xU5GGolQtg/KgbY65CLlU3D6Yhv+3Os+oWCj+MdURGX9r17RqBaM
	qqMlVJTmR2El3l5xDclpHaNZRL/fG8O1wynasYq7Oag2knt4rwmJ5R2GSxOoDsFMSvDJ
	c9kGyTtrHjZOs/Q3Y5WYMpnGChu9uazMJTKjsFnQzP2aT2caKe3THdYZe5Y71kXKuV15
	QEAA==
X-Gm-Message-State: AOAM533OzDosFynQgpNtxO0UETbasSCHwX9CBAe326onqYlnuFxKo1yY
	ogymX1AL34S7Ev0L6E5etyifReDhzNeLih+FJmJ2+A==
X-Google-Smtp-Source: ABdhPJzf7x9CNNO+bnTL7ccWPdJMGj5rcrJdH+gi4z67GahFamuGnCABtN5RCIhrCvjUMVb9BfOrAHDXXr0x3X1l1Pc=
X-Received: by 2002:a63:88c3:: with SMTP id l186mr1768633pgd.377.1637721658407;
	Tue, 23 Nov 2021 18:40:58 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-22-hch@lst.de>
In-Reply-To: <20211109083309.584081-22-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 18:40:47 -0800
Message-ID: <CAPcyv4hY4g82PrjMPO=1kiM5sL=3=yR66r6LeG8RS3Ha2k1eUw@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 21/29] xfs: move dax device handling into
	xfs_{alloc, free}_buftarg
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

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Hide the DAX device lookup from the xfs_super.c code.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

That's an interesting spelling of "Signed-off-by", but patch looks
good to me too. I would have expected a robot to complain about
missing sign-off?

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

