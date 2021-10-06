Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7AFC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 20:04:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2482C610CC
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 20:04:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2482C610CC
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633550689;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TFaK2JgF8ZPWSnJl6R9az2qncgGM90XTFiISlOsEGFw=;
	b=jS9qag6AYckc+AHNas3xGsO0Yvsh46nshoG5qurczdGHgJIOZW358WvoCS2M5V5kWtIO0H
	GUFtE45IkKh96ciTAAabx44uYWM4vQPYpscsIu+OH7kjNxEkDwEzyR/zvU3wp0JWR7q2+0
	SqzxSXnnkqwlaDEdWBEN3xZALU9LHPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-aug1a3MTPICOy7cYZi45XQ-1; Wed, 06 Oct 2021 16:04:47 -0400
X-MC-Unique: aug1a3MTPICOy7cYZi45XQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2C491808304;
	Wed,  6 Oct 2021 20:04:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF5901F42A;
	Wed,  6 Oct 2021 20:04:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 61AD81806D01;
	Wed,  6 Oct 2021 20:04:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196K4TJx020042 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 16:04:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 73BFC1F427; Wed,  6 Oct 2021 20:04:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CB1B917001;
	Wed,  6 Oct 2021 20:04:26 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 196K4OLc025609; 
	Wed, 6 Oct 2021 15:04:24 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 196K4NcV025608;
	Wed, 6 Oct 2021 15:04:23 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  6 Oct 2021 15:04:15 -0500
Message-Id: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 0/8] improving config parsing warnings
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is a series of patches to make multipath provide better warnings
when parsing multipath.conf. The first three patches fix small issues.
The last five patches make multipath print warning messages with
the file and line number, when it was previously either accepting
invalid values or silently changing them.

Benjamin Marzinski (8):
  libmulitpath: add section name to invalid keyword output
  libmultipath: use typedef for keyword handler function
  libmultipath: print the correct file when parsing fails
  libmultipath: pass file and line number to keyword handlers
  libmultipath: make set_int take a range for valid values
  libmultipath: improve checks for set_str
  libmultipath: split set_int to enable reuse
  libmultipath: cleanup invalid config handling

 libmultipath/dict.c   | 481 ++++++++++++++++++++++++++++--------------
 libmultipath/parser.c |  31 +--
 libmultipath/parser.h |  15 +-
 3 files changed, 349 insertions(+), 178 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

