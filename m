Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [178.154.239.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EA91E7C03
	for <dm-devel@lists.linux.dev>; Thu, 26 Jun 2025 16:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750954155; cv=none; b=fW/Jlqq5QvODjPpimR4I1z8grsdjbnNzW87qEiyGQIiuJXGMeUvGv1DOm6I/ZnEia5zsr9v8xgWey7Wap4ZAUoSMgWNG29q+X3R7l0qbFW/9hyk25TQQL8LjaOI+H+3zERcYnUaCZGzuoFVBAVb9rOTJ6FQb/g/kxE8L0ct6rGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750954155; c=relaxed/simple;
	bh=hFDZDCAclppSeb8xMoYN4RA4YaRiRcF/xcmI3MiNBN0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oQL4g6v+n+IqXxsPOfqVcnEyXh3XIrLqmY29B5qdTMlIN63ZBJjP9mD8QZLGiyRfQbr0k0yjah8mInj1v5RMIUc3Y3tL6UQEmLoM3zypj5LR0C1VMguKB21TEMWoP8piibauGl/1JTtSBnuYom5aJTC0k3oRFFPOz4CUmoVPrro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=AEE7C7/n; arc=none smtp.client-ip=178.154.239.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="AEE7C7/n"
Received: from mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:23c6:0:640:5e87:0])
	by forward101b.mail.yandex.net (Yandex) with ESMTPS id 7D15B60E82;
	Thu, 26 Jun 2025 19:09:09 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 89YA4j1LveA0-tFd5eqeT;
	Thu, 26 Jun 2025 19:09:08 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1750954148; bh=ODSH7QSoxPeLg4q7L8NFp0J7IMCvcVnhoUQ/FL74jug=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=AEE7C7/ny7uwKHed6NJJVovUA3N7OLQ0Sf9JOu2wgGhucz3cJXK14X7syVPh2WCzT
	 TAQJK9drnrN1ttF6Gf7KvbdTtIQHkTHnUSdOxrMDII5pEXcgCfDefKdLOfwD7aqaO+
	 coEpL5QdKCyKKs9JGK3n2olVU9+h2G0/3erj16bE=
Authentication-Results: mail-nwsmtp-smtp-production-canary-88.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Tushar Sugandhi <tusharsu@linux.microsoft.com>,
	dm-devel@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] dm: ima: avoid extra calls to strlen()
Date: Thu, 26 Jun 2025 19:07:50 +0300
Message-ID: <20250626160750.434191-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 'scnprintf()' returns the number of characters emitted (not
including the trailing '\0'), use that return value instead of the
subsequent calls to 'strlen()' where appropriate. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/md/dm-ima.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index b90f34259fbb..8b50c908c6f4 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -241,10 +241,11 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 		/*
 		 * First retrieve the target metadata.
 		 */
-		scnprintf(target_metadata_buf, DM_IMA_TARGET_METADATA_BUF_LEN,
-			  "target_index=%d,target_begin=%llu,target_len=%llu,",
-			  i, ti->begin, ti->len);
-		target_metadata_buf_len = strlen(target_metadata_buf);
+		target_metadata_buf_len =
+			scnprintf(target_metadata_buf,
+				  DM_IMA_TARGET_METADATA_BUF_LEN,
+				  "target_index=%d,target_begin=%llu,target_len=%llu,",
+				  i, ti->begin, ti->len);
 
 		/*
 		 * Then retrieve the actual target data.
@@ -448,11 +449,9 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 		if (r)
 			goto error;
 
-		scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
-			  "%sname=%s,uuid=%s;device_resume=no_data;",
-			  DM_IMA_VERSION_STR, dev_name, dev_uuid);
-		l = strlen(device_table_data);
-
+		l = scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
+			      "%sname=%s,uuid=%s;device_resume=no_data;",
+			      DM_IMA_VERSION_STR, dev_name, dev_uuid);
 	}
 
 	capacity_len = strlen(capacity_str);
@@ -561,10 +560,9 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 		if (dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio))
 			goto error;
 
-		scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
-			  "%sname=%s,uuid=%s;device_remove=no_data;",
-			  DM_IMA_VERSION_STR, dev_name, dev_uuid);
-		l = strlen(device_table_data);
+		l = scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
+			      "%sname=%s,uuid=%s;device_remove=no_data;",
+			      DM_IMA_VERSION_STR, dev_name, dev_uuid);
 	}
 
 	memcpy(device_table_data + l, remove_all_str, remove_all_len);
@@ -647,10 +645,9 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 		if (dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio))
 			goto error2;
 
-		scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
-			  "%sname=%s,uuid=%s;table_clear=no_data;",
-			   DM_IMA_VERSION_STR, dev_name, dev_uuid);
-		l = strlen(device_table_data);
+		l = scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
+			      "%sname=%s,uuid=%s;table_clear=no_data;",
+			      DM_IMA_VERSION_STR, dev_name, dev_uuid);
 	}
 
 	capacity_len = strlen(capacity_str);
@@ -706,7 +703,7 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
 	char *old_device_data = NULL, *new_device_data = NULL, *combined_device_data = NULL;
 	char *new_dev_name = NULL, *new_dev_uuid = NULL, *capacity_str = NULL;
 	bool noio = true;
-	int r;
+	int r, len;
 
 	if (dm_ima_alloc_and_copy_device_data(md, &new_device_data,
 					      md->ima.active_table.num_targets, noio))
@@ -728,12 +725,11 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
 	md->ima.active_table.device_metadata = new_device_data;
 	md->ima.active_table.device_metadata_len = strlen(new_device_data);
 
-	scnprintf(combined_device_data, DM_IMA_DEVICE_BUF_LEN * 2,
-		  "%s%snew_name=%s,new_uuid=%s;%s", DM_IMA_VERSION_STR, old_device_data,
-		  new_dev_name, new_dev_uuid, capacity_str);
+	len = scnprintf(combined_device_data, DM_IMA_DEVICE_BUF_LEN * 2,
+			"%s%snew_name=%s,new_uuid=%s;%s", DM_IMA_VERSION_STR, old_device_data,
+			new_dev_name, new_dev_uuid, capacity_str);
 
-	dm_ima_measure_data("dm_device_rename", combined_device_data, strlen(combined_device_data),
-			    noio);
+	dm_ima_measure_data("dm_device_rename", combined_device_data, len, noio);
 
 	goto exit;
 
-- 
2.50.0

