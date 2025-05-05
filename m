Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06C62ECFCF;
	Mon,  5 May 2025 23:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746486491; cv=none; b=DaiRvkJs20tdIzWHCqT7/9kl9LdawjMWri0/oXd2Mv6Myxe8nk8icxCOOi82tsT0pOYtBkl/+cPDjm9KGx3TCF16oDimXysYA+YTH+Of9GaDhYm+wWnoa/u54QZJuXraMpNrh1U0XIGLPmOe0QR5j1e0cy9fWJ+XSZ7ZYmPtllA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746486491; c=relaxed/simple;
	bh=gYgC3uqARkx9Ycx1hG7wwHOFQuipsFmYjvt9NBeP2og=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=u2oFz3oHs7dxhiIx1EGDvXXQIQb8NnqwKKDe8mVLMQ4AvJTxtM/7YGEfb3t2s6yahuT9sZPo9/oC91pdMTiS1xAZiFfZfz05u5CaoL3m/MAZ5hBPnabnFlMwdt3Ncgk2wlr8GAWPfRv4AwRsE9/+7wOPIFm9zlcrIDMX8OaFeBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHJ0NrYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHJ0NrYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7A0C4CEED;
	Mon,  5 May 2025 23:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746486489;
	bh=gYgC3uqARkx9Ycx1hG7wwHOFQuipsFmYjvt9NBeP2og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hHJ0NrYNi0+e2TsMjZRSI/VaYLxP/k7VxV6BltnnegHFgiMMM2gq5FwR7dC27sKwI
	 xnCIfsQ1zAw0FlxE/R3qqzthGqdmTGl1HAKEg0IistKbVdQO7yfLPXqcxUNH3da+qa
	 vkryKIuq5RM0Paa2KXPKj6sdQVNKWElbf4wwmNCC78YtC7GztBax0QabuSzYV80Hx9
	 ZbeRXW5+2MljD4aVTdRUha4S59I5y/VJEaxTdBGiYNt5Py8S7LWjHB/Ud3gOgeEjxD
	 gX5+I2LDqgNOQj5C60TvGaFLKUkeEcccvLNV2qfPQpFqxMne8Uof2K2VA1V7o9UuQq
	 9kVJ/rq2Hp0ZA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.1 057/212] dm: restrict dm device size to 2^63-512 bytes
Date: Mon,  5 May 2025 19:03:49 -0400
Message-Id: <20250505230624.2692522-57-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505230624.2692522-1-sashal@kernel.org>
References: <20250505230624.2692522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.136
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
index aabb2435070b8..9e3f8c737c487 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -670,6 +670,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 		DMERR("%s: zero-length target", dm_device_name(t->md));
 		return -EINVAL;
 	}
+	if (start + len < start || start + len > LLONG_MAX >> SECTOR_SHIFT) {
+		DMERR("%s: too large device", dm_device_name(t->md));
+		return -EINVAL;
+	}
 
 	ti->type = dm_get_target_type(type);
 	if (!ti->type) {
-- 
2.39.5

