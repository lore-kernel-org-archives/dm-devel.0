Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A1A4C43217
	for <dm-devel@archiver.kernel.org>; Tue,  1 Feb 2022 23:40:59 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-TYHFU3L5OoiNneoP9cZZ7w-1; Tue, 01 Feb 2022 18:40:57 -0500
X-MC-Unique: TYHFU3L5OoiNneoP9cZZ7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0367734772;
	Tue,  1 Feb 2022 23:40:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D77127A226;
	Tue,  1 Feb 2022 23:40:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B0D584A7CD;
	Tue,  1 Feb 2022 23:40:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 211NecoL026654 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Feb 2022 18:40:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 364612026990; Tue,  1 Feb 2022 23:40:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 31A362026985
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 23:40:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17C411C05AC9
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 23:40:35 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-636-HGiTkVF0NtaJQNPolQm5aA-1; Tue, 01 Feb 2022 18:40:31 -0500
X-MC-Unique: HGiTkVF0NtaJQNPolQm5aA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 610D01F397;
	Tue,  1 Feb 2022 23:40:30 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 29E2813B8F;
	Tue,  1 Feb 2022 23:40:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id OAQvCO7E+WH4dAAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 01 Feb 2022 23:40:30 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  2 Feb 2022 00:40:23 +0100
Message-Id: <20220201234024.27675-6-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 211NecoL026654
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 5/6] multipath: Makefile: modules-load.d file for
	SCSI device handlers
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The kernel's autoload mechanism for SCSI device handlers doesn't
work during SCSI device probing. While it's possible to load and
attach device handlers after probing, it has disadvantages: the
handlers are useful for error handling even before multipathd has
started, and at least up to kernel 5.17, the sysfs "access_state" attribute
will remain invisible for already probed devices.

Distributions will therefore want to make sure the handlers are either
built-in in the kernel, or loaded early. Add functionality to
create and install a modules-load.d file with a list of handlers
to load. By default, the list is empty, and no file will be generated.
The list can be specified at install-time like this:

   make SCSI_DH_MODULES_PRELOAD="scsi_dh_rdac scsi_dh_emc" install

dracut automatically adds modules-load.d files and the modules they
reference to the initramfs.

Note: distributions that compile scsi_mod as a module may rather want
to use a modprobe.d file with a statement like this:

softdep scsi_mod post: scsi_dh_alua scsi_dh_rdac

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc       | 5 +++++
 multipath/Makefile | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/Makefile.inc b/Makefile.inc
index 5223c96..3342af6 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -9,6 +9,11 @@
 # Uncomment to disable dmevents polling support
 # ENABLE_DMEVENTS_POLL = 0
 
+# List of scsi device handler modules to load on boot, e.g.
+# SCSI_DH_MODULES_PRELOAD := scsi_dh_alua scsi_dh_rdac
+SCSI_DH_MODULES_PRELOAD :=
+
+
 PKGCONFIG	?= pkg-config
 
 ifeq ($(TOPDIR),)
diff --git a/multipath/Makefile b/multipath/Makefile
index 015f73c..c930499 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -29,11 +29,17 @@ install:
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(man8dir)
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(man5dir)
 	$(INSTALL_PROGRAM) -m 644 $(EXEC).conf.5 $(DESTDIR)$(man5dir)
+ifneq ($(SCSI_DH_MODULES_PRELOAD),)
+	$(INSTALL_PROGRAM) -m 644 scsi_dh.conf $(DESTDIR)$(modulesloaddir)/scsi_dh.conf
+	for _x in $(SCSI_DH_MODULES_PRELOAD); do echo "$$_x"; done \
+	    >>$(DESTDIR)$(modulesloaddir)/scsi_dh.conf
+endif
 
 uninstall:
 	$(RM) $(DESTDIR)$(bindir)/$(EXEC)
 	$(RM) $(DESTDIR)$(udevrulesdir)/11-dm-mpath.rules
 	$(RM) $(DESTDIR)$(modulesloaddir)/multipath.conf
+	$(RM) $(DESTDIR)$(modulesloaddir)/scsi_dh.conf
 	$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
 	$(RM) $(DESTDIR)$(man8dir)/$(EXEC).8
 	$(RM) $(DESTDIR)$(man5dir)/$(EXEC).conf.5
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

