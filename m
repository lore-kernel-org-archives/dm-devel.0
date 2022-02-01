Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97F31C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  1 Feb 2022 23:40:48 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-EbLUFJ8APO2XZRKE3kInQg-1; Tue, 01 Feb 2022 18:40:44 -0500
X-MC-Unique: EbLUFJ8APO2XZRKE3kInQg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EB9C184608A;
	Tue,  1 Feb 2022 23:40:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA0C51037F3E;
	Tue,  1 Feb 2022 23:40:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 956ED1809C88;
	Tue,  1 Feb 2022 23:40:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 211Nebaf026649 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Feb 2022 18:40:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7D2C776C5; Tue,  1 Feb 2022 23:40:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7878D76CD
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 23:40:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B4AF01044560
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 23:40:32 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-441-67jBU99INE6uagXThG4P7A-1; Tue, 01 Feb 2022 18:40:31 -0500
X-MC-Unique: 67jBU99INE6uagXThG4P7A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C425121114;
	Tue,  1 Feb 2022 23:40:29 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8CD2713B8F;
	Tue,  1 Feb 2022 23:40:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id YPY4IO3E+WH4dAAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 01 Feb 2022 23:40:29 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  2 Feb 2022 00:40:21 +0100
Message-Id: <20220201234024.27675-4-mwilck@suse.com>
In-Reply-To: <20220201234024.27675-1-mwilck@suse.com>
References: <20220201234024.27675-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 211Nebaf026649
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 3/6] multipath-tools: install
	modules-load.d/multipath.conf
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

If multipath-tools is installed, we want to load the dm-multipath
module early on, because multipath -u might spit out irritating
error messages in syslog otherwise.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc                | 1 +
 multipath/Makefile          | 3 +++
 multipath/modules-load.conf | 3 +++
 3 files changed, 7 insertions(+)
 create mode 100644 multipath/modules-load.conf

diff --git a/Makefile.inc b/Makefile.inc
index c5f1fa5..5223c96 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -73,6 +73,7 @@ usr_prefix	= $(prefix)
 bindir		= $(exec_prefix)/sbin
 libudevdir	= $(prefix)/$(SYSTEMDPATH)/udev
 udevrulesdir	= $(libudevdir)/rules.d
+modulesloaddir  = $(prefix)/$(SYSTEMDPATH)/modules-load.d
 multipathdir	= $(TOPDIR)/libmultipath
 man8dir		= $(prefix)/usr/share/man/man8
 man5dir		= $(prefix)/usr/share/man/man5
diff --git a/multipath/Makefile b/multipath/Makefile
index c690368..015f73c 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -23,6 +23,8 @@ install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(udevrulesdir)
 	$(INSTALL_PROGRAM) -m 644 11-dm-mpath.rules $(DESTDIR)$(udevrulesdir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).rules $(DESTDIR)$(udevrulesdir)/56-multipath.rules
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(modulesloaddir)
+	$(INSTALL_PROGRAM) -m 644 modules-load.conf $(DESTDIR)$(modulesloaddir)/multipath.conf
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man8dir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(man8dir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
@@ -31,6 +33,7 @@ install:
 uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
 	$(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
+	$(RM) $(DESTDIR)$(modulesloaddir)/multipath.conf
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
 	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8
 	$(RM) $(DESTDIR)$(man5dir)/$(EXEC).conf.5
diff --git a/multipath/modules-load.conf b/multipath/modules-load.conf
new file mode 100644
index 0000000..b517d32
--- /dev/null
+++ b/multipath/modules-load.conf
@@ -0,0 +1,3 @@
+# load dm-multipath early, both multipathd and multipath depend on it
+# (note that multipath may be called from udev rules!)
+dm-multipath
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

