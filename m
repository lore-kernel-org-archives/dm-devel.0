Received: from mta1.migadu.com (out-102.mta1.migadu.com [95.215.58.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638D135C6B8
	for <dm-devel@lists.linux.dev>; Thu, 13 Aug 2026 08:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786608866; cv=none; b=k+/VcRFYE+Cna2mS8pcqf74W73eulBSATMFweEPQweFrrNEEBZ9wR7WJA7temQoO2iro3S4jzZ0/BFGrNwuNoVxuLUMb3OrfKXf3rfgyQWaP/m6BXwXS/2mK6J1iV6FBTBZ4vfm7JoOvFqUPN9iSOcbdVPZP8Z50RHvZ4UVinEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786608866; c=relaxed/simple;
	bh=J0iN+tYQVCf0aL57blCvGcAdLc0zmiT1pHNPtbwINCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sPTx0/JKE05xjrmEll4dhnvJJcAhXXkrpmobmzB14gZuovTkztRC81DkPLaHxhbRaYtIOiouGafTSNrKoY5Kvisyh2mu/qS1rmzMZPJ5OzysTqVSqAvI4mYTihxi0wNsEtxDPcheOpvmmjy/bG327xOldWJMx9MYNOvOvLX9Kek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bcNo3AZm; arc=none smtp.client-ip=95.215.58.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bcNo3AZm"
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=J0iN+tYQVCf0aL57blCvGcAdLc0zmiT1pHNPtbwINCw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786608861; v=1; x=1787213661;
 b=bcNo3AZmXZhRZVnq9NAOI+Fm+WcrDoUqjBccQmLFgbtsTdjBnUski0GbLKmLyigJ49zOd+kJ
 WEhWvxDOJetpeYCLorxW2ZzLmW2f9ExxcG9U2C16stmxJr67qAYZYPcPFA2sl8nUpP0SDwQBvOI
 BzNvGO9U6CGcvXmyx1aVLqE8=
X-Envelope-To: dm-devel@lists.linux.dev
Received: from fedora.fritz.box (62.216.208.217)
	by mta12.migadu.com with ESMTPS id 946b9a59ee4d20ba;
	Thu, 13 Aug 2026 08:14:20 +0000
X-Migadu-Flow: FLOW_OUT
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Mike Snitzer <snitzer@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dm-crypt: Reject malformed raw keys in crypt_set_key()
Date: Thu, 13 Aug 2026 10:13:36 +0200
Message-ID: <20260813081335.40282-3-thorsten.blum@linux.dev>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1268; i=thorsten.blum@linux.dev; h=from:subject; bh=J0iN+tYQVCf0aL57blCvGcAdLc0zmiT1pHNPtbwINCw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFm1Neut5BesnLz+h+i1NRz5b1o8ZyWfC+7aUNf4fMrxx VsTV7mkdJSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEdFsZ/ocxXfHdcdLi5M6N rSm2UY2cyq2B7jnneeYsS//VtGOHijXD/7w73JYPBc5+Y+ues+LUXNaL/cf1GjkeF/91Cb43efl JB1YA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

dm-crypt calculates the raw key size by dividing the hex string length
by two. If the string has an odd number of characters, the key size is
rounded down and hex2bin() only decodes complete byte pairs.

For example, a 33-character raw key string is malformed, but dm-crypt
treats it as a 16-byte key and ignores the last character.

Reject raw key strings whose length does not match the expected number
of hex characters. This restores the trailing character check that was
lost when the open-coded decoder was replaced with hex2bin().

Fixes: e944e03e336f ("dm crypt: replace custom implementation of hex2bin()")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/md/dm-crypt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 608b617fb817..b7aa3d893303 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2615,6 +2615,9 @@ static int crypt_set_key(struct crypt_config *cc, char *key)
 	kfree_sensitive(cc->key_string);
 	cc->key_string = NULL;
 
+	if (cc->key_size && key_string_len != cc->key_size * 2)
+		goto out;
+
 	/* Decode key from its hex representation. */
 	if (cc->key_size && hex2bin(cc->key, key, cc->key_size) < 0)
 		goto out;
