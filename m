Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 147ECCA0FF2
	for <dm-devel@archiver.kernel.org>; Fri,  1 Sep 2023 18:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693591415;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=x9I9BB5Rgy4925UuRQR/eDlHMh5kijrzpA+d2NBh/Ww=;
	b=du0HLKJHISJiYV5tgO73OjjEJemZiqHcvGJbrvN2NiBenFGw1l+GA9B/MFMdKgR76t6Te9
	vZKyFzRniGu/3QbT+xBXGt9dldEQTCd00/u7Px20FfjpQ4o7TrZ8vuPX7R/KjCc9OeAS8C
	0+H5q4H92rCAnc7GVmqQpTMDggPI5/Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-Hr3wAwPeNImE_o9aO5Avow-1; Fri, 01 Sep 2023 14:03:32 -0400
X-MC-Unique: Hr3wAwPeNImE_o9aO5Avow-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 725C990A7FF;
	Fri,  1 Sep 2023 18:03:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5AAE5493111;
	Fri,  1 Sep 2023 18:03:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 16D8E19472B4;
	Fri,  1 Sep 2023 18:03:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 27D5719472A5
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 18DF421EE561; Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 10CF821EE560
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E71D41051048
 for <dm-devel@redhat.com>; Fri,  1 Sep 2023 18:03:26 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-196-B31wUMSjO7i4MGIQJaZ3hg-1; Fri,
 01 Sep 2023 14:03:23 -0400
X-MC-Unique: B31wUMSjO7i4MGIQJaZ3hg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 00CF91F853;
 Fri,  1 Sep 2023 18:03:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BF9DB13582;
 Fri,  1 Sep 2023 18:03:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id AO/ZLGkn8mTpRQAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 01 Sep 2023 18:03:21 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  1 Sep 2023 20:02:31 +0200
Message-ID: <20230901180235.23980-19-mwilck@suse.com>
In-Reply-To: <20230901180235.23980-1-mwilck@suse.com>
References: <20230901180235.23980-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 18/21] libmultipath: keep bindings in memory
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Rather than opening the bindings file every time we must retrieve
a binding, keep the contents in memory and write the file only
if additions have been made. This simplifies the code, and should speed up
alias lookups significantly. As a side effect, the aliases will be stored
sorted by alias, which changes the way aliases are allocated if there are
unused "holes" in the sequence of aliases. For example, if the bindings file
contains mpathb, mpathy, and mpatha, in this order, the next new alias used to
be mpathz and is now mpathc.

Another side effect is that multipathd will not automatically pick up changes
to the bindings file at runtime without a reconfigure operation. It is
questionable whether these on-the-fly changes were a good idea in the first
place, as inconsistent configurations may easily come to pass. It desired,
it would be feasible to implement automatic update of the bindings using the
existing inotify approach.

The new implementation of get_user_friendly_alias() is slightly different
than before. The logic is summarized in a comment in the code. Unit tests
will be provided that illustrate the changes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/alias.c     | 369 ++++++++++++++++-----------------------
 libmultipath/alias.h     |   2 +-
 libmultipath/configure.c |   3 +-
 3 files changed, 157 insertions(+), 217 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 2f9bc82..6003df0 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -50,8 +50,6 @@
 "# alias wwid\n" \
 "#\n"
 
-static const char bindings_file_header[] = BINDINGS_FILE_HEADER;
-
 struct binding {
 	char *alias;
 	char *wwid;
@@ -80,6 +78,45 @@ static void _free_binding(struct binding *bdg)
 	free(bdg);
 }
 
+static const struct binding *get_binding_for_alias(const Bindings *bindings,
+						   const char *alias)
+{
+	const struct binding *bdg;
+	int i;
+
+	if (!alias)
+		return NULL;
+	vector_foreach_slot(bindings, bdg, i) {
+		if (!strncmp(bdg->alias, alias, WWID_SIZE)) {
+			condlog(3, "Found matching alias [%s] in bindings file."
+				" Setting wwid to %s", alias, bdg->wwid);
+			return bdg;
+		}
+	}
+
+	condlog(3, "No matching alias [%s] in bindings file.", alias);
+	return NULL;
+}
+
+static const struct binding *get_binding_for_wwid(const Bindings *bindings,
+						  const char *wwid)
+{
+	const struct binding *bdg;
+	int i;
+
+	if (!wwid)
+		return NULL;
+	vector_foreach_slot(bindings, bdg, i) {
+		if (!strncmp(bdg->wwid, wwid, WWID_SIZE)) {
+			condlog(3, "Found matching wwid [%s] in bindings file."
+				" Setting alias to %s", wwid, bdg->alias);
+			return bdg;
+		}
+	}
+	condlog(3, "No matching wwid [%s] in bindings file.", wwid);
+	return NULL;
+}
+
 static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
 {
 	struct binding *bdg;
@@ -115,6 +152,24 @@ static int add_binding(Bindings *bindings, const char *alias, const char *wwid)
 	return BINDING_ERROR;
 }
 
