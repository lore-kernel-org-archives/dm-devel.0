Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBA4EEB57E
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450395;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HH8khLGceWukN6GLUr4cCKlo1/o2jSSeYjwlL6T97co=;
	b=EXjFziXmpmxMoKGSMJfFwFMwJrkVnjCUrVFRb90a+V8a8cUChL6GJEgkpkzjTs8F0e1zAi
	rhhCr1JPD1PazGB3c9qKMQ020QDYQQeFmZVp8D9zURRfSTQrfld+p2NAayrOA3LrGOfG8U
	sBL7ZvDgh5Wy/xDz5OkrK46lgTF9FIw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-YJoqsGenOvKtP9O4AKuWGA-1; Mon, 11 Sep 2023 12:39:51 -0400
X-MC-Unique: YJoqsGenOvKtP9O4AKuWGA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 047AE3815F74;
	Mon, 11 Sep 2023 16:39:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E35B140C6EA8;
	Mon, 11 Sep 2023 16:39:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B562E19465B6;
	Mon, 11 Sep 2023 16:39:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4A43819465A8
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 398822027046; Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3187C2027047
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F45D945E90
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:28 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-aKibbLd7OpuxzSee96tNDg-1; Mon,
 11 Sep 2023 12:39:24 -0400
X-MC-Unique: aKibbLd7OpuxzSee96tNDg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 999F91F8BB;
 Mon, 11 Sep 2023 16:39:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6A80F139CC;
 Mon, 11 Sep 2023 16:39:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id sB9ZGLpC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:22 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:40 +0200
Message-ID: <20230911163846.27197-32-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 31/37] multipath-tools man pages: generate
 with correct paths
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Generate the man pages using the compile-time settings for paths
to multipath.conf etc.

Add a paragraph about the CONFIGDIR (/etc/multipath/conf.d)
and the drop-in configuration files in the multipath.conf man page.

Also, make sure all generated man pages and other files are correctly
removed by "make clean".

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 .gitignore                                    |  4 +++
 Makefile.inc                                  |  3 +++
 mpathpersist/Makefile                         |  5 ++--
 .../{mpathpersist.8 => mpathpersist.8.in}     |  2 +-
 multipath/Makefile                            | 13 +++++----
 multipath/{multipath.8 => multipath.8.in}     | 10 +++----
 .../{multipath.conf.5 => multipath.conf.5.in} | 27 ++++++++++++-------
 multipathd/Makefile                           |  9 ++++---
 multipathd/{multipathd.8 => multipathd.8.in}  |  8 +++---
 9 files changed, 49 insertions(+), 32 deletions(-)
 rename mpathpersist/{mpathpersist.8 => mpathpersist.8.in} (99%)
 rename multipath/{multipath.8 => multipath.8.in} (97%)
 rename multipath/{multipath.conf.5 => multipath.conf.5.in} (98%)
 rename multipathd/{multipathd.8 => multipathd.8.in} (97%)

diff --git a/.gitignore b/.gitignore
index 535353e..2986578 100644
--- a/.gitignore
+++ b/.gitignore
@@ -13,11 +13,15 @@ cscope.files
 cscope.out
 kpartx/kpartx
 multipath/multipath
+multipath/multipath.8
+multipath/multipath.conf.5
 multipath/multipath.rules
 multipath/tmpfiles.conf
 multipathd/multipathd
+multipathd/multipathd.8
 multipathd/multipathc
 mpathpersist/mpathpersist
+mpathpersist/mpathpersist.8
 abi.tar.gz
 abi
 abi-test
diff --git a/Makefile.inc b/Makefile.inc
index 96206b2..79e521e 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -133,3 +133,6 @@ NV_VERSION_SCRIPT = $(DEVLIB:%.so=%-nv.version)
 	@grep -P '^[ \t]+[a-zA-Z_][a-zA-Z0-9_]*;' $< >>$@
 	@printf 'local:\n\t*;\n};\n' >>$@
 
+%:	%.in
+	@echo creating $@
+	$(Q)sed 's:@CONFIGFILE@:'$(configfile)':g;s:@CONFIGDIR@:'$(configdir)':g;s:@STATE_DIR@:'$(statedir)':g;s:@RUNTIME_DIR@:'$(runtimedir)':g' $< >$@
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index f57c105..f374946 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -8,10 +8,11 @@ LIBDEPS += -L$(mpathpersistdir) -lmpathpersist -L$(multipathdir) -lmultipath \
 	-L$(mpathutildir) -lmpathutil -L$(mpathcmddir) -lmpathcmd -lpthread -ldevmapper -ludev
 
 EXEC = mpathpersist
