Received: from forward200b.mail.yandex.net (forward200b.mail.yandex.net [178.154.239.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7762566
	for <dm-devel@lists.linux.dev>; Tue,  5 Aug 2025 10:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754390662; cv=none; b=fVquu2gqizwvaGZnIyx6p+76tJa7qjmBKpF/F2mYUTq6V7rIPrD+v5BH5aw0eRx08UH5ECt3TVeCqA9z9LI6FISaMoQjyd058fnO6d12SB0/pugSf32cr71rVHEhIPNc86GP3paCO4/pZPdLY7d+HjoYmVL0W4Fqy0//kRCsY1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754390662; c=relaxed/simple;
	bh=AAdDhzzjpuAWruuzzgwQPcwId7SA9SGU/Lf6UjIGHRk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kq085XoiieBmdv5zEbMIDkRJvBqZsJlk4/uSOyGRffN94hP+hKOIoHGRXsxuBx+Zhj1ugPXHNTOfSX6zOsjgAiDebdEzGeTTbD+6gvDdDqeJGmOW+3izUfkLcjpgJYrYRJEc4vOyz159nslYRz0rUqK/nX70p0BBEca2LIuf8F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=WIDQRTR4; arc=none smtp.client-ip=178.154.239.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="WIDQRTR4"
Received: from forward101b.mail.yandex.net (forward101b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:d101])
	by forward200b.mail.yandex.net (Yandex) with ESMTPS id BCB4580E36
	for <dm-devel@lists.linux.dev>; Tue, 05 Aug 2025 13:36:09 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-87.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-87.sas.yp-c.yandex.net [IPv6:2a02:6b8:c23:2f3c:0:640:7ca0:0])
	by forward101b.mail.yandex.net (Yandex) with ESMTPS id 8C71DC0107;
	Tue, 05 Aug 2025 13:36:01 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-87.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 0adw0e9M58c0-B3PldoND;
	Tue, 05 Aug 2025 13:36:01 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1754390161; bh=Arv0eeqJJyWd5SVB68jbPF1oe6YKqGhuaMTw7VHusNA=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=WIDQRTR4YUkV3tu0u8ezvMh2Kxky1OhKjloKRGtdIz6Fz8G9PjIHPbrSFneJttbES
	 B7F+JaIYxWPKGwuvoxGvg4ig8huMM9KDv+fdsPkZTXxHfLJ4G4IsyDKEPL4054nzVy
	 Ad3OrmZeE4FQBZFfb9MFlVmP26rDl/2KprKh7N9I=
Authentication-Results: mail-nwsmtp-smtp-production-main-87.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] dm: ima: more strlen() drops
Date: Tue,  5 Aug 2025 13:35:41 +0300
Message-ID: <20250805103541.490377-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following commit ebbd17695e9e ("dm: ima: avoid extra calls to
strlen()"), convert 'dm_ima_alloc_and_copy_capacity_str()' to
return the number of characters emitted by 'scnprintf()' and
simplify the users accordingly. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/md/dm-ima.c | 40 ++++++++++++++++------------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 8b50c908c6f4..f5c0ecc7cb0b 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -157,10 +157,8 @@ static int dm_ima_alloc_and_copy_capacity_str(struct mapped_device *md, char **c
 	if (!(*capacity_str))
 		return -ENOMEM;
 
-	scnprintf(*capacity_str, DM_IMA_DEVICE_BUF_LEN, "current_device_capacity=%llu;",
-		  capacity);
-
-	return 0;
+	return scnprintf(*capacity_str, DM_IMA_DEVICE_BUF_LEN, "current_device_capacity=%llu;",
+			 capacity);
 }
 
 /*
@@ -371,18 +369,18 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 {
 	char *device_table_data, *dev_name = NULL, *dev_uuid = NULL, *capacity_str = NULL;
 	char active[] = "active_table_hash=";
-	unsigned int active_len = strlen(active), capacity_len = 0;
+	unsigned int active_len = strlen(active);
 	unsigned int l = 0;
 	bool noio = true;
 	bool nodata = true;
-	int r;
+	int capacity_len;
 
 	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
 	if (!device_table_data)
 		return;
 
-	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
-	if (r)
+	capacity_len = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
+	if (capacity_len < 0)
 		goto error;
 
 	memcpy(device_table_data + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
@@ -445,8 +443,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 	}
 
 	if (nodata) {
-		r = dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio);
-		if (r)
+		if (dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio))
 			goto error;
 
 		l = scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
@@ -454,7 +451,6 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 			      DM_IMA_VERSION_STR, dev_name, dev_uuid);
 	}
 
-	capacity_len = strlen(capacity_str);
 	memcpy(device_table_data + l, capacity_str, capacity_len);
 	l += capacity_len;
 
@@ -483,18 +479,17 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 	unsigned int device_active_len = strlen(device_active_str);
 	unsigned int device_inactive_len = strlen(device_inactive_str);
 	unsigned int remove_all_len = strlen(remove_all_str);
-	unsigned int capacity_len = 0;
 	unsigned int l = 0;
 	bool noio = true;
 	bool nodata = true;
-	int r;
+	int capacity_len;
 
 	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN*2, GFP_KERNEL, noio);
 	if (!device_table_data)
 		goto exit;
 
-	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
-	if (r) {
+	capacity_len = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
+	if (capacity_len < 0) {
 		kfree(device_table_data);
 		goto exit;
 	}
@@ -570,7 +565,6 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 	memcpy(device_table_data + l, remove_all ? "y;" : "n;", 2);
 	l += 2;
 
-	capacity_len = strlen(capacity_str);
 	memcpy(device_table_data + l, capacity_str, capacity_len);
 	l += capacity_len;
 
@@ -602,20 +596,20 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
  */
 void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 {
-	unsigned int l = 0, capacity_len = 0;
+	unsigned int l = 0;
 	char *device_table_data = NULL, *dev_name = NULL, *dev_uuid = NULL, *capacity_str = NULL;
 	char inactive_str[] = "inactive_table_hash=";
 	unsigned int inactive_len = strlen(inactive_str);
 	bool noio = true;
 	bool nodata = true;
-	int r;
+	int capacity_len;
 
 	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
 	if (!device_table_data)
 		return;
 
-	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
-	if (r)
+	capacity_len = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
+	if (capacity_len < 0)
 		goto error1;
 
 	memcpy(device_table_data + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
@@ -650,7 +644,6 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 			      DM_IMA_VERSION_STR, dev_name, dev_uuid);
 	}
 
-	capacity_len = strlen(capacity_str);
 	memcpy(device_table_data + l, capacity_str, capacity_len);
 	l += capacity_len;
 
@@ -703,7 +696,7 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
 	char *old_device_data = NULL, *new_device_data = NULL, *combined_device_data = NULL;
 	char *new_dev_name = NULL, *new_dev_uuid = NULL, *capacity_str = NULL;
 	bool noio = true;
-	int r, len;
+	int len;
 
 	if (dm_ima_alloc_and_copy_device_data(md, &new_device_data,
 					      md->ima.active_table.num_targets, noio))
@@ -716,8 +709,7 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
 	if (!combined_device_data)
 		goto error;
 
-	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
-	if (r)
+	if (dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio) < 0)
 		goto error;
 
 	old_device_data = md->ima.active_table.device_metadata;
-- 
2.50.1

