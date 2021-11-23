Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98260C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 03:51:45 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-nMM5qdI8P7GWGav8DzMTTA-1; Mon, 22 Nov 2021 22:51:40 -0500
X-MC-Unique: nMM5qdI8P7GWGav8DzMTTA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13033420E9;
	Tue, 23 Nov 2021 03:51:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B5DF260862;
	Tue, 23 Nov 2021 03:51:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1ACA01832E7F;
	Tue, 23 Nov 2021 03:51:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AN3pWbk012974 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Nov 2021 22:51:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D40B651E2; Tue, 23 Nov 2021 03:51:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE25B51E1
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 03:51:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA3BD801E6E
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 03:51:29 +0000 (UTC)
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com
	[209.85.214.181]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-295-TBjn8ZJiPWGvWdsFQuhEoA-1; Mon, 22 Nov 2021 22:51:27 -0500
X-MC-Unique: TBjn8ZJiPWGvWdsFQuhEoA-1
Received: by mail-pl1-f181.google.com with SMTP id y7so15952515plp.0
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 19:51:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=set6lIbZWt1UwkjEncJQUmHWp82483Zo0VHgKUnBt0w=;
	b=WI9DDW5ksiMiCQcXptHwXVG5+fpfJBOSgwcdhqjGXJwLNcOZEALDFrc33MkutNcqB1
	g9qv9XRZdyeVXpNnvrsc+NYFtUvKEq1LRvol+ZMs5Uk91e+s5JvcqoM44qdsaP3wG447
	SQ/QXDycf7ZN2/UhC1mpbo2pt5dUfOwXgYQ55e3zuBl2pCQKyevKBGJcLhWu8Giy4pMY
	1KaIa+4CMcUUbqVYJuUhadoT7wMq6PgFiQxfJUkwVkmOPIvxNebiWpv+jLN0PchGlmEK
	vJ4b5WsYlURfCqrTdDcfeFYw9aVvTJFopYiFgdAMTbKTjkADDhTMwFoV2V3sZt+FnsrA
	9chA==
X-Gm-Message-State: AOAM530LXf5Nxcpc22QMGA7d9+PRhrWgW+wmepSNMqyXQEvY57Lfz/sq
	gaMteN3Zky+7FlnH8XzNiGOGQbHyh+L4fb7GiDWf/Q==
X-Google-Smtp-Source: ABdhPJwgdeM7vJZ2DKKwalEr7KeonINU2K18nZr67CpB7ixzXQKpSb7Eol7dgHhzUPEgLb+CGDYy92xBtwbeaxDZs1M=
X-Received: by 2002:a17:902:6acb:b0:142:76c3:d35f with SMTP id
	i11-20020a1709026acb00b0014276c3d35fmr2967201plt.89.1637639486743;
	Mon, 22 Nov 2021 19:51:26 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-8-hch@lst.de>
In-Reply-To: <20211109083309.584081-8-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Nov 2021 19:51:15 -0800
Message-ID: <CAPcyv4jnLdFaDwLTeRhJcTzyjd-psZRgWqVDqzOAZr3EGLbF2w@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
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
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 07/29] xfs: factor out a xfs_setup_dax_always
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Factor out another DAX setup helper to simplify future changes.  Also
> move the experimental warning after the checks to not clutter the log
> too much if the setup failed.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

