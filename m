Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 398AFC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 02:55:09 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-H5oGj9isNFC6oNLIlIdOsQ-1; Mon, 22 Nov 2021 21:55:04 -0500
X-MC-Unique: H5oGj9isNFC6oNLIlIdOsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F13CA801983;
	Tue, 23 Nov 2021 02:54:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B83771017CE3;
	Tue, 23 Nov 2021 02:54:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 45BE51832E7F;
	Tue, 23 Nov 2021 02:54:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AN2svWP009153 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Nov 2021 21:54:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 794234010FE9; Tue, 23 Nov 2021 02:54:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 73D02400DFBC
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 02:54:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E562385A5A8
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 02:54:56 +0000 (UTC)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
	[209.85.214.182]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-106-fd74dAXfPD-4wDbDtg2RIA-1; Mon, 22 Nov 2021 21:54:54 -0500
X-MC-Unique: fd74dAXfPD-4wDbDtg2RIA-1
Received: by mail-pl1-f182.google.com with SMTP id b13so15831557plg.2
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 18:54:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=hzu6WTfZUrCey1J7m6mzu3SyuG3mlb0cV5bc4AfptPs=;
	b=BAB6AwtkXlW3SwqzPr6fZD7gzZTooxozpvEzaJZDMwVmiqK5TwFi+pF4pLwdx4QMfm
	ihVObDYFzFbnKOur3fdV2+6C2/AEPkNKQjAyMXIXOtkG2+EVOwmecJX5c6grV298Txdc
	YkS53671KwzCk3QvIUuN22NT/3izVcJF6pB+mAngWmKr5nQwxYfXAYUahdwN/huHIyZs
	IXO5M8TLJsyZjHPFKjsxXRydJ0Ht8P2+OtcOyfkjkn/K1dOvf2wcSzX7wwSRMUDPEExm
	qyozL9IXpxSC9sphfMnOb/t8o8YDLQCGqMNuCoiWGHLnA9IK5WQHfU50ZWKP1tGCQBEW
	KQkA==
X-Gm-Message-State: AOAM533TywnhSVAUFXlyppGxulS9+fVAQ7HtaDcHXrmMnAED+u3H246t
	n2Olg6Q8nS3XyGDYnRxyN1d5f3fodH1gPth3e/kiVA==
X-Google-Smtp-Source: ABdhPJxeiX5ifpjvIOpWVxQMDUuHcOe3OIdJeR8Imw/gLHmEQwl4x/JiO/uU+o3bH9o5PQYkURGBJLUFMItHEKRZD78=
X-Received: by 2002:a17:902:a50f:b0:143:7dec:567 with SMTP id
	s15-20020a170902a50f00b001437dec0567mr2776615plq.18.1637636093077;
	Mon, 22 Nov 2021 18:54:53 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-4-hch@lst.de>
	<CAPcyv4hzWBZfex=C2_+nNLFKODw8+E9NSgK50COqE748cfEKTg@mail.gmail.com>
In-Reply-To: <CAPcyv4hzWBZfex=C2_+nNLFKODw8+E9NSgK50COqE748cfEKTg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Nov 2021 18:54:42 -0800
Message-ID: <CAPcyv4g=KgKZR6JF8_=mTs7Ndgq7DSU+5_sTJ7gQuwUgC5dRYg@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 03/29] dax: remove CONFIG_DAX_DRIVER
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

On Wed, Nov 17, 2021 at 9:43 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > CONFIG_DAX_DRIVER only selects CONFIG_DAX now, so remove it.
>
> Applied.

Unapplied,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

