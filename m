Return-Path: <SRS0=8v/u=FH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2554AC433FE
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 19:45:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 56C0D221F2
	for <dm-devel@archiver.kernel.org>; Thu,  3 Dec 2020 19:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56C0D221F2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-G7KwtmwAO1GbOU8g6q0yCA-1; Thu, 03 Dec 2020 14:45:49 -0500
X-MC-Unique: G7KwtmwAO1GbOU8g6q0yCA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D03AE80EF8D;
	Thu,  3 Dec 2020 19:45:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 185A860854;
	Thu,  3 Dec 2020 19:45:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8FB6D180954D;
	Thu,  3 Dec 2020 19:45:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B3JjZ2t023050 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 14:45:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4FE462166B27; Thu,  3 Dec 2020 19:45:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A82A2166B2C
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 19:45:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23E20801230
	for <dm-devel@redhat.com>; Thu,  3 Dec 2020 19:45:33 +0000 (UTC)
Received: from mail-qv1-f65.google.com (mail-qv1-f65.google.com
	[209.85.219.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-569-6B2lKQwEPbWrR-vS3b-_kA-1; Thu, 03 Dec 2020 14:45:31 -0500
X-MC-Unique: 6B2lKQwEPbWrR-vS3b-_kA-1
Received: by mail-qv1-f65.google.com with SMTP id n9so1588149qvp.5
	for <dm-devel@redhat.com>; Thu, 03 Dec 2020 11:45:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=ehh149i/IiSP0EMQTmZOg7uX3bioxkynO8akD/sHgj8=;
	b=iKUjwNXDNj51B/5UFw6W1w4n3LfnSN7WgVzxTxoxzZKzQ7GGCnQ0wrhoWYupNOhURk
	YNqPdQDXVbcMPMbojEs+KqHbmsO+LPoxlWV2elnoJYrpe7aqVpj5l0NP5SdrhAOWpFf0
	N9wFIk4Eje2KvthvvCqyZLzsKKW2Chei/v9TsPZclCEJtwt2AkD+ScJyfSST/cs2vtZa
	zMohBXdSYGNwn8LWg1tfb8OkCUwPuZRnDPYs3L80Ajw+smiWOo+IQUscyVu/sVEfKFNh
	QRd8LrTMGZ1nHP05BiJwgSvDCed3WYHuMZFG/+UIDrnK8ELNC4AxTjkeC/b3doYX85vB
	Awyg==
X-Gm-Message-State: AOAM532j1JECeRnE+UEEcdMEXdI9UX7RS5ajMblLcq/xcpJwP/GwQLgf
	DS7sCp4yqmbujYFBOC8f991W8kRRbWCh7g==
X-Google-Smtp-Source: ABdhPJyqNbQdpf8vfSyIW2twgYfE2j/5PIsFbMCutpC4UJ5dQcGXqBdFTLKHA+kJQ681qsA75i7wBg==
X-Received: by 2002:a0c:aed4:: with SMTP id n20mr645079qvd.16.1607024730368;
	Thu, 03 Dec 2020 11:45:30 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:6aeb])
	by smtp.gmail.com with ESMTPSA id
	z81sm2152679qkb.116.2020.12.03.11.45.29
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 03 Dec 2020 11:45:29 -0800 (PST)
Date: Thu, 3 Dec 2020 14:45:02 -0500
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <X8lAPgNyC8Aldfrn@mtj.duckdns.org>
References: <20201203162139.2110977-1-hch@lst.de>
	<20201203162139.2110977-2-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20201203162139.2110977-2-hch@lst.de>
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
	Damien Le Moal <damien.lemoal@wdc.com>,
	linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 1/5] block: remove the unused block_sleeprq
	tracepoint
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 03, 2020 at 05:21:35PM +0100, Christoph Hellwig wrote:
> The block_sleeprq tracepoint was only used by the legacy request code.
> Remove it now that the legacy request code is gone.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

