Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51B046F4AD
	for <dm-devel@lists.linux.dev>; Fri, 25 Sep 2026 21:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790372450; cv=none; b=OuLaWoG7Fn64IZhrCTf5ctR6PmqFgG82uLqIv6GbdURhmDXa/kXxNHuS+RdOzkmffjKKQn6ma1UgNeL3o4JFHpYRjodikfi5oVEx5h7NIuhyLguEi9X+v0gM6IGQsaunkaIPebEPgbbisk0IxFB65kY6x3TcNFTPxotDkLhdNbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790372450; c=relaxed/simple;
	bh=XF3Enlc0Er2h6moKV4hLnLM1l1TLJDrHJlI8eC/PaRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wol3O2VbmHmwlgzCoKHuWO4VZ0qno2nRBGEgunRJsS26xALVHdCXXNubwyx7DsKELW7rEQzciYWQ76eaLeBclGGmOGeSpZV5LwWSvYdZ6eWRkI36XpLZs3PNA2Rq/IbDVBfkyZ6hK+MH19NtNwkMMnf8/FxUTRvfopevNd2DmPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A4KrJevV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=iOFRmIiG; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=D7gB1v35; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AZA4GlHu; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A4KrJevV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="iOFRmIiG";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="D7gB1v35";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AZA4GlHu"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8742C1F45A;
	Fri, 25 Sep 2026 21:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790372442; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mKQmC8rD6OpNi2nce436NtA4UAgtVR1qkqAbx3vXyoQ=;
	b=A4KrJevVp/7kCaFTBrhT4zMk3QaC/7f6VJjp6o6ZLDtGHL1DrsXjPk+oxIV0dIz3IGrCwF
	nw22Akc6N7NUUW0qfHvipFSjKnfiug2/+3VQMvh6RyLQKsZUgN9NZ+OQQJttNsmEZHl7br
	mmGu9UR4tcfO7ThD3BF6bHDS29HfJ0g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790372442;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mKQmC8rD6OpNi2nce436NtA4UAgtVR1qkqAbx3vXyoQ=;
	b=iOFRmIiGRf9l58slON4ILOuKgmhYonfhruumwlsx1rYkz5lVJb/Pcf0KY7ARReFcWpgbLu
	Xsm5D2S4XzmburCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790372438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mKQmC8rD6OpNi2nce436NtA4UAgtVR1qkqAbx3vXyoQ=;
	b=D7gB1v35/jaCFZxgInaSSmwffDYme9mMg1MOyKH6uPhhPUk787+PIVV3dL9XZKPUjpBBw6
	al8Ks+kR2bxzqdK/y8YkeES/IODCK+bNG5ckzEBymwdzrbj/V6K9ZQTTchFtvTtQlDrjfu
	VAtcBdlr+4YE3h50oVcP21vJG/bz58I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790372438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mKQmC8rD6OpNi2nce436NtA4UAgtVR1qkqAbx3vXyoQ=;
	b=AZA4GlHu3FtwjLjFmzhg98JXzoLNYTF1CgIvCiCXoqCEH+sLihr4zcXjVD9OxxzUi0PfCl
	ghtsYp3YZiRxTPDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E786613310;
	Fri, 25 Sep 2026 21:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7imQB1XqtmoZLwAAD6G6ig:T5
	(envelope-from <mwilck@suse.de>); Fri, 25 Sep 2026 21:40:37 +0000
From: mwilck@suse.de
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 4/4] libmultipath: use mmap in lookup_wwid()
Date: Fri, 25 Sep 2026 23:40:09 +0200
Message-ID: <20260925214014.2464499-5-mwilck@suse.de>
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
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.com:email];
	RCVD_TLS_ALL(0.00)[]

From: Martin Wilck <mwilck@suse.com>

Replace the line-by-line reading in lookup_wwid() with mmap()
and a simple loop over the in-memory structures.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/wwids.c | 71 ++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index c193b97..42455de 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -4,8 +4,10 @@
 #include <string.h>
 #include <limits.h>
 #include <stdio.h>
+#include <stdbool.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/mman.h>
 #include <fcntl.h>
 
 #include "util.h"
@@ -24,41 +26,44 @@
  * Copyright (c) 2010 Benjamin Marzinski, Redhat
  */
 
-static int
-lookup_wwid(FILE *f, const char *wwid) {
-	int c;
-	char buf[LINE_MAX];
-	int count;
+struct mem_map {
+	char *addr;
+	ssize_t len;
+};
 
-	while ((c = fgetc(f)) != EOF){
-		if (c != '/') {
-			if (fgets(buf, LINE_MAX, f) == NULL)
-				return 0;
-			else
-				continue;
-		}
-		count = 0;
-		while ((c = fgetc(f)) != '/') {
-			if (c == EOF)
-				return 0;
-			if (count >= WWID_SIZE - 1)
-				goto next;
-			if (wwid[count] == '\0')
-				goto next;
-			if (c != wwid[count++])
-				goto next;
-		}
-		if (wwid[count] == '\0')
-			return 1;
-next:
-		if (fgets(buf, LINE_MAX, f) == NULL)
-			return 0;
-	}
-	return 0;
+static void cleanup_mmap(struct mem_map *mm)
+{
+	if (mm->addr)
+		munmap(mm->addr, mm->len);
 }
 
-static int
-write_out_wwid(int fd, const char *wwid) {
+static bool lookup_wwid(int fd, const char *wwid)
+{
+	struct mem_map mm __attribute__((cleanup(cleanup_mmap))) = { .addr = 0 };
+	struct stat stb;
+	ssize_t wlen;
+	const char *line;
+
+	if (fstat(fd, &stb) != 0)
+		return false;
+
+	mm.len = stb.st_size;
+	mm.addr = mmap(NULL, stb.st_size, PROT_READ, MAP_SHARED, fd, 0);
+	if (!mm.addr)
+		return false;
+
+	wlen = strlen(wwid);
+	for (line = mm.addr; line >= mm.addr && line < mm.addr + mm.len;
+	     line = memchr(line, '\n', mm.addr + mm.len - line) + 1)
+		if (line[0] == '/' && (line - mm.addr + 2 + wlen <= mm.len) &&
+		    line[wlen + 1] == '/' && !strncmp(wwid, line + 1, wlen))
+			return true;
+
+	return false;
+}
+
+static int write_out_wwid(int fd, const char *wwid)
+{
 	int ret;
 	off_t offset;
 	char buf[WWID_SIZE + 3];
@@ -245,7 +250,7 @@ int check_wwids_file(const char *wwid, int write_wwid)
 		close(fd);
 		return -1;
 	}
-	found = lookup_wwid(f, wwid);
+	found = lookup_wwid(fd, wwid);
 	if (found) {
 		ret = 0;
 		goto out;
-- 
2.55.0

