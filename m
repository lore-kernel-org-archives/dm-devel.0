Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3FC38FA2
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="B++2di0X"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2BCB41FD99;
	Thu, 26 Oct 2023 17:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342147; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JIx79esz0SHDHIWRI7L3jf/u6mUmZMxY93MB+hy6ZaU=;
	b=B++2di0X9kmLPh3ykK7d/wRGUYfQQzAgiZU6K5GOQC2AvCFrZSDyBXhg6r37r1yFSnFcSl
	s6omiUYvylu7JKqGHztMfy4MxlNiLhgM9G3pLvrB2wgveJmXBFIW78FQ7jy62qrtR/iROB
	W4QsyXlzXE8NQcR4sUbfDZkGL6KdecY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C15E913A96;
	Thu, 26 Oct 2023 17:42:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id oNElLAKlOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:26 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 03/14] libmultipath: directio: fix error handling
Date: Thu, 26 Oct 2023 19:41:42 +0200
Message-ID: <20231026174153.1133-4-mwilck@suse.com>
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

libaio uses a different error return convention than glibc. The error code is
not returned in errno, but as the negated return value of the function.
Adapt the directio checker code.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/checkers/directio.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/libmultipath/checkers/directio.c b/libmultipath/checkers/directio.c
index 83ab29f..12b8be4 100644
--- a/libmultipath/checkers/directio.c
+++ b/libmultipath/checkers/directio.c
@@ -70,6 +70,7 @@ static struct aio_group *
 add_aio_group(void)
 {
 	struct aio_group *aio_grp;
+	int rc;
 
 	aio_grp = malloc(sizeof(struct aio_group));
 	if (!aio_grp)
@@ -77,9 +78,9 @@ add_aio_group(void)
 	memset(aio_grp, 0, sizeof(struct aio_group));
 	INIT_LIST_HEAD(&aio_grp->orphans);
 
-	if (io_setup(AIO_GROUP_SIZE, &aio_grp->ioctx) != 0) {
+	if ((rc = io_setup(AIO_GROUP_SIZE, &aio_grp->ioctx)) != 0) {
 		LOG(1, "io_setup failed");
-		if (errno == EAGAIN)
+		if (rc == -EAGAIN)
 			LOG(1, "global number of io events too small. Increase fs.aio-max-nr with sysctl");
 		free(aio_grp);
 		return NULL;
@@ -259,7 +260,6 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
 	struct timespec *timep = timeout;
 
 	do {
-		errno = 0;
 		nr = io_getevents(aio_grp->ioctx, 1, 128, events, timep);
 		got_events |= (nr > 0);
 
@@ -283,8 +283,7 @@ get_events(struct aio_group *aio_grp, struct timespec *timeout)
 	} while (nr == 128); /* assume there are more events and try again */
 
 	if (nr < 0)
-		LOG(4, "async io getevents returned %i (errno=%s)",
-		    nr, strerror(errno));
+		LOG(4, "async io getevents returned %s", strerror(-nr));
 
 	return got_events;
 }
@@ -320,8 +319,8 @@ check_state(int fd, struct directio_context *ct, int sync, int timeout_secs)
 		io_prep_pread(&ct->req->io, fd, ct->req->buf,
 			      ct->req->blksize, 0);
 		ct->req->state = PATH_PENDING;
-		if (io_submit(ct->aio_grp->ioctx, 1, ios) != 1) {
-			LOG(3, "io_submit error %i", errno);
+		if ((rc = io_submit(ct->aio_grp->ioctx, 1, ios)) != 1) {
+			LOG(3, "io_submit error %i", -rc);
 			return PATH_UNCHECKED;
 		}
 	}
-- 
2.42.0

