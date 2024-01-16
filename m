Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFC018EB3;
	Tue, 16 Jan 2024 10:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApXV6RZ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139CCC433F1;
	Tue, 16 Jan 2024 10:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705402513;
	bh=PBvNRXcu/41VvHuYAFHUnv/+4yFV2kcd/hK9mVaf/Is=;
	h=From:To:Cc:Subject:Date:From;
	b=ApXV6RZ2oZcNPYavf8QY6R5/i3GYxJFymq9djetC5CMV9aWRhPWIEBUS+Tut3IhZ2
	 nuBVtoG+1J3/Idwu0qA+GrIykAaO54XZYsc8lmiULo0eb6eg/nCySA/vd7+7R0V/Nh
	 W58sN2r+H/VW3rDElt6Pd/tTIV5Rcabfy0W/z7nxB8jMvnFEGhVj1y9WoFEcBYa9ma
	 mvtdRPK/C6IXkQQBfpYlQcXq0O6AnfqXkIAYo+eJWOAtMiQA1YDF1SflQPcxG7oDZ9
	 8ahK2AOGBt56gICvOU7WfrSsVetuWzmwq4gROAD0vediIRISX/1qj9uPti7XBDj71I
	 uKTqCSf1H56Dg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	snitzer@kernel.org
Cc: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Patch "dm audit: fix Kconfig so DM_AUDIT depends on BLK_DEV_DM" has been added to the 6.1-stable tree
Date: Tue, 16 Jan 2024 05:55:10 -0500
Message-ID: <20240116105511.237522-1-sashal@kernel.org>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-audit-fix-kconfig-so-dm_audit-depends-on-blk_dev_.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit a4901842cd2699b969448ec2eb7bad34199a04d5
Author: Mike Snitzer <snitzer@kernel.org>
Date:   Wed Dec 13 14:46:19 2023 -0500

    dm audit: fix Kconfig so DM_AUDIT depends on BLK_DEV_DM
    
    [ Upstream commit 6849302fdff126997765d16df355b73231f130d4 ]
    
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 662d219c39bf..db0e97020256 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -650,6 +650,7 @@ config DM_ZONED
 
 config DM_AUDIT
 	bool "DM audit events"
+	depends on BLK_DEV_DM
 	depends on AUDIT
 	help
 	  Generate audit events for device-mapper.
