Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC811ECAAD2
	for <dm-devel@archiver.kernel.org>; Thu,  1 Sep 2022 22:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662070170;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JdQFWdW5AU7xGWc7owBhR+lw9FuDM1ETD60gQlmJfC0=;
	b=hv1zLmPxWRYIAhbuHlZmoj+avWmw+abwGtq5vcPJt6ihONAFZggJUsSSO434JNJIDtwNK+
	I1tjK7aV+UGl5xmxZSMNB94t7QhsSk8UsLaT1BzyP43q8s7BmYaxUTxmp7JDNhBW3q0wcp
	qAajSnr5tWXstVeafykp9dyRZm0YJr0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-141-S7P78Iq7PzSLpPZtHNvoQg-1; Thu, 01 Sep 2022 18:09:29 -0400
X-MC-Unique: S7P78Iq7PzSLpPZtHNvoQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33AA01C051B1;
	Thu,  1 Sep 2022 22:09:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7A3971121314;
	Thu,  1 Sep 2022 22:09:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2727F19426AB;
	Thu,  1 Sep 2022 22:09:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C7D251946A5E
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Sep 2022 22:09:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9920F2166B2A; Thu,  1 Sep 2022 22:09:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 953F22166B26
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 22:09:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7311E3C0ED5A
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 22:09:23 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-372-kEK9wQmJMj2KGJU6sA8Frg-1; Thu,
 01 Sep 2022 18:09:21 -0400
X-MC-Unique: kEK9wQmJMj2KGJU6sA8Frg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 4F471206C3;
 Thu,  1 Sep 2022 22:09:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 101B413A89;
 Thu,  1 Sep 2022 22:09:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id +M1BApAtEWMuFQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 01 Sep 2022 22:09:20 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  2 Sep 2022 00:09:12 +0200
Message-Id: <20220901220912.4894-2-mwilck@suse.com>
In-Reply-To: <20220901220912.4894-1-mwilck@suse.com>
References: <20220901220912.4894-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH v2 16/16] multipathd: Fix command completion in
 interactive mode
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The command completion never worked, because the handlers
array wasn't initialized in client mode.

The handlers array is now also required in multipathc,
but it doesn't need the actual handler functions. To keep
multipathc as small as possible, we just add a handler table
with NULL handler functions.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/callbacks.c    | 60 +++++++++++++++++++++++++++++++++++++
 multipathd/cli.c          |  2 ++
 multipathd/cli_handlers.c | 62 ++-------------------------------------
 multipathd/main.c         |  1 -
 multipathd/multipathc.c   |  3 ++
 5 files changed, 67 insertions(+), 61 deletions(-)
 create mode 100644 multipathd/callbacks.c

