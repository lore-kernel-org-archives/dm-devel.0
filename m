Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82AC38FA9
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="r0Dpgjyb"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C07E321AD9;
	Thu, 26 Oct 2023 17:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342148; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sWOYifjRo0pjoi2bV7Gs3EioF8gZFSxPfXdUnZYDoJA=;
	b=r0Dpgjybqs6VHwLiu2FoFWuGD8PsTmucBAw960owBnmXS43lVOggjQO/VogJrW2Gwv2UmJ
	is6mTk6h1W5ApOfXnXG0Qp20pP35/hhZTgcKHIUsiSAnFpbHHBxij0RCNB0IN8sJrFL7ij
	FH0Lh6Aiw7pPfX6BUczWUnbH+om8PwQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F07771358F;
	Thu, 26 Oct 2023 17:42:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id CBa6NgOlOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:27 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Li Xiao Keng <lixiaokeng@huawei.com>,
	Miao Guanqin <miaoguanqin@huawei.com>,
	Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH v2 05/14] libmultipath: io_err_stat: call io_destroy() inside free_io_err_pathvec()
Date: Thu, 26 Oct 2023 19:41:44 +0200
Message-ID: <20231026174153.1133-6-mwilck@suse.com>
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
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -5.15
X-Spamd-Result: default: False [-5.15 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.com:s=susede1];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 FROM_NO_DN(0.00)[];
	 RCPT_COUNT_SEVEN(0.00)[7];
	 MID_CONTAINS_FROM(1.00)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-2.05)[95.32%]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

Memory used by aio iocbs must not be freed before either all iocbs
have finished, or io_destroy() has been called (which will wait until
all iocbs have finished).

Don't call cancel_inflight_io() from free_io_err_stat_path(). Rather,
cancel directly from free_io_err_pathvec(). This way we make sure that
we can't call io_cancel() with an already destroyed ioctx, and that
we don't free memory of in-flight requests.

The other callers of free_io_err_stat_path() also don't need to call
cancel_inflight_io(). In service_paths(), where free_io_err_stat_path()
it is called for paths on which all IO has either finished or timed out,
hanging requests will already have been cancelled in the
try_to_cancel_timeout_io() code path (note that total_time is at least
2 * IO_TIMEOUT_SEC). In the failure case of enqueue_io_err_stat_by_path(), no
IO has been submitted yet.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Li Xiao Keng <lixiaokeng@huawei.com>
Cc: Miao Guanqin <miaoguanqin@huawei.com>
Cc: Guan Junxiong <guanjunxiong@huawei.com>
---
 libmultipath/io_err_stat.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index c474c34..3f32e32 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -175,8 +175,6 @@ static void free_io_err_stat_path(struct io_err_stat_path *p)
 	if (!p->dio_ctx_array)
 		goto free_path;
 
-	cancel_inflight_io(p);
-
 	for (i = 0; i < CONCUR_NR_EVENT; i++)
 		inflight += deinit_each_dio_ctx(p->dio_ctx_array + i);
 
@@ -221,6 +219,15 @@ static void free_io_err_pathvec(void)
 	pthread_cleanup_push(cleanup_mutex, &io_err_pathvec_lock);
 	if (!io_err_pathvec)
 		goto out;
+
+	/* io_cancel() is a noop, but maybe in the future it won't be */
+	vector_foreach_slot(io_err_pathvec, path, i) {
+		if (path && path->dio_ctx_array)
+			cancel_inflight_io(path);
+	}
+
+	/* This blocks until all I/O is finished */
+	io_destroy(ioctx);
 	vector_foreach_slot(io_err_pathvec, path, i)
 		free_io_err_stat_path(path);
 	vector_free(io_err_pathvec);
@@ -752,5 +759,4 @@ void stop_io_err_stat_thread(void)
 
 	pthread_join(io_err_stat_thr, NULL);
 	free_io_err_pathvec();
-	io_destroy(ioctx);
 }
-- 
2.42.0

