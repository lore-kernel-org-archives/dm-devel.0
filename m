Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C348C433FE
	for <dm-devel@archiver.kernel.org>; Tue,  1 Feb 2022 23:41:02 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-fkwml_ciP5euH08jDqTXzg-1; Tue, 01 Feb 2022 18:40:59 -0500
X-MC-Unique: fkwml_ciP5euH08jDqTXzg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA7EA18460EA;
	Tue,  1 Feb 2022 23:40:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DA4E46962;
	Tue,  1 Feb 2022 23:40:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 666611809CBA;
	Tue,  1 Feb 2022 23:40:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 211Neeav026666 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Feb 2022 18:40:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E12F72166B13; Tue,  1 Feb 2022 23:40:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB4CE2166B17
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 23:40:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 598733C02B8E
	for <dm-devel@redhat.com>; Tue,  1 Feb 2022 23:40:35 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-468-fYMl_C2SPbS2p23RFd0lEg-1; Tue, 01 Feb 2022 18:40:31 -0500
X-MC-Unique: fYMl_C2SPbS2p23RFd0lEg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A60D51F3A8;
	Tue,  1 Feb 2022 23:40:30 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6E4EB13B8F;
	Tue,  1 Feb 2022 23:40:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 0JDlGO7E+WH4dAAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 01 Feb 2022 23:40:30 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed,  2 Feb 2022 00:40:24 +0100
Message-Id: <20220201234024.27675-7-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 211Neeav026666
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 6/6] README.md: add basic information about
	building multipath-tools
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 README.md | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/README.md b/README.md
index b15c265..1547862 100644
--- a/README.md
+++ b/README.md
@@ -52,6 +52,62 @@ To get latest devel code:
 Github page: https://github.com/opensvc/multipath-tools
 
 
+Building multipath-tools
+========================
+
+Prerequisites: development packages of for `libdevmapper`, `libreadline`,
+`libaio`, `libudev`, `libjson-c`, `liburcu`, and `libsystemd`.
+
+To build multipath-tools, type:
+
+    make
+	make DESTDIR="/my/target/dir" install
+
+To uninstall, type:
+
+    make uninstall
+
+Customizing the build
+---------------------
+
+The following variables can be passed to the `make` command line:
+
+ * `ENABLE_LIBDMMP=0`: disable building libdmmp
+ * `ENABLE_DMEVENTS_POLL=0`: disable support for the device-mapper event
+   polling API. For use with pre-5.0 kernels that don't supprt dmevent polling
+   (but even if you don't use this option, multipath-tools will work with
+   these kernels).
+ * `SCSI_DH_MODULES_PRELOAD="(list)"`: specify a space-separated list of SCSI
+   device handler kernel modules to load early during boot. Some
+   multipath-tools functionality depends on these modules being loaded
+   early. This option causes a *modules-load.d(5)* configuration file to be
+   created, thus it depends on functionality provided by *systemd*.
+   This variable only matters for `make install`.
+
+Note: The usefulness of the preload list depends on the kernel configuration.
+It's especially useful if `scsi_mod` is builtin but `scsi_dh_alua` and
+other device handler modules are built as modules. If `scsi_mod` itself is compiled
+as a module, it might make more sense to use a module softdep for the same
+purpose.
+
+See `Makefile.inc` for additional variables to customize paths and compiler
+flags.
+
+Special Makefile targets
+------------------------
+
+The following targets are intended for developers only.
+
+ * `make test` to build and run the unit tests
+ * `make valgrind-test` to run the unit tests under valgrind
+ * `make abi` to create an XML representation of the ABI of the libraries in
+   the `abi/` subdirectory
+ * `make abi-test` to compare the ABI of a different multipath-tools version,
+   which must be stored in the `reference-abi/` subdirectory. If this test
+   fails, the ABI has changed wrt the reference.
+ * `make compile-commands.json` to create input for [clangd](https://clangd.llvm.org/).
+
+
 Add storage devices
 ===================
 
-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

