Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2166138
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706323354; cv=none; b=Ew+ItIAo0HJFE9Vk3ITSNJDiBzyWpjz4sRJzvrjo/nXvY2Jiaj9naZWRi54vSbfy1+S/Wvvrxw+6Ri4e3VzLRCdVU4fGrib5Ry0t8El2UCpbVlh9OE+oOwhT1nbsdsHU2jtmdKY/Kdmw1FhOcFms/F2SkC3pxhsvcehD7455hUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706323354; c=relaxed/simple;
	bh=syHJ59edBYtg9+cnQVp6CKvCfrlXWGkTUuLJzXlivL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0T4o9LXNE4gbVQ6bUgZ8OXTkOLG/NNHlbAlWnEbyD9TdmEVZO5c6xobl4IAgUUh2z+OMUJV6vg8qBj+eOh1qphap+1B9HprF6LWJEVcC2efHX3f7YzoOo3RgoVKg8gql8EqqOUbr3amdH6iJtdW0PrG9+22zZ3H5V5PC9Th7Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GMlMWX6n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GMlMWX6n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706323351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/10SdPJJFo42KK4DRCDa3Y1h5cEGaykMaYddzzUyZsA=;
	b=GMlMWX6nlZu5vgTPN3oB8y9I72pNDspJQOAxEwEs59mtzKIcD32BH+5v2d8iP6LPDHnXb1
	eUWMxt2VVBDoC7HDyJCNBIXZSRUATTM7GoJSmmtW4Gn4Oyxhwkge0qRTt6h5OUgoElHRwk
	TVDinaZsgywt4CEkrcvBwb/lvy6eMDY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-caxcufJLMYSCeJairbFp7A-1; Fri, 26 Jan 2024 21:42:29 -0500
X-MC-Unique: caxcufJLMYSCeJairbFp7A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0870827D8A;
	Sat, 27 Jan 2024 02:42:29 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9B3BDC38;
	Sat, 27 Jan 2024 02:42:29 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 96D28560D6; Fri, 26 Jan 2024 21:42:29 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/3] dm vdo: rename vdo_map_to_system_error to vdo_status_to_errno
Date: Fri, 26 Jan 2024 21:42:29 -0500
Message-ID: <3a92b2a73e786b649fec0a2016a9bd421777b3d8.1706323002.git.msakai@redhat.com>
In-Reply-To: <cover.1706323002.git.msakai@redhat.com>
References: <cover.1706323002.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/data-vio.c      |  2 +-
 drivers/md/dm-vdo/dm-vdo-target.c | 10 +++++-----
 drivers/md/dm-vdo/status-codes.c  |  4 ++--
 drivers/md/dm-vdo/status-codes.h  |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 711396e7a77d..7d8100f29e13 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -274,7 +274,7 @@ static void acknowledge_data_vio(struct data_vio *data_vio)
 {
 	struct vdo *vdo = vdo_from_data_vio(data_vio);
 	struct bio *bio = data_vio->user_bio;
-	int error = vdo_map_to_system_error(data_vio->vio.completion.result);
+	int error = vdo_status_to_errno(data_vio->vio.completion.result);
 
 	if (bio == NULL)
 		return;
diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index fcba50d8d088..e2e60a29e873 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -1117,7 +1117,7 @@ static int vdo_message(struct dm_target *ti, unsigned int argc, char **argv,
 		vdo_write_stats(vdo, result_buffer, maxlen);
 		result = 1;
 	} else {
-		result = vdo_map_to_system_error(process_vdo_message(vdo, argc, argv));
+		result = vdo_status_to_errno(process_vdo_message(vdo, argc, argv));
 	}
 
 	uds_unregister_thread_device_id();
@@ -1613,7 +1613,7 @@ static int construct_new_vdo_registered(struct dm_target *ti, unsigned int argc,
 	if (result != VDO_SUCCESS) {
 		release_instance(instance);
 		free_device_config(config);
-		return vdo_map_to_system_error(result);
+		return vdo_status_to_errno(result);
 	}
 
 	return VDO_SUCCESS;
@@ -1852,7 +1852,7 @@ static int prepare_to_modify(struct dm_target *ti, struct device_config *config,
 		if (result != VDO_SUCCESS) {
 			if (result == VDO_PARAMETER_MISMATCH) {
 				/*
-				 * If we don't trap this case, vdo_map_to_system_error() will remap
+				 * If we don't trap this case, vdo_status_to_errno() will remap
 				 * it to -EIO, which is misleading and ahistorical.
 				 */
 				result = -EINVAL;
@@ -1892,7 +1892,7 @@ static int update_existing_vdo(const char *device_name, struct dm_target *ti,
 	result = prepare_to_modify(ti, config, vdo);
 	if (result != VDO_SUCCESS) {
 		free_device_config(config);
-		return vdo_map_to_system_error(result);
+		return vdo_status_to_errno(result);
 	}
 
 	set_device_config(ti, vdo, config);
@@ -2850,7 +2850,7 @@ static int vdo_preresume(struct dm_target *ti)
 	if ((result == VDO_PARAMETER_MISMATCH) || (result == VDO_INVALID_ADMIN_STATE))
 		result = -EINVAL;
 	uds_unregister_thread_device_id();
-	return vdo_map_to_system_error(result);
+	return vdo_status_to_errno(result);
 }
 
 static void vdo_resume(struct dm_target *ti)
diff --git a/drivers/md/dm-vdo/status-codes.c b/drivers/md/dm-vdo/status-codes.c
index 33b1de29b205..b4d7eb7f94ff 100644
--- a/drivers/md/dm-vdo/status-codes.c
+++ b/drivers/md/dm-vdo/status-codes.c
@@ -87,7 +87,7 @@ int vdo_register_status_codes(void)
 }
 
 /**
- * vdo_map_to_system_error() - Given an error code, return a value we can return to the OS.
+ * vdo_status_to_errno() - Given an error code, return a value we can return to the OS.
  * @error: The error code to convert.
  *
  * The input error code may be a system-generated value (such as -EIO), an errno macro used in our
@@ -96,7 +96,7 @@ int vdo_register_status_codes(void)
  *
  * Return: A system error code value.
  */
-int vdo_map_to_system_error(int error)
+int vdo_status_to_errno(int error)
 {
 	char error_name[UDS_MAX_ERROR_NAME_SIZE];
 	char error_message[UDS_MAX_ERROR_MESSAGE_SIZE];
diff --git a/drivers/md/dm-vdo/status-codes.h b/drivers/md/dm-vdo/status-codes.h
index 9e0126a83c6b..5d1e8bbe54b4 100644
--- a/drivers/md/dm-vdo/status-codes.h
+++ b/drivers/md/dm-vdo/status-codes.h
@@ -105,6 +105,6 @@ extern const struct error_info vdo_status_list[];
 
 int vdo_register_status_codes(void);
 
-int vdo_map_to_system_error(int error);
+int vdo_status_to_errno(int error);
 
 #endif /* VDO_STATUS_CODES_H */
-- 
2.42.0