+MANPAGES := mpathpersist.8
 
 OBJS = main.o
 
-all: $(EXEC)
+all: $(EXEC) $(MANPAGES)
 
 $(EXEC): $(OBJS)
 	$(Q)$(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS) $(LIBDEPS)
@@ -23,7 +24,7 @@ install:
 	$(Q)$(INSTALL_PROGRAM) -m 644 $(EXEC).8 $(DESTDIR)$(mandir)/man8
 
 clean: dep_clean
-	$(Q)$(RM) core *.o $(EXEC)
+	$(Q)$(RM) core *.o $(EXEC) $(MANPAGES)
 
 include $(wildcard $(OBJS:.o=.d))
 
diff --git a/mpathpersist/mpathpersist.8 b/mpathpersist/mpathpersist.8.in
similarity index 99%
rename from mpathpersist/mpathpersist.8
rename to mpathpersist/mpathpersist.8.in
index 8d26b37..fecef0d 100644
--- a/mpathpersist/mpathpersist.8
+++ b/mpathpersist/mpathpersist.8.in
@@ -31,7 +31,7 @@ mpathpersist \- Manages SCSI persistent reservations on dm multipath devices.
 .
 This utility is used to manage SCSI persistent reservations on Device Mapper
 Multipath devices. To be able to use this functionality, the \fIreservation_key\fR
-attribute must be defined in the \fI/etc/multipath.conf\fR file. Otherwise the
+attribute must be defined in the \fI@CONFIGFILE@\fR file. Otherwise the
 \fBmultipathd\fR daemon will not check for persistent reservation for newly
 discovered paths or reinstated paths.
 .
diff --git a/multipath/Makefile b/multipath/Makefile
index 73db991..68cb5ce 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -3,7 +3,9 @@
 #
 include ../Makefile.inc
 
-EXEC := multipath
+EXEC      := multipath
+MANPAGES  := multipath.8 multipath.conf.5
+GENERATED := $(MANPAGES) multipath.rules tmpfiles.conf
 
 CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathcmddir)
 CFLAGS += $(BIN_CFLAGS)
@@ -13,7 +15,7 @@ LIBDEPS += -L$(multipathdir) -lmultipath -L$(mpathutildir) -lmpathutil \
 
 OBJS := main.o
 
-all: $(EXEC) multipath.rules tmpfiles.conf
+all: $(EXEC) $(GENERATED)
 
 $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	@echo building $@ because of $?
@@ -47,15 +49,12 @@ uninstall:
 	$(Q)$(RM) $(DESTDIR)$(libudevdir)/rules.d/56-multipath.rules
 	$(Q)$(RM) $(DESTDIR)$(mandir)/man8/$(EXEC).8
 	$(Q)$(RM) $(DESTDIR)$(mandir)/man5/$(EXEC).conf.5
+	$(Q)$(RM) $(DESTDIR)$(tmpfilesdir)/multipath.conf
 
 clean: dep_clean
-	$(Q)$(RM) core *.o $(EXEC) multipath.rules tmpfiles.conf
+	$(Q)$(RM) core *.o $(EXEC) $(GENERATED)
 
 include $(wildcard $(OBJS:.o=.d))
 
 dep_clean:
 	$(Q)$(RM) $(OBJS:.o=.d)
-
-%:	%.in
-	@echo creating $@
-	$(Q)sed 's,@RUNTIME_DIR@,$(runtimedir),' $< >$@
diff --git a/multipath/multipath.8 b/multipath/multipath.8.in
similarity index 97%
rename from multipath/multipath.8
rename to multipath/multipath.8.in
index 5fed6df..348eb22 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8.in
@@ -185,7 +185,7 @@ Display the currently used multipathd configuration.
 .B \-T
 Display the currently used multipathd configuration, limiting the output to
 those devices actually present in the system. This can be used a template for
-creating \fImultipath.conf\fR.
+creating \fI@CONFIGFILE@\fR.
 .
 .\" ----------------------------------------------------------------------------
 .SH OPTIONS
