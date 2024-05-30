Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8345D44C76
	for <dm-devel@lists.linux.dev>; Thu, 30 May 2024 16:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717088109; cv=none; b=l6YV26p/qcQ+oPws//JDJL91xvnokdRp+fefGWKg6a3GmIAOaGVxObpac7P3YQVrZCY0PkIb8VZw0FvnjCSeXyI6+9/tBWWWzVsQ1AvBWmSSQxvCP4cgukHoMGmaHTTwwfQIKuSftToFm/fa6aMBU0C74zPaweBIALLQa70aWWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717088109; c=relaxed/simple;
	bh=T29x4ddHRnf3FvV5chhdCmxh/NecPz15yapgN3NFGZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/i6vzKwG/RjxebGggDgQxAh6d6h9rdfGga/6/g63wq3uY/Cy4xGqlqs3JMtW/5Kvf/i4rV5uGnmHeikeXhxyof+32MOjxUM9/FuzAeR25tSVHXfp+h9XINSMsbmSGyZQ/gdt3z4D1HyDQlpIdjHqeR4981mtU5nv6WbMNf10+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=akz2rL9Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="akz2rL9Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717088106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2KHCmvLmkLcThjWPa+zkoivDz59NtHiAmpDgS4Pp6y8=;
	b=akz2rL9ZYLwnYItSWSIt0Gni6lKgcawelV60Aei1R2/8D4yPagBUA0Ib3Uj2tI1aF6/yCa
	33Xdl+FlYVZaQphLN/SJhU5J7exgg7bHM0SpB6oMFSxSgqSRkCrOI5IV9v6rOwNRMqfBCH
	3/sLfTAooC13EPQaquqzYtu2O8pUjjQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-LbMgLUYQM0u8X8k-yxv-yg-1; Thu, 30 May 2024 12:55:03 -0400
X-MC-Unique: LbMgLUYQM0u8X8k-yxv-yg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BBD4880118E;
	Thu, 30 May 2024 16:55:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B48EB40C6EB7;
	Thu, 30 May 2024 16:55:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44UGt2ot397045
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 30 May 2024 12:55:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44UGt2lT397044;
	Thu, 30 May 2024 12:55:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Nitin Yewale <nyewale@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 5/7] multipath-tools man pages: add missing multipathd commands
Date: Thu, 30 May 2024 12:54:58 -0400
Message-ID: <20240530165500.397009-6-bmarzins@redhat.com>
In-Reply-To: <20240530165500.397009-1-bmarzins@redhat.com>
References: <20240530165500.397009-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Also, the description for "del map $map" was incorrect.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/multipathd.8.in | 42 +++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 06d91c06..32976052 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -114,18 +114,24 @@ The following commands can be used in interactive mode:
 Show the paths that multipathd is monitoring, and their state.
 .
 .TP
-.B list|show paths format $format
+.B list|show paths [raw] format $format
 Show the paths that multipathd is monitoring, using a format string with path
-format wildcards.
+format wildcards. Adding \fIraw\fR will remove the headers and alignment
+padding from the ouput.
+.
+.TP
+.B list|show path $path
+Show whether path $path is offline or running.
 .
 .TP
 .B list|show maps|multipaths
 Show the multipath devices that the multipathd is monitoring.
 .
 .TP
-.B list|show maps|multipaths format $format
+.B list|show maps|multipaths [raw] format $format
 Show the status of all multipath devices that the multipathd is monitoring,
-using a format string with multipath format wildcards.
+using a format string with multipath format wildcards. Adding \fIraw\fR will
+remove the headers and alignment padding from the output.
 .
 .TP
 .B list|show maps|multipaths status
@@ -138,6 +144,10 @@ Show some statistics of all multipath devices that the multipathd is monitoring.
 .TP
 .B list|show maps|multipaths topology
 Show the current multipath topology. Same as '\fImultipath \-ll\fR'.
+.TP
+.
+.B list|show maps|multipaths json
+Show information about all multipath devices in JSON format.
 .
 .TP
 .B list|show topology
@@ -149,6 +159,16 @@ Show topology of a single multipath device specified by $map, for example
 36005076303ffc56200000000000010aa. This map could be obtained from '\fIlist maps\fR'.
 .
 .TP
+.B list|show map|multipath $map [raw] format $format.
+Show the status of multipath device $map, using a format string with multipath
+format wildcards. Adding \fIraw\fR will remove the headers and alignment
+padding from the output.
+.
+.TP
+.B list|show map|multipath $map json
+Show information about multipath device $map in JSON format.
+.
+.TP
 .B list|show wildcards
 Show the format wildcards used in interactive commands taking $format.
 .
@@ -182,6 +202,14 @@ paths, and whether multipathd is currently handling a uevent.
 Show the current state of the multipathd daemon.
 .
 .TP
+.B reset maps|multipaths stats
+Reset the statistics of all multipath devices.
+.
+.TP
+.B reset map|multipath $map stats
+Reset the statistics of multipath device $map.
+.
+.TP
 .B add path $path
 Add a path to the list of monitored paths. $path is as listed in /sys/block (e.g. sda).
 .
@@ -197,8 +225,12 @@ for the multipath device (e.g. mpath1) or the uid of the multipath device
 (e.g. 36005076303ffc56200000000000010aa).
 .
 .TP
+.B remove|del maps|multipaths
+Remove all multipath devices.
+.
+.TP
 .B remove|del map|multipath $map
-Stop monitoring a multipath device.
+Remove the multipath device $map.
 .
 .TP
 .B resize map|multipath $map
-- 
2.45.0

