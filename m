Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4250AC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 04:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669784221;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6TrMkyBobKznYz3dKcZrtPnok27crXcDLTLs/LUhbUE=;
	b=N9S1LEw5OU4vFBQVXYfSg4/fccA1tB8IESSMhl09Fz4Jb9FcUpZu4eahLwSzWk7GssLvvT
	/0UCUOxQBynn1NEM01o6Tu3yl1QsxUx5I+auLukWQgIwiFex5zukZOWQY59eCAkjHXxHeb
	zRqEsSNE6iBhAkqSNfAPakFQ4zw6kbY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-jgkAErITPoi1VECkdGJV_Q-1; Tue, 29 Nov 2022 23:56:56 -0500
X-MC-Unique: jgkAErITPoi1VECkdGJV_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46A2685A588;
	Wed, 30 Nov 2022 04:56:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5B1C92166B2D;
	Wed, 30 Nov 2022 04:56:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E0C4819465A4;
	Wed, 30 Nov 2022 04:56:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B913C19465B1
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 04:56:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A9C0C40C6E13; Wed, 30 Nov 2022 04:56:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 72BB840C6EC4;
 Wed, 30 Nov 2022 04:56:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2AU4up17009796;
 Tue, 29 Nov 2022 22:56:51 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2AU4uo8f009795;
 Tue, 29 Nov 2022 22:56:50 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 29 Nov 2022 22:56:48 -0600
Message-Id: <1669784208-9754-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1669784208-9754-1-git-send-email-bmarzins@redhat.com>
References: <1669784208-9754-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 2/2] libmpathpersist: fix command keyword ordering
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
Cc: lixiaokeng <lixiaokeng@huawei.com>,
 device-mapper development <dm-devel@redhat.com>,
 miaoguanqin <miaoguanqin@huawei.com>, Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When libmpathpersist was communicating with multipathd, it wasn't using
the correct keyword order for the commands, as specified in the CLI
commands reference. Since commit f812466f, multipathd requires commands
to be ordered correctly. Fix the ordering.

Fixes: f812466f ("multipathd: more robust command parsing")
Reported-by: miaoguanqin <miaoguanqin@huawei.com>
Cc: lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_updatepr.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index 5824c169..4529a82b 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -18,7 +18,7 @@
 #include "mpathpr.h"
 
 
-static int do_update_pr(char *alias, char *arg)
+static int do_update_pr(char *alias, char *cmd, char *key)
 {
 	int fd;
 	char str[256];
@@ -31,7 +31,10 @@ static int do_update_pr(char *alias, char *arg)
 		return -1;
 	}
 
-	snprintf(str,sizeof(str),"map %s %s", alias, arg);
+	if (key)
+		snprintf(str,sizeof(str),"%s map %s key %s", cmd, alias, key);
+	else
+		snprintf(str,sizeof(str),"%s map %s", cmd, alias);
 	condlog (2, "%s: pr message=%s", alias, str);
 	if (send_packet(fd, str) != 0) {
 		condlog(2, "%s: message=%s send error=%d", alias, str, errno);
@@ -56,18 +59,16 @@ static int do_update_pr(char *alias, char *arg)
 }
 
 int update_prflag(char *mapname, int set) {
-	return do_update_pr(mapname, (set)? "setprstatus" : "unsetprstatus");
+	return do_update_pr(mapname, (set)? "setprstatus" : "unsetprstatus",
+			    NULL);
 }
 
 int update_prkey_flags(char *mapname, uint64_t prkey, uint8_t sa_flags) {
 	char str[256];
-	char *flagstr = "";
 
-	if (sa_flags & MPATH_F_APTPL_MASK)
-		flagstr = ":aptpl";
-	if (prkey)
-		sprintf(str, "setprkey key %" PRIx64 "%s", prkey, flagstr);
-	else
-		sprintf(str, "unsetprkey");
-	return do_update_pr(mapname, str);
+	if (!prkey)
+		return do_update_pr(mapname, "unsetprkey", NULL);
+	sprintf(str, "%" PRIx64 "%s", prkey,
+		(sa_flags & MPATH_F_APTPL_MASK) ? ":aptpl" : "");
+	return do_update_pr(mapname, "setprkey", str);
 }
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

