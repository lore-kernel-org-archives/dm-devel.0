Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45655EE7FF4
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450393;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1vSj0+T2SOSdS99wOaDOXDNMnCuaqGZMOPdwpHI9jl0=;
	b=SSc3ZMTHD1g6ZqVCA2mXz9OWCRQCNUaKCc+Zqhfq+wiloITunIwzEdF9Tu8136MaGm7sZY
	Cd25MU7kCVjvSBdrwUPcTeLdXUNzAYjFverHacyIRMQHS9cxy9vqGO/bpMdzVvzDcQY35a
	HtzlkdverwQavBbDRM+GyNbZmtd8Vbo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-Xs_X9tB6O7aotdS2lhsBlA-1; Mon, 11 Sep 2023 12:39:50 -0400
X-MC-Unique: Xs_X9tB6O7aotdS2lhsBlA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D2BD63815F01;
	Mon, 11 Sep 2023 16:39:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BC86E44029;
	Mon, 11 Sep 2023 16:39:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B071919465B7;
	Mon, 11 Sep 2023 16:39:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5BC6819465A2
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3F3BB40C6EA8; Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3823640C6EC0
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 198C6181A719
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-fFkM_rd1M5SyOJE8a_iaMg-1; Mon,
 11 Sep 2023 12:39:24 -0400
X-MC-Unique: fFkM_rd1M5SyOJE8a_iaMg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 2059E1F8C3;
 Mon, 11 Sep 2023 16:39:23 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E6648139CC;
 Mon, 11 Sep 2023 16:39:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id OG+VNrpC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:22 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:42 +0200
Message-ID: <20230911163846.27197-34-mwilck@suse.com>
In-Reply-To: <20230911163846.27197-1-mwilck@suse.com>
References: <20230911163846.27197-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v2 33/37] multipath-tools: README.md: improve
 documentation for compile-time options
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 README.md | 38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/README.md b/README.md
index a7f994a..679e55b 100644
--- a/README.md
+++ b/README.md
@@ -89,9 +89,17 @@ The following variables can be passed to the `make` command line:
  * `plugindir="/some/path"`: directory where libmultipath plugins (path
    checkers, prioritizers, and foreign multipath support) will be looked up.
    This used to be the run-time option `multipath_dir` in earlier versions.
- * `configdir="/some/path"` : directory to search for configuration files.
+   The default is `$(prefix)/$(LIB)/multipath`, where `$(LIB)` is `lib64` on
+   systems that have `/lib64`, and `lib` otherwise.
+ * `configfile="/some/path`": The path to the main configuration file.
+    The defalt is `$(etc_prefix)/etc/multipath.conf`.
+ * `configdir="/some/path"` : directory to search for additional configuration files.
     This used to be the run-time option `config_dir` in earlier versions.
-	The default is `/etc/multipath/conf.d`.
+	The default is `$(etc_prefix)/etc/multipath/conf.d`.
+ * `statedir="/some/path"`: The path of the directory where multipath-tools
+    stores run-time settings that need persist between reboots, such as known
+	WWIDs, user-friendly names, and persistent reservation keys.
+	The default is `$(etc_prefix)/etc/multipath`.
  * `READLINE=libedit` or `READLINE=libreadline`: enable command line history
     and TAB completion in the interactive mode *(which is entered with `multipathd -k` or `multipathc`)*.
     The respective development package will be required for building.
@@ -119,21 +127,27 @@ The following variables can be passed to the `make` command line:
 ### Installation Paths
 
  * `prefix`: The directory prefix for (almost) all files to be installed.
-   Distributions may want to set this to `/usr`.
-   **Note**: for multipath-tools, unlike many other packages, `prefix`
-   defaults to the empty string, which resolves to the root directory (`/`).
+   "Usr-merged" distributions[^systemd] may want to set this to `/usr`. The
+   default is empty (`""`).
  * `usr_prefix`: where to install those parts of the code that aren't necessary
-   for booting. You may want to set this to `/usr` if `prefix` is empty.
- * `systemd_prefix`: Prefix for systemd-related files. It defaults to `/usr`.
-   Some systemd installations use separate `prefix` and `rootprefix`. On such
-   a distribution, set `prefix`, and override `unitdir` to use systemd's
-   `rootprefix`.
+   for booting. Non-usr-merged distributions[^systemd] may want to set this to
+   `/usr`. The default is `$(prefix)`.
+ * `systemd_prefix`: Prefix for systemd-related files[^systemd]. The default is `/usr`.
+ * `etc_prefix`: The prefix for configuration files. "Usr-merged"
+   distributions with immutable `/usr`[^systemd] may want to set this to
+   `/etc`. The default is `$(prefix)`.
  * `LIB`: the subdirectory under `prefix` where shared libraries will be
    installed. By default, the makefile uses `/lib64` if this directory is
    found on the build system, and `/lib` otherwise.
    
-See also `configdir` and `plugindir` above. See `Makefile.inc` for more
-fine-grained control.
+The options `configdir`, `plugindir`, `configfile`, and `statedir` above can
+be used for setting indvidual paths where the `prefix` variables don't provide
+sufficient control. See `Makefile.inc` for even more fine-grained control.
+
+[^systemd]: Some systemd installations use separate `prefix` and `rootprefix`. 
+	On such a distribution, set `prefix`, and override `unitdir` to use systemd's
+   `rootprefix`. Recent systemd releases generally require everything to be
+	installed under `/usr` (so-called "usr-merged" distribution). On "usr-
 
 ### Compiler Options
 
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

