Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689F933B6F9;
	Fri, 19 Dec 2025 19:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766172743; cv=none; b=eRzqf4bxBsSZXckg2AbqkleRzzRPsyBIuPx+X8SeN021TTpLRhKUhFqvx3OUE4/myOhFY5rC5aTkykRquO0Lw/7g8U8VC45Judegf7L+L3k3sAOWj5GeAekjfB9HfBtmu22ruxEupFgtbzemzUsIiUbczijNUhhsG7lxRgj2aUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766172743; c=relaxed/simple;
	bh=IJehVVJZ76CUbe3T7t0EQZ6LBqx+1Md312+l+dSi2Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNrYAfSoyr5DiXoTcjH/Vd9JTlO6tr1h9Ikeipz3MYIhvBuY23qRqPNAq30SVNsrvnhJnXOdtstPFaULFVD0D5LUm0VqFpxapXyEotbcK0cUvIX5gvc4X9eJzG7XfssRDW4Gcdqhaug3d1ojSFCy3ZeD7UvqrClQorLaRD5ICgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PYX+mrKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PYX+mrKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2B77C116B1;
	Fri, 19 Dec 2025 19:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766172743;
	bh=IJehVVJZ76CUbe3T7t0EQZ6LBqx+1Md312+l+dSi2Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYX+mrKpjfyfqmwnwV8PM7el5jCS8SfZeIy+cBVpq+hFpUtvms32bShqr905dZTtc
	 TP9WCpOO29hWfrkqsCV42p5Q2BAUZOcOUqO0zTchVyWgB/9T4NY627HjH3J1smq582
	 XCOkFOhjkdFK1ohwZLRd0HjkAjMZM9/7JeCVuViuLsN2mXiZWJe74nHiZUgkBDTZQb
	 BEzZuEz3Z4gYX64X+3wpiwOibIwQOmKtSTORydlurKXddjAvs9ceklBDu1CLhd+1Pu
	 59I/mBGf1oZMUnZOepNYSoDQkx0LHG2YkjNefQiyOJ3mfMQgAExaItm/wLSvuI/enk
	 fPtAfqYJJtdUw==
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
Subject: [PATCH v2 7/7] dm-verity: allow REED_SOLOMON to be 'm' if DM_VERITY is 'm'
Date: Fri, 19 Dec 2025 11:29:09 -0800
Message-ID: <20251219192909.385494-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219192909.385494-1-ebiggers@kernel.org>
References: <20251219192909.385494-1-ebiggers@kernel.org>
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

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
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

