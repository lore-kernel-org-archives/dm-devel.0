Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 468D5C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:43 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-123-Tv4346XyNmiUHhsLzA6zmA-1; Sat, 27 Nov 2021 10:20:40 -0500
X-MC-Unique: Tv4346XyNmiUHhsLzA6zmA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAE3710168C4;
	Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A15625F4E9;
	Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7CF451809CB8;
	Sat, 27 Nov 2021 15:20:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJoUB032717 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C271451E5; Sat, 27 Nov 2021 15:19:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCB5E51DC
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F086805B0A
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:49 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-542-FMDl4MhoPqS3PkkyDPwuWQ-1; Sat, 27 Nov 2021 10:19:47 -0500
X-MC-Unique: FMDl4MhoPqS3PkkyDPwuWQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1B6F62170C;
	Sat, 27 Nov 2021 15:19:46 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C61A013AAD;
	Sat, 27 Nov 2021 15:19:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id WNVELpFMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:45 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:05 +0100
Message-Id: <20211127151929.7727-13-mwilck@suse.com>
In-Reply-To: <20211127151929.7727-1-mwilck@suse.com>
References: <20211127151929.7727-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJoUB032717
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 12/35] multipathd: add and set cli_handlers in
	a single step
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Modify set_handler_callback() such that a missing slot is created
if no matching slot is found. This way, we can skip the initialization
with NULL handlers on startup. Assigning the same handler multiple
times would be a bug which is tested with assert().

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli.c | 95 ++++++++----------------------------------------
 multipathd/cli.h |  7 ++--
 2 files changed, 19 insertions(+), 83 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index 3582370..c1fa7ce 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -4,6 +4,7 @@
 #include <sys/time.h>
 #include <errno.h>
 #include <pthread.h>
+#include <assert.h>
 #include "vector.h"
 #include "structs.h"
 #include "structs_vec.h"
@@ -63,26 +64,26 @@ out:
 	return 1;
 }
 
-int
-add_handler (uint64_t fp, cli_handler *fn)
+static struct handler *add_handler(uint64_t fp, cli_handler *fn, bool locked)
 {
 	struct handler * h;
 
 	h = alloc_handler();
 
-	if (!h)
-		return 1;
+	if (h == NULL)
+		return NULL;
 
 	if (!vector_alloc_slot(handlers)) {
 		free(h);
-		return 1;
+		return NULL;
 	}
 
 	vector_set_slot(handlers, h);
 	h->fingerprint = fp;
 	h->fn = fn;
+	h->locked = locked;
 
-	return 0;
+	return h;
 }
 
 static struct handler *
@@ -99,26 +100,17 @@ find_handler (uint64_t fp)
 }
 
 int
-set_handler_callback (uint64_t fp, cli_handler *fn)
+__set_handler_callback (uint64_t fp, cli_handler *fn, bool locked)
 {
-	struct handler * h = find_handler(fp);
+	struct handler *h;
 
-	if (!h)
+	assert(find_handler(fp) == NULL);
+        h = add_handler(fp, fn, locked);
+        if (!h) {
+		condlog(0, "%s: failed to set handler for code %"PRIu64,
+			__func__, fp);
 		return 1;
-	h->fn = fn;
-	h->locked = 1;
-	return 0;
-}
-
-int
-set_unlocked_handler_callback (uint64_t fp, cli_handler *fn)
-{
-	struct handler * h = find_handler(fp);
-
-	if (!h)
-		return 1;
-	h->fn = fn;
-	h->locked = 0;
+	}
 	return 0;
 }
 
