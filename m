Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2A646AECC
	for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 16:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779468284; cv=none; b=N4nD1HB0nD4KanN4dKdHqSnKFt4fmkk7IBo8nVqzzNO3+sxZUQQr20QCl71LdwvYG9K7pAPMsDJ49XggwzCbBdcnhe/ZhNbXXSgiR07Z9GhpjqwaI4LscmREq/TZwqfHkFIrdlwl5dZMRkTKAnnqHDpvGWf0mLfW71618vib3Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779468284; c=relaxed/simple;
	bh=E9nqpJmkFFOE5rXCWDsB4SqaATPEbMYYnK15jZK1JUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPKXlkK78KoB77i3DbDo9tZd+n/I1NgNFJGbIQYnv1BvQRwD+uLZiuw0GukDKWI/sPKzswm+r3KgqV82x7ctyowTk4MrXFs3kpdQ8XIfsOmPta8JuvL/mARABxCKpPgfY71SKaziiswEKViUyzfuNaRlhfD6Rg6v3PBMCXNqpX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dwAf66jC; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dwAf66jC"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-44e5624c053so4657831f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 22 May 2026 09:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779468281; x=1780073081; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wquKeVwk9ztUhB5WlI2KjbtTjjmukvxevZQvcveqCI=;
        b=dwAf66jCGZpLKve4aujQdjGYETZsyFAEq8zSN+yZ9ZDbyTTXkDPpuQ7mZUWLUdHFKs
         JXZ6Bx7JMhCmor3YngBpqBb+6rexHVpwcECSyodf4UqqHrIUvmSE3iYSYHWMZlFFHK9P
         zpdtxiAOahxGIA6nSwxLOykRl5/xvuSNFRkSZKnb3o2JXro/WNmIybYG930XOcU6Nw7F
         Ni4Od4fdvEcKphbFIIc10BMlFcsf3Ik7AAyIptdTba3Ipjcj/8rUid2LQ2lgxo2/JDuP
         jAY5fD+dI5Mg6L8rdo05dZAILdpKc/TkkcH4E9cD9uHPW+f2DKqb/y6JydGKfqC0sVDS
         yt2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779468281; x=1780073081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6wquKeVwk9ztUhB5WlI2KjbtTjjmukvxevZQvcveqCI=;
        b=LTEwHfGJHFocZ9ZguONKcy+ijfvJKlVzWY5StRP35v6f6rsyxEMKxo5+M86cxMyc5M
         quwl1JEZ+5Fh5gH3mAf5graAR3lBw4TMtpIRjsPkJxKKBD5sFQFgBFbu1mSKKuj4NhZ/
         BC+Z6QvqShTg3UvvkB89fFLOd6pQsDWSCl8qXa7rNuT5FAZ50/la/O03EaoXL1dF1oSO
         +7jQSrlmMeml03HgtphxsD6CM0h8wQ3hnFa0rBNlqJ5nGsu9kaN+bT/Ml/I7rMWiyxfA
         D7Rk+KoHinzVntpb2ug62b261ynZ1TdBGTYfmMC5N4xgSX8QzIiLMxNqVtsfVAYQ1uXv
         QmXQ==
X-Forwarded-Encrypted: i=1; AFNElJ99i9Wtas5dyh/1JdDBsdhp+4yziqwf0GKtua+QUN78axTFKpjVI7EYwUqjD0Z3IkHLJRGBh7tQ7A==@lists.linux.dev
X-Gm-Message-State: AOJu0YxzMNmCchaQOPcOW/mSqQsZMEZDx9lo6zQT1HyuzqStsWpGXkLx
	DG/eXEUx5emuJvb065HHeq73a1QH78FLu12HffNDbcw0iUops2hr0KpwhUz2kHP4Xac=
X-Gm-Gg: Acq92OG/V6OM47IyAdYo8cpB2EenpXGFero1svB13rzKfhcKnmggPJiug0B0MjGEzkm
	GtI9PxZ+Yyr+TnvHrpgQf7A3xuCONozTyalSRQ+ZnSooQgh0QXDHxe95QbK8CPRqMyhEMADDcCs
	5mHftRYHOjsuYNdm1hdMG9/MBj733DgTFNV9h7djGG+2urVJZCr7Ap4h0IL5+pChrgD4/i1trEl
	LBn3mDM4mDn2FjJpyGTbYAuFDnkzoi1chLT9ejzO6LjkPLKkAhqMhfDjfUgNBAA4a4S6LQ3+3NX
	WDPF1TAhwJ/6uHLfXufTebNTqbEmXj6IytCFygKHc/JJ9L2ZLs2KfRvr+CV52/IWNX4UhWHoQJ+
	mR5Q4LuyTc7PCFDm0dLVu5QLAMjt2Pdvt0fXFBpqJWXy4XcisDKvDB9LyzUvmBGfB2xx+AWSDOD
	3FUSUzAicffTow5QXFqqfFUTbFPP3InMZ+4GQzq+MfFusVBVp+b585+vVILo8iOluETjDwmMLvN
	3wRRaNjrt5e9Q==
X-Received: by 2002:a05:6000:41d9:b0:45d:4fc0:fe0a with SMTP id ffacd0b85a97d-45eb38a1a59mr5938505f8f.32.1779468281167;
        Fri, 22 May 2026 09:44:41 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45eb6c9f598sm5516576f8f.6.2026.05.22.09.44.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 09:44:40 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Brian Bunker <brian@purestorage.com>,
	dm-devel@lists.linux.dev
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 02/19] libmultipath: checkers: add two generic checker messages
Date: Fri, 22 May 2026 18:43:58 +0200
Message-ID: <20260522164415.846589-3-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522164415.846589-1-mwilck@suse.com>
References: <20260522164415.846589-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add generic messages for "timed out" and "still running".
They will be needed by follow-up patches.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/checkers.c | 2 ++
 libmultipath/checkers.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index bb6ad1e..8a90ade 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -365,6 +365,8 @@ static const char *generic_msg[CHECKER_GENERIC_MSGTABLE_SIZE] = {
 	[CHECKER_MSGID_GHOST] = " reports path is ghost",
 	[CHECKER_MSGID_UNSUPPORTED] = " doesn't support this device",
 	[CHECKER_MSGID_DISCONNECTED] = " no access to this device",
+	[CHECKER_MSGID_TIMEOUT] = " timed out",
+	[CHECKER_MSGID_RUNNING] = " still running",
 };
 
 const char *checker_message(const struct checker *c)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index a969e7d..2317cd1 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -124,6 +124,8 @@ enum {
 	CHECKER_MSGID_GHOST,
 	CHECKER_MSGID_UNSUPPORTED,
 	CHECKER_MSGID_DISCONNECTED,
+	CHECKER_MSGID_TIMEOUT,
+	CHECKER_MSGID_RUNNING,
 	CHECKER_GENERIC_MSGTABLE_SIZE,
 	CHECKER_FIRST_MSGID = 100,   /* lowest msgid for checkers */
 	CHECKER_MSGTABLE_SIZE = 100, /* max msg table size for checkers */
-- 
2.54.0

