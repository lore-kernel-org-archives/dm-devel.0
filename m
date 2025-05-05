Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B879129953C;
	Mon,  5 May 2025 22:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484993; cv=none; b=mSfEOEM4auN7FqSWnSXvF76GH6MOtGtKL6Oc/jF6+PVJDeHfV3I5PAShUsaXy/VuflLHOMSzoGVlTb+N0ydAuW3cDc2dm1lkwkODCx0YsZIcAMnqe0Q8ztlbdMa5e3y+uNIfz4eeKf0u+7x79/7Vxic5L19GQbBs5vrhcbGvHzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484993; c=relaxed/simple;
	bh=vOhOxXNjw4zpR7UC2IKxXrHebiqELIIMpbbJ0NHfh7Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zg1a0HY0kIl+W/IJUbzIufyy/f9uZukeaeETG/QQ4jrolYWYvfsYeQ4U5a8xTxLDgWwKBEJ/JryYBIWX5GdmNwcmMTDKzamAduupQRUWZxYmVN1fGzlLmYJqgkRitjR9vuanC78+HYrF2fpJCL08BmKfAp1oWx87Qoz3ZFg4Y8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IeFyMQ6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IeFyMQ6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8230C4CEEF;
	Mon,  5 May 2025 22:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484993;
	bh=vOhOxXNjw4zpR7UC2IKxXrHebiqELIIMpbbJ0NHfh7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeFyMQ6ruiiCngjhWbP3vKUYTwkWLX1qIbw0XEQ2Q2ilTDH9Kx5pTNqn4w5EG7800
	 Kgc25LT9cly2qx7gmLl3Af9QgraML3FFhCwp8jBeP1IBaKLYt6+bsKKOP2rRRVaVYz
	 hVP0XhXWvEz/II5NwtFsU9Cu8SG8KtDw1WvUxAg4SDodVIhffYMaKzoOsbfO0kRdwZ
	 go/qWEulu5Sli1v09klGnxOVOshkDUC27ZqzAVC3sxiKITQRgdVtwCa2JgC16rKTz+
	 fbeQ/cy1diU3Xj/q05W/FkwuIihhfBTe1ZRibusTSG2EiejX4C86myUHNcvRrHjHb2
	 ItG/PQbrAFJpQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.12 115/486] dm: restrict dm device size to 2^63-512 bytes
Date: Mon,  5 May 2025 18:33:11 -0400
Message-Id: <20250505223922.2682012-115-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
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
index dbd39b9722b91..337255393b3c4 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -697,6 +697,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
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

