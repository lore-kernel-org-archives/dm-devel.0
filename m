Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D8835EE7
	for <dm-devel@lists.linux.dev>; Fri,  5 Jan 2024 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1576921C3A;
	Fri,  5 Jan 2024 18:40:47 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6B1813C99;
	Fri,  5 Jan 2024 18:40:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4OmUMi5NmGWjYQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 05 Jan 2024 18:40:46 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 3/3] libmultipath: tur: protect pthread_cond_timedwait with a loop
Date: Fri,  5 Jan 2024 19:40:36 +0100
Message-ID: <20240105184037.16518-4-mwilck@suse.com>
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
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1576921C3A
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	 REPLY(-4.00)[]

From: Martin Wilck <mwilck@suse.com>

Defect reported by coverity (413383 Data race condition)

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/tur.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
index eb2fca1..2800446 100644
--- a/libmultipath/checkers/tur.c
+++ b/libmultipath/checkers/tur.c
@@ -438,9 +438,12 @@ int libcheck_check(struct checker * c)
 		}
 		tur_timeout(&tsp);
 		pthread_mutex_lock(&ct->lock);
-		if (ct->state == PATH_PENDING && ct->msgid == MSG_TUR_RUNNING)
-			r = pthread_cond_timedwait(&ct->active, &ct->lock,
-						   &tsp);
+
+		for (r = 0;
+		     r == 0 && ct->state == PATH_PENDING &&
+			     ct->msgid == MSG_TUR_RUNNING;
+		     r = pthread_cond_timedwait(&ct->active, &ct->lock, &tsp));
+
 		if (!r) {
 			tur_status = ct->state;
 			c->msgid = ct->msgid;
-- 
2.43.0

