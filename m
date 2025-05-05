Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCE23BAF8C;
	Mon,  5 May 2025 23:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487350; cv=none; b=Ezjt+a9XbCcpW0GmRrJ4WH6xwGdaSLCMwjAZcZemwY6U2AUgjCxiXigwWsB3Gi2tD9IbT3KFcu2E+Q5vj3u92qtsHB5lHXUN8ucp8fAQ5Gbk2ig6NOUcuQzP7DUBhTKsz4dDXJq5O3l8B6osj46rinqqFQQr/COzPgPzIcV8LsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487350; c=relaxed/simple;
	bh=nanbNKYj96vcUJn2A0Z613RcwVYZefRqfujfXtzf3x8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GTP5S+p8jS76qhru3GEJOdQwuSpI4RNbtaV0vE0vomyoHxETyaK/Hx/TwUQT3HeE/+FZx9TXtgLgc6kqoPgB9mqj3zGoHIYGDoppSi56yA1q34CUWCV5brY4qdv6dvI5QkMYFOo2i57BFCB+Vhl6JH49ls6adi6UZYgAxFy8shc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D9u8T5S3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D9u8T5S3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88FCC4CEF1;
	Mon,  5 May 2025 23:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746487349;
	bh=nanbNKYj96vcUJn2A0Z613RcwVYZefRqfujfXtzf3x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D9u8T5S3bPXIl3DvazkazJRkxwbcu96333XeNbkXVGKU3jNAJwfx7tZW+XTcJHXpn
	 VEaVJhiRzG4j4kjaUTFoXXSKNHH7FQyCCmUsXZyRkSj13WQw73Pk4EIhQLi32x9LgV
	 QG/PN8cP1cqNThzC2rRhiO5apgahKJcFYmds679LReMuzkPEt7Jv7xpyNhrQAwz26u
	 BEuO3r8PxN7YafHE7bYS6cyGpt6iKtvgU2BWGdJaJDxk3xieP0a1GUYZlSg0BnaheN
	 QzsNdDOT3vvMhVeNNYfJH/WcvoTkIOmpkxte8tkB5R8aUIC3SIZhpWDeGeNHX+sd/R
	 9RXxJVfzUn+2g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 5.4 22/79] dm: restrict dm device size to 2^63-512 bytes
Date: Mon,  5 May 2025 19:20:54 -0400
Message-Id: <20250505232151.2698893-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505232151.2698893-1-sashal@kernel.org>
References: <20250505232151.2698893-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 45fc728515c14f53f6205789de5bfd72a95af3b8 ]

The devices with size >= 2^63 bytes can't be used reliably by userspace
because the type off_t is a signed 64-bit integer.

Therefore, we limit the maximum size of a device mapper device to
2^63-512 bytes.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index fcb9e2775f78a..5b0d45d92e654 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -741,6 +741,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		DMERR("%s: zero-length target", dm_device_name(t->md));
 		return -EINVAL;
 	}
+	if (start + len < start || start + len > LLONG_MAX >> SECTOR_SHIFT) {
+		DMERR("%s: too large device", dm_device_name(t->md));
+		return -EINVAL;
+	}
 
 	tgt->type = dm_get_target_type(type);
 	if (!tgt->type) {
-- 
2.39.5

