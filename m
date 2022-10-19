Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C4B0C4332F
	for <dm-devel@archiver.kernel.org>; Wed, 19 Oct 2022 17:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666202271;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/C+GY64K8nAMNba2UhKxK33v1157fg74zqk5rFdL1B8=;
	b=DtEHl33BqA7HDuPLGduLsq1gGsIUFq60Jf+b27kpdjWkJbICrx8RpvSRwB/Z7fiBf0JU+r
	ItcBtRo1VD/EYaRsLaulUGFUSymJWqhdmnd8QTw5NtqmDPzDBDn7pBSDQxhvDdYHYR5K7E
	+2BAHmSM9DNt7tH7Av3arzIuLU2qY6o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-bzWmpfKnORCxEuiTmdkipQ-1; Wed, 19 Oct 2022 13:57:47 -0400
X-MC-Unique: bzWmpfKnORCxEuiTmdkipQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AC7E833AF1;
	Wed, 19 Oct 2022 17:57:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A623B49BB64;
	Wed, 19 Oct 2022 17:57:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5C3111946595;
	Wed, 19 Oct 2022 17:57:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 447611946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Oct 2022 17:57:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 33BBD10DF8; Wed, 19 Oct 2022 17:57:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 16B6017582;
 Wed, 19 Oct 2022 17:57:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 29JHvbo8010435;
 Wed, 19 Oct 2022 12:57:38 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 29JHvWB9010434;
 Wed, 19 Oct 2022 12:57:32 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 19 Oct 2022 12:57:10 -0500
Message-Id: <1666202230-10397-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH] kpartx: hold device open until partitions have
 been created
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

kpartx was closing the whole device after it read the partition
information off it.  This allowed a race, where the device could be
removed and another one created with the same major:minor, after kpartx
read the partition information but before it created the partition
devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/kpartx.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 3c499995..1d568c9e 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -441,12 +441,7 @@ main(int argc, char **argv){
 		if (n >= 0)
 			printf("%s: %d slices\n", ptp->type, n);
 #endif
-
-		if (n > 0) {
-			close(fd);
-			fd = -1;
-		}
-		else
+		if (n <= 0)
 			continue;
 
 		switch(what) {
@@ -666,9 +661,9 @@ main(int argc, char **argv){
 		if (n > 0)
 			break;
 	}
+	if (fd != -1)
+		close(fd);
 	if (what == LIST && loopcreated) {
-		if (fd != -1)
-			close(fd);
 		if (del_loop(device)) {
 			if (verbose)
 				fprintf(stderr, "can't del loop : %s\n",
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

