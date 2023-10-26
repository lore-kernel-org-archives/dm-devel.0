Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0C638FA0
	for <dm-devel@lists.linux.dev>; Thu, 26 Oct 2023 17:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KP36RBgp"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 74EA51FE64;
	Thu, 26 Oct 2023 17:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698342149; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rp6iGt5q3jYRAQbTE4KQyIA5s2Ipb/gpgKu3lM/KYCA=;
	b=KP36RBgpidJce934WWWeZkuRmic5jyx2CS/znad2M4p+I+kBu/GraWNhfvJfNQllY25Qmg
	mw6aZ/txEy4LVPw8D5lxea1XqX0cXb9H1wdPKwzVTnr7ANejbfsNjY+dWn5JIrAJg8I13j
	hh43g34yWdoiJqDBjqnV6uARkNnurtk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DFB731358F;
	Thu, 26 Oct 2023 17:42:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id APTJMgSlOmVGPgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 26 Oct 2023 17:42:28 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Li Xiao Keng <lixiaokeng@huawei.com>,
	Miao Guanqin <miaoguanqin@huawei.com>,
	Guan Junxiong <guanjunxiong@huawei.com>
Subject: [PATCH v2 06/14] libmultipath: io_err_stat: use higher number of aio slots
Date: Thu, 26 Oct 2023 19:41:45 +0200
Message-ID: <20231026174153.1133-7-mwilck@suse.com>
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

Currently the number of iocbs per path to test is the same as the
total number of iocbs in the ioctx. This can easily cause iocb
starvation, in particular if some IOs are hanging. In that case
io_submit() will fail, and some paths under test will use much
less IOs as intended, or in the worst case, none at all.

The total number of iocbs reserved in the kernel should be higher.
With this patch, we will be able to run the marginal path test for
at least NR_IOSTAT_PATHS=32 paths at the same time. This is not an upper
limit, because kernel IOCBs can be reused between paths.

Increase the log levels of io_setup and io_submit to make it sure
we catch problems with this approach.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Li Xiao Keng <lixiaokeng@huawei.com>
Cc: Miao Guanqin <miaoguanqin@huawei.com>
Cc: Guan Junxiong <guanjunxiong@huawei.com>
---
 libmultipath/io_err_stat.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index 3f32e32..5749003 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -38,6 +38,7 @@
 #define TIMEOUT_NO_IO_NSEC		10000000 /*10ms = 10000000ns*/
 #define FLAKY_PATHFAIL_THRESHOLD	2
 #define CONCUR_NR_EVENT			32
+#define NR_IOSTAT_PATHS			32
 
 #define PATH_IO_ERR_IN_CHECKING		-1
 #define PATH_IO_ERR_WAITING_TO_CHECK	-2
@@ -477,7 +478,7 @@ static int send_each_async_io(struct dio_ctx *ct, int fd, char *dev)
 		get_monotonic_time(&ct->io_starttime);
 		io_prep_pread(&ct->io, fd, ct->buf, ct->blksize, 0);
 		if (io_submit(ioctx, 1, ios) != 1) {
-			io_err_stat_log(5, "%s: io_submit error %i",
+			io_err_stat_log(2, "%s: io_submit error %i",
 					dev, errno);
 			return rc;
 		}
@@ -703,8 +704,8 @@ int start_io_err_stat_thread(void *data)
 	if (uatomic_read(&io_err_thread_running) == 1)
 		return 0;
 
-	if (io_setup(CONCUR_NR_EVENT, &ioctx) != 0) {
-		io_err_stat_log(4, "io_setup failed");
+	if (io_setup(CONCUR_NR_EVENT * NR_IOSTAT_PATHS, &ioctx) != 0) {
+		io_err_stat_log(1, "io_setup failed - increase /proc/sys/fs/aio-nr ?");
 		return 1;
 	}
 
-- 
2.42.0

