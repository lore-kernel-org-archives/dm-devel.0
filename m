Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D540CA0FF4
	for <dm-devel@archiver.kernel.org>; Fri,  1 Sep 2023 18:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693591409;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YqradqieUeyyS36hjN+rqQ5NgWjmOnFaDspqtQv0WAc=;
	b=fHV8qzVuq0u2oM/tN6OSuitKfzHKvSjjnpVEvbDSTVyKJUZaDRgdxSFeRLISa3FhFNbm0j
	deVvvqhbolkQVNryeEK3oP04S0KphrtcJGlQPu9i1C7kWvB6vqnWphJHRm/20cT48tXq4t
	KD/w2Qaw1XSxnoHINcqzHr3vwlUTOaw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-7nAG2YmUNxeYhQaLKJn5tQ-1; Fri, 01 Sep 2023 14:03:26 -0400
X-MC-Unique: 7nAG2YmUNxeYhQaLKJn5tQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 42CC81C18C9B;
	Fri,  1 Sep 2023 18:03:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2AE3D20C3B2A;
	Fri,  1 Sep 2023 18:03:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E695C194729D;
	Fri,  1 Sep 2023 18:03:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8096219472AD
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Sep 2023 18:03:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7021F1460FE7; Fri,  1 Sep 2023 18:03:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 699DC1402C0A
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DF7610264FA
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:21 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-qLFsq1_sOKWx0zaV32HuhQ-1; Fri,
 01 Sep 2023 14:03:17 -0400
X-MC-Unique: qLFsq1_sOKWx0zaV32HuhQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id A0B2E21865;
 Fri,  1 Sep 2023 18:03:16 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4304713582;
 Fri,  1 Sep 2023 18:03:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id ANGeDWQn8mTpRQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 01 Sep 2023 18:03:16 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  1 Sep 2023 20:02:15 +0200
Message-ID: <20230901180235.23980-3-mwilck@suse.com>
In-Reply-To: <20230901180235.23980-1-mwilck@suse.com>
References: <20230901180235.23980-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 02/21] libmultipath: add alias_already_taken()
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>,
 David Bond <dbond@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Factor out a trivial helper function.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: David Bond <dbond@suse.com>
---
 libmultipath/alias.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index c0139a2..abde08c 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -8,6 +8,7 @@
 #include <string.h>
 #include <limits.h>
 #include <stdio.h>
+#include <stdbool.h>
 
 #include "debug.h"
 #include "util.h"
@@ -109,8 +110,24 @@ scan_devname(const char *alias, const char *prefix)
 	return n;
 }
 
-static int
-id_already_taken(int id, const char *prefix, const char *map_wwid)
+static bool alias_already_taken(const char *alias, const char *map_wwid)
+{
+
+	if (dm_map_present(alias)) {
+		char wwid[WWID_SIZE];
+
+		/* If both the name and the wwid match, then it's fine.*/
+		if (dm_get_uuid(alias, wwid, sizeof(wwid)) == 0 &&
+		    strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
+			return false;
+		condlog(3, "%s: alias '%s' already taken, but not in bindings file. reselecting alias",
+			map_wwid, alias);
+		return true;
+	}
+	return false;
+}
+
+static bool id_already_taken(int id, const char *prefix, const char *map_wwid)
 {
 	STRBUF_ON_STACK(buf);
 	const char *alias;
@@ -120,20 +137,9 @@ id_already_taken(int id, const char *prefix, const char *map_wwid)
 		return 0;
 
 	alias = get_strbuf_str(&buf);
-	if (dm_map_present(alias)) {
-		char wwid[WWID_SIZE];
-
-		/* If both the name and the wwid match, then it's fine.*/
-		if (dm_get_uuid(alias, wwid, sizeof(wwid)) == 0 &&
-		    strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
-			return 0;
-		condlog(3, "%s: alias '%s' already taken, but not in bindings file. reselecting alias", map_wwid, alias);
-		return 1;
-	}
-	return 0;
+	return alias_already_taken(alias, map_wwid);
 }
 
-
 /*
  * Returns: 0   if matching entry in WWIDs file found
  *         -1   if an error occurs
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