diff --git a/multipathd/callbacks.c b/multipathd/callbacks.c
new file mode 100644
index 0000000..0bd76b7
--- /dev/null
+++ b/multipathd/callbacks.c
@@ -0,0 +1,60 @@
+void init_handler_callbacks(void)
+{
+	set_handler_callback(LIST+PATHS, HANDLER(cli_list_paths));
+	set_handler_callback(LIST+PATHS+FMT, HANDLER(cli_list_paths_fmt));
+	set_handler_callback(LIST+PATHS+RAW+FMT, HANDLER(cli_list_paths_raw));
+	set_handler_callback(LIST+PATH, HANDLER(cli_list_path));
+	set_handler_callback(LIST+MAPS, HANDLER(cli_list_maps));
+	set_handler_callback(LIST+STATUS, HANDLER(cli_list_status));
+	set_unlocked_handler_callback(LIST+DAEMON, HANDLER(cli_list_daemon));
+	set_handler_callback(LIST+MAPS+STATUS, HANDLER(cli_list_maps_status));
+	set_handler_callback(LIST+MAPS+STATS, HANDLER(cli_list_maps_stats));
+	set_handler_callback(LIST+MAPS+FMT, HANDLER(cli_list_maps_fmt));
+	set_handler_callback(LIST+MAPS+RAW+FMT, HANDLER(cli_list_maps_raw));
+	set_handler_callback(LIST+MAPS+TOPOLOGY, HANDLER(cli_list_maps_topology));
+	set_handler_callback(LIST+TOPOLOGY, HANDLER(cli_list_maps_topology));
+	set_handler_callback(LIST+MAPS+JSON, HANDLER(cli_list_maps_json));
+	set_handler_callback(LIST+MAP+TOPOLOGY, HANDLER(cli_list_map_topology));
+	set_handler_callback(LIST+MAP+FMT, HANDLER(cli_list_map_fmt));
+	set_handler_callback(LIST+MAP+RAW+FMT, HANDLER(cli_list_map_fmt));
+	set_handler_callback(LIST+MAP+JSON, HANDLER(cli_list_map_json));
+	set_handler_callback(LIST+CONFIG+LOCAL, HANDLER(cli_list_config_local));
+	set_handler_callback(LIST+CONFIG, HANDLER(cli_list_config));
+	set_handler_callback(LIST+BLACKLIST, HANDLER(cli_list_blacklist));
+	set_handler_callback(LIST+DEVICES, HANDLER(cli_list_devices));
+	set_handler_callback(LIST+WILDCARDS, HANDLER(cli_list_wildcards));
+	set_handler_callback(RESET+MAPS+STATS, HANDLER(cli_reset_maps_stats));
+	set_handler_callback(RESET+MAP+STATS, HANDLER(cli_reset_map_stats));
+	set_handler_callback(ADD+PATH, HANDLER(cli_add_path));
+	set_handler_callback(DEL+PATH, HANDLER(cli_del_path));
+	set_handler_callback(ADD+MAP, HANDLER(cli_add_map));
+	set_handler_callback(DEL+MAP, HANDLER(cli_del_map));
+	set_handler_callback(DEL+MAPS, HANDLER(cli_del_maps));
+	set_handler_callback(SWITCH+MAP+GROUP, HANDLER(cli_switch_group));
+	set_unlocked_handler_callback(RECONFIGURE, HANDLER(cli_reconfigure));
+	set_unlocked_handler_callback(RECONFIGURE+ALL, HANDLER(cli_reconfigure_all));
+	set_handler_callback(SUSPEND+MAP, HANDLER(cli_suspend));
+	set_handler_callback(RESUME+MAP, HANDLER(cli_resume));
+	set_handler_callback(RESIZE+MAP, HANDLER(cli_resize));
+	set_handler_callback(RELOAD+MAP, HANDLER(cli_reload));
+	set_handler_callback(RESET+MAP, HANDLER(cli_reassign));
+	set_handler_callback(REINSTATE+PATH, HANDLER(cli_reinstate));
+	set_handler_callback(FAIL+PATH, HANDLER(cli_fail));
+	set_handler_callback(DISABLEQ+MAP, HANDLER(cli_disable_queueing));
+	set_handler_callback(RESTOREQ+MAP, HANDLER(cli_restore_queueing));
+	set_handler_callback(DISABLEQ+MAPS, HANDLER(cli_disable_all_queueing));
+	set_handler_callback(RESTOREQ+MAPS, HANDLER(cli_restore_all_queueing));
+	set_unlocked_handler_callback(QUIT, HANDLER(cli_quit));
+	set_unlocked_handler_callback(SHUTDOWN, HANDLER(cli_shutdown));
+	set_handler_callback(GETPRSTATUS+MAP, HANDLER(cli_getprstatus));
+	set_handler_callback(SETPRSTATUS+MAP, HANDLER(cli_setprstatus));
+	set_handler_callback(UNSETPRSTATUS+MAP, HANDLER(cli_unsetprstatus));
+	set_handler_callback(FORCEQ+DAEMON, HANDLER(cli_force_no_daemon_q));
+	set_handler_callback(RESTOREQ+DAEMON, HANDLER(cli_restore_no_daemon_q));
+	set_handler_callback(GETPRKEY+MAP, HANDLER(cli_getprkey));
+	set_handler_callback(SETPRKEY+MAP+KEY, HANDLER(cli_setprkey));
+	set_handler_callback(UNSETPRKEY+MAP, HANDLER(cli_unsetprkey));
+	set_handler_callback(SETMARGINAL+PATH, HANDLER(cli_set_marginal));
+	set_handler_callback(UNSETMARGINAL+PATH, HANDLER(cli_unset_marginal));
+	set_handler_callback(UNSETMARGINAL+MAP, HANDLER(cli_unset_all_marginal));
+}
diff --git a/multipathd/cli.c b/multipathd/cli.c
index d1bfeee..5d25ddb 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -14,6 +14,7 @@
 
 #include "mpath_cmd.h"
 #include "cli.h"
+#include "cli_handlers.h"
 #include "debug.h"
 #include "strbuf.h"
 
@@ -451,6 +452,7 @@ cli_init (void) {
 	if (alloc_handlers())
 		return 1;
 
+	init_handler_callbacks();
 	return 0;
 }
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 3d39967..5b8f647 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1519,63 +1519,5 @@ static int cli_unset_all_marginal(void * v, struct strbuf *reply, void * data)
 	return reload_and_sync_map(mpp, vecs, 0);
 }
 
