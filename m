Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18AA1799F
	for <dm-devel@lists.linux.dev>; Mon, 28 Jul 2025 08:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753689858; cv=none; b=Q4+UnMP1dJO8TitmcZ4YfhT204SLDw7AOU/hAImXK84MJiiH8AvT5eZOIaDCAgODMr9Pzbnmn/tiwPgRTzLrawTqini9UkpRkmpAjgRYAX2QeS74u8Ix8Y2B0FgMc/mIsFZdjWQs1Z4oGNjdUfQPIdOuA3B0MGS2uBOi60tXeY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753689858; c=relaxed/simple;
	bh=X3FcJGNi1771H+bhzkQh2dupvCAeQOQeCkmxUCNewdY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rY9o8FwWlPnkUekZCFnJDeW/ok1h3vDoOZlGffRXjEc8FIsK6QCu3ZlhUzYcYTpbcRsRSbE0X1MdERohDmiWRVKEKxszehobMGwQD1SHpif3C26nXSsITAWdhcHZ5oMeJ1NFVzD5uJ4lBmnFppBECOTrCGerPoHeunKhz1Vwrws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XztiSSO+; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XztiSSO+"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-456127b9958so1915595e9.3
        for <dm-devel@lists.linux.dev>; Mon, 28 Jul 2025 01:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753689855; x=1754294655; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6Rfl4zoPYgsJxm54cGr0T9gnt9MDwo/H86NN6qM2CEI=;
        b=XztiSSO+3I/Pw16rK0IHs9GMArZkFvyys+vaXCQY25hPcZyeyhTtxrQYDUuMoBiR/k
         yTd7yCm+EKkBTtqrjRiyx6JFwbNAkXgJqdVJAtBpqpS1hi9WPCoUpEnFXNsiwW+gKldD
         FD2H0BqENjxAvw5L/MXv7GtJDlUpXafsXAzkMmuoDhqiVO0m6vqaXmuD2NRcBWLvuQSm
         b95EnmSiWW/dbVY6fvFmZlX32hw1k+mEM76Tjr4xfnyYKHP2/KC7pFqn5bpvaenbgFXj
         DKWB8LfpouEL2iQ9P3rQ9EyuDphDwuanHPNXrUBSdVh0l7vtc0pc0nWqCXHj2KP28Ysh
         QAVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753689855; x=1754294655;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Rfl4zoPYgsJxm54cGr0T9gnt9MDwo/H86NN6qM2CEI=;
        b=BwlALWH2AdkV363cYB9aEtAMYase2VA/JAfAnYt5ko/VSgl/EAEtS8TdeKPm2l8F+k
         D2ybv1diIIDhiQ5kuNFmKuis4dIcoKAcrZKDJuMwUzTw2pQok5ADLcAAiwAJ4axehZGI
         IJDZJmJYQhmtVyuGdHjUcSMJMaA67jNpQY7yeq6bD0a6qmB54uFTore6G9PkSvYlzG3G
         vHsFl2apU8W8Wg+HiAhzeeb/Crxsl82y7Pmhz6Ka5jNs6b+l+jMGyIgQo2SlSNAMlY6u
         h19ZU+TjuznnR2JuUPSuDFZoxD0gCf0dtzr8RL4Uz80DU1oPtJtqD74T3JJ+blaeUUL8
         Yw/g==
X-Forwarded-Encrypted: i=1; AJvYcCXvwMVZJguzZFNFyZnYB05guqaVyyox6Ig+s4mJnBdM6x1qfTjiRTQ65d4HbD8XIu4co67iThCwdA==@lists.linux.dev
X-Gm-Message-State: AOJu0YxgRj2fu4QsxuYk5aZMe9buusfO+Yv8+5lOEZ4/sAhMcYw5TFF7
	PHT/pWH94Kh3JQudY9U4jCW87gjcecDb7KFEymuegeA6YN1R3y5bCSM=
X-Gm-Gg: ASbGncude3qyMxsI6arBmPIO3cGLTtgVPghtc/IVUS7MtqoQAXu6SZxB1ycn2STajAz
	sA/jD6ns8pC93RK9qqkyKnCX5X3QKCIqtgHujaXHIxkt3mYwFzROYpKj6n9MJUHXwQSR8mAfNeJ
	CdS6QmLJcXPjS9X9ZPQyCRwEkerze6tuaYPAkRxR+4CNtNpeXnnH0fnPsOWnVgs3Vobo6H9IBvn
	p5HYcm8fhXJ2Uaj7YZvhNcRLuqb4lda/bq1Dga2XrEQ/tncBJK/ohnYFyNTDzZy81snFJs4FY1I
	/3SJXWV6AXA7IIhjJ5Ccc4wvWTZVPOuax44tVXyJZZTsiZYzUvP0EfwQeEMLOJm1dQ5f5+l1a6d
	65ySaNhJ2VYy/0M0gLnT/zpXUuG90S3gdG3b33rWT8o5rELQ/D1ZxKbOaFzx3hWY=
X-Google-Smtp-Source: AGHT+IHDT/M39U1uzcosoSvrAMxYGTt+l+vTCTQk2giK6Yjl2ZbMgtpTCpz7e9rkH3eXXJaiji7LBA==
X-Received: by 2002:a05:600c:4f06:b0:451:dee4:cd07 with SMTP id 5b1f17b1804b1-4587bf739ecmr22339825e9.0.1753689854737;
        Mon, 28 Jul 2025 01:04:14 -0700 (PDT)
Received: from localhost (222.red-88-5-235.dynamicip.rima-tde.net. [88.5.235.222])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054f338sm142519275e9.13.2025.07.28.01.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 01:04:14 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: fix hwtable comments
Date: Mon, 28 Jul 2025 10:04:11 +0200
Message-ID: <20250728080411.347752-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

- use "VSP" for the whole family, too many variants
- identify Quantum models

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 4ca4245c..a9991865 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -470,7 +470,7 @@ static struct hwentry default_hw[] = {
 	 * Maintainer: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
 	 */
 	{
-		/* USP-V, HUS VM, VSP, VSP G1X00 and VSP GX00 families / HPE XP */
+		/* USP-V, HUS VM, and VSP Series / HPE XP */
 		.vendor        = "(HITACHI|HP|HPE)",
 		.product       = "^OPEN-",
 		.pgpolicy      = GROUP_BY_PRIO,
@@ -1327,7 +1327,7 @@ static struct hwentry default_hw[] = {
 	 * Quantum
 	 */
 	{
-		/* StorNext family */
+		/* StorNext QX/QXS Series */
 		.vendor        = "Quantum",
 		.product       = "(StorNext QX|QXS)",
 		.bl_product    = "cvfsctl",
@@ -1337,7 +1337,7 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 18,
 	},
 	{
-		/* F-Series */
+		/* F/H Series */
 		.vendor        = "QUANTUM",
 		.product       = "^(F|P|H)[24]",
 		.pgpolicy      = GROUP_BY_PRIO,
-- 
2.50.1