+static int delete_binding(Bindings *bindings, const char *wwid)
+{
+	struct binding *bdg;
+	int i;
+
+	vector_foreach_slot(bindings, bdg, i) {
+		if (!strncmp(bdg->wwid, wwid, WWID_SIZE)) {
+			_free_binding(bdg);
+			break;
+		}
+	}
+	if (i >= VECTOR_SIZE(bindings))
+		return BINDING_NOTFOUND;
+
+	vector_del_slot(bindings, i);
+	return BINDING_DELETED;
+}
+
 static int write_bindings_file(const Bindings *bindings, int fd)
 {
 	struct binding *bnd;
@@ -267,38 +322,15 @@ static bool id_already_taken(int id, const char *prefix, const char *map_wwid)
 	return alias_already_taken(alias, map_wwid);
 }
 
-/*
- * Returns: 0   if matching entry in WWIDs file found
- *         -1   if an error occurs
- *         >0   a free ID that could be used for the WWID at hand
- * *map_alias is set to a freshly allocated string with the matching alias if
- * the function returns 0, or to NULL otherwise.
- */
-static int
-lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
-	       const char *prefix, int check_if_taken)
+int get_free_id(const Bindings *bindings, const char *prefix, const char *map_wwid)
 {
-	char buf[LINE_MAX];
-	unsigned int line_nr = 0;
-	int id = 1;
+	const struct binding *bdg;
+	int i, id = 1;
 	int biggest_id = 1;
 	int smallest_bigger_id = INT_MAX;
 
-	*map_alias = NULL;
-
-	rewind(f);
-	while (fgets(buf, LINE_MAX, f)) {
-		const char *alias, *wwid;
-		char *c, *saveptr;
-		int curr_id;
-
-		line_nr++;
-		c = strpbrk(buf, "#\n\r");
-		if (c)
-			*c = '\0';
-		alias = strtok_r(buf, " \t", &saveptr);
-		if (!alias) /* blank line */
-			continue;
+	vector_foreach_slot(bindings, bdg, i) {
+		int curr_id = scan_devname(bdg->alias, prefix);
 
 		/*
 		 * Find an unused index - explanation of the algorithm
@@ -333,8 +365,6 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
 		 * biggest_id is always > smallest_bigger_id, except in the
 		 * "perfectly ordered" case.
 		 */
-
-		curr_id = scan_devname(alias, prefix);
 		if (curr_id == id) {
 			if (id < INT_MAX)
 				id++;
@@ -345,36 +375,15 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
 		}
 		if (curr_id > biggest_id)
 			biggest_id = curr_id;
+
 		if (curr_id > id && curr_id < smallest_bigger_id)
 			smallest_bigger_id = curr_id;
-		wwid = strtok_r(NULL, " \t", &saveptr);
-		if (!wwid){
-			condlog(3,
-				"Ignoring malformed line %u in bindings file",
-				line_nr);
-			continue;
-		}
-		if (strcmp(wwid, map_wwid) == 0){
-			condlog(3, "Found matching wwid [%s] in bindings file."
-				" Setting alias to %s", wwid, alias);
-			*map_alias = strdup(alias);
-			if (*map_alias == NULL) {
-				condlog(0, "Cannot copy alias from bindings "
-					"file: out of memory");
-				return -1;
-			}
-			return 0;
-		}
 	}
-	if (!prefix && check_if_taken)
-		id = -1;
-	if (id >= smallest_bigger_id) {
-		if (biggest_id < INT_MAX)
-			id = biggest_id + 1;
-		else
-			id = -1;
-	}
-	if (id > 0 && check_if_taken) {
+
+	if (id >= smallest_bigger_id)
+		id = biggest_id < INT_MAX ? biggest_id + 1 : -1;
+
+	if (id > 0) {
 		while(id_already_taken(id, prefix, map_wwid)) {
 			if (id == INT_MAX) {
 				id = -1;
@@ -391,63 +400,16 @@ lookup_binding(FILE *f, const char *map_wwid, char **map_alias,
 			}
 		}
 	}
-	if (id < 0) {
+
+	if (id < 0)
 		condlog(0, "no more available user_friendly_names");
-		return -1;
-	} else
-		condlog(3, "No matching wwid [%s] in bindings file.", map_wwid);
 	return id;
 }
 
-static int
-rlookup_binding(FILE *f, char *buff, const char *map_alias)
-{
-	char line[LINE_MAX];
-	unsigned int line_nr = 0;
-
-	buff[0] = '\0';
-
-	while (fgets(line, LINE_MAX, f)) {
-		char *c, *saveptr;
-		const char *alias, *wwid;
-
-		line_nr++;
-		c = strpbrk(line, "#\n\r");
-		if (c)
-			*c = '\0';
-		alias = strtok_r(line, " \t", &saveptr);
-		if (!alias) /* blank line */
-			continue;
-		wwid = strtok_r(NULL, " \t", &saveptr);
-		if (!wwid){
-			condlog(3,
-				"Ignoring malformed line %u in bindings file",
-				line_nr);
-			continue;
-		}
-		if (strlen(wwid) > WWID_SIZE - 1) {
-			condlog(3,
-				"Ignoring too large wwid at %u in bindings file", line_nr);
-			continue;
-		}
-		if (strcmp(alias, map_alias) == 0){
-			condlog(3, "Found matching alias [%s] in bindings file."
-				" Setting wwid to %s", alias, wwid);
-			strlcpy(buff, wwid, WWID_SIZE);
-			return 0;
-		}
-	}
-	condlog(3, "No matching alias [%s] in bindings file.", map_alias);
-
-	return -1;
-}
-
 static char *
-allocate_binding(int fd, const char *wwid, int id, const char *prefix)
+allocate_binding(const char *filename, const char *wwid, int id, const char *prefix)
 {
 	STRBUF_ON_STACK(buf);
-	off_t offset;
-	ssize_t len;
 	char *alias, *c;
 
 	if (id <= 0) {
@@ -460,29 +422,22 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
 	    format_devname(&buf, id) == -1)
 		return NULL;
 
-	if (print_strbuf(&buf, " %s\n", wwid) < 0)
-		return NULL;
-
-	offset = lseek(fd, 0, SEEK_END);
-	if (offset < 0){
-		condlog(0, "Cannot seek to end of bindings file : %s",
-			strerror(errno));
-		return NULL;
-	}
-
-	len = get_strbuf_len(&buf);
 	alias = steal_strbuf_str(&buf);
 
-	if (write(fd, alias, len) != len) {
-		condlog(0, "Cannot write binding to bindings file : %s",
-			strerror(errno));
-		/* clear partial write */
-		if (ftruncate(fd, offset))
-			condlog(0, "Cannot truncate the header : %s",
-				strerror(errno));
+	if (add_binding(&global_bindings, alias, wwid) != BINDING_ADDED) {
+		condlog(0, "%s: cannot allocate new binding %s for %s",
+			__func__, alias, wwid);
 		free(alias);
 		return NULL;
 	}
+
+	if (update_bindings_file(&global_bindings, filename) == -1) {
+		condlog(1, "%s: deleting binding %s for %s", __func__, alias, wwid);
+		delete_binding(&global_bindings, wwid);
+		free(alias);
+		return NULL;
+	}
+
 	c = strchr(alias, ' ');
 	if (c)
 		*c = '\0';
@@ -491,144 +446,130 @@ allocate_binding(int fd, const char *wwid, int id, const char *prefix)
 	return alias;
 }
 
+/*
+ * get_user_friendly_alias() action table
+ *
+ * The table shows the various cases, the actions taken, and the CI
+ * functions from tests/alias.c that represent them.
+ *
+ *  - O: old alias given
+ *  - A: old alias in table (y: yes, correct WWID; X: yes, wrong WWID)
+ *  - W: wwid in table
+ *  - U: old alias is used
+ *
+ *  | No | O | A | W | U | action                                     | function gufa_X              |
+ *  |----+---+---+---+---+--------------------------------------------+------------------------------|
+ *  |  1 | n | - | n | - | get new alias                              | nomatch_Y                    |
+ *  |  2 | n | - | y | - | use alias from bindings                    | match_a_Y                    |
+ *  |  3 | y | n | n | n | add binding for old alias                  | old_nomatch_nowwidmatch      |
+ *  |  4 | y | n | n | y | error, no alias (can't add entry)          | old_nomatch_nowwidmatch_used |
+ *  |  5 | y | n | y | - | use alias from bindings (avoid duplicates) | old_nomatch_wwidmatch        |
+ *  |  6 | y | y | n | - | [ impossible ]                             | -                            |
+ *  |  7 | y | y | y | n | use old alias == alias from bindings       | old_match                    |
+ *  |  8 | y | y | y | y | error, no alias (would be duplicate)       | old_match_used               |
+ *  |  9 | y | X | n | - | get new alias                              | old_match_other              |
+ *  | 10 | y | X | y | - | use alias from bindings                    | old_match_other_wwidmatch    |
+ *
+ * Notes:
+ *  - "use alias from bindings" means that the alias from the bindings file will
+ *     be tried; if it is in use, the alias selection will fail. No other
+ *     bindings will be attempted.
+ *  - "get new alias" fails if all aliases are used up, or if writing the
+ *     bindings file fails.
+ */
+
 char *get_user_friendly_alias(const char *wwid, const char *file, const char *alias_old,
 			      const char *prefix, bool bindings_read_only)
 {
 	char *alias = NULL;
 	int id = 0;
-	int fd, can_write;
 	bool new_binding = false;
-	char buff[WWID_SIZE];
-	FILE *f;
+	bool old_alias_taken = false;
+	const struct binding *bdg;
 
-	fd = open_file(file, &can_write, bindings_file_header);
-	if (fd < 0)
-		return NULL;
-
-	f = fdopen(fd, "r");
-	if (!f) {
-		condlog(0, "cannot fdopen on bindings file descriptor");
-		close(fd);
-		return NULL;
-	}
-
-	if (!strlen(alias_old))
+	if (!*alias_old)
 		goto new_alias;
 
-	/* lookup the binding. if it exists, the wwid will be in buff
-	 * either way, id contains the id for the alias
-	 */
-	rlookup_binding(f, buff, alias_old);
-
-	if (strlen(buff) > 0) {
-		/* if buff is our wwid, it's already
-		 * allocated correctly
-		 */
-		if (strcmp(buff, wwid) == 0) {
+	/* See if there's a binding matching both alias_old and wwid */
+	bdg = get_binding_for_alias(&global_bindings, alias_old);
+	if (bdg) {
+		if (!strcmp(bdg->wwid, wwid)) {
 			if (!alias_already_taken(alias_old, wwid))
 				alias = strdup(alias_old);
 			else
 				condlog(0, "ERROR: old alias [%s] for wwid [%s] is used by other map",
 					alias_old, wwid);
 			goto out;
-
 		} else {
 			condlog(0, "alias %s already bound to wwid %s, cannot reuse",
-				alias_old, buff);
-			goto new_alias;		     ;
+				alias_old, bdg->wwid);
+			goto new_alias;
 		}
 	}
 
-	/*
-	 * Look for an existing alias in the bindings file.
-	 * Pass prefix = NULL, so lookup_binding() won't try to allocate a new id.
-	 */
-	id = lookup_binding(f, wwid, &alias, NULL, 0);
-	if (alias) {
-		if (alias_already_taken(alias, wwid)) {
-			free(alias);
-			alias = NULL;
-		} else
-			condlog(3, "Use existing binding [%s] for WWID [%s]",
-				alias, wwid);
-		goto out;
-	}
-
 	/* allocate the existing alias in the bindings file */
-	id = scan_devname(alias_old, prefix);
-	if (id > 0 && id_already_taken(id, prefix, wwid)) {
+	if (alias_already_taken(alias_old, wwid)) {
 		condlog(0, "ERROR: old alias [%s] for wwid [%s] is used by other map",
 			alias_old, wwid);
+		old_alias_taken = true;
+	} else
+		id = scan_devname(alias_old, prefix);
+
+new_alias:
+	/* Check for existing binding of WWID */
+	bdg = get_binding_for_wwid(&global_bindings, wwid);
+	if (bdg) {
+		if (!alias_already_taken(bdg->alias, wwid)) {
+			condlog(3, "Use existing binding [%s] for WWID [%s]",
+				bdg->alias, wwid);
+			alias = strdup(bdg->alias);
+		}
 		goto out;
 	}
 
-new_alias:
-	if (id <= 0) {
+	/*
+	 * old_alias_taken means that the WWID is not in the bindings file, but
+	 * alias_old is currently taken by a different WWID. We shouldn't added
+	 * a new binding in this case.
+	 */
+	if (id <= 0 && !old_alias_taken) {
 		/*
 		 * no existing alias was provided, or allocating it
 		 * failed. Try a new one.
 		 */
-		id = lookup_binding(f, wwid, &alias, prefix, 1);
-		if (id == 0 && alias_already_taken(alias, wwid)) {
-			free(alias);
-			alias = NULL;
-		}
+		id = get_free_id(&global_bindings, prefix, wwid);
 		if (id <= 0)
 			goto out;
 		else
 			new_binding = true;
 	}
 
-	if (fflush(f) != 0) {
-		condlog(0, "cannot fflush bindings file stream : %s",
-			strerror(errno));
-		goto out;
-	}
+	if (!bindings_read_only && id > 0)
+		alias = allocate_binding(file, wwid, id, prefix);
 
-	if (can_write && !bindings_read_only) {
-		alias = allocate_binding(fd, wwid, id, prefix);
-		if (alias && !new_binding)
-			condlog(2, "Allocated existing binding [%s] for WWID [%s]",
-				alias, wwid);
-	}
+	if (alias && !new_binding)
+		condlog(2, "Allocated existing binding [%s] for WWID [%s]",
+			alias, wwid);
 
 out:
-	pthread_cleanup_push(free, alias);
-	fclose(f);
-	pthread_cleanup_pop(0);
 	return alias;
 }
 
-int
-get_user_friendly_wwid(const char *alias, char *buff, const char *file)
+int get_user_friendly_wwid(const char *alias, char *buff)
 {
-	int fd, unused;
-	FILE *f;
+	const struct binding *bdg;
 
 	if (!alias || *alias == '\0') {
 		condlog(3, "Cannot find binding for empty alias");
 		return -1;
 	}
 
-	fd = open_file(file, &unused, bindings_file_header);
-	if (fd < 0)
-		return -1;
-
-	f = fdopen(fd, "r");
-	if (!f) {
-		condlog(0, "cannot fdopen on bindings file descriptor : %s",
-			strerror(errno));
-		close(fd);
+	bdg = get_binding_for_alias(&global_bindings, alias);
+	if (!bdg) {
+		*buff = '\0';
 		return -1;
 	}
-
-	rlookup_binding(f, buff, alias);
-	if (!strlen(buff)) {
-		fclose(f);
-		return -1;
-	}
-
-	fclose(f);
+	strlcpy(buff, bdg->alias, WWID_SIZE);
 	return 0;
 }
 
diff --git a/libmultipath/alias.h b/libmultipath/alias.h
index 37b49d9..5ef6720 100644
--- a/libmultipath/alias.h
+++ b/libmultipath/alias.h
@@ -2,7 +2,7 @@
 #define _ALIAS_H
 
 int valid_alias(const char *alias);
-int get_user_friendly_wwid(const char *alias, char *buff, const char *file);
+int get_user_friendly_wwid(const char *alias, char *buff);
 char *get_user_friendly_alias(const char *wwid, const char *file,
 			      const char *alias_old,
 			      const char *prefix, bool bindings_read_only);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 029fbbd..d809490 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -1378,8 +1378,7 @@ static int _get_refwwid(enum mpath_cmds cmd, const char *dev,
 			refwwid = tmpwwid;
 
 		/* or may be a binding */
-		else if (get_user_friendly_wwid(dev, tmpwwid,
-						conf->bindings_file) == 0)
+		else if (get_user_friendly_wwid(dev, tmpwwid) == 0)
 			refwwid = tmpwwid;
 
 		/* or may be an alias */
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

