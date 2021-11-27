Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5334AC433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-345-4X15XXMMOACYrp9-s2qnJQ-1; Sat, 27 Nov 2021 10:20:34 -0500
X-MC-Unique: 4X15XXMMOACYrp9-s2qnJQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFB558042E1;
	Sat, 27 Nov 2021 15:20:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B5E8C5DF2E;
	Sat, 27 Nov 2021 15:20:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 94E031809CB8;
	Sat, 27 Nov 2021 15:20:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJmkb032679 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B6C15404727C; Sat, 27 Nov 2021 15:19:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B27E84047272
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99ECF811E76
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:48 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-235-jjFWVQgFNnCxag9Cstu6Eg-1; Sat, 27 Nov 2021 10:19:46 -0500
X-MC-Unique: jjFWVQgFNnCxag9Cstu6Eg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 564EE21709;
	Sat, 27 Nov 2021 15:19:45 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 08A4013AAD;
	Sat, 27 Nov 2021 15:19:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 4EaOO5BMomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:44 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:19:03 +0100
Message-Id: <20211127151929.7727-11-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJmkb032679
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 10/35] multipathd: add prototype for
	cli_handler functions
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Use a typedef instead of spelling out the function type everywhere.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/cli.c |  6 +++---
 multipathd/cli.h | 10 ++++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/multipathd/cli.c b/multipathd/cli.c
index bddf172..3582370 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -64,7 +64,7 @@ out:
 }
 
 int
-add_handler (uint64_t fp, int (*fn)(void *, char **, int *, void *))
+add_handler (uint64_t fp, cli_handler *fn)
 {
 	struct handler * h;
 
@@ -99,7 +99,7 @@ find_handler (uint64_t fp)
 }
 
 int
-set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *))
+set_handler_callback (uint64_t fp, cli_handler *fn)
 {
 	struct handler * h = find_handler(fp);
 
@@ -111,7 +111,7 @@ set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *))
 }
 
 int
-set_unlocked_handler_callback (uint64_t fp,int (*fn)(void *, char **, int *, void *))
+set_unlocked_handler_callback (uint64_t fp, cli_handler *fn)
 {
 	struct handler * h = find_handler(fp);
 
diff --git a/multipathd/cli.h b/multipathd/cli.h
index 6a68107..84b1fbe 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -124,16 +124,18 @@ struct key {
 	int has_param;
 };
 
+typedef int (cli_handler)(void *keywords, char **reply, int *len, void *data);
+
 struct handler {
 	uint64_t fingerprint;
 	int locked;
-	int (*fn)(void *, char **, int *, void *);
+	cli_handler *fn;
 };
 
 int alloc_handlers (void);
-int add_handler (uint64_t fp, int (*fn)(void *, char **, int *, void *));
-int set_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *));
-int set_unlocked_handler_callback (uint64_t fp, int (*fn)(void *, char **, int *, void *));
+int add_handler (uint64_t fp, cli_handler *fn);
+int set_handler_callback (uint64_t fp, cli_handler *fn);
+int set_unlocked_handler_callback (uint64_t fp, cli_handler *fn);
 int parse_cmd (char * cmd, char ** reply, int * len, void *, int);
 int load_keys (void);
 char * get_keyparam (vector v, uint64_t code);
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

