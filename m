Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40DA3DDAF6
	for <dm-devel@lists.linux.dev>; Tue,  6 Oct 2026 20:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791319554; cv=none; b=ehGFjr2P4H5579woQmaRxeI9dVxXxamBFsbOqBjHmxX9YcHENpATHdf0Oj4NLUh1/6O2DNm5FnUotgZL6VvwuJ2032T8qiHy8mTGJL+QoBGBdmbiwegjKURdQmpvo8LZ/s3ApmVJrOPNrgCTpfZYfHbAWa3JhtIDoPbD9sDq48E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791319554; c=relaxed/simple;
	bh=AKEKMJAAXLdh4l261Fe1n/RklpW721QWlNZ3BzBsCL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgkXvl2H60HVXhG12dUDbrlimwRGDWMZ1wYNuh4nvGu2P1M4QH+QF/nZwzX166+KkvBKVjcf+00yD74MyQ17H0nz26lnDflSHBfZzNhDJJV8BrIJEcmA1l8Eboxg7Zq3x8ToyTGzxsjyTJhLYxPQXOOEujV1Mmh8AuqkAjHJjOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JkIU7Fi7; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=UVeQqVWB; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ZvhgYwF/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=5KlcO9G6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JkIU7Fi7";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="UVeQqVWB";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ZvhgYwF/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="5KlcO9G6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 46E611F7B7;
	Tue,  6 Oct 2026 20:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791319545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUC3UqIHnkOrZ3h5egrCYk3yV+YLLJsgFUSDDh5u+68=;
	b=JkIU7Fi7eBHMWcLDp46Q0ZDsrmn2HCUw/YlgBW8hANAUeCFQKyvbUJZfwqWvdnvYFtzg4j
	9GABiAN/9inwfgsvJp0NsJYsGqDan3F08oQ24poSnX0rbUlFYiX06jdbaAx02Vka5v6Q2b
	LJZGvoVNnjwm/d7hZGCgV3E87sHqQqE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791319545;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUC3UqIHnkOrZ3h5egrCYk3yV+YLLJsgFUSDDh5u+68=;
	b=UVeQqVWB+IyLN01wdCSAhTFfyQqk2Ym7jbRELZD/KuvRwBkpeeyc4Dp0a1FovAdG46583P
	nij9WgffFzQ/+/CA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791319541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUC3UqIHnkOrZ3h5egrCYk3yV+YLLJsgFUSDDh5u+68=;
	b=ZvhgYwF/4h+eDW7EXyW0Ay4l9C6z6GvrDSMgBCz3prrtIrUmLKVMAatKnA7DOzhZ50CrRI
	4dRmIPI/HuGiWsnXyDYeD+dJSczz2aIup4W5N9FTCp6hsaN5b1TzGWuBpzxZjBwBWkPKaw
	ufzgVZYaVedKmR6dpJ+zePf7RBU/Ljo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791319541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUC3UqIHnkOrZ3h5egrCYk3yV+YLLJsgFUSDDh5u+68=;
	b=5KlcO9G6UowzOIE6zj5NbLBotMQwrp2C2MrR3PRQsItPV0TdxgbbSeTdyc9m+tGGph9ht1
	WGNWc2hOD9s9zkCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CDC4D13B88;
	Tue,  6 Oct 2026 20:45:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h2fNHvRdxWqCPAAAD6G6ig:T2
	(envelope-from <mwilck@suse.de>); Tue, 06 Oct 2026 20:45:40 +0000
From: mwilck@suse.de
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/3] libmultipath: constify functions in wwid.c
Date: Tue,  6 Oct 2026 22:45:21 +0200
Message-ID: <20261006204530.993731-2-mwilck@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006204530.993731-1-mwilck@suse.de>
References: <20261006204530.993731-1-mwilck@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_NO_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

From: Martin Wilck <mwilck@suse.com>

Use `const char *wwid` where possible.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/wwids.c | 19 ++++++++-----------
 libmultipath/wwids.h |  6 +++---
 2 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index aac18c0..42da2b7 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -24,8 +24,8 @@
  * Copyright (c) 2010 Benjamin Marzinski, Redhat
  */
 
-static int
-lookup_wwid(FILE *f, char *wwid) {
+static int lookup_wwid(FILE *f, const char *wwid)
+{
 	int c;
 	char buf[LINE_MAX];
 	int count;
@@ -57,8 +57,8 @@ next:
 	return 0;
 }
 
-static int
-write_out_wwid(int fd, char *wwid) {
+static int write_out_wwid(int fd, const char *wwid)
+{
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

