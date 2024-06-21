Received: from out203-205-221-149.mail.qq.com (out203-205-221-149.mail.qq.com [203.205.221.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7837FBF3
	for <dm-devel@lists.linux.dev>; Fri, 21 Jun 2024 05:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718949042; cv=none; b=tnJVc9b/zlFHgCtJ9Z/uqQ+tnK1Td0kb5mlUfhFIWgjWxkp7NADC54GTvkRU2tEbT/ly6kVvumzX33sCRvRrtkFceeiA01TIXg8gSBAHknAi3npBgz0/nbXqnq5k0fC6oGhb65DAQ8AAGDrYlJjgtHAGLL9homd7BNhoTqAlukA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718949042; c=relaxed/simple;
	bh=Lb0SKkS9pokpBKNXfoBjTT4kCN1hqsP4Sm4uMO4tfgc=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=OLWr64ZICSKGoQ2X94t4HvQrtsIfegofGjtnbOK64inJbw+YeYb7htjLbPzHpLhWjiszoY1X5fe4T6gCiWl3ARIEdfWqyZHI11jBD+yHJeFsJCv8kBClyaWZc7iQVtqfPGxbEjtLOsppoMaOKh+TAuYZ0Psl5ARU1gaQuZDMNEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=pKY0O6+Z; arc=none smtp.client-ip=203.205.221.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="pKY0O6+Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1718949031; bh=9UN+5mrz9/+dVZqayLcDV1SeJMFA1zY6fWx2LaYwIbE=;
	h=From:To:Cc:Subject:Date;
	b=pKY0O6+ZzBDCmaYDDwgVcg935ihqBZ+QZRCbUsqKraRUDiW4+bZKxXeitwO5eI7Ko
	 1wpcDSowcllL9EYZ6BFwrQgCyqJoiCrF9CNDUz2or6M/Ei5bZZQBHG0BcX31I0Vnfy
	 3EN6ijZR44haSWP8VeI34nt7WUDbGLSIj9fFOJlA=
Received: from localhost.localdomain ([123.150.8.42])
	by newxmesmtplogicsvrsza29-0.qq.com (NewEsmtp) with SMTP
	id B12100B3; Fri, 21 Jun 2024 13:44:18 +0800
X-QQ-mid: xmsmtpt1718948658td1eqxgec
Message-ID: <tencent_3AC35DC56B065071A7930A3C4FAD98117D0A@qq.com>
X-QQ-XMAILINFO: MRw/zKT/0BpP0U+3bzPOhdT3bVoRyitaIWFybxVC2fQhQOFN2mqy65hoC4rPDf
	 ysDyod+zoQC24kKUCnMtPGLcbVMUi3/ZaRo8zEihbjmyxtq5N6wUYUnEKwQivM7LCcuWYV8v3TyZ
	 qhc7BU0wmZAa2eLdnIJF+ucvwcUmt4/+nmAF3fBWpDcsikyZm9gYRsRiiXSasGeRusZVUTM0Mfgv
	 cGGiT9cabpFd1SwxQgljEO5yXhKmqznjq9d5XSIAVo1uueSKj6PtQTJRkKwxfEUhnofHjoMi2ZC4
	 8egS6RLGNe/LRX93c+ofSmi0Xciz2KEZ69fPf+8snzYtQECBXYmarfnR3bn5POr6X1O2o8+sFK8Y
	 ozzNepvQAnM18hamGjLAjQ5XBeUW/H7i55ufLoZvFAU38ixeNzO22NdmkVCRDbQkIIr7P5r7wDqP
	 T+OkcwOtyNrd9X8vpWVCSH3ZFV6NQDFIbmWRYwQ9uCgkzlybdmsyi8+CXRaaH7WMLEwbvprfkFHp
	 vz2HGpdo8IrcyuOC9nfOBN3P4eqAVt6YiO3tSa+pRqXdI9krtCa8nSbLigK1LI/sWikfTJaHvlHe
	 3YxM1sYNCNjE/aXs2KzT2ywFeGWouq/SFIw3zEmvPWFZO9QxHdYh9CNKQFTrIPIwh4Hn/RIygqSO
	 yqSbyaZhM094wagVXJ+dXOiGGtNkKui2dk3f6fRPO0o/nFRz7Hu+8otiHHAJrf3oS4NqZNd3Zusw
	 xav9yW17Ia2Ub7xWfkHW6IRcWbWUbWLtZpjY396ZcacL4F9FCbabHovUHVp4ufvZbHsM/NNspUsM
	 d/WiBmlFTyUjU+G351wAIsg1KpsEHZ3nFhgACukDqtU0NEGBotf2AzS1DANbTHUEuNbUHu0GoEDQ
	 Lfl5Skci8ugLMsiMaLxUG+3zP1ecfNontYZwqTru05RBo14HePdGQ=
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: 303146950@qq.com
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	Kou Wenqi <kouwenqi@kylinos.cn>
Subject: [PATCH] multipath: do not change configuration when dumpping config
Date: Fri, 21 Jun 2024 13:44:10 +0800
X-OQ-MSGID: <20240621054410.7416-1-303146950@qq.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kou Wenqi <kouwenqi@kylinos.cn>

"multipath -t" and "multipath -T" might change multipathd
configuration items "retrigger_tries" and "force_sync".
Make sure they don't.

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

