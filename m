Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42DD1FFC6D
	for <dm-devel@lists.linux.dev>; Tue,  2 Dec 2025 03:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764644542; cv=none; b=oYJoqWBtPh0m0Oke2X3uzwChbGSvO1lHuvmyvoEDNK2xT6ruLBL0nD97enXfWNf46FFn/LMbC02Fyr9jtEDm/A4KU1SLhfv2F86DfUu+KFnitEu4MvcTx6rLFroiKtFog7OGYX6ilUmHUtdH6IMmodBKdvOc81wgAk/EyNC63xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764644542; c=relaxed/simple;
	bh=MQ+u8PYAre6sq0oyKsZFqU7wDPF2uaqIh+UZIkg2yG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=B8J+E9Jw3DIA3NVyvMOi5yD0vLq/zHlSUbc8elL6cKX852WW0SuKlH7D0lFyVVljDl/9ETx6MtfPAZUlmptegkvESZXeLb/KoyC50j6lUJHBeI017WJJPcUu/sK2omg7u4FVjMuSiVWjikBCkY8Ot1DDSvlJi/d0ihs5SBvsrtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Sm/0CF4P; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Sm/0CF4P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764644539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ojPFNUTSjvyuooXSOhpW//rVLMFVba4hFMaI3eYCioQ=;
	b=Sm/0CF4PHo+M0eGeAyrHHtFr/e596TEGLG9JDLuHtEoC8/5qvq+h0JppCen9nnsBr0f8h0
	ZzavV63CGJlJq679J9x4Gk0rgWXI4CFdFb9Kb7Hxoep/3AHoNNOfFPL9usO9CenHpo7zHA
	wE3WqXn7I8NIGDGk0NMJHrMZXfCklvk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-57-vCuR9E2_OcSKzUyJu-zRgw-1; Mon,
 01 Dec 2025 22:02:16 -0500
X-MC-Unique: vCuR9E2_OcSKzUyJu-zRgw-1
X-Mimecast-MFC-AGG-ID: vCuR9E2_OcSKzUyJu-zRgw_1764644535
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A46E1800357;
	Tue,  2 Dec 2025 03:02:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 43B20180047F;
	Tue,  2 Dec 2025 03:02:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5B232EJS1432985
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 1 Dec 2025 22:02:14 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5B232Ewl1432984;
	Mon, 1 Dec 2025 22:02:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 2/4] multipath-tools man pages: fix multipathd commands keyword ordering
Date: Mon,  1 Dec 2025 22:02:11 -0500
Message-ID: <20251202030213.1432964-3-bmarzins@redhat.com>
In-Reply-To: <20251202030213.1432964-1-bmarzins@redhat.com>
References: <20251202030213.1432964-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nS8cEWNuj1r22Jnh2R4ZLvOlFObrgQ3ju1E0f_rJgIc_1764644535
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

multipathd now has a fixed ordering of the keywords. Specifically, verbs
must come first. Fix the man page to reflect the ordering.

Fixes: f812466f6 ("multipathd: more robust command parsing")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/multipathd.8.in | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/multipathd/multipathd.8.in b/multipathd/multipathd.8.in
index 8815e099..7ffb8d4c 100644
--- a/multipathd/multipathd.8.in
+++ b/multipathd/multipathd.8.in
@@ -344,48 +344,48 @@ will not be disabled when the daemon stops.
 Restores configured queue_without_daemon mode.
 .
 .TP
-.B map|multipath $map setprstatus
+.B setprstatus map|multipath $map
 Enable persistent reservation management on $map.
 .
 .TP
-.B map|multipath $map unsetprstatus
+.B unsetprstatus map|multipath $map
 Disable persistent reservation management on $map.
 .
 .TP
-.B map|multipath $map getprstatus
+.B getprstatus map|multipath $map
 Get the current persistent reservation management status of $map.
 .
 .TP
-.B map|multipath $map getprkey
+.B getprkey map|multipath $map
 Get the current persistent reservation key associated with $map.
 .
 .TP
-.B map|multipath $map setprkey key $key
+.B setprkey map|multipath $map key $key
 Set the persistent reservation key associated with $map to $key in the
 \fIprkeys_file\fR. This key will only be used by multipathd if
 \fIreservation_key\fR is set to \fBfile\fR in \fI@CONFIGFILE@\fR.
 .
 .TP
-.B map|multipath $map unsetprkey
+.B unsetprkey map|multipath $map
 Remove the persistent reservation key associated with $map from the
 \fIprkeys_file\fR. This will only unset the key used by multipathd if
 \fIreservation_key\fR is set to \fBfile\fR in \fI@CONFIGFILE@\fR.
 .
 .TP
-.B path $path setmarginal
+.B setmarginal path $path
 move $path to a marginal pathgroup. The path will remain in the marginal
 path group until \fIunsetmarginal\fR is called. This command will only
 work if \fImarginal_pathgroups\fR is enabled and there is no Shaky paths
 detection method configured (see the multipath.conf man page for details).
 .
 .TP
-.B path $path unsetmarginal
+.B unsetmarginal path $path
 return marginal path $path to its normal pathgroup. This command will only
 work if \fImarginal_pathgroups\fR is enabled and there is no Shaky paths
 detection method configured (see the multipath.conf man page for details).
 .
 .TP
-.B map $map unsetmarginal
+.B unsetmarginal map $map
 return all marginal paths in $map to their normal pathgroups. This command
 will only work if \fImarginal_pathgroups\fR is enabled and there is no Shaky
 paths detection method configured (see the multipath.conf man page for details).
-- 
2.50.1

