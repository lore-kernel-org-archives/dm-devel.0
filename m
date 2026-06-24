Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDBD3D5C05
	for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782312779; cv=none; b=OpNe+2OfwQff9QxZij5dEUFvE623k0ztoGLIahrmg2XMl1RfHtpGtLnLk+gJtus2cGA/TQIngtHXSCPLeQYvN1KMA4PDexFrPvnLoTlnWvyeaqsg9iB0DyG56Jlj/0rlS1wAU16ELSRXnSsKas/j+39LYgWgbUR6V8xADEmxACk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782312779; c=relaxed/simple;
	bh=wImPAAkpRxw6gvdNVIH0703AsaioboseNVoqb/6085M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sbkv/M2dsE2BZXMKoC1SuevUefqsQjlgbYFVrSFe37gL/nY5ElThDKxfpPCDS22JSEfTTPo/ayipd2NTxA6ImQghEMUOZpsrOj+8u+jVw5WeQk4vUxVRgEEpMLfXmqqNd7zaIMRWXTfUo/x4ku6PX6EJJwFrXwi+ha+1apFBxc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EpR1sCnn; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EpR1sCnn"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4926046fbc5so11666145e9.0
        for <dm-devel@lists.linux.dev>; Wed, 24 Jun 2026 07:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782312775; x=1782917575; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3L5mgyDN+SYmyQ/3UWmhVYF6uYgYwomGUpC7eL9GCc=;
        b=EpR1sCnnmNjbVk8Gelni0yOn8wzL0d8paaAVbp3jFX5HWZ31oFtQqudKW6f6HCqYfw
         4yUZQn7x3PMNV4O2tZif+D0iBW9/kTZSvaMychdnWHV/E/LFMS6JvQetW2rlMhpbJcyM
         8BJrhxBs92BQbig4y7c+lEBGNnt8K1v+oh+5X8RwmNu5QWIQus7kpZcjNULi4oQBKkxc
         kLkirii3Gbfgvpe7yJsfoApvUr4pI/JIuOdiOStjTDWth9zUZfG9Z33DGdpfdvRFXXim
         4wqCJNzvRD4pC/WIw5SWxiAJ4BUsyebM13+eeXuwNtXozEztad0T/pp0qHqUwCu6kJra
         5H5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782312775; x=1782917575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v3L5mgyDN+SYmyQ/3UWmhVYF6uYgYwomGUpC7eL9GCc=;
        b=PTKoaoL4ac6zFBsA6qX4bCHb10m3W3qRDEf6pBaF0LkCHXca4eo1BLhIr7wjPqe/TC
         MDGA3Y5oIZwBO/lg0nYPS1bpK3NXVNGeO8mnqVD5D9GTLR2EAPVnuTWhuvBu2MnKC2i/
         IqacvrByrj+szT20nsmobiJmHye/jotRLOFeeIeMFLNphaHKMhxgdoNqBpnvmYk4eQ3W
         K0aHyxVYFAxrUebiZsb67xPegW4I2KXFRLx/OEYWjWeUUuecKc6W6HcSUxaxi0jtD6km
         frjwCwkJ3gGZ9Ymay1ZjVgVvB2Yc9kaq/7rzzxHUniUTDJlmyHOI93a1vp5D7+oIUXQU
         cbRw==
X-Forwarded-Encrypted: i=1; AFNElJ99T3Q2gtbs1rdtq4CIZXChrNG8ygz7nBwdA/3rhqjIRcECHfnqpCjwN5QxYy71ryh9IhhudCIuWw==@lists.linux.dev
X-Gm-Message-State: AOJu0YwzOgInzOfBch9r7EA2RdwcVo7RN12LaBPYEm+MnOQ0Um+loS/w
	mzqodSu+SF1L1Exbi6HSGLPU/E5rk6ChUp6xvvmRRyqyJE5jzs3q70vt
X-Gm-Gg: AfdE7ckk2RrYB2YwGSJcJmTWkcQxQXkp4a3WoZMHG4J46JdbKIlHmDZ68y6+4JhO8sa
	88Yz/lZGcO8TKHMlvZAzF4CFzQlowyGFmfX4rUXfInJMcMifDRHVxgSYH9HPV1pRDZ8znqp8JK8
	QSvYf9Kbmgbl3zm9TUMt6HRSePEOAp073Qpe7Y2CPBFj2DDUmMHLnLgcZbvsz7U2l3NagunUeBH
	vYJdlglPn4zQrk6eMebUEfLesQ0le4aC4PFvWimY3S1sdioi+iAC41/zGM37gJ7NsV4D2nva6jT
	gg1DT/qHkO+KM52pkC6svG+Yf5hEnGocVQZesmv0Gxa+wTZiPIAioKAkHVwCafZOPyGQb1mvQR5
	wnIk4kbIH8ocD1E+CcUaNVLm1zR5y3Kq+Vz7ld7JuFEUocRTQIs8IBvye4WMTeNiok50dW/ht1U
	GTmepj1I/u87wseVQ03OvQlGQWqPvd2+waRqYxe28+2JJ7q7vduVAVuNoH1214uGgX6zDuBw==
X-Received: by 2002:a05:600c:3e05:b0:492:3fb5:3a17 with SMTP id 5b1f17b1804b1-4926329a882mr10925625e9.2.1782312775003;
        Wed, 24 Jun 2026 07:52:55 -0700 (PDT)
