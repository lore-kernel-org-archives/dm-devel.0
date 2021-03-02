Return-Path: <SRS0=Fgdj=IA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9561C433E6
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 19:06:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2A30064F31
	for <dm-devel@archiver.kernel.org>; Tue,  2 Mar 2021 19:06:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A30064F31
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614711967;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NHWHRvQtqLn3WIBCJ5d8rOf0/3r0aP4Ey6GnW5YlXrA=;
	b=Cr0/mW3PwsUJLT1v0lP60JfMwhizReg9cOE2iiBg3oopZ3Pf8vc4ihUVg77LInGD+IhupA
	jeYsBnfyyuwXQ+hzqHNOLvaQh+50EB2U26AIvrtI6rKoFq0sajGsbTklVO/MHr8O50ktZH
	1tRNnnMWtormHfLn277/DzZ1EXJbGuc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-wD-x8MelMcGJ5DbI-qtTSg-1; Tue, 02 Mar 2021 14:06:05 -0500
X-MC-Unique: wD-x8MelMcGJ5DbI-qtTSg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DDC8801980;
	Tue,  2 Mar 2021 19:06:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FCFB708E2;
	Tue,  2 Mar 2021 19:06:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A790A18095CB;
	Tue,  2 Mar 2021 19:05:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 122J5vsF011067 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 14:05:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 88807100F495; Tue,  2 Mar 2021 19:05:57 +0000 (UTC)
Received: from leontynka.twibright.com (ovpn-116-252.ams2.redhat.com
	[10.36.116.252])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 47BA210023BD;
	Tue,  2 Mar 2021 19:05:54 +0000 (UTC)
Received: from debian-a64.vm ([192.168.208.2])
	by leontynka.twibright.com with smtp (Exim 4.92)
	(envelope-from <mpatocka@redhat.com>)
	id 1lHAL9-0003k5-GT; Tue, 02 Mar 2021 20:05:52 +0100
Received: by debian-a64.vm (sSMTP sendmail emulation);
	Tue, 02 Mar 2021 20:05:50 +0100
Message-Id: <20210302190513.688854040@debian-a64.vm>
User-Agent: quilt/0.65
Date: Tue, 02 Mar 2021 20:05:13 +0100
From: Mikulas Patocka <mpatocka@redhat.com>
To: JeffleXu <jefflexu@linux.alibaba.com>, Mike Snitzer <msnitzer@redhat.com>, 
	Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
	caspar@linux.alibaba.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, hch@lst.de
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH 0/4] Reworked device mapper polling patchset
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

This is reworked patchset for device mapper I/O polling.

The polling happens inside device mapper and the polling cookie is not
returned to the upper-layer code (because returning it would be unsafe).

Mikulas

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

