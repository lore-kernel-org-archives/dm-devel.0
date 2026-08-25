Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EEF44AB76
	for <dm-devel@lists.linux.dev>; Tue, 25 Aug 2026 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787670108; cv=none; b=rlgHRSfe9hr6n6EpjGu8T9A84bjedYH+M437HjntgTMD+MKwRxH5BMHjNBpVZj5Yc2ArIXiJLzDv2V1MB+mG+4HnuWeiE5kBcJn9ANVTOiNHUnxu99p5pLSmQNxRNLOtsDBB2tJJDY1x4RPscrydl2uJ+eqvgGMDnfGIhDao50k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787670108; c=relaxed/simple;
	bh=/z8AutZe+eyH55RPZrglz6Mzt/6YhsFPmlI4cO24qYo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cPvhAB9/pCIkLbNcloXErSkwPzsxt93BS1mGDw5c+VC3yw2uwrO6lCgyImxFQEeXWX2+GaGHqtWG8bFPd7cNI3CFJqe42+0UxhreTb7/CnHdqVhqVvaNfAK6ErQMj9OIpNJ6Qy91B0Ak0yOJmmL1YqnZp+hgqQlQHdEuDPFL4WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NtiZV5Tk; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NtiZV5Tk"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-472326ca506so2553434f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 25 Aug 2026 08:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787670105; x=1788274905; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BIdQrw0hld2dP4JW5OUmLXbKvYVVg0T/24mwah6JdiQ=;
        b=NtiZV5Tkc2+0v6YSCktaBJwkKwofkknAihYHRpTMjfXNAA/Kh70hkUHvLuM0Hv9EA8
         WFrBtn9Aoo7fvrNwm6CWxDtd3Kd8yUsA7eFojAb+xLANfv/GBOaxYhqMcjArsQZkZ3E3
         Q37kiV+HVC4nQ9U17F9F+Npfldm7mEKdMxaI2AuYYTDz7pcvc7JOOzxyUtV266xk+PEz
         xbZgPr6tuhEfveYCEXqhWq+zMLh+np2C4Awpjog9uix92OKtnsFI0dRzKKppu2thHYkG
         fFjoyAARFpmc//Rfda1W3zdzIv2rQxSfzcFyDQUSSt9COm1JIPA3ueKpmSdWkA5tsga+
         SjnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787670105; x=1788274905;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BIdQrw0hld2dP4JW5OUmLXbKvYVVg0T/24mwah6JdiQ=;
        b=WKVPBryn960m7KHlDO9lKIL1FwQtZYspXTOVwwIM5K5oFaFw7h4jTbG9ZSHbMNw3WJ
         2VhQvkBiOjvNsI7f4tWeSkMoDhs/ifbwzZffX9Ns1IScWHqjq2rxjl3RrtGjTEHeCUBm
         8QMsNah63YwOrhQ+o+T3gvxkSyTi67w9wWGe5SeJMqnfBVX4jQtly48vnruLB8LSI5Ed
         IlZfoBPR1qwH6+84mB2yjaThaCDS9US5CecJ6JPY4B6sgAMjbAmA/o3G5fSNvFL+Igdq
         m5MEOvfHGVZ6Lwz9Stu1lEoMdsoVP54HMWPkyheT/uaGh5ateAdWoDxJL3HQ4To/izIK
         rzdA==
X-Gm-Message-State: AFuF++kF3eH/v7vZDoVJFUaTOFwL5TELeyXxMkm/iRdq3GfLvaIIjilE
	vVzEXU3U6pJxVk13OdCpWD/mQrm5Fawhf0ExdzH0w2EJigDSSz1TLIuL4DXwWNYtiSI=
X-Gm-Gg: AR+sD11IKaibvTpzinsLz11vmj3R+kAt9TNs/HewnEgHDrsh5TeapnrhwIKsOt4Rrh1
	5KSY4yK4QJZ6VB7/bzLTWWZw0QrJQ3xrlFGuc2A3ccYajAviSr5mlWa4A41VTssRnuVXyuoxwej
	wQOGVgHwaWv+bO+YZ/1KXmrm1BS39CrjlcjOP9w+15+OUEO6MTSKp9e34mwBId9wUSRKSCKHBdY
	ZM5/lyR+uQH8CvF493dPk0QidZnBfZ2NnjdM71SLNfTQdxug5y/ZSrYVWQTuL9bhjxYsIVdSaY1
	LI/KB9onimJtIFmsZ1CetL/WZELwSIpNzEc/mVFJpMZqtsyzwuGJ3ZB6+inkHhBsw2u9EWw47eB
	H9Noc84JS5Tsm1eutO8CdOS22YwV4+50JBlE5pnjAYoAar0H2nftdSj1HfAvnU7A6SKfy+Sc3ED
	ozR8oUuEAxXcqI0HLeGUoM0qwo4URfRFdDx9kAlxezLxSvqhrffAiTULbZqlpn08lmKE48A1hEh
	5uOfppzuWgLsGwJ9M0P2gPI0ZwGN0I=
X-Received: by 2002:a05:6000:1785:b0:481:98d:b24 with SMTP id ffacd0b85a97d-482c0bb16ffmr42911302f8f.19.1787670104435;
        Tue, 25 Aug 2026 08:01:44 -0700 (PDT)
Received: from MacBookPro.lan ([2001:861:3dd1:ccb0:89f3:b0e7:fffd:b7b1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482df980037sm1360695f8f.20.2026.08.25.08.01.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 08:01:43 -0700 (PDT)
From: Elouan Da Costa Peixoto <elouandacostapeixoto@gmail.com>
To: dm-devel@lists.linux.dev
Cc: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	linux-kernel@vger.kernel.org,
	Elouan Da Costa Peixoto <elouandacostapeixoto@gmail.com>
Subject: [PATCH] Signed-off-by: Elouan Da Costa Peixoto <elouandacostapeixoto@gmail.com>
Date: Tue, 25 Aug 2026 17:01:21 +0200
Message-ID: <20260825150121.84094-1-elouandacostapeixoto@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove unused memset() with superblock_disk uuid field.
The uuid field is not used, so there's no need to set it using memset().
Remove memset() call and FIXME comment
---
 drivers/md/dm-clone-metadata.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/dm-clone-metadata.c b/drivers/md/dm-clone-metadata.c
index e50a5b5a4aea..75ea39d18c12 100644
--- a/drivers/md/dm-clone-metadata.c
+++ b/drivers/md/dm-clone-metadata.c
@@ -300,9 +300,6 @@ static void __prepare_superblock(struct dm_clone_metadata *cmd,
 {
 	sb->flags = cpu_to_le32(0UL);
 
-	/* FIXME: UUID is currently unused */
-	memset(sb->uuid, 0, sizeof(sb->uuid));
-
 	sb->magic = cpu_to_le64(SUPERBLOCK_MAGIC);
 	sb->version = cpu_to_le32(DM_CLONE_MAX_METADATA_VERSION);
 

base-commit: 0a0d1d55dad570724bf8c7ea83409639cfb4be9b
-- 
2.55.0

