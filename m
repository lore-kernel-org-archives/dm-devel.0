Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502D13D5652
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 14:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782312781; cv=none; b=jnN67XyLu9DWAf30z96LmMwszxodL5TZdzN4CHONyGMcnUStVQONuSQBcKKdljYRcuDkru9ioNJ9o37xGdV717UTjEOboeea3CjXm79yQoLrki3x+7PgprVHSXKwquzkHzE9jvYRA9Gr3q7/U6W4E3sqW4xpMvqjYKZJdzweSlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782312781; c=relaxed/simple;
	bh=i+1zfmoF6Ni0osWFykDwF6eI1O/z6HU8tXuesOETdq4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BWEVshrw+NfO5zvPQvdp5tuInx7/CljbU1b0Wn37QEkVwkw5ih2lGhW3hSuXSgaxJbufeNJfxPPymzVPrkmso9yuviEFK9BUd67A2Swj9IJmxh5z1Wa7TOJ7gG3gk+d8AojmqiSs0yxUggr7NY0Dhe7tadnvxy4Vw+BiTW0Uxjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mXLhXLG2; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mXLhXLG2"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49241dbf9c1so9451515e9.2
        for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 07:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782312776; x=1782917576; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lEW+ehp8fdxrw4rnlcdItkyNhL9TC1RVDN+JA5R/x0E=;
        b=mXLhXLG2fkQRxJ/kS525JAiYwG7j/zwFhhXRJyesJen89TTMXvIhjChMRqFz3vkEQ2
         2KmmICvNUwhMi+fLdZEsqEAM3ga5g5CBa5Emu73O/8vh+k6+s20uUuigr8OsysWYqEwk
         13ON/JhbCurGLSbtqeBFf78W1l9wzNOtu2PHim+dUODnlYTtV+2+DyLjhWg0ibfqtIRD
         BvvVdugZ+2G2Db5GIhoURNn3vxVjL+NJKYYd0cKBvc3/hRxprTATJfAk8tVxVYzYJSPg
         tXaH9Oyhrx6auNVViU700BXx8F4SMZrDTTkp/V3o+nzSS8n820d/6tFJhRQLRrLjPdyO
         Jm9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782312776; x=1782917576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lEW+ehp8fdxrw4rnlcdItkyNhL9TC1RVDN+JA5R/x0E=;
        b=kWAJ4tWNVhSKcdvIZku8xybQAKU/MFTOXYhdIjnxDRb1qwIF8hYP/1VUZOwrmvs5tV
         nZJ7xYy3LrnpW2cJPtvit9NmOJWOftUwmQz1mO4xnWJ0Hkh1sY5Wq0sKagiNoJwLKUDh
         Y74Mr6VknPzK7GvYAPfPSRMQzpuSZnPQR5BcLlgGwEcp6fjOPhIamnaWK0UQwvglYf7+
         enJOanxchza1YJyKN3DLWn+Wd1GyxSlGioZk2GCsz6c6Pml6IlnutWKhfsxbaZOjtEVl
         EkFZeTYRjAuOKpjrfjPPL7p/3l+zMsA/HcyeeJOp4wh893CfdsHcvfYtlRcRiSw5ZUZr
         q/ZA==
X-Forwarded-Encrypted: i=1; AFNElJ/6ULkGUo7vU2mrVKlfy2yM6gEFHB1wc9mSGTIcj9K5sbDome17KtyRNDE7E7EJ2ia727I85lxXnQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwTz5tJpMrJhCD+wdLTvloWfjC1Z64Y4I9c/Wg1FPTYhkaUNeEW
	GYkl/l1WLbC7K4yqQwOZ9wYuXjL9a2+JSYdNPmuT4gd9bxdxLKLa8xb4
X-Gm-Gg: AfdE7cktAT2YhDPtK3VQBUUuYVFmafa6PIOZD8nvs1QFCDQPZ2ZIVoEaJ2BIkUi7Gmb
	Jq32MoLXv4NpjRGK5vI8dlfJuM0LbkLSN1Gkx7caldXZX0YJ3/T1AD+PvilKp+7ChgYuFrI24t/
	2NLgcyOBigiS0nye1ZclEy/hbBMnOlW6L5GOtnvLivcMtzzU2fToxbUAp/16bgUcP7VS9SpyFe8
	zPAy9XSWAI7/tSV6XJigzW6JAP36gKPkF/3oeM3yhiBFOAl/xZ0ALyyPH7ggqTMkqX548u2GqF1
	uaU3TEVX4YrwXt9JmH2utn3NnBhCHpu2R9pA0KUZGIGr7HT7aULWdn/FAbuwSfe3ohtAPe3SLxw
	5ou2ap9xGmEjLTWzeDYEKEDykSKO11lLd5tKsSI3y1so6bnV5JqiRnufgR4pf2gGgibXllM7iKN
	qj+Ea2U5qEMBJUteMiIgIkaJeOOP4i7/k0hLHXaJDnvYKyA0Y3FtSRvw9dYAoxNw5dyZHt9Q==
X-Received: by 2002:a05:600d:8489:10b0:492:4161:ae9d with SMTP id 5b1f17b1804b1-49260849b3bmr43023205e9.8.1782312775542;
        Wed, 24 Jun 2026 07:52:55 -0700 (PDT)
