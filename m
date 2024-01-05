Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D4D35EE5
	for <dm-devel@lists.linux.dev>; Fri,  5 Jan 2024 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="L7GXf5Vh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="L7GXf5Vh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CA4EF21C38;
	Fri,  5 Jan 2024 18:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1704480046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u89V/+ix42r5HMxxpdceKE5PkUmmAOZrI2zYST098Vw=;
	b=L7GXf5VhJPaxsQ7gzniTO0OISltiUP/YobHZEE1zVVRl/DbRZvsQLu3FpH1A0sWRdtlSB7
	WE3rYTZQUYb5ZEPSFhFJd7spxB5wYth/nBfUC8ra88fpSXIU15arteAshqAq2cO6w2iv3i
	di9NUdvDX2lagc1ayypSQGvEZBeGvgQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1704480046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u89V/+ix42r5HMxxpdceKE5PkUmmAOZrI2zYST098Vw=;
	b=L7GXf5VhJPaxsQ7gzniTO0OISltiUP/YobHZEE1zVVRl/DbRZvsQLu3FpH1A0sWRdtlSB7
	WE3rYTZQUYb5ZEPSFhFJd7spxB5wYth/nBfUC8ra88fpSXIU15arteAshqAq2cO6w2iv3i
	di9NUdvDX2lagc1ayypSQGvEZBeGvgQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96D63136F5;
	Fri,  5 Jan 2024 18:40:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cHIEIy5NmGWjYQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 05 Jan 2024 18:40:46 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 2/3] libmultipath: is_uevent_busy(): check servicing_uev under lock
Date: Fri,  5 Jan 2024 19:40:35 +0100
Message-ID: <20240105184037.16518-3-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105184037.16518-1-mwilck@suse.com>
References: <20240105184037.16518-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -3.00
X-Spamd-Result: default: False [-3.00 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FROM_NO_DN(0.00)[];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-2.70)[98.67%]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

This fixes a coverity-reported defect (413384 Data race condition).
Indeed, we always set servicing_uev with the lock held, so it makes
sense to read it with the lock held, too.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 3b5dd31..32135d7 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -82,12 +82,13 @@ static void reset_filter_state(struct uevent_filter_state *st)
 
 int is_uevent_busy(void)
 {
-	int empty;
+	int empty, servicing;
 
 	pthread_mutex_lock(uevq_lockp);
 	empty = list_empty(&uevq);
+	servicing = servicing_uev;
 	pthread_mutex_unlock(uevq_lockp);
-	return (!empty || servicing_uev);
+	return (!empty || servicing);
 }
 
 struct uevent * alloc_uevent (void)
-- 
2.43.0

