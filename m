Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEF138FA0
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LQzzgOzf"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3CB5A1FD96;
	Thu, 26 Oct 2023 17:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qAS+XjmKimDzPD6Sb6CMaXdhq+09JwYeop7FtyQvVBk=;
	b=LQzzgOzf1P+jsobsWpnYpNq6p2BFu9Imvk0w+6DbPSAsLxtnOGx0JN5U7fEhC8nymIVXco
	JLdoOk0lM4jT3T5akU6EnsCHRVOfCqskB2iMoIU+X00mKkBjePwq5NzA/t3CYaoVYCekVs
	atYdp2y9eGcsC3RJjuB+9b+FPQeJwpI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D168513A96;
	Thu, 26 Oct 2023 17:42:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id oFMoLwGlOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:25 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 01/14] libmultipath: reduce log level of directio messages
Date: Thu, 26 Oct 2023 19:41:40 +0200
Message-ID: <20231026174153.1133-2-mwilck@suse.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231026174153.1133-1-mwilck@suse.com>
References: <20231026174153.1133-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Martin Wilck <mwilck@suse.com>

The directio checker logs too much at verbosity 3.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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

