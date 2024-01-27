Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03B1BA55
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 03:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706324492; cv=none; b=TwCtgqSi5OqRH53RFI62dHR399jj6N9F5HXUYczzDg/WntQvfyE3s2LKW9GtN+bTte+/Jylw8au388gSI/bKa1LxMxumcGUQlMpctIQe1dLGPTWWjW8UoyJ09nR8JavrhDzjXzUZ6p6aroTw8u0+a6ofPUuAcWNRKGWqrhOCWlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706324492; c=relaxed/simple;
	bh=/PuUCahpJAtAbNKOb/I6W/oWNApxUUDQYN2n+8ZU0mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=egk8x22tXksRkRnrJc4RPRyIN0YRlWwijozE9D6zsrwM9NbF9lJoyIFMu1+XnyCqPj73n3ThDBtLemdJ5orKE3esRlUcGkNgUNVB5OC8Z9v4whr02bb9j1YkTgmikkeWscfh17rL7Dbh4mACGsWbHjzCSv8drk7s2IJQoXZjfn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=edzwgqj2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="edzwgqj2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706324489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fsrmcbHnUT+Vw5hTsJoZAuMDGUlVKzY9EmeVmWmBrxI=;
	b=edzwgqj2pl37tTNjnMAQeNOu+2HJtlfm/eqkRVh6hI3hrwqMnxwa1G6LvRmf259UWiefuM
	wiMf5wRiBE7vaI6MdXv1MZfyE/XsETe/Bn9wGinazGWGMj08477sNq4Q2bOcc/Sq7zsb27
	1LI8ObidlzTLNfjX3szqNotdwn35yos=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-615-RpBBhp7uNPaZstNL0hu8cQ-1; Fri,
 26 Jan 2024 22:01:27 -0500
X-MC-Unique: RpBBhp7uNPaZstNL0hu8cQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 911391C04B68;
	Sat, 27 Jan 2024 03:01:27 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8B2AF2166B33;
	Sat, 27 Jan 2024 03:01:27 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 88E32560E6; Fri, 26 Jan 2024 22:01:27 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/3] dm vdo index: fix various small nits
Date: Fri, 26 Jan 2024 22:01:27 -0500
Message-ID: <efaa64fc09e3f1e98a23e9375640cd8b00c84a30.1706324128.git.msakai@redhat.com>
In-Reply-To: <cover.1706324127.git.msakai@redhat.com>
References: <cover.1706324127.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Add braces around multi-line while loops and if statements. Also
remove excess newlines.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Chung Chung <cchung@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/index-layout.c   | 10 +++++-----
 drivers/md/dm-vdo/index-page-map.c |  3 +--
 drivers/md/dm-vdo/index-session.c  | 12 ++++++++----
 drivers/md/dm-vdo/index.c          |  3 +--
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-vdo/index-layout.c b/drivers/md/dm-vdo/index-layout.c
index 6446a1f58641..f0511988ea07 100644
--- a/drivers/md/dm-vdo/index-layout.c
+++ b/drivers/md/dm-vdo/index-layout.c
@@ -386,9 +386,10 @@ static void define_sub_index_nonce(struct index_layout *layout)
 	encode_u64_le(buffer, &offset, sil->sub_index.start_block);
 	encode_u16_le(buffer, &offset, 0);
 	sil->nonce = generate_secondary_nonce(primary_nonce, buffer, sizeof(buffer));
-	if (sil->nonce == 0)
+	if (sil->nonce == 0) {
 		sil->nonce = generate_secondary_nonce(~primary_nonce + 1, buffer,
 						      sizeof(buffer));
+	}
 }
 
 static void setup_sub_index(struct index_layout *layout, u64 start_block,
@@ -651,10 +652,11 @@ static int discard_index_state_data(struct index_layout *layout)
 			saved_result = result;
 	}
 
-	if (saved_result != UDS_SUCCESS)
+	if (saved_result != UDS_SUCCESS) {
 		return uds_log_error_strerror(result,
 					      "%s: cannot destroy all index saves",
 					      __func__);
+	}
 
 	return UDS_SUCCESS;
 }
