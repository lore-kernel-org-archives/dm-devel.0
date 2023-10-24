Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAADF2C872
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 16:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="k4rF7aK5"
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2C58C1FE93;
	Tue, 24 Oct 2023 16:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1698166188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gx5qDAcpms3q+Ut9vrYGogn72o9cSMxyb8NdVFAxPdI=;
	b=k4rF7aK5+7ZLgske30nZFrq+g2D88bEANGQcSbJjziNGYso2kvPRxEv3qMSs4DQo5mpZUw
	Wp1xwv5iRHLWxKpSOoxWBseQFQjSzBBlj6i47Ibk05OOfalpfVQ4/m+jwTNPa29ssvLP4e
	aLvg0DarB9dyXLSlNt8Op04Xi8pOhkU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CB09F134F5;
	Tue, 24 Oct 2023 16:49:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 4Ny9L6v1N2VadQAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 24 Oct 2023 16:49:47 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Miao Guanqin <miaoguanqin@huawei.com>,
	Li Xiao Keng <lixiaokeng@huawei.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 4/6] libmultipath: io_err_stat: call io_destroy() before free_io_err_pathvec()
Date: Tue, 24 Oct 2023 18:49:35 +0200
Message-ID: <20231024164937.14684-5-mwilck@suse.com>
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
X-Spam-Score: -4.53
X-Spamd-Result: default: False [-4.53 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
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
	 BAYES_HAM(-1.43)[91.17%]
X-Spam-Flag: NO

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/io_err_stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index c474c34..1982915 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -751,6 +751,6 @@ void stop_io_err_stat_thread(void)
 		pthread_cancel(io_err_stat_thr);
 
 	pthread_join(io_err_stat_thr, NULL);
-	free_io_err_pathvec();
 	io_destroy(ioctx);
+	free_io_err_pathvec();
 }
-- 
2.42.0