Received: from snowdrop.snailnet.com (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4924923392dsm735988005e9.2.2026.06.24.07.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:52:55 -0700 (PDT)
From: David Laight <david.laight.linux@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Tony Asleson <tasleson@redhat.com>,
	"Bryn M . Reeves" <bmr@redhat.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: David Laight <david.laight.linux@gmail.com>
Subject: [PATCH 2/3] dm: list_devices(): Only process devices once
Date: Wed, 24 Jun 2026 15:52:42 +0100
Message-Id: <20260624145243.2736-3-david.laight.linux@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260624145243.2736-1-david.laight.linux@gmail.com>
References: <20260624145243.2736-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of doing a prescan to determine the length of buffer required,
checking the supplied buffer is big enough, and then doing a second
scan to fill the output buffer just do a single scan and detect when
the buffer is too short.

For additional safety only call strlen() once and use the
returned length for everything (incuding the copy).
Ensure than all the pad bytes between the entries are zero.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---
 drivers/md/dm-ioctl.c | 87 ++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 47 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 6234cb8b86b7..57cfbc12c0ce 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -605,79 +605,72 @@ static int list_devices(struct file *filp, struct dm_ioctl *param, size_t param_
 {
 	struct rb_node *n;
 	struct hash_cell *hc;
-	size_t len, needed = 0;
-	struct gendisk *disk;
-	struct dm_name_list *orig_nl, *nl, *old_nl = NULL;
+	size_t len;
+	struct dm_name_list *nl, *old_nl = NULL;
+	void *result_start, *result_limit;
 	uint32_t *event_nr;
 
-	down_write(&_hash_lock);
-
-	/*
-	 * Loop through all the devices working out how much
-	 * space we need.
-	 */
-	for (n = rb_first(&name_rb_tree); n; n = rb_next(n)) {
-		hc = container_of(n, struct hash_cell, name_node);
-		if (!filter_device(hc, param->name, param->uuid))
-			continue;
-		needed += align_val(offsetof(struct dm_name_list, name) + strlen(hc->name) + 1);
-		needed += align_val(sizeof(uint32_t) * 2);
-		if (param->flags & DM_UUID_FLAG && hc->uuid)
-			needed += align_val(strlen(hc->uuid) + 1);
-	}
-
 	/*
 	 * Grab our output buffer.
 	 */
-	nl = orig_nl = get_result_buffer(param, param_size, &len);
-	if (len < needed || len < sizeof(nl->dev)) {
-		param->flags |= DM_BUFFER_FULL_FLAG;
-		goto out;
-	}
-	param->data_size = param->data_start + needed;
+	nl = result_start = get_result_buffer(param, param_size, &len);
+	result_limit = result_start + len;
 
-	nl->dev = 0;	/* Flags no data */
+	if (len >= sizeof(*nl))
+		nl->dev = 0;	/* Flags no data */
+
+	down_write(&_hash_lock);
 
 	/*
-	 * Now loop through filling out the names.
+	 * Loop through filling out the names.
 	 */
 	for (n = rb_first(&name_rb_tree); n; n = rb_next(n)) {
-		void *uuid_ptr;
+		void *next_nl;
 
 		hc = container_of(n, struct hash_cell, name_node);
 		if (!filter_device(hc, param->name, param->uuid))
 			continue;
-		if (old_nl)
-			old_nl->next = (uint32_t) ((void *) nl -
-						   (void *) old_nl);
-		disk = dm_disk(hc->md);
-		nl->dev = huge_encode_dev(disk_devt(disk));
-		nl->next = 0;
-		strcpy(nl->name, hc->name);
 
-		old_nl = nl;
-		event_nr = align_ptr(nl->name + strlen(hc->name) + 1);
+		len = strlen(hc->name);
+		event_nr = align_ptr(nl->name + len + 1);
+		next_nl = event_nr + 2;
+		if (next_nl > result_limit)
+			break;
+
+		((u64 *)event_nr)[-1] = 0;
+		memcpy(nl->name, hc->name, len);
+
+		nl->dev = huge_encode_dev(disk_devt(dm_disk(hc->md)));
+
 		event_nr[0] = dm_get_event_nr(hc->md);
 		event_nr[1] = 0;
-		uuid_ptr = align_ptr(event_nr + 2);
+
 		if (param->flags & DM_UUID_FLAG) {
 			if (hc->uuid) {
+				len = strlen(hc->uuid);
+				next_nl = align_ptr(next_nl + len + 1);
+				if (next_nl > result_limit)
+					break;
 				event_nr[1] |= DM_NAME_LIST_FLAG_HAS_UUID;
-				strcpy(uuid_ptr, hc->uuid);
-				uuid_ptr = align_ptr(uuid_ptr + strlen(hc->uuid) + 1);
+				((u64 *)next_nl)[-1] = 0;
+				memcpy(event_nr + 2, hc->uuid, len);
 			} else {
 				event_nr[1] |= DM_NAME_LIST_FLAG_DOESNT_HAVE_UUID;
 			}
 		}
-		nl = uuid_ptr;
+		nl->next = next_nl - (void *)nl;
+		old_nl = nl;
+		nl = next_nl;
 	}
-	/*
-	 * If mismatch happens, security may be compromised due to buffer
-	 * overflow, so it's better to crash.
-	 */
-	BUG_ON((char *)nl - (char *)orig_nl != needed);
 
- out:
+	if (old_nl)
+		old_nl->next = 0;
+
+	if (n)
+		param->flags |= DM_BUFFER_FULL_FLAG;
+	else
+		param->data_size = param->data_start + ((void *)nl - result_start);
+
 	up_write(&_hash_lock);
 	return 0;
 }
-- 
2.39.5

