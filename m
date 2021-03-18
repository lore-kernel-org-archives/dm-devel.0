Return-Path: <SRS0=wQ+j=IQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41EA0C433E6
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 09:14:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A4B6164F24
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 09:14:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4B6164F24
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-iJ3o73SsMZadSHJfeh-O4A-1; Thu, 18 Mar 2021 05:14:52 -0400
X-MC-Unique: iJ3o73SsMZadSHJfeh-O4A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E0F6814314;
	Thu, 18 Mar 2021 09:14:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95123690FA;
	Thu, 18 Mar 2021 09:14:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7F0BF1809C83;
	Thu, 18 Mar 2021 09:14:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12I9EfWM005118 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Mar 2021 05:14:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1BE242024CD5; Thu, 18 Mar 2021 09:14:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 161F52024CD0
	for <dm-devel@redhat.com>; Thu, 18 Mar 2021 09:14:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA67D801E8D
	for <dm-devel@redhat.com>; Thu, 18 Mar 2021 09:14:38 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-101-_4vvikauMGSQNaf6_sFuWw-1;
	Thu, 18 Mar 2021 05:14:34 -0400
X-MC-Unique: _4vvikauMGSQNaf6_sFuWw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id A016EAD4A;
	Thu, 18 Mar 2021 09:14:32 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Mar 2021 10:14:12 +0100
Message-Id: <20210318091413.28027-2-mwilck@suse.com>
In-Reply-To: <20210318091413.28027-1-mwilck@suse.com>
References: <20210318091413.28027-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12I9EfWM005118
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 2/3] 11-dm-mpath.rules: run "multipath -U"
	with -v1
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

In cases where some path devices are temporarily unavailable (e.g. failover),
high amounts of error messages such as these are seen:

Feb 27 08:02:03 ictm1608s02h1 multipath[1420]: get_udev_device: failed to look up 65:224 with type 1
Feb 27 08:02:03 ictm1608s02h1 multipath[1420]: 3600a098000aada210000f1625de51ed9: discarding non-existing path 65:224

This is because every invocation of "multipath -U" prints these messages
at the default log level (-v2). In the case of "multipath -U", these
messages aren't important, and in failover situations, "multipath -U" is
run pretty often, spamming the log with many similar messages.

Generally reducing the log level of these messages would be wrong,
because they are important for multipathd's operation, to verify that
multipathd does the right thing when discovering a discrepancy between the dm
state and the devices present in the system. Therefore, just decrease the
verbosity with which we invoke "multipath -U" in the udev rules.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index cd522e8..d191ae8 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -32,7 +32,7 @@ ACTION=="add", ENV{.MPATH_DEVICE_READY_OLD}=="1", GOTO="paths_ok"
 
 # Check the map state directly with multipath -U.
 # This doesn't attempt I/O on the device.
-PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -U %k", GOTO="paths_ok"
+PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -U -v1 %k", GOTO="paths_ok"
 ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
 LABEL="paths_ok"
 
-- 
2.30.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