@@ -233,11 +233,11 @@ option from \fBmultipath.conf(5)\fR.
 .B \-i
 Ignore WWIDs file when processing devices. If
 \fIfind_multipaths strict\fR or \fIfind_multipaths no\fR is set in
-\fImultipath.conf\fR, multipath only considers devices that are
+\fI@CONFIGFILE@\fR, multipath only considers devices that are
 listed in the WWIDs file. This option overrides that behavior. For other values
 of \fIfind_multipaths\fR, this option has no effect. See the description of
 \fIfind_multipaths\fR in
-.BR multipath.conf (5).
+.BR @CONFIGFILE@ (5).
 This option should only be used in rare circumstances.
 .
 .TP
@@ -246,8 +246,8 @@ Treat the bindings file as read only.
 .
 .TP
 .BI \-b " file"
-Set \fIuser_friendly_names\fR bindings file location. The default is
-\fI/etc/multipath/bindings\fR.
+(\fBdeprecated, do not use\fR) Set \fIuser_friendly_names\fR bindings file location. The default is
+\fI@STATE_DIR@/bindings\fR.
 .
 .TP
 .B \-q
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5.in
similarity index 98%
rename from multipath/multipath.conf.5
rename to multipath/multipath.conf.5.in
index 93af17d..20df223 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5.in
@@ -13,14 +13,14 @@
 .SH NAME
 .\" ----------------------------------------------------------------------------
 .
