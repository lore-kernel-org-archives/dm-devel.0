Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B911B299A83
	for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 07:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755244609; cv=none; b=QuAn1xFgtf8tS7N7CEYT6ZuZwdB9uNpzKAbNswLDM9pHUJMNvqOJmlwo2fUZesmZPtLJFiZbIcpB4TFoou78erBJRm37FIf8EQd+6b6fPdltXqc3JSSJHHkImCdFS6rleqexIwAS+1tkeRhSgz+vnSAmqce2Oj7Z56N4BFcMfUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755244609; c=relaxed/simple;
	bh=oiW7TuWfQe9Z1HQMPOLyGiMF8f38lxC9MCTawN7ptP0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VWKxloOZ2YH2SMNAUQG7pBJZvEfowM6xR/Am2SNy0ysYW0bTg6MAowg0/McQb/7UbVGF4jjaEpRt2h7mzYHt/4rQkHC7MmE4bp/mq9D1MOcU15i3+dUNsMUnzDA2Cbcn7qAsT8tLsWMa1m4pGkZH3k6AlfglpyhjQCeo+3h3TY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NN+8vyhV; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NN+8vyhV"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76e2e8e2d2dso1057007b3a.1
        for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 00:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755244607; x=1755849407; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HMTg+nOkj+dnHJbIiU5pkF76kd2wHW96OO62FUl4QQU=;
        b=NN+8vyhV5my9cHUupJyOSDm2+qcMOFFqyGXPS4a6JBx9YHP/uv/veFj9JmdTdpRBnM
         T9UlFu/mzlQMIvXgqbMt6ftaZHXeDf9nBccDHlCOQH6V4Ic1MiY1JcYU6u0uu1nC1Kig
         CQSbHwTSQdC1f1UEfwOsl6nTTyBL5nzN+exdwQxVJNK5TLzGEu+TJn78fS4WM/tkzCmP
         2UfB5DXQJkNzcSxZAbkKqJeuzgvm26EbXu2pFlVWv064MpLRqnkqtTN0S5Id9tLayfUe
         BF7mod4Bb+GSU4948U1kWOR3IFIGMU+KaQNq6MePoY0atCxbUt3HUiaYGU3qw1u9sT/U
         JiCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755244607; x=1755849407;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HMTg+nOkj+dnHJbIiU5pkF76kd2wHW96OO62FUl4QQU=;
        b=QH4u7XW5cHokRs/jfsrLA6fNgBIYtHsZI1NNl36hBn8rg3TwYQkuyU/OQTp79sIke+
         EO5azvcxyZLvtr9yAVR9GHRag0Cbs+6qMCL1/UyAacB186ODBKgSuL4dJRHyDoZQ6ekR
         T3lBRGAoRMhFE0vJQJ1OyZCmxacB3kVnWS+m4DCqyq38ygsJNfM5QlWMQdDbafA+DwbM
         crZJfXWaYg1yUXT8wXp0ojpcKqfqGZwhpUJdrxDlUY5zhOnPf52aCBMM8REqIhSqT2E4
         XOYFazei6GgzDMaORrvOl8miaUONdHdUpHcZPXumn/KEl5gmr48YHM3TDXgwc2N4TECe
         zzug==
X-Forwarded-Encrypted: i=1; AJvYcCXbfUTfEOT4IQRY3GTQnj3xnsNkykz8U0cVHZr29FnqTb0xNVrvoEm/GaiJXroCPFMsLSlG9VL89w==@lists.linux.dev
X-Gm-Message-State: AOJu0Yxp9xdfL1vl23T8aQQ5cqPQmsuBbgQb2+9EE9tKQ1zgvcX+Vk2X
	mdojts3QdRaybg/A9APmAHh8J3fVrYRC54Ge53cfaiHl6rFiJsroCsPfZhnVX/Ct
X-Gm-Gg: ASbGnctd//eG/PEqeGRD3x4R985d/ID6tPOmcSWvpwUCGaVaQ0NkvkPuj+dtJLS4PdP
	sMOGpUYDUZNUlaqtL8RqCbkltgLWI6bYCxZY5ISjVlTzxV5l0kI7qd23oRWTGEIdQXEkydeZop8
	Nwe/xYDZFpZ3lyrYU5226eRRKs+iu7U9mMyU2nmHAjSTqJEOjEBuxRpoVwRerPc/FpwqCUSs6PO
	1We6p04/OyMUGH8fA9F1c5qUDYeJtyHmMY1+50gqnYtYtWv/0HVrprS33sdfDXlTHBa5WXza1CE
	FwchG0NWZpQZ6NEkNh6DQr0HZiNduelEuBUikDDwPaQirr8DHSq/manUYNtFeGOSuO7/1HT3fZs
	O+xEEEB4OYohk884OY/FhbsY8rBP9eXzU
X-Google-Smtp-Source: AGHT+IFnhmNbusWTe/NOS4pC1bhuI319agqnjyX52xFJvTnt58N0geNwlNtco1oTbthm6m7oN0gKbQ==
X-Received: by 2002:a05:6a00:228c:b0:76e:1f87:222e with SMTP id d2e1a72fcca58-76e446ab211mr1706302b3a.3.1755244607021;
        Fri, 15 Aug 2025 00:56:47 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e452b6b48sm590217b3a.52.2025.08.15.00.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 00:56:46 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 01D924278709; Fri, 15 Aug 2025 14:56:40 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Device Mapper <dm-devel@lists.linux.dev>
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 0/3] Documentation fixes for dm-pcache
Date: Fri, 15 Aug 2025 14:56:13 +0700
Message-ID: <20250815075622.23953-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=763; i=bagasdotme@gmail.com; h=from:subject; bh=oiW7TuWfQe9Z1HQMPOLyGiMF8f38lxC9MCTawN7ptP0=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBnznq83ueyr1ftSQOqt3pKUn/7RbddSDTu/venUPTsnt 33+U50VHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZjI1DSG/6XzBBm9phecKmGf 9GlDXu+5M3dvO9lzcwhP6HJ6czZS/RLDf+87wjdfmXAWc0h8+RPS9FJLi+/6hoOLpkXzlEju5Gz KYgcA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Hi,

Here are docs fixes for dm-pcache as reported in linux-next ([1], [2]).

Enjoy!

[1]: https://lore.kernel.org/linux-next/20250815130543.3112144e@canb.auug.org.au/
[2]: https://lore.kernel.org/linux-next/20250815131115.45518c74@canb.auug.org.au/

Bagas Sanjaya (3):
  dm-pcache: Remove unnecessary line breaks
  dm-pcache: Use bullet list for data_crc constructor argument
  Documentation: device-mapper: Add dm-pcache docs to toctree index

 .../admin-guide/device-mapper/dm-pcache.rst       | 15 ++++-----------
 Documentation/admin-guide/device-mapper/index.rst |  1 +
 2 files changed, 5 insertions(+), 11 deletions(-)


base-commit: 6fb8fbbaf147fe4153177320ee354c457605800a
-- 
An old man doll... just what I always wanted! - Clara

