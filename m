Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D226624
	for <dm-devel@lists.linux.dev>; Mon, 24 Jun 2024 01:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719193563; cv=none; b=BfmZX0WpQbYehbe3DcY78pe9VIEuZVlJxnfNzdchyhLXLQO6z7lqIYS4paKmMWM1Ghjp1f2k98XnU/0WEmWRzzzCH9AhNUVCGvNJTvY4iGicHBUxexNpXHBnxydQEAANhE8k3P2GkPqaWmqEgTPdoc1zIKNfqANMngTVQ+/Ip4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719193563; c=relaxed/simple;
	bh=9fD1cvn5h0pGoYhgIEHNsqdozgCAI6O+ikLKMryFpjs=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=u+Qh3tqPr/a+PCf5/aJCnEw8td02GMc4wYAvPQwrvGCVJZOZjGiubY+5XceI340W90NdMH9prwa6T5DYjpaxkCz85winmjKZUzAN/LWtTIbq8bn7AZJt7MvpYOHswauhIWTMtbmZEihbpQyAYk+uvThh4toCjxDwjw8yW06/8s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=n1tx/1p+; arc=none smtp.client-ip=162.62.57.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="n1tx/1p+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1719193549; bh=Qn6FbS/vi/zduJxdCS9vtQS2pzRQ8M5Zl5odmZ9NOEo=;
	h=From:To:Cc:Subject:Date;
	b=n1tx/1p+un/gxCYz8nUA+VNoRzlWCnKTrSKqiHTTsYW/g91YTCUnMe1mwUstxrN2H
	 IORe50XvRE2dEyGp8YOrjwESFWP+2A9uoREUz1BeXhBarGlyFfP2DoBDmeySiz24cX
	 mE5dN1X9U8jz9RtTryVW/oVyEdDI3NbCIhe4SzeI=
Received: from localhost.localdomain ([123.150.8.42])
	by newxmesmtplogicsvrszb16-1.qq.com (NewEsmtp) with SMTP
	id B64200F0; Mon, 24 Jun 2024 09:45:36 +0800
X-QQ-mid: xmsmtpt1719193536t20l61l27
Message-ID: <tencent_FE02DEB8FF48DD9EE156F288BCE172E25709@qq.com>
X-QQ-XMAILINFO: OQhZ3T0tjf0auiQIUAhPd51+pV/yE/t1YwZOV6jlrRiKlUuJnwX1NyhLP1OnOF
	 n/kaReaIHS7bRhni7fEQ4bmj8vBKCPhAHubRSRAUgszbaZifhdKrDB2M6GbHRKM2JrPciGJo6FlG
	 Iy/rxl1YYtPNtcsedOVC7qwUqblFVm2l2e//C6UiJXiKhnjkdPlaTz6yyfGylHRgQkF/FtL2b9p6
	 paMt7MSKGaf4K1DmN5Eh1F97eJa71ef1S40q26VLYTfhqnK4fzLAQkE67TZzx6AwTj9Xkv85Npky
	 FdWCMIaVsB7+hD2qE3FKIWUDTTI6N41S/SLPxEbHZpPzCCNdq7iTMnKJspkYCgRo3depxvRW8tGp
	 NQ45Lpwv9p71g64AzWUqAtg9mWTbHDQMFGCYxBt5j/WxjSsKf3sPt0tPSZzwG9fFXFuYOyxgtLGx
	 Sq1xMuWoRhActgcF+2TvWxfArSuRJHZdIYgGmPeaeHXmJV7CY7vkKky4BEbRtibST0/TIp2ohVoC
	 84O1GtbRFPk1tvGcLcwwVVIxPE2HzaXB/BwiDN1BKRTXcz9UXEtf1qiSoQSqQFUxKgex9iDTvK9C
	 vrWbKfAk1CKqCeRCyhW+HupGrq0Z1Ameqwg2tFIxKQb+S3O1I8QUeFhAbYpi5GhZub1B/FCsJi61
	 JDq8UAqo730aGD1QOt0dn39tBCqkOn5wmN/tPH5HJOfyh+rIKbk9PzuOP2ntADZ1dIs59oWwv9RL
	 7mSIsF8ImunQLwQSccHAD/4G4GdWyibsLCMTFGipTRk/md2h5HdZzl00aQUgSs0EzL3qHujdughw
	 OnNOWuHfESFsaN1GIiWisoCgzhN1GN+IXIAqq7r+oq1zxDEBDqyEA/BzBbWsc1kSPPe+xjPXVCjD
	 pNjYOOCQevaKYSOaQAV4QzgzJxBy+nFNCq5TpkwGfkMfEbIcFMDNE2GkmvZqS2MA==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: 303146950@qq.com
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	Kou Wenqi <kouwenqi@kylinos.cn>
Subject: [PATCH v2] multipath: display the correct configuration when dumpping config
Date: Mon, 24 Jun 2024 09:45:27 +0800
X-OQ-MSGID: <20240624014527.155640-1-303146950@qq.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kou Wenqi <kouwenqi@kylinos.cn>

"multipath -t" and "multipath -T" might show the wrong
multipathd configuration items "retrigger_tries" and
"force_sync". Make sure they don't.

Signed-off-by: Kou Wenqi <kouwenqi@kylinos.cn>
---
 multipath/main.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/multipath/main.c b/multipath/main.c
index ce702e7f..f4abdad0 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -842,6 +842,8 @@ main (int argc, char *argv[])
 	char *dev = NULL;
 	struct config *conf;
 	bool enable_foreign = false;
+	int retrigger_tries_ori;
+	int force_sync_ori;
 
 	libmultipath_init();
 	if (atexit(dm_lib_exit) || atexit(libmultipath_exit))
@@ -852,7 +854,9 @@ main (int argc, char *argv[])
 	if (atexit(uninit_config))
 		condlog(1, "failed to register cleanup handler for config: %m");
 	conf = get_multipath_config();
+	retrigger_tries_ori = conf->retrigger_tries;
 	conf->retrigger_tries = 0;
+	force_sync_ori = conf->force_sync;
 	conf->force_sync = 1;
 	if (atexit(cleanup_vecs))
 		condlog(1, "failed to register cleanup handler for vecs: %m");
@@ -924,10 +928,14 @@ main (int argc, char *argv[])
 				conf->find_multipaths = FIND_MULTIPATHS_GREEDY;
 			break;
 		case 't':
+			conf->retrigger_tries = retrigger_tries_ori;
+			conf->force_sync = force_sync_ori;
 			r = dump_config(conf, NULL, NULL) ? RTVL_FAIL : RTVL_OK;
 			goto out;
 		case 'T':
 			cmd = CMD_DUMP_CONFIG;
+			conf->retrigger_tries = retrigger_tries_ori;
+			conf->force_sync = force_sync_ori;
 			break;
 		case 'h':
 			usage(argv[0]);
-- 
2.27.0

