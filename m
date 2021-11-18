Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D77C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CCE5561A7D
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:05:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CCE5561A7D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-535-eRomYQyHOwCO-QMSRjeeIg-1; Thu, 18 Nov 2021 18:05:11 -0500
X-MC-Unique: eRomYQyHOwCO-QMSRjeeIg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A57F1926DB3;
	Thu, 18 Nov 2021 23:05:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 05F5626FA3;
	Thu, 18 Nov 2021 23:05:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CF13B4EA31;
	Thu, 18 Nov 2021 23:05:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMxFfb002337 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B6BE72026D64; Thu, 18 Nov 2021 22:59:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B25CA2026D46
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A3001066682
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:15 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-370-YKwze_dZN6mXnrEspRHcpw-1; Thu, 18 Nov 2021 17:59:11 -0500
X-MC-Unique: YKwze_dZN6mXnrEspRHcpw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 88AB22177B;
	Thu, 18 Nov 2021 22:59:10 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 41AF313B11;
	Thu, 18 Nov 2021 22:59:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id +OMfDr7almGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:59:10 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:58:31 +0100
Message-Id: <20211118225840.19810-40-mwilck@suse.com>
In-Reply-To: <20211118225840.19810-1-mwilck@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMxFfb002337
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 39/48] multipathd: add "reconfigure all"
	command.
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Benjamin Marzinski <bmarzins@redhat.com>

With this commit, multipathd no longer defaults to full reconfigures for
the "reconfigure" command and the HUP signal. The default is a weak
reconfigure. A new command, "reconfigure all", has been added to do
a full reconfigure.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/main.c          |  2 +-
 multipathd/cli.c          |  1 +
 multipathd/cli.h          |  2 ++
 multipathd/cli_handlers.c | 10 ++++++++++
 multipathd/main.c         |  2 +-
 multipathd/multipathd.8   | 10 ++++++++--
 6 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/multipath/main.c b/multipath/main.c
index b2d300e..47e799b 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -760,7 +760,7 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
 		return NOT_DELEGATED;
 
 	if (cmd == CMD_CREATE && conf->force_reload == FORCE_RELOAD_YES) {
-		p += snprintf(p, n, "reconfigure");
+		p += snprintf(p, n, "reconfigure all");
 	}
 	else if (cmd == CMD_FLUSH_ONE && dev && dev_type == DEV_DEVMAP) {
 		p += snprintf(p, n, "del map %s", dev);
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 1c6351e..b42db81 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -210,6 +210,7 @@ load_keys (void)
 	r += add_key(keys, "local", LOCAL, 0);
 	r += add_key(keys, "setmarginal", SETMARGINAL, 0);
 	r += add_key(keys, "unsetmarginal", UNSETMARGINAL, 0);
+	r += add_key(keys, "all", ALL, 0);
 
 
 	if (r) {
diff --git a/multipathd/cli.h b/multipathd/cli.h
index b05746f..21685fc 100644
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
index d165675..f89f4e7 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1012,6 +1012,15 @@ cli_reconfigure(void * v, struct strbuf *reply, void * data)
 {
 	condlog(2, "reconfigure (operator)");
 
+	schedule_reconfigure(FORCE_RELOAD_WEAK);
+	return 0;
+}
+
+int
+cli_reconfigure_all(void * v, struct strbuf *reply, void * data)
+{
+	condlog(2, "reconfigure all (operator)");
+
 	schedule_reconfigure(FORCE_RELOAD_YES);
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
index 1efbaab..f8a422a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2818,7 +2818,7 @@ handle_signals(bool nonfatal)
 		return;
 	if (reconfig_sig) {
 		condlog(2, "reconfigure (signal)");
-		schedule_reconfigure(FORCE_RELOAD_YES);
+		schedule_reconfigure(FORCE_RELOAD_WEAK);
 	}
 	if (log_reset_sig) {
 		condlog(2, "reset log (signal)");
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 048a838..e60d7f7 100644
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
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

