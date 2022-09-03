Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3755C6FA86
	for <dm-devel@archiver.kernel.org>; Sat,  3 Sep 2022 11:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662203511;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2psUiy4dXmlxpwv2zcvWmNvF6HgnOGWzWfhLfenbLwE=;
	b=N7run+qrqrofmpASQf1Kd+tuNMIKqYp1WBrnsk6Zwekjo3LzsXf35JjA3VShfqALyxoC0j
	G0jmyh+YjpyYPbJBcClPgDE15Va3cmjj3xXqmN873N4ZDBs8B3Vir4Ler6dbkAZqR8frG+
	NlcbEGF4GQ0ZfAClsGL2ApUME4rCXjc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-UjkcYBSsOxariEA4mq8ZYA-1; Sat, 03 Sep 2022 07:11:48 -0400
X-MC-Unique: UjkcYBSsOxariEA4mq8ZYA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05C5F1C05AD7;
	Sat,  3 Sep 2022 11:11:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 68BC12026D4C;
	Sat,  3 Sep 2022 11:11:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2E6B61940379;
	Sat,  3 Sep 2022 11:11:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 18E61194B973
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Sep 2022 11:11:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F3AAC401473; Sat,  3 Sep 2022 11:11:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EFECB40334C
 for <dm-devel@redhat.com>; Sat,  3 Sep 2022 11:11:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5AEA85A585
 for <dm-devel@redhat.com>; Sat,  3 Sep 2022 11:11:43 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-339-jB6gA4ePNWSbSMDB_2eBRw-1; Sat,
 03 Sep 2022 07:11:40 -0400
X-MC-Unique: jB6gA4ePNWSbSMDB_2eBRw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 3000820990;
 Sat,  3 Sep 2022 11:11:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E7DA3139F9;
 Sat,  3 Sep 2022 11:11:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id KETpNmo2E2OqGwAAMHmgww
 (envelope-from <mwilck@suse.com>); Sat, 03 Sep 2022 11:11:38 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat,  3 Sep 2022 13:11:26 +0200
Message-Id: <20220903111128.14367-2-mwilck@suse.com>
In-Reply-To: <20220903111128.14367-1-mwilck@suse.com>
References: <20220903111128.14367-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 1/3] multipathd: add multipathc.8 manual page
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Document multipathc, and update the man page of multipathd to
describe the command mode correctly.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/multipathc.8 | 64 +++++++++++++++++++++++++++++++++++++++++
 multipathd/multipathd.8 | 34 +++++++++++++++++-----
 2 files changed, 91 insertions(+), 7 deletions(-)
 create mode 100644 multipathd/multipathc.8

