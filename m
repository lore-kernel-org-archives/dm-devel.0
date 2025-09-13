Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BE52EB844
	for <dm-devel@lists.linux.dev>; Sat, 13 Sep 2025 13:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757768556; cv=none; b=KXT9pI54hVBnvjTF4X0BvzeHoj4zANOREQ4QbGC5a4uR602HalN3o02yf/15YxPUAvnGhJWAGw/kBEDwYymJalubGvVp1iAnUWOkjJbxgSSqOUFlEJnh06PIRww81gaxSDmw4kPH+XvD/y5hEk6V9u6ZViGhP45AyjUGdR4FVOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757768556; c=relaxed/simple;
	bh=P116aqqJoWYAnLSdPaRpp3dutRj9g30WG/csJk+48mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DF/a0iFSYTyKP4+bVJZjw3oHHFVsCCF6SmlGbl4HDDXEg7gEB3hwtsNX8rTcUet2WICLast8uECIEvxvcfSsM7pcA6r65me1ZRMMtPJ90j72VF4KJLjCXgMIuzHc9E/X6SQvye9QRClUNmFbOnfdcXf2wP2Mw1DIn4T1497jZ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kwgn2UMH; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kwgn2UMH"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3e93c6c4b20so24029f8f.0
        for <dm-devel@lists.linux.dev>; Sat, 13 Sep 2025 06:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757768553; x=1758373353; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJtNkj3n+0hEx4S7vB2ldKSavO/omSjrOzJQ6kYu6O8=;
        b=kwgn2UMH0c9XqGy7D5GsOcdD63XbfBeuCJc+lPEQ/ReOS2n/fg/ZXm+z/Xk9zBEI6u
         8IVSVo01DwLqXNNQ0PRRSfPedbJkKaSgVKExr4UtwO+ptH8UqT1qhJACPRYoI+MYSx9I
         BASxTPNz8U/AjqqHrCC4+wnEGgxyX6Y6Xi/k6MULMCPNYfHOZNbfP1X24UiNyD19C07c
         2X3Zoj+7Ub6CU2hGVEXlvmJcgvtKl9K8g+FtzH9T/ae8aOoASgewCwczBhShHadyFTw9
         aN0yWsYeUeJqX6XczrAo0e5qlhBfJYlQNQugxhRtnGXF7BghnHWIVolQ+M7y2wO5X2TJ
         BsXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757768553; x=1758373353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJtNkj3n+0hEx4S7vB2ldKSavO/omSjrOzJQ6kYu6O8=;
        b=rdPXfGwCe1wumqIbShe8nmfi4qm05fBdY6Bnop/q++sUBGle3/BqTrC/+gAuUcBqxh
         BrZmMf4mSwA6/j38eCKeatTA2V+OcyuqBJyTsD3RPd+0q9+fLoTBlSPjy8mcWjxfIwSR
         elSVHnmpqqmCWQeyyE5DgFH7wtBR1G66mWIstAI9iGgbx4Kl1YUpr7qMcUAkkUQ/IE/4
         LG9H0G6uzC8nY3jJ1+/gmrqhgpQKempEPVq4QITcXuj1c9BjrxWDRC6nj0/HWXp3JhiC
         DYd8fUMEKHOItc16ch5/h/K5u93k5KthMu1kloZvGeggf+DLnckyIYsRS/86Jwf5Xr3w
         4iuA==
X-Forwarded-Encrypted: i=1; AJvYcCWp7iSIvfeyeFStTwHYzOg5unqcRSQ380Wq9v1f1uhKJ5FJicBcM4E7SMpPZejSc5Wh3Wd9oYg9SQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YxWmnlV5MGJYitRzVV9XchNcpMkmzdvvPfWG2eAnYDjX7u8mLvt
	NNUjPE8gm073kg9YT5qjQJNsjP8abo2hcEz4gS8GJ3sUnVfg61bZYz0=
X-Gm-Gg: ASbGnctH4iZbDAZN9g634YzLm00LcFaLnZtmxIC90HjZJsmwxwiA/+2HzmxSQMJwQu/
	RQ9WsI8LCpF9llY9LTErsnYHxXF55bayFg+PGwY+J2fMf1YdCyRm9q8+sQMMZQlHu8VxIodggE4
	JlT+IgunC/nYTs23SfAfoVZG+LI4WL88cbDbhAYbsDITnUxzBMnmI/mn8fdAgy2XEtl7W+rfNzl
	SNpfsxGY+P+m8ePLpww5MMFZe0yMd7zNOjrpvnj0kkS/BBqaB/ymOc7SMfwCxzg0LKge/r0icLa
	tGY0sH6bjCA8M1WO4PY2oRgIAFteimvC0aA0dtOhr2G/Ehvgaaa4s90MrdMj9AbTbHNk54ZpbR9
	ndEvguUvtLBCeF/K/7xE5OaUEIzTOXxucxOvoH7dBnUETm60HR6NEYiNWpQZW
X-Google-Smtp-Source: AGHT+IGpnZp3LkrifXzukmPLTjXFVLDjgWnOHtZClE/A7igVt42aJKYayHkuC/Ik4MVQs4XKc3gbPA==
X-Received: by 2002:a05:6000:2c07:b0:3d9:9347:b303 with SMTP id ffacd0b85a97d-3e76578f484mr2196291f8f.2.1757768552733;
        Sat, 13 Sep 2025 06:02:32 -0700 (PDT)
Received: from localhost (85.red-80-39-42.staticip.rima-tde.net. [80.39.42.85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607878c9sm10281772f8f.26.2025.09.13.06.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 06:02:32 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 4/4] multipath-tools: add VASTData Block Subsystem NVMe to hwtable
Date: Sat, 13 Sep 2025 15:02:16 +0200
Message-ID: <20250913130221.35073-5-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250913130221.35073-1-xose.vazquez@gmail.com>
References: <20250913130221.35073-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index dd3bd30c..2b0f17f5 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1416,6 +1416,15 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = 30,
 		.prio_args     = "exclusive_pref_bit",
 	},
+	/*
+	 * VAST Data
+	 */
+	{
+		// Block Subsystem NVMe
+		.vendor        = "NVME",
+		.product       = "VASTData",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
 	/*
 	 * EOL
 	 */
-- 
2.51.0

