Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6292250291
	for <dm-devel@lists.linux.dev>; Mon, 13 May 2024 06:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715582898; cv=none; b=KWcJJ9p1uq8oSem5Mw7f7BixogRk7DRkAAk72rbnMgGkoZwCD6968nB2kmwhMF7O0Z8RdfwgcRd7lJ1GpPJsG1t/NpQtfwDqKS+OyWSzpjvMaeIDdbaQYru1EsqhdnuQsBAu6JxyZghyoTEHkT90i5woKpMePjbtDT/0mKbzB0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715582898; c=relaxed/simple;
	bh=g+Txp+V6bBnZ6mNM2ldvG8Bo61JXNkhjI7TrcZpMoR8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l56lsb6BN8CVxDBy4j9GNCxiZozgPljYonYjR0Mn4DRdQb6ffrHyIw4ouWeojXCbWQ/nJIcAwfx5JWgpmbj3qkFf+TbDEzwiCIqJS6dHdB1TrdXesJDx2aNdxKdmMj/pikKASG9rCfTZYFBgGqx/KOuwGVdeqGgJqZ8NF0e54oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eaYs4sOY; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eaYs4sOY"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1ed835f3c3cso35201505ad.3
        for <dm-devel@lists.linux.dev>; Sun, 12 May 2024 23:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715582897; x=1716187697; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WAn1QnCLmKhF79JSYAzXqb2f9rtYvseqh4fzWPBN/xY=;
        b=eaYs4sOYsfLSw/Gd2l0hPsHFLUzArP93CercQLLauyfu8WsO1OYWRqEanvUDpf87QI
         EoXamssWxpaKjW4jVHJ0nUG2g/hj+/VaJly7OQtWvSBpVugFF+4kaviTA1Y8n0Xc43sz
         Ul1BqkFE3PzSmcuFTG3kr1xwuR/9bVnvpS9b9YhB359TKc1j/+hKdvAhi5nAwVZshOkB
         ysjzQQIe92ZcSPseYeFy6Q9k/LY9YgpM78gfOe9p2FNDB3Pb/fqPQQzjzBVlgs5GVrty
         MHu4jgVpox9mHLo+K3YcHeDNiRO7tSS21CC6yvufKOl5NAmdS9OX/mtp0M2NGUsqSQNY
         2A+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715582897; x=1716187697;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WAn1QnCLmKhF79JSYAzXqb2f9rtYvseqh4fzWPBN/xY=;
        b=aNABhoxKXCvdRSv73WuaGrMPpBKR8C+OPxlE2f8a511jp2Gh0OUQJWMIpoh43q4LtE
         aPTYOKqz27ow/ym8N9ooqYlZZjRs6JzDNxmlOLpNOwJHAV4KHCv9JLoT6e88DdM2SbWb
         +/7kR61iHbnRuMJBQJ6azXMOUSBxF/FKIelKf2lIDgeFfzRFlKxQMJrZsSdElq98uSph
         KdEprc9CmTBxAiTY/EvKLAmb021GpRNLIVHXOiPCXFnOr6YeMTE8e6e0G+0VmWluHR58
         BGYsG6pbvs0LG3YxyJwiAy2LC+Xsh3vXV2nsVoUDZqsRR3jv06e/wPwwkN7TnfrUKS4P
         kcgw==
X-Forwarded-Encrypted: i=1; AJvYcCUUWuuVXWCDlVUkXpVX+GBx7jr2KmFyvUmHEOj/ppGpzuyax1K/fCjVFdHBL8Ucjcu50dL37FDwafhCWZJYrPSmc6ME4R8CXko=
X-Gm-Message-State: AOJu0YzsisIxdaGPbWsVHn8JTtJL9zW65XMvyqFB18Ndytw0rLLV/VD9
	7/5Mau8vxZknZrRt5iwwnIU0hM4LG6tilhUGJlm0vTnOoLVIDcHb
X-Google-Smtp-Source: AGHT+IEKlTF/Ld4tfYqam1+K7GJQo14DMMl6bt/fxvXZP7TcBciAH9kQTe1fRn5e3zRlO1WqIYbZYg==
X-Received: by 2002:a17:902:9a4b:b0:1eb:5b59:fab9 with SMTP id d9443c01a7336-1ef4404a1admr97980705ad.53.1715582896474;
        Sun, 12 May 2024 23:48:16 -0700 (PDT)
Received: from jay.. ([140.116.245.228])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0b9d35fcsm73500465ad.25.2024.05.12.23.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 May 2024 23:48:16 -0700 (PDT)
From: "Tse-Chia.Chang" <merqqcury@gmail.com>
To: snitzer@kernel.org
Cc: agk@redhat.com,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Tse-Chia.Chang" <merqqcury@gmail.com>
Subject: [PATCH] md: Reduce flag condition
Date: Mon, 13 May 2024 14:47:00 +0800
Message-Id: <20240513064700.88178-1-merqqcury@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clear DM_COPYD_IGNORE_ERROR will have no effect regardless of whether
it is set in the flags. Therefore, this patch reduces one conditional
check.

Signed-off-by: Tse-Chia.Chang <merqqcury@gmail.com>
---
 drivers/md/dm-kcopyd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 6ea75436a..7a21875b1 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -817,8 +817,7 @@ void dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 	/*
 	 * If we need to write sequentially, errors cannot be ignored.
 	 */
-	if (job->flags & BIT(DM_KCOPYD_WRITE_SEQ) &&
-	    job->flags & BIT(DM_KCOPYD_IGNORE_ERROR))
+	if (job->flags & BIT(DM_KCOPYD_WRITE_SEQ))
 		job->flags &= ~BIT(DM_KCOPYD_IGNORE_ERROR);
 
 	if (from) {
-- 
2.34.1

