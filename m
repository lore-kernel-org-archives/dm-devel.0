Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937712AB2F
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 16:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="cHaBHms8"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE6401FE91;
	Tue, 24 Oct 2023 16:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698166186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLa/8FiblCQOw2DT3ImD99Q+WgvUdBSduIYNpV2MPgY=;
	b=cHaBHms8dtgVUpphWoYJvcXZzY7BtC15R2rDzHwEmwwxMaIFh80krDkr06YEYG61HYUj/F
	yCRG12hvrjb/Nvuk3ULgINiie9rd/g4HHVka/NeJM7BkGuQOnbyGwHm9gX3DgcKU7OaFYK
	T1f+HQ8hruE1CpgwIIrGmrNe8jaQ4Yg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6EEF713A96;
	Tue, 24 Oct 2023 16:49:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id wNN6Gar1N2VadQAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 24 Oct 2023 16:49:46 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Miao Guanqin <miaoguanqin@huawei.com>,
	Li Xiao Keng <lixiaokeng@huawei.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/6] libmultipath: reduce log level of directio messages
Date: Tue, 24 Oct 2023 18:49:32 +0200
Message-ID: <20231024164937.14684-2-mwilck@suse.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231024164937.14684-1-mwilck@suse.com>
References: <20231024164937.14684-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: 0.90
X-Spamd-Result: default: False [0.90 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RCPT_COUNT_FIVE(0.00)[6];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 FROM_NO_DN(0.00)[];
	 MID_CONTAINS_FROM(1.00)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.00)[26.59%]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

The directio checker logs too much at verbosity 3.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/directio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 2f3ece0..25b2383 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -266,7 +266,7 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
 		for (i = 0; i < nr; i++) {
 			struct async_req *req = container_of(events[i].obj, struct async_req, io);
 
-			LOG(3, "io finished %lu/%lu", events[i].res,
+			LOG(4, "io finished %lu/%lu", events[i].res,
 			    events[i].res2);
 
 			/* got an orphaned request */
@@ -283,7 +283,7 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
 	} while (nr == 128); /* assume there are more events and try again */
 
 	if (nr < 0)
-		LOG(3, "async io getevents returned %i (errno=%s)",
+		LOG(4, "async io getevents returned %i (errno=%s)",
 		    nr, strerror(errno));
 
 	return got_events;
@@ -315,7 +315,7 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 	} else {
 		struct iocb *ios[1] = { &ct->req->io };
 
-		LOG(3, "starting new request");
+		LOG(4, "starting new request");
 		memset(&ct->req->io, 0, sizeof(struct iocb));
 		io_prep_pread(&ct->req->io, fd, ct->req->buf,
 			      ct->req->blksize, 0);
@@ -360,7 +360,7 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 			ct->running = 0;
 		rc = PATH_DOWN;
 	} else {
-		LOG(3, "async io pending");
+		LOG(4, "async io pending");
 		rc = PATH_PENDING;
 	}
 
-- 
2.42.0

