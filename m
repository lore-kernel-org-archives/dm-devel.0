Return-Path: <SRS0=FvAS=OA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FDFC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4BC4860041
	for <dm-devel@archiver.kernel.org>; Fri, 10 Sep 2021 11:43:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4BC4860041
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-daIuNCrPMiCKQnXL9c2QUQ-1; Fri, 10 Sep 2021 07:43:20 -0400
X-MC-Unique: daIuNCrPMiCKQnXL9c2QUQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D035B84A5E4;
	Fri, 10 Sep 2021 11:43:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6F051009962;
	Fri, 10 Sep 2021 11:43:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8D8A34E58F;
	Fri, 10 Sep 2021 11:43:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18ABgxBP010202 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Sep 2021 07:42:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 68DB610BC2B7; Fri, 10 Sep 2021 11:42:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6486210AF42D
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:42:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4BCC7100B8C3
	for <dm-devel@redhat.com>; Fri, 10 Sep 2021 11:42:59 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-509-ZK0Bd9BmOYu3FsZWvxWvVA-1; Fri, 10 Sep 2021 07:42:55 -0400
X-MC-Unique: ZK0Bd9BmOYu3FsZWvxWvVA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4CA8222437;
	Fri, 10 Sep 2021 11:42:54 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0320D13D34;
	Fri, 10 Sep 2021 11:42:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id uDJTOr1EO2GPOAAAMHmgww
	(envelope-from <mwilck@suse.com>); Fri, 10 Sep 2021 11:42:53 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 10 Sep 2021 13:40:57 +0200
Message-Id: <20210910114120.13665-13-mwilck@suse.com>
In-Reply-To: <20210910114120.13665-1-mwilck@suse.com>
References: <20210910114120.13665-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18ABgxBP010202
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 12/35] multipathd: add and set cli_handlers in a
	single step
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Modify set_handler_callback() such that a missing slot is created
if no matching slot is found. This way, we can skip the initialization
with NULL handlers on startup.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli.c | 85 +++++++-----------------------------------------
 multipathd/cli.h |  6 ++--
 2 files changed, 15 insertions(+), 76 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index 5213813..7020d2b 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -100,26 +100,20 @@ find_handler (uint64_t fp)
 }
 
 int
-set_handler_callback (uint64_t fp, cli_handler *fn)
+__set_handler_callback (uint64_t fp, cli_handler *fn, bool locked)
 {
-	struct handler * h = find_handler(fp);
+	struct handler *h = find_handler(fp);
 
-	if (!h)
+	if (!h) {
+		add_handler(fp, fn);
+		h = find_handler(fp);
+	}
+	if (!h) {
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
+	h->locked = locked;
 	return 0;
 }
 
@@ -513,63 +507,6 @@ cli_init (void) {
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
index 3dac1b4..dbb75be 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -134,8 +134,10 @@ struct handler {
 
 int alloc_handlers (void);
 int add_handler (uint64_t fp, cli_handler *fn);
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
2.33.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

