Return-Path: <SRS0=muSZ=IM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E4FC433E0
	for <dm-devel@archiver.kernel.org>; Sun, 14 Mar 2021 09:30:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4776B64EBA
	for <dm-devel@archiver.kernel.org>; Sun, 14 Mar 2021 09:30:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4776B64EBA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-WdvaYUgNMKSww3hnLow87g-1; Sun, 14 Mar 2021 05:30:12 -0400
X-MC-Unique: WdvaYUgNMKSww3hnLow87g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 435A1817469;
	Sun, 14 Mar 2021 09:30:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 198816E407;
	Sun, 14 Mar 2021 09:30:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 086F218006D9;
	Sun, 14 Mar 2021 09:30:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12E9U4Mr023603 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 14 Mar 2021 05:30:04 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7BDF02026D6A; Sun, 14 Mar 2021 09:30:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76FB42026D60
	for <dm-devel@redhat.com>; Sun, 14 Mar 2021 09:30:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D82C4811E7A
	for <dm-devel@redhat.com>; Sun, 14 Mar 2021 09:30:00 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-423-XeinXoZPNfe3OW-Qxbivdg-1; Sun, 14 Mar 2021 05:29:58 -0400
X-MC-Unique: XeinXoZPNfe3OW-Qxbivdg-1
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat
	Linux)) id 1lLMpd-00Fpf6-5r; Sun, 14 Mar 2021 09:14:55 +0000
Date: Sun, 14 Mar 2021 09:14:41 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20210314091441.GA3773360@infradead.org>
References: <1615563895-28565-1-git-send-email-sergei.shtepa@veeam.com>
	<1615563895-28565-2-git-send-email-sergei.shtepa@veeam.com>
	<20210312190641.GA2550@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210312190641.GA2550@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-api@vger.kernel.org, pavel.tide@veeam.com,
	linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	Sergei Shtepa <sergei.shtepa@veeam.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v7 1/3] block: add blk_mq_is_queue_frozen()
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Mar 12, 2021 at 02:06:41PM -0500, Mike Snitzer wrote:
> This is returning a frozen state that is immediately stale.  I don't
> think any code calling this is providing the guarantees you think it
> does due to the racey nature of this state once the mutex is dropped.

The code only uses it for asserts in the form of WARN_ONs.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

