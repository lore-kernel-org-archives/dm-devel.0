Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7197013B58A;
	Sun, 11 Jan 2026 21:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768167546; cv=none; b=VlqR0aKXFJEuhI14Xdc4BZiYqeXsTe7oyCXXRdhCO0yX/TYREybf8xoioC7ZfPlEXwtqLOl7YQi5fhFrFgbhS8azl8II/96wyPJ1MBxnG4Np3Iiv8FRMM6im3u4po7I0zcuTjdPRKhAYx1wP/gc0PFHCj+xHS+VtdECIr0iLeN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768167546; c=relaxed/simple;
	bh=sKPQ2a2R4mmADvLRBV220wKlB0vPViIc33+txu11jdI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mw4D/2X/45QRosdRE3dCaaPpFbf0vBpTKxWtkDR/KNx2liKqppJ91tyRpcJtDcH7LNhw/NrBikwTzUPrVMPwuEI25RUPkp1rXvkmAAt/Mc2Qwid4Oi2K2WgK6E3ClKtlIZx98119yUe5TxM6b6zIQLh45ggIxiX94rCBHGo8jWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DJBPWLoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DJBPWLoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2F1C4CEF7;
	Sun, 11 Jan 2026 21:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768167546;
	bh=sKPQ2a2R4mmADvLRBV220wKlB0vPViIc33+txu11jdI=;
	h=From:To:Cc:Subject:Date:From;
	b=DJBPWLoMz/CpuSqMchjOCpVQ2CfQ/NQr7QBgCqPBoFN2CW5C6sF2OT9PxHh3OGgPR
	 m9ty+46kPd4znlc8Lwv5zRVCuQeCZQiOf0XlTAud834nAqFDhTVBWFdKhRkW5+C3LE
	 vKHAD0MsHtRuqnwdJDSyxu5QkpQOczhlTObEiQinyOSGJfAR2OQalGwbL3csG+THjg
	 XYeIbTyqxKEw0vU/wXTdghkyvyfE5bzpYbGWP0X8LBg4poIgraaBD8chKNFsCIEBFM
	 TT4Ro9wcUKq6cCnW1WXpwNN6qb7aNQ4hHUWXQr3iqpJB/iAogR0iCqtpUymYO8akLP
	 manbNmhYAgOJg==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] Optimize dm-bufio cache lookups
Date: Sun, 11 Jan 2026 13:38:19 -0800
Message-ID: <20260111213821.94895-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series updates dm-bufio to avoid redundant work when looking up
buffers in its cache.

Eric Biggers (2):
  dm-bufio: merge cache_put() into cache_put_and_wake()
  dm-bufio: avoid redundant buffer_tree lookups

 drivers/md/dm-bufio.c | 170 ++++++++++++++++++++++++------------------
 1 file changed, 97 insertions(+), 73 deletions(-)


base-commit: 8fbb8fe75d4cf92eaa7b21828ec39c1bf79a262f
-- 
2.52.0

