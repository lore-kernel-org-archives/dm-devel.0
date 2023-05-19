Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE17C7EE26
	for <dm-devel@archiver.kernel.org>; Mon, 22 May 2023 06:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684738678;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FSm9DrQQZMYjZ66dF6L7f7Vuz911H20EuhZUZFhREB8=;
	b=gCm6+2Jmt5f/3eT+CKBdrcB4YKT45cYxeldyfRZ32jOIUkOihJI/bA4axsSdb5M2q3YQoA
	O5PZEb2/VZbvc1AaKsrF+/VY/gTkf+9T8v8UdFLd0S7uTsMISKViptrKcfGstfGup7sxzl
	ErPXbhpbDy7pLAsCitB0KhS27DafZHw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-zcVxGS4oPnyhUDdho5VFNg-1; Mon, 22 May 2023 02:57:54 -0400
X-MC-Unique: zcVxGS4oPnyhUDdho5VFNg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0330A101A531;
	Mon, 22 May 2023 06:57:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD3CA4F2DC5;
	Mon, 22 May 2023 06:57:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BE1401946595;
	Mon, 22 May 2023 06:57:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 29D8419465A4
 for <dm-devel@listman.corp.redhat.com>; Fri, 19 May 2023 22:43:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0B38A40D1B62; Fri, 19 May 2023 22:43:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 04A9840D1B61
 for <dm-devel@redhat.com>; Fri, 19 May 2023 22:43:55 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7DE8185A78E
 for <dm-devel@redhat.com>; Fri, 19 May 2023 22:43:55 +0000 (UTC)
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
 by relay.mimecast.com with ESMTP id us-mta-536-VUTcxRyEPMCR_HUAZClDog-1;
 Fri, 19 May 2023 18:43:51 -0400
X-MC-Unique: VUTcxRyEPMCR_HUAZClDog-1
Received: from mua.local.altlinux.org (mua.local.altlinux.org [192.168.1.14])
 by vmicros1.altlinux.org (Postfix) with ESMTP id 6A9A672C8D3;
 Sat, 20 May 2023 01:33:56 +0300 (MSK)
Received: by mua.local.altlinux.org (Postfix, from userid 508)
 id 59B157CFDD8; Sat, 20 May 2023 01:33:56 +0300 (IDT)
Date: Sat, 20 May 2023 01:33:56 +0300
From: "Dmitry V. Levin" <ldv@strace.io>
To: dm-devel@redhat.com
Message-ID: <20230519223356.GA32042@altlinux.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Mon, 22 May 2023 06:57:50 +0000
Subject: [dm-devel] [PATCH] 11-dm-mpath.rules: fix warnings reported by
 udevadm verify
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: mwilck@suse.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: strace.io
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fix the following warnings reported by udevadm verify:

multipath/11-dm-mpath.rules:18 Whitespace after comma is expected.
multipath/11-dm-mpath.rules:73 Whitespace after comma is expected.
multipath/11-dm-mpath.rules:73 Whitespace after comma is expected.
multipath/11-dm-mpath.rules:78 Whitespace after comma is expected.
multipath/11-dm-mpath.rules:78 Whitespace after comma is expected.
multipath/11-dm-mpath.rules:78 Whitespace after comma is expected.
multipath/11-dm-mpath.rules: udev rules check failed

Signed-off-by: Dmitry V. Levin <ldv@strace.io>
---
 multipath/11-dm-mpath.rules | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index d191ae8d..c339f521 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -14,7 +14,7 @@ ENV{.MPATH_DEVICE_READY_OLD}="$env{MPATH_DEVICE_READY}"
 # multipath sets DM_SUBSYSTEM_UDEV_FLAG2 when it reloads a
 # table with no active devices. If this happens, mark the
 # device not ready
-ENV{DM_SUBSYSTEM_UDEV_FLAG2}=="1", ENV{MPATH_DEVICE_READY}="0",\
+ENV{DM_SUBSYSTEM_UDEV_FLAG2}=="1", ENV{MPATH_DEVICE_READY}="0", \
 	GOTO="mpath_action"
 
 # If the last path has failed mark the device not ready
@@ -68,13 +68,13 @@ ENV{MPATH_DEVICE_READY}=="0", ENV{DM_NOSCAN}="1"
 # Also skip all foreign rules if no path is available.
 # Remember the original value of DM_DISABLE_OTHER_RULES_FLAG
 # and restore it back once we have at least one path available.
-ENV{MPATH_DEVICE_READY}=="0", ENV{.MPATH_DEVICE_READY_OLD}=="1",\
-	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=="",\
+ENV{MPATH_DEVICE_READY}=="0", ENV{.MPATH_DEVICE_READY_OLD}=="1", \
+	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}=="", \
 	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="$env{DM_UDEV_DISABLE_OTHER_RULES_FLAG}"
 ENV{MPATH_DEVICE_READY}=="0", ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="1"
-ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0",\
-	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}",\
-	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="",\
+ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0", \
+	ENV{DM_UDEV_DISABLE_OTHER_RULES_FLAG}="$env{DM_DISABLE_OTHER_RULES_FLAG_OLD}", \
+	ENV{DM_DISABLE_OTHER_RULES_FLAG_OLD}="", \
 	ENV{DM_ACTIVATION}="1", ENV{MPATH_UNCHANGED}="0"
 
 # The code to check multipath state ends here. We need to set
-- 
ldv

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