@@ -512,63 +504,6 @@ cli_init (void) {
 	if (alloc_handlers())
 		return 1;
 
-	add_handler(LIST+PATHS, NULL);
-	add_handler(LIST+PATHS+FMT, NULL);
-	add_handler(LIST+PATHS+RAW+FMT, NULL);
-	add_handler(LIST+PATH, NULL);
-	add_handler(LIST+STATUS, NULL);
-	add_handler(LIST+DAEMON, NULL);
-	add_handler(LIST+MAPS, NULL);
-	add_handler(LIST+MAPS+STATUS, NULL);
-	add_handler(LIST+MAPS+STATS, NULL);
-	add_handler(LIST+MAPS+FMT, NULL);
-	add_handler(LIST+MAPS+RAW+FMT, NULL);
-	add_handler(LIST+MAPS+TOPOLOGY, NULL);
-	add_handler(LIST+MAPS+JSON, NULL);
-	add_handler(LIST+TOPOLOGY, NULL);
-	add_handler(LIST+MAP+TOPOLOGY, NULL);
-	add_handler(LIST+MAP+JSON, NULL);
-	add_handler(LIST+MAP+FMT, NULL);
-	add_handler(LIST+MAP+RAW+FMT, NULL);
-	add_handler(LIST+CONFIG, NULL);
-	add_handler(LIST+CONFIG+LOCAL, NULL);
-	add_handler(LIST+BLACKLIST, NULL);
-	add_handler(LIST+DEVICES, NULL);
-	add_handler(LIST+WILDCARDS, NULL);
-	add_handler(RESET+MAPS+STATS, NULL);
-	add_handler(RESET+MAP+STATS, NULL);
-	add_handler(ADD+PATH, NULL);
-	add_handler(DEL+PATH, NULL);
-	add_handler(ADD+MAP, NULL);
-	add_handler(DEL+MAP, NULL);
-	add_handler(DEL+MAPS, NULL);
-	add_handler(SWITCH+MAP+GROUP, NULL);
-	add_handler(RECONFIGURE, NULL);
-	add_handler(SUSPEND+MAP, NULL);
-	add_handler(RESUME+MAP, NULL);
-	add_handler(RESIZE+MAP, NULL);
-	add_handler(RESET+MAP, NULL);
-	add_handler(RELOAD+MAP, NULL);
-	add_handler(DISABLEQ+MAP, NULL);
-	add_handler(RESTOREQ+MAP, NULL);
-	add_handler(DISABLEQ+MAPS, NULL);
-	add_handler(RESTOREQ+MAPS, NULL);
-	add_handler(REINSTATE+PATH, NULL);
-	add_handler(FAIL+PATH, NULL);
-	add_handler(QUIT, NULL);
-	add_handler(SHUTDOWN, NULL);
-	add_handler(GETPRSTATUS+MAP, NULL);
-	add_handler(SETPRSTATUS+MAP, NULL);
-	add_handler(UNSETPRSTATUS+MAP, NULL);
-	add_handler(GETPRKEY+MAP, NULL);
-	add_handler(SETPRKEY+MAP+KEY, NULL);
-	add_handler(UNSETPRKEY+MAP, NULL);
-	add_handler(FORCEQ+DAEMON, NULL);
-	add_handler(RESTOREQ+DAEMON, NULL);
-	add_handler(SETMARGINAL+PATH, NULL);
-	add_handler(UNSETMARGINAL+PATH, NULL);
-	add_handler(UNSETMARGINAL+MAP, NULL);
-
 	return 0;
 }
 
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 84b1fbe..07fd61b 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -133,9 +133,10 @@ struct handler {
 };
 
 int alloc_handlers (void);
-int add_handler (uint64_t fp, cli_handler *fn);
-int set_handler_callback (uint64_t fp, cli_handler *fn);
-int set_unlocked_handler_callback (uint64_t fp, cli_handler *fn);
+int __set_handler_callback (uint64_t fp, cli_handler *fn, bool locked);
+#define set_handler_callback(fp, fn) __set_handler_callback(fp, fn, true)
+#define set_unlocked_handler_callback(fp, fn) __set_handler_callback(fp, fn, false)
+
 int parse_cmd (char * cmd, char ** reply, int * len, void *, int);
 int load_keys (void);
 char * get_keyparam (vector v, uint64_t code);
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

