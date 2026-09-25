Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD9341D4D6
	for <dm-devel@lists.linux.dev>; Fri, 25 Sep 2026 21:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790372449; cv=none; b=lyQHudzbRrXqA6xoh9RgGPDRg8BhzQ9xBdTAqKtDTQK10ehPhXFgL9ZiGKrdhgv9grxZCSeocu8svW+ZG45Vm6+km1Gdr2xXfWCj7x1Jw8vFnPp8hxD25bDdT5ko5nv4Z2GKj32UaYGMAqCJSrKw28wl17wbnyPYttAgujbr5vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790372449; c=relaxed/simple;
	bh=SEct7GiB1AxQCdqCJnnfybgiy649xBQIVP//cvoR7mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mu1WRTpr/geH7vUiq35+/apXyEzeW1dgY4sjDPHmwUfiQrbI2lSb6YPYJHYTikItPy9h9nH+pPuyL9ZuTqvCfcTu5D0np0x9yx3BTV/O7Zm3W5OfMYHFWUXqI+L1RATnefALJwH6EWm4aS7ASdUPT7oJaRZI8pO/l1i3cB5m7JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sJRzBPp+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FILocg44; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ed1LTGYf; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2PtOf0Ck; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sJRzBPp+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FILocg44";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ed1LTGYf";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2PtOf0Ck"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E6EBE1F44F;
	Fri, 25 Sep 2026 21:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790372442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1iSQwf/PTPg+k1GJUXH3aEdFl6HrR5axZXbMgEtkDqQ=;
	b=sJRzBPp+8xwLVTqAOr2HwgAftMe035XyipHiYk337u4/YBWnPCAhG34uVlbJ27/foEcA5t
	ncgA0VV7Hmu+ExNqPkhH1ZfTLH0+0ZvSdtsMXVz2/DAIk6aQp3cOqUJsCraI/ANWeHPqQy
	inpQn1fFSf7JjsAn7qgekCOMGTzURvA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790372442;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1iSQwf/PTPg+k1GJUXH3aEdFl6HrR5axZXbMgEtkDqQ=;
	b=FILocg44uSq4NfrYIEy4FOaV0fwXHumN7w8v/e5if5mq1VKHwdeoFpxJDokcLucW0NSnUT
	oI9/Q2zpbg8UGnBA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ed1LTGYf;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2PtOf0Ck
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790372437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1iSQwf/PTPg+k1GJUXH3aEdFl6HrR5axZXbMgEtkDqQ=;
	b=ed1LTGYfmCFsF86cmxAZbrqpyKrQxAmfa93xi2aJizo+oo8HWtKdo3ipPlfX4Lsy0PFpEK
	8pAHE6ZzAAn+kZxILGii8HWmArDyHvZSWBH+NnDPhIF5Di3h9U12Av/U8p+71jkHs/pm90
	M/x/05ePaxy+nJyaCNXGUABCLMJwy9A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790372437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1iSQwf/PTPg+k1GJUXH3aEdFl6HrR5axZXbMgEtkDqQ=;
	b=2PtOf0Ck+gK7O4tDKVvcCh6qNNa8q9jFM/GQRo8CHwtas/awaAlIgpDYthE08ig8NfU+pS
	rFb4c1SJcS5IwQDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74EF313274;
	Fri, 25 Sep 2026 21:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7imQB1XqtmoZLwAAD6G6ig:T2
	(envelope-from <mwilck@suse.de>); Fri, 25 Sep 2026 21:40:37 +0000
From: mwilck@suse.de
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 1/4] libmultipath: constify functions in wwid.c
Date: Fri, 25 Sep 2026 23:40:06 +0200
Message-ID: <20260925214014.2464499-2-mwilck@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260925214014.2464499-1-mwilck@suse.de>
References: <20260925214014.2464499-1-mwilck@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E6EBE1F44F
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_NO_DN(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

From: Martin Wilck <mwilck@suse.com>

Use `const char *wwid` where possible.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/wwids.c | 15 ++++++---------
 libmultipath/wwids.h |  6 +++---
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index aac18c0..c193b97 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -25,7 +25,7 @@
  */
 
 static int
-lookup_wwid(FILE *f, char *wwid) {
+lookup_wwid(FILE *f, const char *wwid) {
 	int c;
 	char buf[LINE_MAX];
 	int count;
@@ -58,7 +58,7 @@ next:
 }
 
 static int
-write_out_wwid(int fd, char *wwid) {
+write_out_wwid(int fd, const char *wwid) {
 	int ret;
 	off_t offset;
 	char buf[WWID_SIZE + 3];
@@ -189,9 +189,8 @@ do_remove_wwid(int fd, char *str) {
 	}
 }
 
-
-int
-remove_wwid(char *wwid) {
+int remove_wwid(const char *wwid)
+{
 	int fd = -1;
 	int len, can_write;
 	char *str;
@@ -231,8 +230,7 @@ out:
 	return ret;
 }
 
-int
-check_wwids_file(char *wwid, int write_wwid)
+int check_wwids_file(const char *wwid, int write_wwid)
 {
 	int fd, can_write, found, ret;
 	FILE *f;
@@ -321,8 +319,7 @@ should_multipath(struct path *pp1, vector pathvec, vector mpvec)
 	return 1;
 }
 
-int
-remember_wwid(char *wwid)
+int remember_wwid(const char *wwid)
 {
 	int ret = check_wwids_file(wwid, 1);
 	if (ret < 0){
diff --git a/libmultipath/wwids.h b/libmultipath/wwids.h
index ee47ad9..5606ac6 100644
--- a/libmultipath/wwids.h
+++ b/libmultipath/wwids.h
@@ -13,9 +13,9 @@
 "# Valid WWIDs:\n"
 
 int should_multipath(struct path *pp, vector pathvec, vector mpvec);
-int remember_wwid(char *wwid);
-int check_wwids_file(char *wwid, int write_wwid);
-int remove_wwid(char *wwid);
+int remember_wwid(const char *wwid);
+int check_wwids_file(const char *wwid, int write_wwid);
+int remove_wwid(const char *wwid);
 int replace_wwids(vector mp);
 
 enum {
-- 
2.55.0

