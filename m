Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D2A111B5
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706323395; cv=none; b=oXFSlt186GW/10I35KJ2+DX4pDXWVtP6eWxEHNPe1vxSY9O5x938v8IotT8XmUPnePGQ7rzMcfp/7yCXOG66ZOMGxAHniqMvjgGxc8IzA3YpmkbquRsXhB2drjFyJ3n0EYV6VgEp3+XF8QNiqFMeWaknHcA1l8TApIRTMFv0rlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706323395; c=relaxed/simple;
	bh=tWVYIuKG+g6WwXRFrMVv0OyE/Mj/1GGnLyKha9Eh074=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e/K34uINZjqnj4+THGJXOgXZgfjXA4+btWKM5q9bBmGSfM8OWEJayIQhBIR+kP5gmmFd0uqHersOqSBzOJveBuTXmgxHIYHso9RUGorMI1V8XJhb68cxWhnKSzk7cL3JcDTXmYrC/+Pq0T57XFciCTpP1l/YAbjx9Q1Zur8gMHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=evRt9Q4p; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="evRt9Q4p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706323393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1OW1hpErKpERVESDMxZMY2hVQykNkiuL8MOWkB9uIo4=;
	b=evRt9Q4pfO9GhO/NF6T3axvL+B80kJ4AGNKF7qcuV5fo50nlip0cfS3zg8Vwk6WO06iBAQ
	KcsLHjc5bJD5ttD2wGOFG2IJNoISvJlG9WelDk83iPZkHm3LrGR/7RNOlH+6JG82tg+52y
	X5IG6Q34lNjlPMFennMbQVy0NvZCBNg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-A_RzSobMN0q3d36xuiDnNA-1; Fri,
 26 Jan 2024 21:42:29 -0500
X-MC-Unique: A_RzSobMN0q3d36xuiDnNA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9B0FE380627D;
	Sat, 27 Jan 2024 02:42:29 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 95B751C060AF;
	Sat, 27 Jan 2024 02:42:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 91302560D4; Fri, 26 Jan 2024 21:42:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 2/3] dm vdo: rename uds_map_to_system_error to uds_status_to_errno
Date: Fri, 26 Jan 2024 21:42:28 -0500
Message-ID: <44029821f4295b58dd7fd8b9995e136c8e1e7262.1706323002.git.msakai@redhat.com>
In-Reply-To: <cover.1706323002.git.msakai@redhat.com>
References: <cover.1706323002.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/errors.c        |  2 +-
 drivers/md/dm-vdo/errors.h        |  2 +-
 drivers/md/dm-vdo/index-layout.c  |  4 ++--
 drivers/md/dm-vdo/index-session.c | 20 ++++++++++----------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-vdo/errors.c b/drivers/md/dm-vdo/errors.c
index d19504a1445e..e8599599a377 100644
--- a/drivers/md/dm-vdo/errors.c
+++ b/drivers/md/dm-vdo/errors.c
@@ -219,7 +219,7 @@ const char *uds_string_error_name(int errnum, char *buf, size_t buflen)
  * system-generated value (such as -EIO), or an internal UDS status code. The result will be a
  * negative errno value.
  */
-int uds_map_to_system_error(int error)
+int uds_status_to_errno(int error)
 {
 	char error_name[UDS_MAX_ERROR_NAME_SIZE];
 	char error_message[UDS_MAX_ERROR_MESSAGE_SIZE];
diff --git a/drivers/md/dm-vdo/errors.h b/drivers/md/dm-vdo/errors.h
index c37f198a159c..cf15d7243204 100644
--- a/drivers/md/dm-vdo/errors.h
+++ b/drivers/md/dm-vdo/errors.h
@@ -71,7 +71,7 @@ const char * __must_check uds_string_error(int errnum, char *buf, size_t buflen)
 
 const char *uds_string_error_name(int errnum, char *buf, size_t buflen);
 
-int uds_map_to_system_error(int error);
+int uds_status_to_errno(int error);
 
 int uds_register_error_block(const char *block_name, int first_error,
 			     int last_reserved_error, const struct error_info *infos,
diff --git a/drivers/md/dm-vdo/index-layout.c b/drivers/md/dm-vdo/index-layout.c
index 4dffa82a3c43..6446a1f58641 100644
--- a/drivers/md/dm-vdo/index-layout.c
+++ b/drivers/md/dm-vdo/index-layout.c
@@ -267,13 +267,13 @@ int uds_compute_index_size(const struct uds_parameters *parameters, u64 *index_s
 	result = uds_make_configuration(parameters, &index_config);
 	if (result != UDS_SUCCESS) {
 		uds_log_error_strerror(result, "cannot compute index size");
-		return uds_map_to_system_error(result);
+		return uds_status_to_errno(result);
 	}
 
 	result = compute_sizes(index_config, &sizes);
 	uds_free_configuration(index_config);
 	if (result != UDS_SUCCESS)
-		return uds_map_to_system_error(result);
+		return uds_status_to_errno(result);
 
 	*index_size = sizes.total_size;
 	return UDS_SUCCESS;
diff --git a/drivers/md/dm-vdo/index-session.c b/drivers/md/dm-vdo/index-session.c
index 615c7b840d7b..73c2927f74ce 100644
--- a/drivers/md/dm-vdo/index-session.c
+++ b/drivers/md/dm-vdo/index-session.c
@@ -210,7 +210,7 @@ static void handle_callbacks(struct uds_request *request)
 	if (request->status == UDS_SUCCESS)
 		update_session_stats(request);
 
-	request->status = uds_map_to_system_error(request->status);
+	request->status = uds_status_to_errno(request->status);
 	request->callback(request);
 	release_index_session(index_session);
 }
@@ -276,7 +276,7 @@ int uds_create_index_session(struct uds_index_session **session)
 		return -EINVAL;
 	}
 
-	return uds_map_to_system_error(make_empty_index_session(session));
+	return uds_status_to_errno(make_empty_index_session(session));
 }
 
 static int __must_check start_loading_index_session(struct uds_index_session *index_session)