-void init_handler_callbacks(void)
-{
-	set_handler_callback(LIST+PATHS, cli_list_paths);
-	set_handler_callback(LIST+PATHS+FMT, cli_list_paths_fmt);
-	set_handler_callback(LIST+PATHS+RAW+FMT, cli_list_paths_raw);
-	set_handler_callback(LIST+PATH, cli_list_path);
-	set_handler_callback(LIST+MAPS, cli_list_maps);
-	set_handler_callback(LIST+STATUS, cli_list_status);
-	set_unlocked_handler_callback(LIST+DAEMON, cli_list_daemon);
-	set_handler_callback(LIST+MAPS+STATUS, cli_list_maps_status);
-	set_handler_callback(LIST+MAPS+STATS, cli_list_maps_stats);
-	set_handler_callback(LIST+MAPS+FMT, cli_list_maps_fmt);
-	set_handler_callback(LIST+MAPS+RAW+FMT, cli_list_maps_raw);
-	set_handler_callback(LIST+MAPS+TOPOLOGY, cli_list_maps_topology);
-	set_handler_callback(LIST+TOPOLOGY, cli_list_maps_topology);
-	set_handler_callback(LIST+MAPS+JSON, cli_list_maps_json);
-	set_handler_callback(LIST+MAP+TOPOLOGY, cli_list_map_topology);
-	set_handler_callback(LIST+MAP+FMT, cli_list_map_fmt);
-	set_handler_callback(LIST+MAP+RAW+FMT, cli_list_map_fmt);
-	set_handler_callback(LIST+MAP+JSON, cli_list_map_json);
-	set_handler_callback(LIST+CONFIG+LOCAL, cli_list_config_local);
-	set_handler_callback(LIST+CONFIG, cli_list_config);
-	set_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
-	set_handler_callback(LIST+DEVICES, cli_list_devices);
-	set_handler_callback(LIST+WILDCARDS, cli_list_wildcards);
-	set_handler_callback(RESET+MAPS+STATS, cli_reset_maps_stats);
-	set_handler_callback(RESET+MAP+STATS, cli_reset_map_stats);
-	set_handler_callback(ADD+PATH, cli_add_path);
-	set_handler_callback(DEL+PATH, cli_del_path);
-	set_handler_callback(ADD+MAP, cli_add_map);
-	set_handler_callback(DEL+MAP, cli_del_map);
-	set_handler_callback(DEL+MAPS, cli_del_maps);
-	set_handler_callback(SWITCH+MAP+GROUP, cli_switch_group);
-	set_unlocked_handler_callback(RECONFIGURE, cli_reconfigure);
-	set_unlocked_handler_callback(RECONFIGURE+ALL, cli_reconfigure_all);
-	set_handler_callback(SUSPEND+MAP, cli_suspend);
-	set_handler_callback(RESUME+MAP, cli_resume);
-	set_handler_callback(RESIZE+MAP, cli_resize);
-	set_handler_callback(RELOAD+MAP, cli_reload);
-	set_handler_callback(RESET+MAP, cli_reassign);
-	set_handler_callback(REINSTATE+PATH, cli_reinstate);
-	set_handler_callback(FAIL+PATH, cli_fail);
-	set_handler_callback(DISABLEQ+MAP, cli_disable_queueing);
-	set_handler_callback(RESTOREQ+MAP, cli_restore_queueing);
-	set_handler_callback(DISABLEQ+MAPS, cli_disable_all_queueing);
-	set_handler_callback(RESTOREQ+MAPS, cli_restore_all_queueing);
-	set_unlocked_handler_callback(QUIT, cli_quit);
-	set_unlocked_handler_callback(SHUTDOWN, cli_shutdown);
-	set_handler_callback(GETPRSTATUS+MAP, cli_getprstatus);
-	set_handler_callback(SETPRSTATUS+MAP, cli_setprstatus);
-	set_handler_callback(UNSETPRSTATUS+MAP, cli_unsetprstatus);
-	set_handler_callback(FORCEQ+DAEMON, cli_force_no_daemon_q);
-	set_handler_callback(RESTOREQ+DAEMON, cli_restore_no_daemon_q);
-	set_handler_callback(GETPRKEY+MAP, cli_getprkey);
-	set_handler_callback(SETPRKEY+MAP+KEY, cli_setprkey);
-	set_handler_callback(UNSETPRKEY+MAP, cli_unsetprkey);
-	set_handler_callback(SETMARGINAL+PATH, cli_set_marginal);
-	set_handler_callback(UNSETMARGINAL+PATH, cli_unset_marginal);
-	set_handler_callback(UNSETMARGINAL+MAP, cli_unset_all_marginal);
-}
+#define HANDLER(x) x
+#include "callbacks.c"
diff --git a/multipathd/main.c b/multipathd/main.c
index 4a65359..ba52d39 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1797,7 +1797,6 @@ uxlsnrloop (void * ap)
 	/* Tell main thread that thread has started */
 	post_config_state(DAEMON_CONFIGURE);
 
-	init_handler_callbacks();
 	umask(077);
 
 	/*
diff --git a/multipathd/multipathc.c b/multipathd/multipathc.c
index 9d49655..b3f7db0 100644
--- a/multipathd/multipathc.c
+++ b/multipathd/multipathc.c
@@ -274,3 +274,6 @@ int main (int argc, const char * const argv[])
 	mpath_disconnect(fd);
 	return 0;
 }
+
+#define HANDLER(x) NULL
+#include "callbacks.c"
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