diff --git a/multipathd/multipathc.8 b/multipathd/multipathc.8
new file mode 100644
index 0000000..6c57c6c
--- /dev/null
+++ b/multipathd/multipathc.8
@@ -0,0 +1,64 @@
+.\" ----------------------------------------------------------------------------
+.\" Update the date below if you make any significant change.
+.\" Make sure there are no errors with:
+.\" groff -z -wall -b -e -t multipathd/multipathd.8
+.\"
+.\" ----------------------------------------------------------------------------
+.
+.TH MULTIPATHC 8 2022-09-03 Linux
+.
+.
+.\" ----------------------------------------------------------------------------
+.SH NAME
+.\" ----------------------------------------------------------------------------
+.
+multipathc \- Interactive client for multipathd
+.
+.
+.\" ----------------------------------------------------------------------------
+.SH SYNOPSIS
+.\" ----------------------------------------------------------------------------
+.
+.B multipathc 
+.RB [\|
+.IR timeout
+.RB \|]
+.
+.
+.\" ----------------------------------------------------------------------------
+.SH DESCRIPTION
+.\" ----------------------------------------------------------------------------
+.
+The \fBmultipathc\fR tool provides an interactive shell for communicating
+with the \fBmultipathd\fR daemon.
+The command \fBmultipathd -k\fR invokes \fBmultipathc\fR.
+.P
+All commands documented in \fBmultipathd(8)\fR are supported.
+The available commands can be viewed by entering '\fIhelp\fR'.
+Use \fIquit\fR, \fIexit\fR, or \fBCTRL-D\fR to exit the shell.
+Keywords can be abbreviated with the first letters (for example,
+\fIshu\fR for \fIshutdown\fR), if the abbreviation is unique.
+Some commands support pretty-printing
+using \fBprintf\fR-style format specifiers. The supported format specifiers
+can be listed with the command \fBshow wildcards\fR.
+Depending on build options, the interactive shell
+may provide command completion and history expansion features.
+.P
+The optional parameter \fBtimeout\fR specifies the timeout to wait for
+a reply from \fBmultipathd\fR, in milliseconds. The default is 4000 ms.
+.
+.
+.\" ----------------------------------------------------------------------------
+.SH "SEE ALSO"
+.\" ----------------------------------------------------------------------------
+.
+.BR multipathd (8)
+.
+.
+.\" ----------------------------------------------------------------------------
+.SH AUTHORS
+.\" ----------------------------------------------------------------------------
+.
+\fImultipath-tools\fR was developed by Christophe Varoqui
+<christophe.varoqui@opensvc.com> and others.
+.\" EOF
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index 1e318bd..a828864 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -5,7 +5,7 @@
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATHD 8 2016-10-27 Linux
+.TH MULTIPATHD 8 2022-09-03 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -20,14 +20,23 @@ multipathd \- Multipath daemon.
 .\" ----------------------------------------------------------------------------
 .
 .B multipathd
-.RB [\| \-d | \-k \|]
+.RB [\| \-d \|]
 .RB [\| \-s \|]
 .RB [\| \-v\ \c
 .IR verbosity \|]
 .RB [\| \-B \|]
 .RB [\| \-w \|]
-.
-.
+.LP
+.B multipathd
+.RB [\| \-v\ \c
+.IR verbosity \|]
+.B -k\fIcommand\fR
+.LP
+.B multipathd
+.RB [\| \-v\ \c
+.IR verbosity \|]
+.B -k
+
 .\" ----------------------------------------------------------------------------
 .SH DESCRIPTION
 .\" ----------------------------------------------------------------------------
@@ -36,6 +45,10 @@ The \fBmultipathd\fR daemon is in charge of checking for failed paths. When this
 happens, it will reconfigure the multipath map the path belongs to, so that this
 map regains its maximum performance and redundancy.
 
+With the \fB-k\fR option, \fBmultipathd\fR acts as a client utility that
+sends commands to a running instance of the multipathd daemon (see
+\fBCOMMANDS\fR below).
+
 This daemon executes the external \fBmultipath\fR tool when events occur.
 In turn, the multipath tool signals the multipathd daemon when it is done with
 devmap reconfiguration, so that it can refresh its failed path list.
@@ -66,10 +79,16 @@ bindings file. If a \fIuser_friendly_name\fR doesn't already exist for a device,
 will use its WWID as its alias.
 .
 .TP
+.B \-k\fIcommand\fB
+multipathd executes the given command (see \fBCOMMANDS\fR below). If the
+command contains whitespace or shell special characters, it needs to be quoted
+like in \fImultipathd -k'show topology'\fR. No whitespace is allowed between
+the \fB-k\fR and the command string.
+.
+.TP
 .B \-k
-multipathd will enter interactive mode. From this mode, the available commands can
-be viewed by entering '\fIhelp\fR'. When you are finished entering commands, press
-\fBCTRL-D\fR to quit.
+multipathd executes the \fBmultipathc\fR interactive shell for entering
+commands (see \fBCOMMANDS\fR below).
 .
 .TP
 .B \-n
@@ -346,6 +365,7 @@ Overrides the \fImax_fds\fR configuration setting.
 .SH "SEE ALSO"
 .\" ----------------------------------------------------------------------------
 .
+.BR multipathc (8),
 .BR multipath (8),
 .BR kpartx (8),
 .BR sd_notify (3),
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

