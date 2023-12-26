Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CED94CB51;
	Tue, 26 Dec 2023 00:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VcXizfEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51308C433C7;
	Tue, 26 Dec 2023 00:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703550093;
	bh=D7XK7v7jtXA2/XI9KF+CUXl+rUqCWqgp3kQRkq8o2r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcXizfEF31rMlNoDH51JyhaTZ1i7TthQNHv/BsOdfBuQsY3v9hsXshd7qtci7pTuq
	 ohOXR6xtypvypN2MKQgQRHbsWPotcq9vb4GhBOHeINqsiXTxBxk2JwnSaeuFZqVJ4l
	 d91ZuXPiGBmUAtKkWxDJAWUH2CJveiIABkUt5+JAVBOM3djVWJ7jR3xE5CF497/ejc
	 pmvYzb7N3LlYYZ6MBhkCI5g8Wdlphh1DoSOq+RPw5U6g52w+ojjKhu7e8jdkLghiIX
	 bZ2w9gUNzAary6DURYCRw1SDr+iVTdHaavzhH5NaulKoL49HOeznX+nxEK6t1MDkqC
	 hR+O4LYflcvzA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	song@kernel.org,
	agk@redhat.com,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 27/39] dm audit: fix Kconfig so DM_AUDIT depends on BLK_DEV_DM
Date: Mon, 25 Dec 2023 19:19:17 -0500
Message-ID: <20231226002021.4776-27-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231226002021.4776-1-sashal@kernel.org>
References: <20231226002021.4776-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 6849302fdff126997765d16df355b73231f130d4 ]

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 2a8b081bce7dd..3ff87cb4dc494 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -660,6 +660,7 @@ config DM_ZONED
 
 config DM_AUDIT
 	bool "DM audit events"
+	depends on BLK_DEV_DM
 	depends on AUDIT
 	help
 	  Generate audit events for device-mapper.
-- 
2.43.0

