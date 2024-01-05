Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386C935EE1
	for <dm-devel@lists.linux.dev>; Fri,  5 Jan 2024 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VQ6vidfn";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="VQ6vidfn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4BFCE1FB51;
	Fri,  5 Jan 2024 18:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1704480046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OzA+lfl/X1Yzyho1mkWph0HgAiM4hkVUYjhoYdlpQYw=;
	b=VQ6vidfn7o9iZ6NSRpIU6WTLvmYbz1MizK7FBLgaZcXlR6EIXwpUuM7Uq4FhIJ+5s4ToN4
	vT3DpucSaMD+hlPNkNImAi+rzbBR59fcpOIFvm72HiMsJr5Oh5JeEUjCPsb/grr8Q7/ova
	trsEXM/sklbXZ7p17BAIEGZpMuzK9rU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1704480046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OzA+lfl/X1Yzyho1mkWph0HgAiM4hkVUYjhoYdlpQYw=;
	b=VQ6vidfn7o9iZ6NSRpIU6WTLvmYbz1MizK7FBLgaZcXlR6EIXwpUuM7Uq4FhIJ+5s4ToN4
	vT3DpucSaMD+hlPNkNImAi+rzbBR59fcpOIFvm72HiMsJr5Oh5JeEUjCPsb/grr8Q7/ova
	trsEXM/sklbXZ7p17BAIEGZpMuzK9rU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0CC7F136F5;
	Fri,  5 Jan 2024 18:40:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mAf6AC5NmGWjYQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 05 Jan 2024 18:40:46 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/3] multipath-tools: coverity defect fixes
Date: Fri,  5 Jan 2024 19:40:33 +0100
Message-ID: <20240105184037.16518-1-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: **
X-Spam-Score: 2.81
X-Spamd-Result: default: False [2.81 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
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
	 BAYES_HAM(-0.89)[85.92%]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

Fixes for defects reported by coverity (new defects in old code).
So far I haven't had time to test them thoroughly.

Martin Wilck (3):
  multipathd: init_unwinder: protect pthread_cond_wait() call with a
    loop
  libmultipath: is_uevent_busy(): check servicing_uev under lock
  libmultipath: tur: protect pthread_cond_timedwait with a loop

 libmultipath/checkers/tur.c | 9 ++++++---
 libmultipath/uevent.c       | 5 +++--
 multipathd/init_unwinder.c  | 6 +++++-
 3 files changed, 14 insertions(+), 6 deletions(-)

-- 
2.43.0

