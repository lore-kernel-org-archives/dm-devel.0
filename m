Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D0220DF6
	for <dm-devel@lists.linux.dev>; Thu,  4 Jan 2024 11:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="K3Bl+pnZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ghMHwPBf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E2C8D21DAF;
	Thu,  4 Jan 2024 11:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1704366462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Ur4brUUBICDLjrAgRMJOZ7HXPQwhSUxCSAdnzG75k0E=;
	b=K3Bl+pnZh8AiJWJ0kvZDfOAa6GRPey5F4SADKvwQAus7oHw+rx+8lWGWAly17e3PtpG+ep
	Z1J+8aaIYUBLyycYAStNMvui0PYRB6MN9D+rZd0JFYZPTdgdIRktDExg+MxA8ksbWH26FF
	9nq9efZqMXNk1wshyA6ENSj+I4jXtYM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1704366461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Ur4brUUBICDLjrAgRMJOZ7HXPQwhSUxCSAdnzG75k0E=;
	b=ghMHwPBfoBn7hBejKJZQ1W5K1dEZcqrYYbftQ6MHtqi9GSvGBLqxdtvi29fq60hoFktbK5
	YkGK/BdmRr+l/+hPEKVg4t+rMJp6iUoFeaejDXyr6BYI9WiHXVsDb+Wveu6z+0BZRusdbC
	K5sUzn3oFml6YOfBFHktnJQiT/aqxKA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D62013722;
	Thu,  4 Jan 2024 11:07:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id N8kaIH2RlmVSfgAAD6G6ig
	(envelope-from <mwilck@suse.com>); Thu, 04 Jan 2024 11:07:41 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Lidong Zhong <lidong.zhong@suse.com>
Subject: [PATCH] libmultipath: fix ANA prioritizer enablement logic
Date: Thu,  4 Jan 2024 12:07:32 +0100
Message-ID: <20240104110732.9110-1-mwilck@suse.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: *
X-Spam-Score: 1.11
X-Spamd-Result: default: False [1.11 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RCPT_COUNT_FIVE(0.00)[5];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 FROM_NO_DN(0.00)[];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[libprioana.so:url,suse.com:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-2.59)[98.19%]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

Fixes: 3e71d8a ("multipath-tools Makefiles: create config.mk")

Suggested-by: Lidong Zhong <lidong.zhong@suse.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/prioritizers/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index fdec36e..ff2524c 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -26,7 +26,7 @@ LIBS = \
 	libpriopath_latency.so \
 	libpriosysfs.so
 
-ifneq ($(ANA_SUPPORT),1)
+ifeq ($(ANA_SUPPORT),1)
 	LIBS += libprioana.so
 	CPPFLAGS += -I../nvme
 endif
-- 
2.43.0

