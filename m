Return-Path: <SRS0=c4z+=NH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70EC1C4338F
	for <dm-devel@archiver.kernel.org>; Mon, 16 Aug 2021 07:22:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DE85961A8C
	for <dm-devel@archiver.kernel.org>; Mon, 16 Aug 2021 07:22:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DE85961A8C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-ejAJC0ICNAKT1nK2WBVUgA-1; Mon, 16 Aug 2021 03:22:23 -0400
X-MC-Unique: ejAJC0ICNAKT1nK2WBVUgA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 452DF1853028;
	Mon, 16 Aug 2021 07:22:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D89385D9D3;
	Mon, 16 Aug 2021 07:22:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B48891819AC2;
	Mon, 16 Aug 2021 07:22:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17G7M71D018768 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 16 Aug 2021 03:22:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 77AEC21602AF; Mon, 16 Aug 2021 07:22:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7373B21602AA
	for <dm-devel@redhat.com>; Mon, 16 Aug 2021 07:22:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16FEB801E6E
	for <dm-devel@redhat.com>; Mon, 16 Aug 2021 07:22:04 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-518-8zBGzOcnM9a-JCO-Qt_AGw-1;
	Mon, 16 Aug 2021 03:22:01 -0400
X-MC-Unique: 8zBGzOcnM9a-JCO-Qt_AGw-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 12B2567373; Mon, 16 Aug 2021 09:21:59 +0200 (CEST)
Date: Mon, 16 Aug 2021 09:21:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Guenter Roeck <linux@roeck-us.net>
Message-ID: <20210816072158.GA27147@lst.de>
References: <20210804094147.459763-1-hch@lst.de>
	<20210804094147.459763-5-hch@lst.de>
	<20210814211309.GA616511@roeck-us.net>
	<20210815070724.GA23276@lst.de>
	<a8d66952-ee44-d3fa-d699-439415b9abfe@roeck-us.net>
MIME-Version: 1.0
In-Reply-To: <a8d66952-ee44-d3fa-d699-439415b9abfe@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/8] block: support delayed holder
 registration
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Aug 15, 2021 at 07:27:37AM -0700, Guenter Roeck wrote:
> [   14.467748][    T1]  Possible unsafe locking scenario:
> [   14.467748][    T1]
> [   14.467928][    T1]        CPU0                    CPU1
> [   14.468058][    T1]        ----                    ----
> [   14.468187][    T1]   lock(&disk->open_mutex);
> [   14.468317][    T1]                                lock(mtd_table_mutex);
> [   14.468493][    T1]                                lock(&disk->open_mutex);
> [   14.468671][    T1]   lock(mtd_table_mutex);

Oh, that ooks like a really old one, fixed by
b7abb0516822 ("mtd: fix lock hierarchy in deregister_mtd_blktrans")
in linux-next.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

