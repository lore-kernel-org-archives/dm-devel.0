Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549F318EA6;
	Tue, 16 Jan 2024 10:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6avwUiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE80C433C7;
	Tue, 16 Jan 2024 10:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705402165;
	bh=vSOH9esmcWvp40wqyLJndc0hj2pjfVRmigUaCM2qBEQ=;
	h=From:To:Cc:Subject:Date:From;
	b=K6avwUiMVhGJKtdJvbbGZqIGJWzTHNMwgVncV9AAzj1dybdkdwkNOGcFbFBeNG+kh
	 SZ0iLDvddOMJsZ8c6MI8sflsmRw79yQVlovTdYI5dO07IfOIKfQb4lc5msSWgzagcD
	 K94FpPse6JMA5m+JZl7PKfhfmMndQPVxErzEqc1+3wnzQN34fL1B6yxbkSJU3RrWm1
	 nEkVXJuU4QukDfCuDpiNayGUevH5h8Xet2eFCArFxs9RRkjW+uiVt0yxH6wVKvNXHH
	 MthtInwgqWjjrV2DmJvA4/kO8MmbStXBOBbiSLBULX5Wo+fyOj2RY9tLDJx1SLMWdq
	 IDytB0F0lI7bQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	snitzer@kernel.org
Cc: Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Subject: Patch "dm audit: fix Kconfig so DM_AUDIT depends on BLK_DEV_DM" has been added to the 6.6-stable tree
Date: Tue, 16 Jan 2024 05:49:22 -0500
Message-ID: <20240116104922.233249-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm audit: fix Kconfig so DM_AUDIT depends on BLK_DEV_DM

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-audit-fix-kconfig-so-dm_audit-depends-on-blk_dev_.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit abc49bbf199f088919bea1156eabc65e549fa698
Author: Mike Snitzer <snitzer@kernel.org>
Date:   Wed Dec 13 14:46:19 2023 -0500

    dm audit: fix Kconfig so DM_AUDIT depends on BLK_DEV_DM
    
    [ Upstream commit 6849302fdff126997765d16df355b73231f130d4 ]
    
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 2a8b081bce7d..3ff87cb4dc49 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -660,6 +660,7 @@ config DM_ZONED
 
 config DM_AUDIT
 	bool "DM audit events"
+	depends on BLK_DEV_DM
 	depends on AUDIT
 	help
 	  Generate audit events for device-mapper.
