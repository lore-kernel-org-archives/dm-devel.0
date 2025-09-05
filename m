Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0AD26B764
	for <dm-devel@lists.linux.dev>; Fri,  5 Sep 2025 21:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757106448; cv=none; b=G85Pjx/09zr0eYiiF6GOh0ZUZ2AZhcBkDhYqptyKBZwHgyeEtcKegtpwfjaLWBT3TZ1+W261m39B0LIviBcOJl0mDTPYyT68SSn6loexnz94Mh2yr80K+utRDCGO83tfoLwpTPZzjs8maxP0ncor5CCioxtFB1+JQBxGNGoTd2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757106448; c=relaxed/simple;
	bh=7FpIJEhXd1T8Sv62bJ9ggO/XO5KCM2ATj++2W8ysdm8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U7KUoUbsheXla+giloz6B/GsPY1LsxcjopF7s5Lw/w6Rx5Whxbv1JdvfdnbVn5fSgunuFArOsvsZx7j4aNcK9OK5MvMYBR3qgHYDVl+rikuPw8umStjVV3MgnY4as/w5Eg0fLU/yQ2zszE4fnKdH6gCB/kmjuFtmZx5jnXEV6k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DjUlsYda; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DjUlsYda"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45b8b25296fso15852595e9.2
        for <dm-devel@lists.linux.dev>; Fri, 05 Sep 2025 14:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757106444; x=1757711244; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yfw9AXDS5Y3NDt/Hd6U+3C/Vl7qbssBCJBXWNmFTpd4=;
        b=DjUlsYdaoGQODQbyofbCI7ef7a7eIMttxWCRSwndiH+7QOJo9SM0fPepT1FIlkSje+
         HDKDi/dX7y8DvxvajDDl1krHy86l6dKIlMiqEpvhS8kklUhM3STPrApEwzLezFngvIoA
         oxihbItbBK8ukARYvOM2vPGepr1O8ZmVlleCPw7daDN9kqtRSmqyitvRtCrtA8FX+KBh
         1otR/q38BeShtlDuQvAnempt+PK8CwvOY3hPhx0tSxx2aQS/mtU9Q4BQnsK7GMGIY+KV
         Yz6M6hjz29qPq+lxvm1ymxsoGVs8GcyUGVLz1h7pKYS9Q2cCNvMzYuKoVnjkWg+iLnn2
         /f4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757106444; x=1757711244;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yfw9AXDS5Y3NDt/Hd6U+3C/Vl7qbssBCJBXWNmFTpd4=;
        b=XN1w9FvGm/O7YU+jYZFjLuPS8guytAhmYdpdy5PfcJ88BtJ9VMc7uunKot+Mr0JsiF
         Fz3HnyQA1BiPWDli9DEH96yLYBZ0y0Gbwnel4erWLCO0oj302der4J0/stVicl6sQLlS
         vR/E/2tLt+gzNd3J0ZtRtwpdeTWlBian3igJ6KFng4hrktaAaeqqGj9rJVePvH1znvaZ
         Y1uncbnTGOAehj5hSmg8uvDaS47l1NdklfcNhCo3RCiM04IMBYcGM7wL/7BDe7AaIRVN
         jbjQI0aP6VI+oKTFuUtQy9vFdTfhilJzMpgrWgTW1M4uyBF1HrK4YoWwvYgLBOl//abB
         2gEA==
X-Forwarded-Encrypted: i=1; AJvYcCWH61APmee59WurlL6CMdNNsdaIhXMfViFSECC5uqG8rOWU4hW3tDJhPK5mCdiNkdUF4+MdEk8t/Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YwntZ0Mpg9TWUOEOSDfYt+ctUkmTJY4Rd8pvM3Dtmc+zoW7mreb
	+vL2v4zyA/ij7TsdVCBPvzjvQBQ6M+0JsEXh77hA4nPXkJINcy5aNf3XWzTxZQtOom4=
X-Gm-Gg: ASbGnctsTPd4/YXXh4yh/Pk8irXLEeDxKYE95F2UO+sPI/WQteDMyYgZHIGOVwvEgBh
	gh9Xk29n9ts8z0eBORJCLWQgZpy7UGhqmOXgW6xWq6Lnq96PIZim0GygQmyWkVx0wvStscRNInY
	CICKBu++4lphdg27/9yt/gmHUtGDx/fc/D7N8vam3GDK9PhxtrEFhbTu5pbFdjO11v3l0e55jce
	rubq1Xlwxpb7IxqnEQmiZgHO/3x8Fk+5zmikv2V8sis8ejfUn4ulJivuF4v91NVMmfd1jGEQVtD
	k3Xq5lqLS6tDT3yxwOav8m2+oP6jhp8Z6qK8yfgZpvUISMftdCxJEvL0kS/WLGCEIW0wGHLHpXP
	Y+XADGzyKwjtclOsJd3g7FpDhFkkOx7MIqIJbb33n80Q4LxuVTOAj3pNV0tgCd1mJbOqBa0u6Pr
	uX5/HNGaREPbU=
X-Google-Smtp-Source: AGHT+IEVhHYvEOgToLUIdtZuwmvJ1c9DndyhCsX70wBTZInsZrDhUino5rj4eFI9WNqKOtaCWdbdOg==
X-Received: by 2002:a05:600c:4e92:b0:45d:dc66:500c with SMTP id 5b1f17b1804b1-45dddec7e90mr2011935e9.19.1757106444233;
        Fri, 05 Sep 2025 14:07:24 -0700 (PDT)
Received: from localhost (p200300f97f1e2d0062fae9454b512ce6.dip0.t-ipconnect.de. [2003:f9:7f1e:2d00:62fa:e945:4b51:2ce6])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45dd0601516sm46992975e9.4.2025.09.05.14.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 14:07:24 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH 0/2] multipath-tools 0.12.0 - late minor fixes
Date: Fri,  5 Sep 2025 23:07:12 +0200
Message-ID: <20250905210714.167202-1-mwilck@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two minor fixes that resulted from a coverity scan.

Martin Wilck (2):
  libmultipath: fix missing return value check in snprint_devices()
  libmultipath/foreign/nvme: fix return value check in get_ctrl_blkdev()

 libmultipath/foreign/nvme.c | 2 +-
 libmultipath/print.c        | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.51.0

