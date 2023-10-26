Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC27538FA3
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aJgxOnBJ"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DA7261FD9A;
	Thu, 26 Oct 2023 17:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342147; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MSFcUEcQ/T5FRrOgbxD0+zqGDxFN/OdMpPQpQXIR0O4=;
	b=aJgxOnBJDn8dRl2XIqETffKtKax2vGp5Q37B0Sr2S0kiwe6LqDBSzQa837plB90naubhiI
	BStKx0gEpSxT1GYWCp3oBGyC6QsgDzsk+3lefK9lTOIkqEr5uoAk/C1F4a9eaqN2npf7Ny
	HvFmfq1gC/QiTi0U8Xs5zAxy9QxTf+s=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47D141358F;
	Thu, 26 Oct 2023 17:42:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id CAF1DgOlOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:27 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Li Xiao Keng <lixiaokeng@huawei.com>,
	Miao Guanqin <miaoguanqin@huawei.com>,
	Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH v2 04/14] libmultipath: io_err_stat: don't free aio memory before completion
Date: Thu, 26 Oct 2023 19:41:43 +0200
Message-ID: <20231026174153.1133-5-mwilck@suse.com>
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
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -4.60
X-Spamd-Result: default: False [-4.60 / 50.00];
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
	 BAYES_HAM(-1.50)[91.69%]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

It is wrong to assume that aio data structures can be reused or freed
after io_cancel(). io_cancel() will almost always return -EINPROGRESS,
anyway. Use the io_starttime field to indicate whether an io event
has been completed by the kernel. Make sure no in-flight buffers are freed.

Fixes https://github.com/opensvc/multipath-tools/issues/73.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Li Xiao Keng <lixiaokeng@huawei.com>
Cc: Miao Guanqin <miaoguanqin@huawei.com>
Cc: Guan Junxiong <guanjunxiong@huawei.com>
---
 libmultipath/io_err_stat.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index dc1c252..c474c34 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -111,10 +111,14 @@ static int init_each_dio_ctx(struct dio_ctx *ct, int blksize,
 	return 0;
 }
 
-static void deinit_each_dio_ctx(struct dio_ctx *ct)
+static int deinit_each_dio_ctx(struct dio_ctx *ct)
 {
-	if (ct->buf)
-		free(ct->buf);
+	if (!ct->buf)
+		return 0;
+	if (ct->io_starttime.tv_sec != 0 || ct->io_starttime.tv_nsec != 0)
+		return 1;
+	free(ct->buf);
+	return 0;
 }
 
 static int setup_directio_ctx(struct io_err_stat_path *p)
@@ -164,6 +168,7 @@ fail_close:
 static void free_io_err_stat_path(struct io_err_stat_path *p)
 {
 	int i;
+	int inflight = 0;
 
 	if (!p)
 		return;
@@ -173,8 +178,13 @@ static void free_io_err_stat_path(struct io_err_stat_path *p)
 	cancel_inflight_io(p);
 
 	for (i = 0; i < CONCUR_NR_EVENT; i++)
-		deinit_each_dio_ctx(p->dio_ctx_array + i);
-	free(p->dio_ctx_array);
+		inflight += deinit_each_dio_ctx(p->dio_ctx_array + i);
+
+	if (!inflight)
+		free(p->dio_ctx_array);
+	else
+		io_err_stat_log(2, "%s: can't free aio space of %s, %d IOs in flight",
+				__func__, p->devname, inflight);
 
 	if (p->fd > 0)
 		close(p->fd);
@@ -503,7 +513,7 @@ static int try_to_cancel_timeout_io(struct dio_ctx *ct, struct timespec *t,
 	int		rc = PATH_UNCHECKED;
 	int		r;
 
-	if (ct->io_starttime.tv_sec == 0)
+	if (ct->io_starttime.tv_sec == 0 && ct->io_starttime.tv_nsec == 0)
 		return rc;
 	timespecsub(t, &ct->io_starttime, &difftime);
 	if (difftime.tv_sec > IOTIMEOUT_SEC) {
@@ -514,8 +524,6 @@ static int try_to_cancel_timeout_io(struct dio_ctx *ct, struct timespec *t,
 		if (r)
 			io_err_stat_log(5, "%s: io_cancel error %i",
 					dev, errno);
-		ct->io_starttime.tv_sec = 0;
-		ct->io_starttime.tv_nsec = 0;
 		rc = PATH_TIMEOUT;
 	} else {
 		rc = PATH_PENDING;
@@ -559,8 +567,6 @@ static void cancel_inflight_io(struct io_err_stat_path *pp)
 		if (r)
 			io_err_stat_log(5, "%s: io_cancel error %d, %i",
 					pp->devname, r, errno);
-		ct->io_starttime.tv_sec = 0;
-		ct->io_starttime.tv_nsec = 0;
 	}
 }
 
-- 
2.42.0

