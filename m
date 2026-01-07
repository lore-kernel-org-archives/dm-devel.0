Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D8C337BA6
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817136; cv=none; b=ksdFqiaG6gCfc+4KtZUtKYfLID1sgz7vOy/JmrMfG1lFJW/CWpKnnkQNr0e4rrz67+X9cV+OXemf8TUzZpD2t8cEhxueyBwyuuD+qSHsO3+GJhLXMsLS5MTF8YoShpMFH2fe8HwNXGEZSjZM1/obq7fOPhTjeSmfTg2I9toaoBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817136; c=relaxed/simple;
	bh=BhRgs5CsT9rnUOTFWWHVqaIvAfRWiFSb2XHFI2zgQI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enyRJ50E8jGAI0Bdj9V28QUrj7JhyWVxNZQ9wZhxVUaIvTBVyFznUj8ViIiFtTpG/b+buEZG9bP8D2ccPoNgbEbcBKsSmnlffO7qCRY598dXQSaYTqVv4iO+Txmh17SjvWwoVR/KUSPWQC+BS1GWqkOZS000OL5XbQ9el578EFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PzsdG6/w; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PzsdG6/w"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b7a72874af1so465734066b.3
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817128; x=1768421928; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VOD69bBD2f0RvUHcVxL54dCDOVnt23kWEjsDm1WKQ6g=;
        b=PzsdG6/w8RZm3/rCQZ24lu6kT9P9l5iSOfst92ZhVAr1FIDbCYigzL2pzC15L+wbfJ
         iaNXVvs2uMVONJfpdecIHgBgY1mDZAva9Ak/c3TfdQgaNc7ZmZpGVWNuyBZWr/VfXRVH
         NA+t2lys8Kweh17t147ZYqnnvQhM7W0/nWndC1zekoYJ/YfEsbeTnaWO71WeenVLoAuD
         4Z4xjfIwvVsvth9DpRURjo0pZcA57gT3OQbUSBMXSvadftVli/S/ArZviyXHTOimmBzU
         oeNLFFfLjydK8kK8ZLnG9combwW5v5pXohQI4nWo8qjqe9SFeACxeGZpVPdzUBQBNo/Y
         vx7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817128; x=1768421928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VOD69bBD2f0RvUHcVxL54dCDOVnt23kWEjsDm1WKQ6g=;
        b=M7nzDfauEtgliNzP5OxDYSMbHpJ27oEptIz/vOQxpBj4nP+qcBsDR8PgGxdr2J7u2u
         r5KJRU3q11A7/jOfe9v2T9hT3/alLh+luhqUJWqD0IpGW+BbbRYPjdkFdHOlmsD3xdl1
         PDPXFWiSuNE0/NZMixt4LrnfnZpIHpuy36odvhYRNd3wU91EW41xsV4yeVMpWpAMI0P0
         WKrEvT9l5g8kmOTDK0oAMY/q6FsAHop65EFmc8bjnUUI0bWgpmZh/9lhBeMCxXnQj2FE
         GYqJqnFxp1UuNj/zUnM4AX/zDkYv86Ft9DYXat2ubDd+f6XYw2Z+hi9baT8kVLI8jv3a
         VpwA==
X-Gm-Message-State: AOJu0YwmXNJhQ2S5LAEhD2Ae758YhutrgY9r5mbojWSxe+oxBiXo7cBU
	8elzw0hEMqorSVNBLR8eZ+2KDNxGEyQEens6VKC7haN9eJETEGS8Dbw4z29H5QRyO58=
X-Gm-Gg: AY/fxX7xQzUoUgXsi/Sfojrckufe9JJhiAdGpI48jTndaPJnVLZGhpb6exOWb1inuQv
	J9doTDr4Yy/vWQEGUgKq1I2eJ0NiN1V67FBcZKhlgtSCxwCBRhHA9z/CWy66VNg/VoVnZOswv3F
	8MhKw12jLVUDuD4s6HZ4d/ianwev9gVnORGpbjH+mb1j51evRjyrZzD8HrdGXL+bIQf7fWRIVpG
	gsySXNF+Q0bErNrR+wc/naEKMknP/J54kGokMtoiFpmT2cC71hvSYKGZrUF9NZFr+22O8/4m8Q8
	HMyMHjGZFSRupr4Hq6+HrVwAUQIJtaISJEQOFl3TlBwLF/byHYumkoZmJWlRh/0oum57nTVOKII
	gBJs7GtlnKQMYeoR07KssX1TWOscmzl36aAgWflPn0yF2ZTMY/0e7ww0KQMmj9CoAzjN7bph0lC
	4/hIzk1rortHquD1PefRTGjan92uJrHBec3r80Nugxn/Dsewwqtdb0sj4to+o7hq4IbcqhC1smM
	Q==
X-Google-Smtp-Source: AGHT+IH80kB4hDneaMqQkdWCeJ0lPZAbfcCw5cO9Jy+eM1M2Icq4PN6Xz+d7HeeeTKAW7Tnz11K0ow==
X-Received: by 2002:a17:907:fdc1:b0:b80:4103:537e with SMTP id a640c23a62f3a-b8444fdcc9dmr366463666b.53.1767817127677;
        Wed, 07 Jan 2026 12:18:47 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a51183asm613934666b.49.2026.01.07.12.18.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:18:47 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 07/26] libmultipath: don't free paths in orphan_paths()
Date: Wed,  7 Jan 2026 21:18:07 +0100
Message-ID: <20260107201826.323977-8-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

remove_map() should just do what the name says, remove the map.
It is unexpected that it also frees the paths of the map, which
can happen if these paths are in INIT_PARTIAL or INIT_REMOVED
state. This is particularly wrong if remove_map is called from a code path
where other data structures are still holding references to the paths in
question, in particular configure() -> coalesce_paths().

Don't free paths in orphan_paths(). A follow-up patch will make sure
that these paths are freed from the checker loop.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 7bceeb6..fe777dc 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -383,19 +383,10 @@ static void orphan_paths(vector pathvec, struct multipath *mpp, const char *reas
 	struct path * pp;
 
 	vector_foreach_slot (pathvec, pp, i) {
-		if (pp->mpp == mpp) {
-			if (pp->initialized == INIT_REMOVED ||
-			    pp->initialized == INIT_PARTIAL) {
-				condlog(3, "%s: freeing path in %s state",
-					pp->dev,
-					pp->initialized == INIT_REMOVED ?
-					"removed" : "partial");
-				vector_del_slot(pathvec, i--);
-				free_path(pp);
-			} else
-				orphan_path(pp, reason);
-		} else if (pp->add_when_online &&
-			   strncmp(mpp->wwid, pp->wwid, WWID_SIZE) == 0) {
+		if (pp->mpp == mpp)
+			orphan_path(pp, reason);
+		else if (pp->add_when_online &&
+			 strncmp(mpp->wwid, pp->wwid, WWID_SIZE) == 0) {
 			pp->add_when_online = false;
 		}
 	}
-- 
2.52.0

