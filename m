Return-Path: <SRS0=qgMK=F2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25CDC433E6
	for <dm-devel@archiver.kernel.org>; Tue, 22 Dec 2020 13:57:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1ABCF23105
	for <dm-devel@archiver.kernel.org>; Tue, 22 Dec 2020 13:57:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ABCF23105
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-QkBNeqZCNvy0iZpi3fzi5w-1; Tue, 22 Dec 2020 08:56:58 -0500
X-MC-Unique: QkBNeqZCNvy0iZpi3fzi5w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51BF0100F341;
	Tue, 22 Dec 2020 13:56:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CE3EA60C64;
	Tue, 22 Dec 2020 13:56:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3519A5002C;
	Tue, 22 Dec 2020 13:56:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BMDuioY017119 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Dec 2020 08:56:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6117D2166B28; Tue, 22 Dec 2020 13:56:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C6DF2166B29
	for <dm-devel@redhat.com>; Tue, 22 Dec 2020 13:56:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01297811E78
	for <dm-devel@redhat.com>; Tue, 22 Dec 2020 13:56:42 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-97-d_r-q3IXMjCqbsCMKW4Jdg-1; Tue, 22 Dec 2020 08:56:38 -0500
X-MC-Unique: d_r-q3IXMjCqbsCMKW4Jdg-1
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat
	Linux)) id 1krhmQ-0001SZ-29; Tue, 22 Dec 2020 13:32:46 +0000
Date: Tue, 22 Dec 2020 13:32:46 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Palmer Dabbelt <palmer@dabbelt.com>
Message-ID: <20201222133246.GA5099@infradead.org>
References: <30d39293-80a4-9ef5-92bb-6b6dec464be3@toxicpanda.com>
	<mhng-2da5b1a2-20f9-4b0e-9ffd-7f60a161ebf0@palmerdabbelt-glaptop>
MIME-Version: 1.0
In-Reply-To: <mhng-2da5b1a2-20f9-4b0e-9ffd-7f60a161ebf0@palmerdabbelt-glaptop>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-raid@vger.kernel.org, bvanassche@acm.org, snitzer@redhat.com,
	corbet@lwn.net, shuah@kernel.org, linux-doc@vger.kernel.org,
	josef@toxicpanda.com, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, song@kernel.org,
	dm-devel@redhat.com, michael.christie@oracle.com,
	linux-kselftest@vger.kernel.org, kernel-team@android.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v1 0/5] dm: dm-user: New target that proxies
 BIOs to userspace
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Dec 14, 2020 at 07:00:57PM -0800, Palmer Dabbelt wrote:
> I haven't gotten a whole lot of feedback, so I'm inclined to at least have some
> reasonable performance numbers before bothering with a v2.

FYI, my other main worry beside duplicating nbd is that device mapper
really is a stacked interface that sits on top of other block device.
Turning this into something else that just pipes data to userspace
seems very strange.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

