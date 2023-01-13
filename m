Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87EF5C61DB3
	for <dm-devel@archiver.kernel.org>; Fri, 13 Jan 2023 09:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673603027;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rKOSnQURhVXpq14jL2CLpkg5406T+lo7bt0ItZY34iM=;
	b=Y+qL+EM04MwvwUa8q7t0VKZQdKff5TPe/qWaqtlusyhEfPvjIt+Hf0dbzSfD1IdVeo1xSb
	nxntUAKetm99XeJYNUFnqzAJlvGcQoV42lUB7ySo4EudQldQdxauiQhdsUaqjai54MbyXa
	IJJ0vbDvajbjywYLs0yYFug0PCQKLyQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-D4kZcaC-Mi6Q6v1mB372EQ-1; Fri, 13 Jan 2023 04:43:43 -0500
X-MC-Unique: D4kZcaC-Mi6Q6v1mB372EQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1C5818E0A66;
	Fri, 13 Jan 2023 09:43:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CF4764078903;
	Fri, 13 Jan 2023 09:43:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AF15E194705C;
	Fri, 13 Jan 2023 09:43:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C134F1946A78
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 Jan 2023 09:43:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A68DA4078904; Fri, 13 Jan 2023 09:43:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E4EA4078903
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 09:43:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8147685C6E1
 for <dm-devel@redhat.com>; Fri, 13 Jan 2023 09:43:40 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-411-xGWEiTIhPDGMr9tOwa_mrA-1; Fri,
 13 Jan 2023 04:43:36 -0500
X-MC-Unique: xGWEiTIhPDGMr9tOwa_mrA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 916645F903;
 Fri, 13 Jan 2023 09:43:35 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 64A181358A;
 Fri, 13 Jan 2023 09:43:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id SDznFscnwWOafQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 13 Jan 2023 09:43:35 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 13 Jan 2023 10:43:09 +0100
Message-Id: <20230113094310.20367-2-mwilck@suse.com>
In-Reply-To: <20230113094310.20367-1-mwilck@suse.com>
References: <20230113094310.20367-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 1/2] libmpathpersist: use conf->timeout for
 updating persistent reservations
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

On systems with many LUNs, multipathd may fail to respond within the
default timeout to a "setprkey" command because the vecs lock is held
by the path checker. Honor the globally configured uxsock timeout in
libmpathpersist.

Reported-by: boposki (github.com/opensvc/multipath-tools/pull/58)
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathpersist/mpath_updatepr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index 4529a82..36bd777 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -14,6 +14,9 @@
 #include <mpath_persist.h>
 #include "debug.h"
 #include "mpath_cmd.h"
+#include "vector.h"
+#include "globals.h"
+#include "config.h"
 #include "uxsock.h"
 #include "mpathpr.h"
 
@@ -24,6 +27,12 @@ static int do_update_pr(char *alias, char *cmd, char *key)
 	char str[256];
 	char *reply;
 	int ret = 0;
+	int timeout;
+	struct config *conf;
+
+	conf = get_multipath_config();
+	timeout = conf->uxsock_timeout;
+	put_multipath_config(conf);
 
 	fd = mpath_connect();
 	if (fd == -1) {
@@ -41,7 +50,7 @@ static int do_update_pr(char *alias, char *cmd, char *key)
 		mpath_disconnect(fd);
 		return -1;
 	}
-	ret = recv_packet(fd, &reply, DEFAULT_REPLY_TIMEOUT);
+	ret = recv_packet(fd, &reply, timeout);
 	if (ret < 0) {
 		condlog(2, "%s: message=%s recv error=%d", alias, str, errno);
 		ret = -1;
-- 
2.39.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

