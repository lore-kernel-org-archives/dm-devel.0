Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9971C433FE
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 19:33:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5EA73611AE
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 19:33:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5EA73611AE
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633548814;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5u2FbIKVDu3liJwkmWtOnr/NfQ18wd0uxpHVIM1Keek=;
	b=b0SuQHajjTHD13xuxHKWeuPt7kj9E+tVRE0wzzad4NX0TBDPGUJlTHMFWVOqNCgHoIV5lj
	rARjOkBZmpFOmN4+NpCAvknQjQBbqUM66JEgUjCuwdhePFfR3WhnyfnQzFARHQ5h21S+mD
	F4Grsj+wtA5jbv/l/nV0wHuAOMehsFg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-YV9UOSzWPPi1_ZfVWwdTLw-1; Wed, 06 Oct 2021 15:33:32 -0400
X-MC-Unique: YV9UOSzWPPi1_ZfVWwdTLw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53F3E100F945;
	Wed,  6 Oct 2021 19:33:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39B0460854;
	Wed,  6 Oct 2021 19:33:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 12EAE1801241;
	Wed,  6 Oct 2021 19:33:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
	[10.5.11.13])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196JQ9sh016720 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 15:26:09 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 543106091B; Wed,  6 Oct 2021 19:26:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3697D60936;
	Wed,  6 Oct 2021 19:25:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 196JPuDk025281; 
	Wed, 6 Oct 2021 14:25:56 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 196JPu7e025280;
	Wed, 6 Oct 2021 14:25:56 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  6 Oct 2021 14:25:50 -0500
Message-Id: <1633548350-25227-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633548350-25227-1-git-send-email-bmarzins@redhat.com>
References: <1633548350-25227-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 4/4] multipathd: add "reconfigure all" command.
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

With this commit, multipathd no longer defaults to full reconfigures for
the "reconfigure" command and the HUP signal. The default is a weak
reconfigure. A new command, "reconfigure all", has been added to do
a full reconfigure.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/main.c          |  2 +-
 multipathd/cli.c          |  1 +
 multipathd/cli.h          |  2 ++
 multipathd/cli_handlers.c | 10 ++++++++++
 multipathd/main.c         |  2 +-
 multipathd/multipathd.8   | 10 ++++++++--
 6 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index 65ece830..7b9797ec 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -759,7 +759,7 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
 		return NOT_DELEGATED;
 
 	if (cmd == CMD_CREATE && conf->force_reload == FORCE_RELOAD_YES) {
-		p += snprintf(p, n, "reconfigure");
+		p += snprintf(p, n, "reconfigure all");
 	}
 	else if (cmd == CMD_FLUSH_ONE && dev && dev_type == DEV_DEVMAP) {
 		p += snprintf(p, n, "del map %s", dev);
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 414f6608..d9308bdf 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -212,6 +212,7 @@ load_keys (void)
 	r += add_key(keys, "local", LOCAL, 0);
 	r += add_key(keys, "setmarginal", SETMARGINAL, 0);
 	r += add_key(keys, "unsetmarginal", UNSETMARGINAL, 0);
+	r += add_key(keys, "all", ALL, 0);
 
 
 	if (r) {
diff --git a/multipathd/cli.h b/multipathd/cli.h
index fcb6af00..bba705e8 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -47,6 +47,7 @@ enum {
 	__LOCAL,			/* 40 */
 	__SETMARGINAL,
 	__UNSETMARGINAL,
+	__ALL,
 };
 
 #define LIST		(1ULL << __LIST)
@@ -93,6 +94,7 @@ enum {
 #define LOCAL		(1ULL << __LOCAL)
 #define SETMARGINAL	(1ULL << __SETMARGINAL)
 #define UNSETMARGINAL	(1ULL << __UNSETMARGINAL)
+#define ALL		(1ULL << __ALL)
 
 #define INITIAL_REPLY_LEN	1200
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index b12a4e7e..58b9916c 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1012,6 +1012,15 @@ cli_reconfigure(void * v, struct strbuf *reply, void * data)
 {
 	condlog(2, "reconfigure (operator)");
 
+	schedule_reconfigure(false);
+	return 0;
+}
+
+int
+cli_reconfigure_all(void * v, struct strbuf *reply, void * data)
+{
+	condlog(2, "reconfigure all (operator)");
+
 	schedule_reconfigure(true);
 	return 0;
 }
@@ -1497,6 +1506,7 @@ void init_handler_callbacks(void)
 	set_handler_callback(DEL+MAPS, cli_del_maps);
 	set_handler_callback(SWITCH+MAP+GROUP, cli_switch_group);
 	set_unlocked_handler_callback(RECONFIGURE, cli_reconfigure);
+	set_unlocked_handler_callback(RECONFIGURE+ALL, cli_reconfigure_all);
 	set_handler_callback(SUSPEND+MAP, cli_suspend);
 	set_handler_callback(RESUME+MAP, cli_resume);
 	set_handler_callback(RESIZE+MAP, cli_resize);
diff --git a/multipathd/main.c b/multipathd/main.c
index 5c831e8d..cc4a4a5d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2817,7 +2817,7 @@ handle_signals(bool nonfatal)
 		return;
 	if (reconfig_sig) {
 		condlog(2, "reconfigure (signal)");
-		schedule_reconfigure(true);
+		schedule_reconfigure(false);
 	}
 	if (log_reset_sig) {
 		condlog(2, "reset log (signal)");
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 048a838d..e60d7f7f 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -195,10 +195,16 @@ group index, starting with 1.
 .
 .TP
 .B reconfigure
-Reconfigures the multipaths. This should be triggered automatically after anyi
-hotplug event.
+Rereads the configuration, and reloads all changed multipath devices. This
+also happens at startup, when the service is reload, or when a SIGHUP is
+received.
 .
 .TP
+.B reconfigure all
+Rereads the configuration, and reloads all multipath devices regardless of
+whether or not they have changed. This also happens when \fImultipath -r\fR is
+run.
+.TP
 .B suspend map|multipath $map
 Sets map $map into suspend state.
 .
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

