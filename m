Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BCB1F2389
	for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 22:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733957983; cv=none; b=TiW9rOjYeCT3r38oxBEwE+kb6NDFwpFwGHi7uSGJLcK3WkbDdO+vIRLoiqWT0UygurLGduOOQ7WoVlDBm4lF/maFrfu89Gd+aJSfu6ZZL4xKM8Y5c4MyjXpAguQK8DwLMttf3VSbX67hz4d4v5SSW5WhIDHs1dYjEfjCtiWlTTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733957983; c=relaxed/simple;
	bh=R7NFayBjk2BPl8FKrvBqxjsKdR6qHuvgsv5AQtx4zn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIniZF0t7FIMPMefonjERglYDwRIy3F6V1pQGDSMoZtueSQLtDi+wTplEB6AWWyUo//lr4/H0Ct6djLREWmFyDZ5ldtwcXc9ijv482knfIdRs6KeWGKn/m2JKgYBV3VxIhnQP1GdMEHueOTpj6edssjLF3KT3Zw8bC0BDCTtE/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=hAUPU9Y7; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="hAUPU9Y7"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aa66ead88b3so826892266b.0
        for <dm-devel@lists.linux.dev>; Wed, 11 Dec 2024 14:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1733957979; x=1734562779; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vhGRGkirBXyp8EBWifTH/q8P1dNy28kbRcySFZeUQkY=;
        b=hAUPU9Y7mw+kw5XyCeLBCt2YcdTFrkKMGpd22fEJLCB5odRDIFNW6wU3eK1vX7HJag
         bRRM8zWwF/sHJVYv5vKPg2TjP4Z22mYVjjkiJXGICYjRXRb/a4ZlZYM2T1N8FV6dFiuP
         uAZ8v3a5ZrhSFfBL+bsbz0IfyppF3B0ovG74116ksM3eB7OgQdvBh5TV7u59FsD/ZHGM
         efy85cxKkn61POwMm/Z/QBtoFbQae2VQxFNtR6h+BLxS12kvKV7C7L5cg+x5td1TUlkl
         FDrzwjfwWYpuo32dem6AGYHbfhiK9MhuhpzMeLrWUEA1BoKQv3b4Ly93jp/saylIKi5n
         Blhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733957979; x=1734562779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vhGRGkirBXyp8EBWifTH/q8P1dNy28kbRcySFZeUQkY=;
        b=RTnmv/HaltVWhvbANxZt9vAyfLLNO3rAh9b4NfwNaFY3n3KXqAyrVdBR/iYYHL3thp
         WTvh599jojhBW4Q6hRml95XvR15f2uWUaz2kudLK09JZmC/PMLVTFTZqFqMWRArd7Frm
         GxvuncrzvDXeiSGKhwnJbhJJvwZtqNxZ1wEd8oy2H4IbjaGXDnPtiSnw0/EOPiWgEZ4d
         H4y29ZsaiMNDP7A6SasSF7mkct9jKBynr3bLnP8QG9a7aB8Y4OGPRnllL/zsemHO1Z9o
         PEpWj2wpB+EIqthUBoBlLVQWYQRL7CDLbgTN9RcoXKH/wir8DNUB1ADtcgqCe0QDUa4K
         9eFg==
X-Gm-Message-State: AOJu0YyA6hw/3aSLShZWFMQP4/S+xRCmTmHfr/qEuKxxCc8Uqk1q+7et
	4O/QcRuVn9QAHcR+H6V12c3c/0nvXmGl+GyDkUzgPmt+YvXXOWvLQPPMUEy17wY=
X-Gm-Gg: ASbGncsWS2SUsmaGQMhtR1h2Ljz3NS53fj20OSnkv0toae9T715tQ2i/qDSi6HOVNF7
	QPDL+upSHAMoqrbvJfol/CA4mI6uodXXRza9+O3WOLDgzqO6FY4F9TNGPUBkl4Iea7RFUsBkbQJ
	X8oWKGKpfm1ki7hvjR0/+YQ0fnWUClok65ALZq6phz2yQrjmBOCQGcsheZc8ETwyaAnbx+7VCJS
	735o0YJfGjjerQpFLskiuZ3QqmlDnyc05SdzEsGppvofqFLYquoobORe932lFYmO6Rn4HWnq5JF
	C1+z0ESH1iMaliW8sQtDaw+FJYShQv2E8b+q2NRF
X-Google-Smtp-Source: AGHT+IFT9jjCPbfuYFn2CXu9BSood7DWZKNY4Js+xK6j4KAvKUpXxG2yybfpDLAV2n5aq20dVX1cug==
X-Received: by 2002:a17:907:93d1:b0:aa6:9017:eaa5 with SMTP id a640c23a62f3a-aa6b13b138emr342491766b.37.1733957978814;
        Wed, 11 Dec 2024 14:59:38 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aa6749d08efsm641073666b.29.2024.12.11.14.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 14:59:38 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 02/14] multipathd: remove dm_get_info() call from refresh_multipath()
Date: Wed, 11 Dec 2024 23:58:57 +0100
Message-ID: <20241211225909.298770-3-mwilck@suse.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241211225909.298770-1-mwilck@suse.com>
References: <20241211225909.298770-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the map is inaccessible, update_multipath_strings() will fail.
There is no need for the extra call to dm_get_info().

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index fa684e6..4a28fbb 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -503,20 +503,12 @@ remove_maps_and_stop_waiters(struct vectors *vecs)
 
 int refresh_multipath(struct vectors *vecs, struct multipath *mpp)
 {
-	if (dm_get_info(mpp->alias, &mpp->dmi) != DMP_OK) {
-		/* Error accessing table */
-		condlog(2, "%s: cannot access table", mpp->alias);
-		goto out;
-	}
-
 	if (update_multipath_strings(mpp, vecs->pathvec) != DMP_OK) {
-		condlog(0, "%s: failed to setup multipath", mpp->alias);
-		goto out;
+		condlog(0, "%s: failed to read map from kernel", mpp->alias);
+		remove_map_and_stop_waiter(mpp, vecs);
+		return 1;
 	}
 	return 0;
-out:
-	remove_map_and_stop_waiter(mpp, vecs);
-	return 1;
 }
 
 int setup_multipath(struct vectors *vecs, struct multipath *mpp)
-- 
2.47.0

