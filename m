Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D699519474
	for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 21:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711314801; cv=none; b=m+03AembZ2T8wKd2+8rlNSX4kmxfBtcPAYyCi6DZCZ2PRI/IdwsMFrvVkkTCoxAClQ8NCydmCpvxPhsa6h/E5h874Utbn2HNHV5SQNYpQ6ZqxBmDg3rRDPS/R3vRUCmeUImG1cZ6yK0STov8ICx5xIJX+2fzrrzbjxomLZtuqDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711314801; c=relaxed/simple;
	bh=oIeg36BZGyWFQlb4uvr9FT8zh3xv7QCBjhCha5tE3X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9U4ALndAAPkKBG9fI3iCqsK8HSPn3e/oA851Efrjya2pEl5z/KDVOZyH/6AqtVU5Yfa103N0Bsxc7IMVY2SYJ1/o/rFi3h9GRKasaMrQ9us2ivi/J0MDpKckHvVgbCgAPjYFuTJtOIVe0vr9Q7ps5dE6CrogQvos05mjo70MUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FL28Jt7o; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FL28Jt7o"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-56bc5a3aeb9so4831525a12.3
        for <dm-devel@lists.linux.dev>; Sun, 24 Mar 2024 14:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1711314797; x=1711919597; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+roRKIT+rmyk5lYzFroLZzmLMHajsWjyNJ3YXFmuPY=;
        b=FL28Jt7olY9HuGl8vIlUsKqXgs0oB5fS8LvxksDXc4v0boEaC5gHDf3AK8sfxWSAni
         XC4FWvXC8v4VgTxgVGku+WlObwyc6EPfHJN4zoRXmaB1GIWIDB0B/0wm8vUFkbxPrzKr
         pChXxqArqGPM6kev7omB22KqT3Z6F2z6WcS3QlDfxos4XImGXfE4LXZZ3H5pdXPaN9Jq
         MldRNK37Gt+xP0X6BySR7lH89hCqAjRjsWnKeA1Jzuxe2zS8I+qHC40avzDwACV4YG05
         qRJvj4fWztUGz3h9ds8WZQ97TYykv2XneKR8JEi5FpmEO55BoOhwzdLj8Pp+lLbjzEkS
         izZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711314797; x=1711919597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I+roRKIT+rmyk5lYzFroLZzmLMHajsWjyNJ3YXFmuPY=;
        b=X0D1h8Vala0zOicIk/QRPQdSsQgBtHfKtNZnpTnYVD10Xigdk0UNIK03uR7LKuquOl
         rBJRf1uhqjBw8709KwS5Pxbynn/piDiTEI9w1cWwJzIHYV7kzi2ST3Up/xDYvF8SJB7h
         dnSJdcmuWFbY/uFXI4o6RGgvZFislBF70L/bcHgjugMQaEv4jihSUtTV7EsZMAEcutdd
         1JBsQ8z6hvhN+8rBkNkQ5N6/p1X1Of8V3qA89qenVTXrPKP70XxcusiW9OTkrUf+WqLs
         9Ot5Xepfui4c5duTRcs6WM9ju28BNQe7mJs+tfmVg7xanFAN+/MWhXgJXHmU1sKrHXUm
         Xs9Q==
X-Gm-Message-State: AOJu0YyShhpfXSSVBXxGzFr4fKrIY2jZmKV5wVPksi5qQ/Y3DJcqP/I6
	XMsYIvOAlQjegHPPdFHk2Fw4EHdUzIZgbeyeaGo6uIQR91azIJsTzEYrHOwqwgQpsob/ixxsZa3
	z
X-Google-Smtp-Source: AGHT+IHvRIzIceDg6SlJxFtTEWe9L+76MySyFc7Gj9KPZE0yMLRv5QjVczZnbJRAeGjuuOlBmPXX2A==
X-Received: by 2002:a50:cc97:0:b0:566:2f24:b063 with SMTP id q23-20020a50cc97000000b005662f24b063mr3877208edi.23.1711314797268;
        Sun, 24 Mar 2024 14:13:17 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id h10-20020a0564020e0a00b00568b6f73491sm2266550edh.14.2024.03.24.14.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Mar 2024 14:13:17 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Peter Rajnoha <prajnoha@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 03/11] 11-dm-mpath.rules: don't import ID_FS_VERSION from udev db
Date: Sun, 24 Mar 2024 22:12:53 +0100
Message-ID: <20240324211301.7200-4-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240324211301.7200-1-mwilck@suse.com>
References: <20240324211301.7200-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the same set of properties to import as 13-dm-disk.rules.
ID_FS_VERSION isn't used in any udev rule I am aware of.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules.in | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipath/11-dm-mpath.rules.in b/multipath/11-dm-mpath.rules.in
index 11b5adf..5259b86 100644
--- a/multipath/11-dm-mpath.rules.in
+++ b/multipath/11-dm-mpath.rules.in
@@ -124,7 +124,6 @@ IMPORT{db}="ID_FS_TYPE"
 IMPORT{db}="ID_FS_USAGE"
 IMPORT{db}="ID_FS_UUID_ENC"
 IMPORT{db}="ID_FS_LABEL_ENC"
-IMPORT{db}="ID_FS_VERSION"
 IMPORT{db}="ID_PART_ENTRY_NAME"
 IMPORT{db}="ID_PART_ENTRY_UUID"
 IMPORT{db}="ID_PART_ENTRY_SCHEME"
-- 
2.43.2

