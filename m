Return-Path: <SRS0=KxaR=D6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B20C5517A
	for <dm-devel@archiver.kernel.org>; Fri, 23 Oct 2020 21:23:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D332620754
	for <dm-devel@archiver.kernel.org>; Fri, 23 Oct 2020 21:23:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FXEqRCX5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D332620754
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603488179;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jR7ilaCKsICD8c+UrrAEmtizmCbqceDeqW55C/Fjx/Q=;
	b=FXEqRCX5lmVbmhqwRDTDA7Z93nJ5q5DlNDjJfXAeWS7mgCyV1aXVJsB8JAyyV9Nq7XySVQ
	/VkqHJw2omsqlqO9Kghh2AjhxapWbpfQjpOAiyX+YxTD6oPy59trONPyfsLmsuXzQZ6H8F
	nlN7opOgvzlNzCCoORZa1+1kBcctaDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-123-S-FFnE4FNFqORUy7GZwQUQ-1; Fri, 23 Oct 2020 17:22:57 -0400
X-MC-Unique: S-FFnE4FNFqORUy7GZwQUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93965804B80;
	Fri, 23 Oct 2020 21:22:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7745E55795;
	Fri, 23 Oct 2020 21:22:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4F68A180B658;
	Fri, 23 Oct 2020 21:22:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09NLFIIW027810 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 23 Oct 2020 17:15:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C5FEE1992D; Fri, 23 Oct 2020 21:15:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC09519C66;
	Fri, 23 Oct 2020 21:15:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09NLFEHx012601; 
	Fri, 23 Oct 2020 16:15:14 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09NLFDxf012600;
	Fri, 23 Oct 2020 16:15:13 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri, 23 Oct 2020 16:15:07 -0500
Message-Id: <1603487708-12547-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
	device-mapper development <dm-devel@redhat.com>,
	Steve Schremmer <sschremm@netapp.com>, Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 4/5] libmultipath: only read 0xc9 vpd page for
	devices with rdac checker
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Only rdac arrays support 0xC9 vpd page inquiries. All other arrays will
return a failure. Since all rdac arrays in the the built-in device
configuration explicitly set the RDAC path checker, and almost all other
scsi arrays do not set a path checker, it makes sense to only do the
rdac inquiry when detecting array capabilities if the array's path
checker is explicitly set to rdac.

Multipath was doing the check if either the path checker was set to
rdac, or no path checker was set.  This means that for almost all
non-rdac arrays, multipath was issuing a bad inquiry. This was annoying
users.

Cc: Steve Schremmer <sschremm@netapp.com>
Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/propsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index fa4ac5d9..90a77d77 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -501,7 +501,7 @@ check_rdac(struct path * pp)
 	if (pp->bus != SYSFS_BUS_SCSI)
 		return 0;
 	/* Avoid ioctl if this is likely not an RDAC array */
-	if (__do_set_from_hwe(checker_name, pp, checker_name) &&
+	if (!__do_set_from_hwe(checker_name, pp, checker_name) ||
 	    strcmp(checker_name, RDAC))
 		return 0;
 	len = get_vpd_sgio(pp->fd, 0xC9, 0, buff, 44);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

