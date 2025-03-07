Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0401854
	for <dm-devel@lists.linux.dev>; Fri,  7 Mar 2025 00:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741306244; cv=none; b=VsawyTpOzbeT8NWgYbqJ7wGEGNvc/0wWIZQ8GsJ2zXeiREGbv7TlKEVynYdRsNQWqKB8sQaGSBv3ktmIS/XJ+hKQ5QJqIwNDiMrMjgwpHZnCzLYXzOq1vY5zOfADUQFK+oIpgVlis/58BNfxax0Ezz6gzlfQmU5tbIojVsPp60s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741306244; c=relaxed/simple;
	bh=QDGqhr/k33XqeakqySZ5t1BNZ40J8dpEwUGvNciRz3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=Jcihi2pW4b9KWDQ8BBbXNxccwREbqtVof89moqpKh+dPisx50Lx8vWnX8vxaFk3RY/TmlsY3rw2QF5LV3SO3Wsx/T1tDW27WnuKRSPQgwCdBtOHrDsy8LX1g1NT8RwuGRSyCMr5kYA4TllDRb9GnL2/StYZFfKQgJXCai/CiQ3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N1sd4OJt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N1sd4OJt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741306241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+8KSejnH7eiwh9Nc+HhbFqZTThwMeGU9ogwFpkRxWUU=;
	b=N1sd4OJtmMlXZTbxhSYBqekUy2E3lLOApAPiZ6x9k+B4Mpf8mUMhDxXoKBeruAPhggvYMJ
	qiNk2qHtII8kmLSfzMjwWJiq1rd7RrdJB6zo0cRiHTHuWb3EOgytG6zBQWu7SHs/3RppXN
	muXNlTB3jc6cSyejqmfPR+TK2UAS6M0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-KbeijMwsOIyoG8AVkuqyvg-1; Thu,
 06 Mar 2025 19:10:38 -0500
X-MC-Unique: KbeijMwsOIyoG8AVkuqyvg-1
X-Mimecast-MFC-AGG-ID: KbeijMwsOIyoG8AVkuqyvg_1741306237
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE88719560BC;
	Fri,  7 Mar 2025 00:10:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 396F6180174C;
	Fri,  7 Mar 2025 00:10:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5270AYCQ3141847
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 6 Mar 2025 19:10:34 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5270AYcj3141846;
	Thu, 6 Mar 2025 19:10:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/2] multipathd: Add multipathd man page section about sockets
Date: Thu,  6 Mar 2025 19:10:34 -0500
Message-ID: <20250307001034.3141833-2-bmarzins@redhat.com>
In-Reply-To: <20250307001034.3141833-1-bmarzins@redhat.com>
References: <20250307001034.3141833-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i-Tv9nV9PuRRLbyST8uPFGnWK69ftUS9gxkYiaa-ECc_1741306237
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Add a section with information about how to communicate with the
multipathd daemon to the man page. Also mention that multipathd
CLI commands can be run without the -k option.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.8.in | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 315884eb..5b1aeb42 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -83,6 +83,11 @@ multipathd executes the given command (see \fBCOMMANDS\fR below). If the
 command contains whitespace or shell special characters, it needs to be quoted
 like in \fImultipathd -k'show topology'\fR. No whitespace is allowed between
 the \fB-k\fR and the command string.
+
+Commands can also be issued without using \fB-k\fR. In this case, the command
+string should not be quoted. Command arguments that contain whitespace or
+special characters still need to be quoted, like in \fImultipathd show paths
+format "%n %w"\fR
 .
 .TP
 .B \-k
@@ -103,6 +108,32 @@ multipath devices on dmevents. Use this flag to force it to use the old event
 waiting method, based on creating a separate thread for each device.
 .
 .
+.\" ----------------------------------------------------------------------------
+.SH COMMUNICATING WITH MULTIPATHD
+.\" ----------------------------------------------------------------------------
+
+In addition to the multipathd CLI, the \fBlibmpathcmd\fR library can be used to
+send commands (see \fBCOMMANDS\fR below) to the multipathd daemon from other
+programs. By default, multipathd listens on both the \fI@ABSTRACT_SOCKET@\fR
+abstract namespace socket and the \fI@PATHNAME_SOCKET@\fR socket file.
+libmpathcmd will use either of these sockets to connect to multipathd. The
+socket file can be useful to communicate with multipathd from different
+namespaces since it can be bind mounted in them, unlike the abstract namespace
+socket. Multipathd will accept \fBlist|show\fR commands from any user. All
+other commands must be issued by root.
+
+It is possible to change the sockets that multipathd listens on. If
+\fImultipathd.socket\fR is running, multipathd will use the sockets it listens
+on.  A maximum of two sockets can be defined by \fImultipathd.socket\fR, and by
+default it listens on \fI@ABSTRACT_SOCKET@\fR and \fI@PATHNAME_SOCKET@\fR. If
+\fImultipathd.socket\fR is not running, a single socket can be configured for
+listening on by setting the \fIMULTIPATH_SOCKET_NAME\fR environment variable
+when starting multipathd. This environment variable must also be set to make
+multipathd CLI commands (or any other program using libmpathcmd) connect to the
+multipathd daemon using a non-default socket, regardless of whether that socket
+was set for the daemon using \fImultipathd.socket\fR or the
+\fIMULTIPATH_SOCKET_NAME\fR environment variable.
+.
 .
 .\" ----------------------------------------------------------------------------
 .SH COMMANDS
-- 
2.48.1

