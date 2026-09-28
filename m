Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E737333DEE9
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 06:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576861; cv=none; b=b7fWoFnq43NC9dTxG7DZhFwl3m2naB7YV5OGjh6YoCM6nRXTiNtk4PbxqNuoPqPU0u212BNg/MVSjYiwMGuyePQ9Lf+kBtg2bey/J5xPoW0O5pILF+TNik161GZEq+3haudJzVsxUx6ry9gXRdMO6a3P0cM/VTodFuzPChOds6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576861; c=relaxed/simple;
	bh=H7vUI5mRibD9dC1GWX3NIDs0desuVHCHEezg46LYpv0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ShsmrfCnA8QDwoFEk6kaQJBwnXxVKURZwDYn9zrJ1dR279n+/n+ycu4mVLYBybmEKvmA2tL7r+87QomH95oPlR2gRNlgJ51OPe10Z42d9CCgK8ULPCYmE4j+xt1fY1nrhyjYu01uyNSMByRi3dF22VfTKLxUCdlsWctTsNy6Ugo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=lf4l/lPS; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="lf4l/lPS"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912df756so20634875e9.3
        for <dm-devel@lists.linux.dev>; Sun, 27 Sep 2026 23:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1790576857; x=1791181657; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EGl5xKQgiRxbz7OyVDlPWje0J4ptC6ADyhIXW/2/+qk=;
        b=lf4l/lPSpb5fAThaNrDJn+5GfcdhiOUdFTKxy5PXem111pZi6o4GOeYKnn2yPly1sG
         D2EEAlFSykf4awScsqlVDubwTmctgf4I+rcw4JgL73CktkH7qepJYAQqO/0L7Wt/mbvh
         UXfY+rrU3UdQ+xFFQQn1Svs4fU8k0q2l1Kx3EzLI6eg3TlL9VreixXUQjsJHMgCfhPoC
         MyDFjwZaEnpFNB6L9Tl4sm604QBqqi4J6hlFAfy/WrSYOHQnODOKtj7c6JAbDHXxiay9
         NsxN0KKkd1vM9hW5BUWx1kYZx81yJodyQW6f/SpLnc6GWB1Nz+8kJQLOqgujO4NjZbVn
         0BPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790576857; x=1791181657;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EGl5xKQgiRxbz7OyVDlPWje0J4ptC6ADyhIXW/2/+qk=;
        b=MDP0ELaca3F3UHriRbYzz0L6J8x42cspWQmyUB20W3KOJWIkfd60FOLNDnlwMVvxUk
         32h/CWOAFY1e7/Oljb8B25JidtV9iPiNEzfTO8gdFVkzcwDLBbAfcJ5FamjBRMIBIe3s
         SUaVZQz3c86YkjZocqtyrPkCfFb9Typ+gpp08vYS3Sx9Rh049yU8CqWIXjMHZfBbIvW1
         PYJGX7ZKA9Y17l+JtHvYJKGWc8t7qt6xtAn1Qv2TOHWm0xAS8F3mM8UvbYAqWjsqIJeo
         sJcjClL/uRw4RPbi3pF1GEi7bhGyd2Lr9OnfDFC5XAVuxUMhNVkgWKeQfa7KhnxOVvJP
         U4XQ==
X-Gm-Message-State: AFuF++mtsVMb7vMAXBUVndxQ66p1xGsDpdpV6FkjN/mdFmnSjtfmzfx+
	X/u7kfq/jrgjL1vwEaCWHANDZ0jPFi4nWtOjFy8DNKmHPOoczXOd/Fjo4tzJx/0jyyc=
X-Gm-Gg: AYBFou1LhQ6fQkYem9A3sMvwsLUU3Nx1da4cK18muszt0LnC3u8DMzzriNJ6XEIEnQr
	Gq/NkFaO8K1Uz/Z9RvEE8A0ZF1r4AEzWiLK2nyy6Fi7a06B1kzVgdPZ84LJjYLN0xByYoaOL5xq
	6MVXDfMUysuMWzDffHPe7A6+PLx68aju6+OI+Wq35NM3VTemUcA4c9cPhj36r36GYEp+TPR3Yms
	ZBfk/2pzO5MppI8nXYkMsm+UdCDbCPzuNwccqFoQ6wqBYmkj9oBxLmX1plt/OKXKCjIH8Zqlt/E
	PlI05F5L9GLPtc39dcnQLSq9ImII3+fDFJsoi78LwsaeonDasALu0u7xdeaooiKn64Dnrv5h81s
	cOJa99fRAI2YIGxrEOlcWHnubEqHIrjiMziBUftVnFhgrkpZbU2x0LkqADw8xaBLjmYSKFFPB+h
	rnSunDOMldxuKYqsC/xgDZ3lS/3goiM9gq4Duf0qcSfFvqoUWjxDBqCCA+gVAGgtMIFWvUcUd/G
	zyQOieKsQEPB7F83Hpt
X-Received: by 2002:a05:600c:638f:b0:49c:ffab:551f with SMTP id 5b1f17b1804b1-49fe66d8112mr205843305e9.22.1790576856992;
        Sun, 27 Sep 2026 23:27:36 -0700 (PDT)
Received: from losig.fritz.box ([2a04:9546:1c54:8601:c375:8df8:9c4c:d013])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a007fd1847sm25431615e9.1.2026.09.27.23.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 23:27:36 -0700 (PDT)
From: Lorenz Kofler <lorenz@sigma-star.at>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	upstream+dm@sigma-star.at,
	Lorenz Kofler <lorenz@sigma-star.at>
Subject: [RFC PATCH 0/1] dm-integrity: support keys in the kernel keyring
Date: Mon, 28 Sep 2026 08:27:33 +0200
Message-ID: <20260928062734.3805458-1-lorenz@sigma-star.at>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-integrity currently accepts keys only as hex strings in the table, so
keys that never leave the kernel, such as trusted keys, cannot be used.

This patch adds support for retrieving keys from the kernel keyring
using the same format as dm-crypt:

  :<key_size>:<key_type>:<key_description>

The keyring lookup code is copied from dm-crypt's
crypt_set_keyring_key() and its helpers. I would prefer to share this
code between dm-crypt and dm-integrity rather than duplicate it, but I
am not sure what the best way is. I see only two options:

1. static inline helpers in a drivers/md header, so dm-crypt and
   dm-integrity each compile their own copy
2. a small library module, similar to dm-bufio, so there is one copy
   that follows the value (y/m) of dm-crypt and dm-integrity

Putting the helpers into dm-mod does not work. The helpers use
key_type_encrypted and key_type_trusted, which can be modules. With
e.g., BLK_DEV_DM=y, DM_CRYPT=m and ENCRYPTED_KEYS=m, built-in dm-mod
would reference a module symbol, and vmlinux fails to link.

Please let me know which approach you would prefer, or if there is a
better way to share this code.

Lorenz Kofler (1):
  dm-integrity: support keys in the kernel keyring

 .../device-mapper/dm-integrity.rst            |  25 +++
 drivers/md/Kconfig                            |   2 +
 drivers/md/dm-integrity.c                     | 164 ++++++++++++++++++
 3 files changed, 191 insertions(+)


base-commit: f0100363d8c374bd8e9ea7c9ba02744f0b802ca4
-- 
2.55.0