-multipath.conf \- multipath daemon configuration file.
+@CONFIGFILE@, @CONFIGDIR@/*.conf \- multipath daemon configuration file.
 .
 .
 .\" ----------------------------------------------------------------------------
 .SH DESCRIPTION
 .\" ----------------------------------------------------------------------------
 .
-.B "/etc/multipath.conf"
+.B "@CONFIGFILE@"
 is the configuration file for the multipath daemon. It is used to
 overwrite the built-in configuration table of \fBmultipathd\fP.
 Any line whose first non-white-space character is a '#' is considered
@@ -29,6 +29,15 @@ a comment line. Empty lines are ignored.
 Currently used multipathd configuration can be displayed with the \fBmultipath -t\fR
 or \fBmultipathd show config\fR command.
 .
+.PP
+Additional configuration can be made in drop-in files under
+.B @CONFIGDIR@.
+Files ending in \fI.conf\fR in this directory are read
+in alphabetical order, after reading \fI@CONFIGFILE@\fR.
+They use the same syntax as \fI@CONFIGFILE@\fR itself,
+and support all sections and keywords. If a keyword occurs in the same section
+in multiple files, the last occurence will take precedence over all others.
+.
 .
 .\" ----------------------------------------------------------------------------
 .SH SYNTAX
@@ -85,7 +94,7 @@ not mandatory.
 .
 .LP
 .B Note on regular expressions:
-The \fImultipath.conf\fR syntax allows many attribute values to be specified as POSIX
+The \fI@CONFIGFILE@\fR syntax allows many attribute values to be specified as POSIX
 Extended Regular Expressions (see \fBregex\fR(7)). These regular expressions
 are \fBcase sensitive\fR and \fBnot anchored\fR, thus the expression "bar" matches "barbie",
 "rhabarber", and "wunderbar", but not "Barbie". To avoid unwanted substring
@@ -711,7 +720,7 @@ The default is: \fBno\fR
 .B user_friendly_names
 If set to
 .I yes
-, using the bindings file \fI/etc/multipath/bindings\fR to assign a persistent
+, using the bindings file \fI@STATE_DIR@/bindings\fR to assign a persistent
 and unique alias to the multipath, in the form of mpath<n>. If set to
 .I no
 use the WWID as the alias. In either case this be will
@@ -790,7 +799,7 @@ The full pathname of the binding file to be used when the user_friendly_names
 option is set.
 .RS
 .TP
-The default is: \fB/etc/multipath/bindings\fR
+The default is: \fB@STATE_DIR@/bindings\fR
 .RE
 .
 .
@@ -801,7 +810,7 @@ The full pathname of the WWIDs file, which is used by multipath to keep track
 of the WWIDs for LUNs it has created multipath devices on in the past.
 .RS
 .TP
-The default is: \fB/etc/multipath/wwids\fR
+The default is: \fB@STATE_DIR@/wwids\fR
 .RE
 .
 .
@@ -813,7 +822,7 @@ track of the persistent reservation key used for a specific WWID, when
 \fIreservation_key\fR is set to \fBfile\fR.
 .RS
 .TP
-The default is: \fB/etc/multipath/prkeys\fR
+The default is: \fB@STATE_DIR@/prkeys\fR
 .RE
 .
 .
@@ -872,7 +881,7 @@ The default is: \fBno\fR
 .I yes
 and the SCSI layer has already attached a hardware_handler to the device,
 multipath will not force the device to use the hardware_handler specified by
-multipath.conf. If the SCSI layer has not attached a hardware handler,
+@CONFIGFILE@. If the SCSI layer has not attached a hardware handler,
 multipath will continue to use its configured hardware handler.
 .RS
 .PP
@@ -1559,7 +1568,7 @@ given device, the attributes of all matching entries are applied to it.
 If an attribute is specified in several matching device subsections,
 later entries take precedence. Thus, entries in files under \fIconfig_dir\fR (in
 reverse alphabetical order) have the highest precedence, followed by entries
-in \fImultipath.conf\fR; the built-in hardware table has the lowest
+in \fI@CONFIGFILE@\fR; the built-in hardware table has the lowest
 precedence. Inside a configuration file, later entries have higher precedence
 than earlier ones.
 .LP
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 0d0146c..cdba3db 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -1,7 +1,8 @@
 include ../Makefile.inc
 
-EXEC := multipathd
-CLI := multipathc
+EXEC     := multipathd
+CLI      := multipathc
+MANPAGES := multipathd.8
 
 CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathpersistdir) -I$(mpathcmddir) -I$(thirdpartydir) \
 	$(shell $(PKG_CONFIG) --modversion liburcu 2>/dev/null | \
@@ -42,7 +43,7 @@ ifeq ($(FPIN_SUPPORT),1)
 OBJS += fpin_handlers.o
 endif
 
-all : $(EXEC) $(CLI)
+all : $(EXEC) $(CLI) $(MANPAGES)
 
 $(EXEC): $(OBJS) $(multipathdir)/libmultipath.so $(mpathcmddir)/libmpathcmd.so
 	@echo building $@ because of $?
@@ -79,7 +80,7 @@ uninstall:
 	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
 
 clean: dep_clean
-	$(Q)$(RM) core *.o $(EXEC) $(CLI)
+	$(Q)$(RM) core *.o $(EXEC) $(CLI) $(MANPAGES)
 
 include $(wildcard $(OBJS:.o=.d) $(CLI_OBJS:.o=.d))
 
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8.in
similarity index 97%
rename from multipathd/multipathd.8
rename to multipathd/multipathd.8.in
index cc72b77..e98c27f 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8.in
@@ -155,7 +155,7 @@ Show the format wildcards used in interactive commands taking $format.
 .TP
 .B list|show config
 Show the currently used configuration, derived from default values and values
-specified within the configuration file \fI/etc/multipath.conf\fR.
+specified within the configuration file \fI@CONFIGFILE@\fR.
 .
 .TP
 .B list|show config local
@@ -165,7 +165,7 @@ the devices section to those devices that are actually present in the system.
 .TP
 .B list|show blacklist
 Show the currently used blacklist rules, derived from default values and values
-specified within the configuration file \fI/etc/multipath.conf\fR.
+specified within the configuration file \fI@CONFIGFILE@\fR.
 .
 .TP
 .B list|show devices
@@ -290,13 +290,13 @@ Get the current persistent reservation key associated with $map.
 .B map|multipath $map setprkey key $key
 Set the persistent reservation key associated with $map to $key in the
 \fIprkeys_file\fR. This key will only be used by multipathd if
-\fIreservation_key\fR is set to \fBfile\fR in \fI/etc/multipath.conf\fR.
+\fIreservation_key\fR is set to \fBfile\fR in \fI@CONFIGFILE@\fR.
 .
 .TP
 .B map|multipath $map unsetprkey
 Remove the persistent reservation key associated with $map from the
 \fIprkeys_file\fR. This will only unset the key used by multipathd if
-\fIreservation_key\fR is set to \fBfile\fR in \fI/etc/multipath.conf\fR.
+\fIreservation_key\fR is set to \fBfile\fR in \fI@CONFIGFILE@\fR.
 .
 .TP
 .B path $path setmarginal
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

