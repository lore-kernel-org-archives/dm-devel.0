Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF755197A8E
	for <dm-devel@lists.linux.dev>; Mon,  5 May 2025 16:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746462635; cv=none; b=lt3TcufptU8Ewd3CMtbI7Y+loE9VXp6FgNm65i3taaS4nzJjZro6qhxVXpje+UsGoRarkPq7hG2GrDEVmkSDVO9YDim07TXFa1PXOHbo7WvWMCSc3V68C3nMTO2sKZePT1z8frRwnUrIn5i1FcpuQ+mVjPbhlS++rvx1rWmsIY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746462635; c=relaxed/simple;
	bh=lbHRoQTS7tHho4jE3HeAx4saixU+wTOluqoGZsxF18k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkRNEwdzh2nSFEWurpVEpcIy8S2hHzmFUCzXDsUqdzRorgEeSYJ8kKX3viP8EOP71FkBTGqk8M48ajbcQbnYfotUwK85xRCu+ojrAqjJxyWZEkmmEW+O9BXy2vf2Hi3llyWh1i57WX7SKdo0b4oHEx20UNmvmd58Tupt/+iz/p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ExBMKpvS; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ExBMKpvS"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39c0dfba946so3675633f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 05 May 2025 09:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1746462630; x=1747067430; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JR6GbcCS8ZEka7rx9h8gxdP3wLrQ8BbMaDPFyAEYmeE=;
        b=ExBMKpvSs+y8pggfLdS/oj6NdWGtFbHzzoi5qG4ablKRax4+GYNdY1eelhV5o9wYm0
         2kNJva8WRAXkNyTqF9VQ2U5tZxD79CdMgwfKeIiKdbtbV4P73/R5Y5pzAzHWsY/M1ib+
         yNEFsA5cymIPz7180CUtqx1D8uWxWC/xNzYHwqoLHp/NZ2zZppEpRMBBp+fE4A09lRVh
         1j5tTuyAjiACs2dZturmM+SLxiLgBytIpU9PZi6GY7sRYu5T4Dnj+PGU+eqPMAl3VFmr
         uVjmW3Hmz4rMPkBOhn1p+7YsdwzrsnW7AmcX1FHd0Rr4gkp9fLEmjcdIpVTJhVghv6kG
         y0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746462630; x=1747067430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JR6GbcCS8ZEka7rx9h8gxdP3wLrQ8BbMaDPFyAEYmeE=;
        b=MsRm9UdYrZDg/oryRBDenxMS14jjEJ2axIeeaaO6Li/xur0YN0mAuAY242YHiMyS5C
         bFsVlgfYuZjvCB8sIu2RtqjUVbhCkJ2saqT37d9CimEFDEMlvpOVo6hOSEF3csTEmZ+g
         QRdKs4zIVDgPFnmEKnRUkJutV81i/uY2ZDlXo/QGGntXjQZKYueeQAtdVr8N9brUssnQ
         6JT/f30G7suyhdz9ZyEY8A0PWlrruING+V61E1VF2CX4AQEq+1YatNo6Tm0OTvpBVWna
         25oyIHBNS4TOXc3VZGWybqlX6OSzsu1Snzh9SBKP5Uh4BXoZJbh/FNStnlAtnRw6dZTf
         YVSw==
X-Forwarded-Encrypted: i=1; AJvYcCW5E0F7z6MoSf1Ftz96t70/YxBLq+14L0Zp2IwtGExey6W+JaMcTaugBHZrqRBgTSFS3P/YNCFNGQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwwAg5TnJY9QM8RI09RbwzPMlkjuRQw6NEFK1YVeD8j2ZZ2gsJ6
	RWqkONxP4xh7nUOyxi7eMKaa5jt09l/1+pC0QCejztxe9aQmVRIzsJzARv69BNoFTtCzZBgvoYf
	O
X-Gm-Gg: ASbGncsH9i/XilO2FfyIC8b7jokJOXQQuMKIcYT6dQ/1olKWyCwqcWLlDu6Z2M11FVT
	FsdfrhSnFZK85HrCIzS1VAu7DJzaZgwvQygdz7VCzODqdFSxk34m2kh4A0oidClDlhsRJ20f9v3
	gwHbTSIHxEkmIfuzetVPYrJhbPb5HBppr0BoFGqnfCzhrTUCEpVuNzhbzrpRpnRjn83K7Qb6nFY
	Jx08EmPVc5o+LrS2jUBHOlZJvrnuqEnot8K4CdN8TXMHPHedoLzn8JmZB9+d4WCvV0sQdgMiOHz
	Kp0wzPg7y5QG38s9kNQ7zM75Ltf+iPPPaOZ+mVeZybk+E6rotIiP4E68I/O19FXK85GbwpTvsH+
	8GERehbg/Ba1O2oc0HHQbmc2MZS3r
X-Google-Smtp-Source: AGHT+IGJpmlRnsY7Vu22Lnf5T62HSubO2zP66PKxoy/gzn9wV4BMYJX0hT9L9kNAk8pwH6EiPpDXIA==
X-Received: by 2002:a5d:4685:0:b0:3a0:a3f3:40cb with SMTP id ffacd0b85a97d-3a0a3f34a61mr2856723f8f.50.1746462629764;
        Mon, 05 May 2025 09:30:29 -0700 (PDT)
Received: from localhost (p200300de3740fd00677a2a06a3663993.dip0.t-ipconnect.de. [2003:de:3740:fd00:677a:2a06:a366:3993])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a099ae0ca4sm11055372f8f.14.2025.05.05.09.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 09:30:29 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 4/6] libmpathutil: silence compiler warning in vector_del_slot()
Date: Mon,  5 May 2025 18:29:56 +0200
Message-ID: <20250505163007.59352-5-mwilck@suse.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505163007.59352-1-mwilck@suse.com>
References: <20250505163007.59352-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Try to silence a gcc warning. Also, replace the wrong-looking
VECTOR_DEFAULT_SIZE by 1 (after all, we've just deleted a single
element).

Found by Fedora's static analysis [1].

[1] https://openscanhub.fedoraproject.org/task/51915/log/device-mapper-multipath-0.11.1-1.fc43/scan-results.html

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/vector.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/libmpathutil/vector.c b/libmpathutil/vector.c
index 7f763cb..3386651 100644
--- a/libmpathutil/vector.c
+++ b/libmpathutil/vector.c
@@ -107,28 +107,28 @@ int find_slot(vector v, const void *addr)
 void
 vector_del_slot(vector v, int slot)
 {
-	int i;
+	int i, allocated;
 
 	if (!v || !v->allocated || slot < 0 || slot >= VECTOR_SIZE(v))
 		return;
 
 	for (i = slot + 1; i < VECTOR_SIZE(v); i++)
-		v->slot[i-1] = v->slot[i];
+		v->slot[i - 1] = v->slot[i];
 
-	v->allocated -= VECTOR_DEFAULT_SIZE;
+	allocated = v->allocated - 1;
 
-	if (v->allocated <= 0) {
+	if (allocated <= 0) {
 		free(v->slot);
 		v->slot = NULL;
 		v->allocated = 0;
 	} else {
 		void *new_slot;
 
-		new_slot = realloc(v->slot, sizeof (void *) * v->allocated);
-		if (!new_slot)
-			v->allocated += VECTOR_DEFAULT_SIZE;
-		else
+		new_slot = realloc(v->slot, sizeof(void *) * allocated);
+		if (new_slot) {
 			v->slot = new_slot;
+			v->allocated = allocated;
+		}
 	}
 }
 
-- 
2.49.0

