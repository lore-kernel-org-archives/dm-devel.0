Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72390C433E6
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 21:42:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E735364F99
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 21:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E735364F99
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-xxqDtDgCO2ioEzSLQLXJnA-1; Tue, 02 Feb 2021 16:42:12 -0500
X-MC-Unique: xxqDtDgCO2ioEzSLQLXJnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B693C100C61A;
	Tue,  2 Feb 2021 21:42:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9974960862;
	Tue,  2 Feb 2021 21:42:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6C3BD5003B;
	Tue,  2 Feb 2021 21:42:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112LfxrY016993 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 16:41:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E069F2166B2E; Tue,  2 Feb 2021 21:41:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA9CC2166B2D
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 21:41:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FEF7811760
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 21:41:55 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-453-vc0omfgGPumF0p2dwwazKQ-1;
	Tue, 02 Feb 2021 16:41:51 -0500
X-MC-Unique: vc0omfgGPumF0p2dwwazKQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 7D5F1AD78;
	Tue,  2 Feb 2021 21:41:49 +0000 (UTC)
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>, lixiaokeng@huawei.com
Date: Tue,  2 Feb 2021 22:41:31 +0100
Message-Id: <20210202214131.19901-4-mwilck@suse.com>
In-Reply-To: <20210202214131.19901-1-mwilck@suse.com>
References: <20210202214131.19901-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 112LfxrY016993
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 3/3] libmultipath: check return value of
	udev_device_get_devnum()
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

udev_device_get_devnum() may fail, in which case it returns
makedev(0, 0).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 921025d..15cf641 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1659,6 +1659,9 @@ common_sysfs_pathinfo (struct path * pp)
 		return PATHINFO_FAILED;
 	}
 	devt = udev_device_get_devnum(pp->udev);
+	if (major(devt) == 0 && minor(devt) == 0)
+		return PATHINFO_FAILED;
+
 	snprintf(pp->dev_t, BLK_DEV_SIZE, "%d:%d", major(devt), minor(devt));
 
 	condlog(4, "%s: dev_t = %s", pp->dev, pp->dev_t);
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