@@ -1242,9 +1244,7 @@ static int __must_check read_super_block_data(struct buffered_reader *reader,
 					      "unknown superblock magic label");
 
 	if ((super->version < SUPER_VERSION_MINIMUM) ||
-	    (super->version == 4) ||
-	    (super->version == 5) ||
-	    (super->version == 6) ||
+	    (super->version == 4) || (super->version == 5) || (super->version == 6) ||
 	    (super->version > SUPER_VERSION_MAXIMUM)) {
 		return uds_log_error_strerror(UDS_UNSUPPORTED_VERSION,
 					      "unknown superblock version number %u",
diff --git a/drivers/md/dm-vdo/index-page-map.c b/drivers/md/dm-vdo/index-page-map.c
index 190d12848ba2..acfff74f37bc 100644
--- a/drivers/md/dm-vdo/index-page-map.c
+++ b/drivers/md/dm-vdo/index-page-map.c
@@ -100,8 +100,7 @@ void uds_get_list_number_bounds(const struct index_page_map *map, u32 chapter_nu
 	u32 slot = chapter_number * map->entries_per_chapter;
 
 	*lowest_list = ((index_page_number == 0) ?
-			0 :
-			map->entries[slot + index_page_number - 1] + 1);
+			0 : map->entries[slot + index_page_number - 1] + 1);
 	*highest_list = ((index_page_number < map->entries_per_chapter) ?
 			 map->entries[slot + index_page_number] :
 			 map->geometry->delta_lists_per_chapter - 1);
diff --git a/drivers/md/dm-vdo/index-session.c b/drivers/md/dm-vdo/index-session.c
index 73c2927f74ce..c261453b9871 100644
--- a/drivers/md/dm-vdo/index-session.c
+++ b/drivers/md/dm-vdo/index-session.c
@@ -392,9 +392,10 @@ int uds_open_index(enum uds_open_index_type open_type,
 static void wait_for_no_requests_in_progress(struct uds_index_session *index_session)
 {
 	uds_lock_mutex(&index_session->request_mutex);
-	while (index_session->request_count > 0)
+	while (index_session->request_count > 0) {
 		uds_wait_cond(&index_session->request_cond,
 			      &index_session->request_mutex);
+	}
 	uds_unlock_mutex(&index_session->request_mutex);
 }
 
@@ -619,9 +620,10 @@ int uds_close_index(struct uds_index_session *index_session)
 	/* Wait for any current index state change to complete. */
 	uds_lock_mutex(&index_session->request_mutex);
 	while ((index_session->state & IS_FLAG_WAITING) ||
-	       (index_session->state & IS_FLAG_CLOSING))
+	       (index_session->state & IS_FLAG_CLOSING)) {
 		uds_wait_cond(&index_session->request_cond,
 			      &index_session->request_mutex);
+	}
 
 	if (index_session->state & IS_FLAG_SUSPENDED) {
 		uds_log_info("Index session is suspended");
@@ -660,9 +662,10 @@ int uds_destroy_index_session(struct uds_index_session *index_session)
 	/* Wait for any current index state change to complete. */
 	uds_lock_mutex(&index_session->request_mutex);
 	while ((index_session->state & IS_FLAG_WAITING) ||
-	       (index_session->state & IS_FLAG_CLOSING))
+	       (index_session->state & IS_FLAG_CLOSING)) {
 		uds_wait_cond(&index_session->request_cond,
 			      &index_session->request_mutex);
+	}
 
 	if (index_session->state & IS_FLAG_DESTROYING) {
 		uds_unlock_mutex(&index_session->request_mutex);
@@ -686,9 +689,10 @@ int uds_destroy_index_session(struct uds_index_session *index_session)
 
 		/* Wait until the load exits before proceeding. */
 		uds_lock_mutex(&index_session->request_mutex);
-		while (index_session->state & IS_FLAG_LOADING)
+		while (index_session->state & IS_FLAG_LOADING) {
 			uds_wait_cond(&index_session->request_cond,
 				      &index_session->request_mutex);
+		}
 		uds_unlock_mutex(&index_session->request_mutex);
 	}
 
diff --git a/drivers/md/dm-vdo/index.c b/drivers/md/dm-vdo/index.c
index 28ae54efaced..3d2a673b3f52 100644
--- a/drivers/md/dm-vdo/index.c
+++ b/drivers/md/dm-vdo/index.c
@@ -1330,8 +1330,7 @@ int uds_save_index(struct uds_index *index)
 	uds_wait_for_idle_index(index);
 	index->prev_save = index->last_save;
 	index->last_save = ((index->newest_virtual_chapter == 0) ?
-			    NO_LAST_SAVE :
-			    index->newest_virtual_chapter - 1);
+			    NO_LAST_SAVE : index->newest_virtual_chapter - 1);
 	uds_log_info("beginning save (vcn %llu)", (unsigned long long) index->last_save);
 
 	result = uds_save_index_state(index->layout, index);
-- 
2.42.0

