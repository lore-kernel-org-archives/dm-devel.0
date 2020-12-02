Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E328C64E7B
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:56:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DE15221FD
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 22:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DE15221FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-j48Gs4G3OUCxp-_rfquEQg-1; Wed, 02 Dec 2020 17:56:31 -0500
X-MC-Unique: j48Gs4G3OUCxp-_rfquEQg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93C261005D5B;
	Wed,  2 Dec 2020 22:56:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EAF55D6BA;
	Wed,  2 Dec 2020 22:56:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C3A014BB7B;
	Wed,  2 Dec 2020 22:56:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B2MuOvm017123 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 17:56:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8A358D7B0A; Wed,  2 Dec 2020 22:56:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 840A8D7B02
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 22:56:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0CB7185A7BC
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 22:56:21 +0000 (UTC)
Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com
	[209.85.219.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-137-P27mh1vhMhGXMN9BVfU2TA-1; Wed, 02 Dec 2020 17:56:19 -0500
X-MC-Unique: P27mh1vhMhGXMN9BVfU2TA-1
Received: by mail-qv1-f66.google.com with SMTP id cv2so63015qvb.9
	for <dm-devel@redhat.com>; Wed, 02 Dec 2020 14:56:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=IBFDTpo6HCPZ58+V0bzhRqACm4PvOWR/Et5h/3XwaU8=;
	b=cW543Ta64uX30hmfLjd2L6qZRUVcHFWCULV06PwpBXWJsjmeW318KpZ9DlpH2Dq0PY
	axbbCixUUN+ybvOaV7iikewOEnWaaikJ0LbOVGZp5fHoyK9bIPo+g5XTHFAlltgFO3V6
	Zf0qHldv62NztI5mmSQ/UIeXcJ6Ff3Uhdqo0T/aklUvz7ZPsiT2ooKU5MS7BsLAOAxTI
	Y3bEOl95/KQfXHH/MTPbXEVq09rq0vmdbkxT4+At8twCIdBdzYw1eLzUBFzQdF/w0LJO
	FX7RhGVdj8jepO7c/stAJifMwfvRid3U6VVYRSOqW7jNXHyJrk9lqUK0/zeqI43BnqI3
	w5DA==
X-Gm-Message-State: AOAM531HPVn9EjABFjSdDU3r89dnQ7htaRyXSQBikBdiclHB5rCb976a
	syPnOMZY+ZLOdb/WKdKUyHc=
X-Google-Smtp-Source: ABdhPJwJibtRzDad60HT36HN6FnIXnXcdBaU9HV0uJhnDSuilp3rwyjJsTTbCkE48vAEqp+9FbP8ZA==
X-Received: by 2002:ad4:4ee7:: with SMTP id dv7mr420732qvb.43.1606949779283;
	Wed, 02 Dec 2020 14:56:19 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
	by smtp.gmail.com with ESMTPSA id
	q123sm100474qke.28.2020.12.02.14.56.18
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Dec 2020 14:56:18 -0800 (PST)
Date: Wed, 2 Dec 2020 17:55:50 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8gbdmOWK46JTUwX@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
	<20201201165424.2030647-5-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201201165424.2030647-5-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-s390@vger.kernel.org,
	linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>,
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>,
	dm-devel@redhat.com, linux-block@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 4/9] block: simplify submit_bio_checks a bit
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Dec 01, 2020 at 05:54:19PM +0100, Christoph Hellwig wrote:
> Merge a few checks for whole devices vs partitions to streamline the
> sanity checks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

