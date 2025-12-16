Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CCB340A76;
	Tue, 16 Dec 2025 23:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765926422; cv=none; b=OsmaHGTe8s/zTdNraNMZxRX1xVvv7xK9sXt+qQXjZRW+Pa61DLb17TnF6+KhlbZ2Oyauk3tYaDyCHIuQYOrlOsn18gepuNpkPg2kyyG42B5C5dP9ky/g/O7DLCGhIwgmEDJhdDbFH1vwpL6ksZsh4jp23kpZcYoXOeo6W7a1WbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765926422; c=relaxed/simple;
	bh=TePe5x8bc2SCbRZ9v/pRAuE0G51ZeD7YUoqCgC3LQ48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbM2HDdtoo/nEtfe5GSahjj2EcTxyo2zJaJEK9eKoK8+smxDZtG9zYqvuPCW4MstkPQ3rpTkviq5FEEBu5E+isHNQIvftaV/vGsXsjGz7YXIWVCjbYwIZYtytM6YEf7p037BZbkCXSM29zEuwkH3hVNk3FPGCzLy2aAgzK5PznI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jf+OSPkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jf+OSPkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E8BC113D0;
	Tue, 16 Dec 2025 23:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765926421;
	bh=TePe5x8bc2SCbRZ9v/pRAuE0G51ZeD7YUoqCgC3LQ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jf+OSPkjYsWOffttmTCaFsgPSvn8S1UkZ0ZTWN7qhrUtFwtsE7KEaJI7He2rO7dpi
	 eVBKwqrGnoDvrAdu6Z8Nov9Dp3GBV6AKUxIYfLWvBvuASgG/qssJnfUWCWdv5DegSU
	 /vJf8SYDq+WBlFrMedeD8drUEiWPwL2Df+aFwCdN+N8tdN8S4emcvALs+Aaufc1TOW
	 X1TrhfpWSp0ulyEtEfzTviJslWaKLLgTBNEKRiawhQ+gWGwXxKAvQ0ixUvrrb6jjhl
	 DuD7sxcvse1MPBERmTRu+K/V579PUKXSewDUbl7l3BkQ2c5lXD5zRMEPG79JvXv1xu
	 IJIK0WuD3cbkA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Eran Messeri <eranm@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7/7] dm-verity: allow REED_SOLOMON to be 'm' if DM_VERITY is 'm'
Date: Tue, 16 Dec 2025 15:06:14 -0800
Message-ID: <20251216230614.51779-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216230614.51779-1-ebiggers@kernel.org>
References: <20251216230614.51779-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The dm-verity kconfig options make the common mistake of selecting a
dependency from a bool "sub-option" rather than the main tristate
option.  This unnecessarily forces the dependency to built-in ('y').

Fix this by moving the selections of REED_SOLOMON and REED_SOLOMON_DEC8
into DM_VERITY, conditional on DM_VERITY_FEC.

This allows REED_SOLOMON to be 'm' if DM_VERITY is 'm'.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 239c1744a926..c58a9a8ea54e 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -547,10 +547,12 @@ config DM_VERITY
 	depends on BLK_DEV_DM
 	select CRYPTO
 	select CRYPTO_HASH
 	select CRYPTO_LIB_SHA256
 	select DM_BUFIO
+	select REED_SOLOMON if DM_VERITY_FEC
+	select REED_SOLOMON_DEC8 if DM_VERITY_FEC
 	help
 	  This device-mapper target creates a read-only device that
 	  transparently validates the data on one underlying device against
 	  a pre-generated tree of cryptographic checksums stored on a second
 	  device.
@@ -596,12 +598,10 @@ config DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
 	  If unsure, say N.
 
 config DM_VERITY_FEC
 	bool "Verity forward error correction support"
 	depends on DM_VERITY
-	select REED_SOLOMON
-	select REED_SOLOMON_DEC8
 	help
 	  Add forward error correction support to dm-verity. This option
 	  makes it possible to use pre-generated error correction data to
 	  recover from corrupted blocks.
 
-- 
2.52.0

