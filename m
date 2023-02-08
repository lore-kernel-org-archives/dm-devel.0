Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3BACC636CD
	for <dm-devel@archiver.kernel.org>; Wed,  8 Feb 2023 00:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675816345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=K6jFdnIlGwvmMF3TUqaoXJv3JbV715gnOdX1daz2wfM=;
	b=IF+gHEytCuQAJJCGdEkQCUaJydqT2jV1z4dpwtcY9HrMsSguZHO4PQS36SNsDKGto0IfJ8
	DqSNRzJLQaHIzDpznGAJZuNZoSUOgI76+DWOrGdfAujQxKlFa2rj49huAXgwlVxmjpcQJ8
	rd/U4r5Uu5stuqyTjyGT0OwcmDwOjEU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-Mb6_dQt-MFKwTkumNcpL-g-1; Tue, 07 Feb 2023 19:32:22 -0500
X-MC-Unique: Mb6_dQt-MFKwTkumNcpL-g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D59D2999B36;
	Wed,  8 Feb 2023 00:32:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6B4D0492C3C;
	Wed,  8 Feb 2023 00:32:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5B552194658D;
	Wed,  8 Feb 2023 00:32:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 826E81946589
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Feb 2023 00:32:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4766A2166B2A; Wed,  8 Feb 2023 00:32:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E4B72166B29;
 Wed,  8 Feb 2023 00:32:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 3180WGPt024409;
 Tue, 7 Feb 2023 18:32:16 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 3180WGgd024408;
 Tue, 7 Feb 2023 18:32:16 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue,  7 Feb 2023 18:32:16 -0600
Message-Id: <1675816336-24371-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH] multipath.rules: fix "smart" bug with failed
 valid path check
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If "multipath -u" fails, udev doesn't import any values from the
program. This means that multipath.rules will continue to use the values
for DM_MULTIPATH_DEVICE_PATH and FIND_MULTIPATHS_WAIT_UNTIL that it has
already imported from the database. This is the correct thing to do for
every case except the MAYBE case for "find_multipaths smart". In that
case, DM_MULTIPATH_DEVICE_PATH will be set to 1, and the rules will
assume that the device has been definitively claimed.

In this case, we know that the device shouldn't have been claimed
before, but we don't know if it should be claimed now, or if we have hit
the timeout and it should be released, since we didn't get any
information from multipath. The safest thing to do is assume that this
was the timeout, and the device shouldn't be claimed. The only time when
this could be the wrong answer is when we first see a new multipath
device, and it could only cause problems if there is metadata on the
device that will cause it to get autoassembled by something else, before
multipathd can autoassemble it. If we assume that it is a multipath
device, or we assume that this wasn't actually the timeout uevent, we
can keep a necessary device from getting released to the reset of the
system.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.rules.in | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/multipath/multipath.rules.in b/multipath/multipath.rules.in
index 8d3cf33a..6f123760 100644
--- a/multipath/multipath.rules.in
+++ b/multipath/multipath.rules.in
@@ -31,7 +31,8 @@ IMPORT{db}="DM_MULTIPATH_DEVICE_PATH"
 
 # multipath -u sets DM_MULTIPATH_DEVICE_PATH and,
 # if "find_multipaths smart", also FIND_MULTIPATHS_WAIT_UNTIL.
-IMPORT{program}="$env{MPATH_SBIN_PATH}/multipath -u %k"
+IMPORT{program}=="$env{MPATH_SBIN_PATH}/multipath -u %k", \
+	ENV{.MPATH_CHECK_PASSED}="1"
 
 # case 1: this is definitely multipath
 ENV{DM_MULTIPATH_DEVICE_PATH}=="1", \
@@ -82,10 +83,19 @@ LABEL="stop_wait"
 # If timeout hasn't expired but we're not in "maybe" state any more, stop timer
 # Do this only once, and only if the timer has been started before
 IMPORT{db}="FIND_MULTIPATHS_WAIT_CANCELLED"
-ENV{FIND_MULTIPATHS_WAIT_CANCELLED}!="?*", \
-	ENV{FIND_MULTIPATHS_WAIT_UNTIL}=="?*", \
-	ENV{FIND_MULTIPATHS_WAIT_UNTIL}!="0", \
-	ENV{FIND_MULTIPATHS_WAIT_CANCELLED}="1", \
-	RUN+="/usr/bin/systemctl stop cancel-multipath-wait-$kernel.timer"
+ENV{FIND_MULTIPATHS_WAIT_CANCELLED}=="?*", GOTO="end_mpath"
+ENV{FIND_MULTIPATHS_WAIT_UNTIL}!="?*", GOTO="end_mpath"
+ENV{FIND_MULTIPATHS_WAIT_UNTIL}=="0", GOTO="end_mpath"
+
+ENV{FIND_MULTIPATHS_WAIT_CANCELLED}="1"
+RUN+="/usr/bin/systemctl stop cancel-multipath-wait-$kernel.timer"
+
+# If "multipath -u" failed, no values are imported from the program,
+# and we are still using the values for DM_MULTIPATH_DEVICE_PATH and
+# FIND_MULTIPATHS_WAIT_UNTIL that were imported from the database.
+# If we are in "smart" mode, we need to give up on the path now,
+# since this may have been the timeout event. Without the imports
+# from "multipath -u", we can't tell.
+ENV{.MPATH_CHECK_PASSED}!="?*", ENV{DM_MULTIPATH_DEVICE_PATH}="0"
 
 LABEL="end_mpath"
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