Received: from snowdrop.snailnet.com (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4924923392dsm735988005e9.2.2026.06.24.07.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:52:54 -0700 (PDT)
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
Subject: [PATCH 1/3] dm: __list_versions(): Only process targets once
Date: Wed, 24 Jun 2026 15:52:41 +0100
Message-Id: <20260624145243.2736-2-david.laight.linux@gmail.com>
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

This removes any problems that might occur if a 'target' is added
between the scans.

For additional safety only call strlen(tt->name) once and use the
returned length for everything (incuding the copy).
Ensure than all the pad bytes between the entries are zero.

Set param->data_size to the actual size of the data.
It was slightly large because ALIGN_MASK was added in instead of the size
being rounded up.

Signed-off-by: David Laight <david.laight.linux@gmail.com>
---

This seems to be the only code that uses dm_target_iterate() and the
dm_get_target_type() call is just a linear scan of the same list that
replaces the lock() with MODULE_GET().
It would all be simpler with a loop here that scanned the list,
but the required locking primitives aren't exposed.
Changing that is a larger change that I wanted to do now.

 drivers/md/dm-ioctl.c | 73 +++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 44 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index a529174c94cf..6234cb8b86b7 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -54,10 +54,8 @@ struct hash_cell {
 };
 
 struct vers_iter {
-	size_t param_size;
 	struct dm_target_versions *vers, *old_vers;
 	char *end;
-	uint32_t flags;
 };
 
 
@@ -684,41 +682,38 @@ static int list_devices(struct file *filp, struct dm_ioctl *param, size_t param_
 	return 0;
 }
 
-static void list_version_get_needed(struct target_type *tt, void *needed_param)
-{
-	size_t *needed = needed_param;
-
-	*needed += sizeof(struct dm_target_versions);
-	*needed += strlen(tt->name) + 1;
-	*needed += ALIGN_MASK;
-}
-
 static void list_version_get_info(struct target_type *tt, void *param)
 {
 	struct vers_iter *info = param;
+	struct dm_target_versions *vers = info->vers;
+	size_t name_len = strlen(tt->name);
+
+	if (!vers)
+		return;
 
-	/* Check space - it might have changed since the first iteration */
-	if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 > info->end) {
-		info->flags = DM_BUFFER_FULL_FLAG;
+	info->old_vers = vers;
+	info->vers = align_ptr((void *)(info->vers + 1) + name_len + 1);
+
+	/* Check space */
+	if ((char *)info->vers > info->end) {
+		info->vers = NULL;
 		return;
 	}
 
-	if (info->old_vers)
-		info->old_vers->next = (uint32_t) ((void *)info->vers - (void *)info->old_vers);
+	/* Zero padding and terminate vers->name[] */
+	((u64 *)info->vers)[-1] = 0;
 
-	info->vers->version[0] = tt->version[0];
-	info->vers->version[1] = tt->version[1];
-	info->vers->version[2] = tt->version[2];
-	info->vers->next = 0;
-	strcpy(info->vers->name, tt->name);
+	vers->next = (char *)info->vers - (char *)vers;
 
-	info->old_vers = info->vers;
-	info->vers = align_ptr((void *)(info->vers + 1) + strlen(tt->name) + 1);
+	vers->version[0] = tt->version[0];
+	vers->version[1] = tt->version[1];
+	vers->version[2] = tt->version[2];
+	memcpy(vers->name, tt->name, name_len);
 }
 
 static int __list_versions(struct dm_ioctl *param, size_t param_size, const char *name)
 {
-	size_t len, needed = 0;
+	size_t len;
 	struct dm_target_versions *vers;
 	struct vers_iter iter_info;
 	struct target_type *tt = NULL;
@@ -729,41 +724,31 @@ static int __list_versions(struct dm_ioctl *param, size_t param_size, const char
 			return -EINVAL;
 	}
 
-	/*
-	 * Loop through all the devices working out how much
-	 * space we need.
-	 */
-	if (!tt)
-		dm_target_iterate(list_version_get_needed, &needed);
-	else
-		list_version_get_needed(tt, &needed);
-
 	/*
 	 * Grab our output buffer.
 	 */
 	vers = get_result_buffer(param, param_size, &len);
-	if (len < needed) {
-		param->flags |= DM_BUFFER_FULL_FLAG;
-		goto out;
-	}
-	param->data_size = param->data_start + needed;
 
-	iter_info.param_size = param_size;
 	iter_info.old_vers = NULL;
 	iter_info.vers = vers;
-	iter_info.flags = 0;
-	iter_info.end = (char *)vers + needed;
+	iter_info.end = (char *)vers + len;
 
 	/*
-	 * Now loop through filling out the names & versions.
+	 * Loop through filling out the names & versions.
 	 */
 	if (!tt)
 		dm_target_iterate(list_version_get_info, &iter_info);
 	else
 		list_version_get_info(tt, &iter_info);
-	param->flags |= iter_info.flags;
 
- out:
+	if (iter_info.vers) {
+		if (iter_info.old_vers)
+			iter_info.old_vers->next = 0;
+		param->data_size = param->data_start + ((char *)iter_info.vers - (char *)vers);
+	} else {
+		param->flags |= DM_BUFFER_FULL_FLAG;
+	}
+
 	if (tt)
 		dm_put_target_type(tt);
 	return 0;
-- 
2.39.5