@@ -374,7 +374,7 @@ int uds_open_index(enum uds_open_index_type open_type,
 
 	result = start_loading_index_session(session);
 	if (result != UDS_SUCCESS)
-		return uds_map_to_system_error(result);
+		return uds_status_to_errno(result);
 
 	session->parameters = *parameters;
 	format_dev_t(name, parameters->bdev->bd_dev);
@@ -386,7 +386,7 @@ int uds_open_index(enum uds_open_index_type open_type,
 				       get_open_type_string(open_type));
 
 	finish_loading_index_session(session, result);
-	return uds_map_to_system_error(result);
+	return uds_status_to_errno(result);
 }
 
 static void wait_for_no_requests_in_progress(struct uds_index_session *index_session)
@@ -470,7 +470,7 @@ int uds_suspend_index_session(struct uds_index_session *session, bool save)
 	uds_unlock_mutex(&session->request_mutex);
 
 	if (no_work)
-		return uds_map_to_system_error(result);
+		return uds_status_to_errno(result);
 
 	if (rebuilding)
 		suspend_rebuild(session);
@@ -484,7 +484,7 @@ int uds_suspend_index_session(struct uds_index_session *session, bool save)
 	session->state |= IS_FLAG_SUSPENDED;
 	uds_broadcast_cond(&session->request_cond);
 	uds_unlock_mutex(&session->request_mutex);
-	return uds_map_to_system_error(result);
+	return uds_status_to_errno(result);
 }
 
 static int replace_device(struct uds_index_session *session, struct block_device *bdev)
@@ -536,7 +536,7 @@ int uds_resume_index_session(struct uds_index_session *session,
 			session->state &= ~IS_FLAG_WAITING;
 			uds_broadcast_cond(&session->request_cond);
 			uds_unlock_mutex(&session->request_mutex);
-			return uds_map_to_system_error(result);
+			return uds_status_to_errno(result);
 		}
 	}
 
@@ -635,7 +635,7 @@ int uds_close_index(struct uds_index_session *index_session)
 	}
 	uds_unlock_mutex(&index_session->request_mutex);
 	if (result != UDS_SUCCESS)
-		return uds_map_to_system_error(result);
+		return uds_status_to_errno(result);
 
 	uds_log_debug("Closing index");
 	wait_for_no_requests_in_progress(index_session);
@@ -646,7 +646,7 @@ int uds_close_index(struct uds_index_session *index_session)
 	index_session->state &= ~IS_FLAG_CLOSING;
 	uds_broadcast_cond(&index_session->request_cond);
 	uds_unlock_mutex(&index_session->request_mutex);
-	return uds_map_to_system_error(result);
+	return uds_status_to_errno(result);
 }
 
 /* This will save and close an open index before destroying the session. */
@@ -702,7 +702,7 @@ int uds_destroy_index_session(struct uds_index_session *index_session)
 	uds_destroy_mutex(&index_session->request_mutex);
 	uds_log_debug("Destroyed index session");
 	uds_free(index_session);
-	return uds_map_to_system_error(result);
+	return uds_status_to_errno(result);
 }
 
 /* Wait until all callbacks for index operations are complete. */
-- 
2.42.0

