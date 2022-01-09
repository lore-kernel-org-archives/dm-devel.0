Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D54AC433F5
	for <dm-devel@archiver.kernel.org>; Sun,  9 Jan 2022 10:29:30 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-hAKP7nY4Nqqih7J-GyekJg-1; Sun, 09 Jan 2022 05:29:26 -0500
X-MC-Unique: hAKP7nY4Nqqih7J-GyekJg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C624A1080865;
	Sun,  9 Jan 2022 10:29:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A4B4D7D4B1;
	Sun,  9 Jan 2022 10:29:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 45B394BB7C;
	Sun,  9 Jan 2022 10:29:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 209ATGEr029298 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 9 Jan 2022 05:29:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A593840CFD14; Sun,  9 Jan 2022 10:29:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A0AD740CFD04
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 10:29:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87DA385A5AA
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 10:29:16 +0000 (UTC)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
	[209.85.221.52]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-110-eL_m3SRCNvi9C4ENdPyLaw-1; Sun, 09 Jan 2022 05:29:14 -0500
X-MC-Unique: eL_m3SRCNvi9C4ENdPyLaw-1
Received: by mail-wr1-f52.google.com with SMTP id k30so3432503wrd.9;
	Sun, 09 Jan 2022 02:29:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=+/aqaMpl5AZ7lEfxCYILQlGqDwcVJyIs7fTiVfgYW6w=;
	b=DKTC19DlpqMHXFuvOJQ1XNH/8+H1hXKVRcdiWCKQgOg1pAizgVAR8BiVNxE42CUuY7
	hetz1UXWMBw/IP1/rwFk5B3wbzZxP+nOG7LIw3+UNF6+EQIAdDMwFWPQ9XuTe95KH5Ml
	tqXZ7yJYI837XZuSNZTf8cGHI72O5Xf+j+6Ms92vC4BXCvWN6CWH+WISwgRRzZaRXmVf
	QawK4DQB0MIQ9DZyQTqLdzWyDc/E01EeBGKTlqDKkjQqsQAUMQR56hTHo1r7/iof1Ovv
	K0doZxx+RezNwbMdGBJGCexy0tkwnDMXmh6/fiiW0pZ0aLczBfi21zyaOSgThh3Uubmy
	/k4A==
X-Gm-Message-State: AOAM531kMT5tfU8/LtBiUP/7wa+r43yfUq+Cog+sriudhKKdQaBb25AT
	yxtGIEmZfmbNYGnenxq86ms=
X-Google-Smtp-Source: ABdhPJz65lMktgocn2g5uhZQUXjFuWeqhd5A9dn1Uq/cjXnTebZBbFrZ6BROKloGqX+QeFFTqFA+Jg==
X-Received: by 2002:adf:eec5:: with SMTP id a5mr3597961wrp.125.1641724153625; 
	Sun, 09 Jan 2022 02:29:13 -0800 (PST)
Received: from nz.home (host81-129-87-145.range81-129.btcentralplus.com.
	[81.129.87.145])
	by smtp.gmail.com with ESMTPSA id b1sm4068075wrd.92.2022.01.09.02.29.12
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sun, 09 Jan 2022 02:29:13 -0800 (PST)
Received: by nz.home (Postfix, from userid 1000)
	id 59B00190CB125; Sun,  9 Jan 2022 10:29:12 +0000 (GMT)
From: Sergei Trofimovich <slyich@gmail.com>
To: dm-devel@redhat.com
Date: Sun,  9 Jan 2022 10:29:05 +0000
Message-Id: <20220109102908.4102332-1-slyich@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Sergei Trofimovich <slyich@gmail.com>, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 1/4] multipath-tools: avoid using GZIP Makefile
	variable
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

`gzip` supports (deprecated) `GZIP` environment variable. If it's
already present Makefile would override it and pass it through causing
thre breakage:

    $ dev>GZIP=-n make
    gzip -9 -c mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
    gzip: -c: option not valid in GZIP environment variable
    Try `gzip --help' for more information.

Fix build by renaming GZIP variable to GZIP_PROG to avoid collision.

CC: Martin Wilck <mwilck@suse.com>
CC: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Sergei Trofimovich <slyich@gmail.com>
---
 Makefile.inc             | 2 +-
 kpartx/Makefile          | 2 +-
 libmpathpersist/Makefile | 4 ++--
 mpathpersist/Makefile    | 2 +-
 multipath/Makefile       | 4 ++--
 multipathd/Makefile      | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index b340f2ae..59856f24 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -75,7 +75,7 @@ nvmedir		= $(TOPDIR)/libmultipath/nvme
 includedir	= $(prefix)/usr/include
 pkgconfdir	= $(usrlibdir)/pkgconfig
 
-GZIP		= gzip -9 -c
+GZIP_PROG	= gzip -9 -c
 RM		= rm -f
 LN		= ln -sf
 INSTALL_PROGRAM	= install
diff --git a/kpartx/Makefile b/kpartx/Makefile
index 2906a984..9be115d6 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -21,7 +21,7 @@ all: $(EXEC)
 
 $(EXEC): $(OBJS)
 	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
+	$(GZIP_PROG) $(EXEC).8 > $(EXEC).8.gz
 
 install: $(EXEC) $(EXEC).8
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 1e6399d6..ccdc3223 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -33,8 +33,8 @@ $(DEVLIB): $(LIBS)
 	$(LN) $(LIBS) $@
 
 man:
-	$(GZIP) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
-	$(GZIP) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
+	$(GZIP_PROG) mpath_persistent_reserve_in.3 > mpath_persistent_reserve_in.3.gz
+	$(GZIP_PROG) mpath_persistent_reserve_out.3 > mpath_persistent_reserve_out.3.gz
 
 install: all
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index 51268010..de66b644 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -14,7 +14,7 @@ all: $(EXEC)
 
 $(EXEC): $(OBJS)
 	$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS) $(LIBDEPS)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
+	$(GZIP_PROG) $(EXEC).8 > $(EXEC).8.gz
 
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
diff --git a/multipath/Makefile b/multipath/Makefile
index 0828a8f7..3f12d75b 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -16,8 +16,8 @@ all: $(EXEC)
 
 $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	$(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
-	$(GZIP) $(EXEC).conf.5 > $(EXEC).conf.5.gz
+	$(GZIP_PROG) $(EXEC).8 > $(EXEC).8.gz
+	$(GZIP_PROG) $(EXEC).conf.5 > $(EXEC).conf.5.gz
 
 install:
 	$(INSTALL_PROGRAM) -d $(DESTDIR)$(bindir)
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 393b6cbb..64df2214 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -40,7 +40,7 @@ all : $(EXEC)
 
 $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	$(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
-	$(GZIP) $(EXEC).8 > $(EXEC).8.gz
+	$(GZIP_PROG) $(EXEC).8 > $(EXEC).8.gz
 
 cli_handlers.o:	cli_handlers.c
 	$(CC) $(CFLAGS) -Wno-unused-parameter -c -o $@ $<
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

