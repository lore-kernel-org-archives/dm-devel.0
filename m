Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386FD35EE3
	for <dm-devel@lists.linux.dev>; Fri,  5 Jan 2024 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8ACC71FB52;
	Fri,  5 Jan 2024 18:40:46 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 560BA13C99;
	Fri,  5 Jan 2024 18:40:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wNMhEy5NmGWjYQAAD6G6ig
	(envelope-from <mwilck@suse.com>); Fri, 05 Jan 2024 18:40:46 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/3] multipathd: init_unwinder: protect pthread_cond_wait() call with a loop
Date: Fri,  5 Jan 2024 19:40:34 +0100
Message-ID: <20240105184037.16518-2-mwilck@suse.com>
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
X-Rspamd-Queue-Id: 8ACC71FB52
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.00 / 50.00];
	 REPLY(-4.00)[]

From: Martin Wilck <mwilck@suse.com>

This fixes a coverity-reported defect (413387 Indefinite wait).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/init_unwinder.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/multipathd/init_unwinder.c b/multipathd/init_unwinder.c
index 14467f3..b1cd283 100644
--- a/multipathd/init_unwinder.c
+++ b/multipathd/init_unwinder.c
@@ -4,10 +4,12 @@
 
 static pthread_mutex_t dummy_mtx = PTHREAD_MUTEX_INITIALIZER;
 static pthread_cond_t dummy_cond = PTHREAD_COND_INITIALIZER;
+static int dummy_started;
 
 static void *dummy_thread(void *arg __attribute__((unused)))
 {
 	pthread_mutex_lock(&dummy_mtx);
+	dummy_started = 1;
 	pthread_cond_broadcast(&dummy_cond);
 	pthread_mutex_unlock(&dummy_mtx);
 	pause();
@@ -27,7 +29,9 @@ int init_unwinder(void)
 		return rc;
 	}
 
-	pthread_cond_wait(&dummy_cond, &dummy_mtx);
+	while (!dummy_started)
+		pthread_cond_wait(&dummy_cond, &dummy_mtx);
+
 	pthread_mutex_unlock(&dummy_mtx);
 
 	return pthread_cancel(dummy);
-- 
2.43.0

