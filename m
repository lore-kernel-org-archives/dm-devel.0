Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF0925B09E
	for <dm-devel@lists.linux.dev>; Tue, 15 Sep 2026 00:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789432758; cv=none; b=dleNlZSK4sbl2JdOiwC2esDbTmN8eHnLxhF5ih7FZRbY0jFiWpJOqzx3Mzgvww6WyHSmFQl2j0lEUJDD+dEWr1NBpltevo2NSK+2YVLwlaHBKR6VS/9vq+b6pH66INbB2okX0aT47LIWaodjHaNjBpqLwhAlKNK0DXs43ZFTS24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789432758; c=relaxed/simple;
	bh=CtgjB2VM/UO02o6L7lZUU881/ia7YlN40IvwkHpiScw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=kSmHWtrnaJbpZnkqXrsSPdGP3qRQi8/eTdO1wXFEG5rQubBSW7pOg/J6SqTbu3l2mmxeTkOR5w6AJba9ZJMNAHxijTaxLBu0+qA493cEKyZhmOXRe1aLMe6OXeeKGS0CkIk/GTN65dUKfNneRRwtubH2vMwLl9eB4/8D+GNpBJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cressey.dev; spf=pass smtp.mailfrom=cressey.dev; dkim=pass (2048-bit key) header.d=cressey.dev header.i=@cressey.dev header.b=ScyL65R8; arc=none smtp.client-ip=91.218.175.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cressey.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cressey.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cressey.dev header.i=@cressey.dev header.b="ScyL65R8"
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=CtgjB2VM/UO02o6L7lZUU881/ia7YlN40IvwkHpiScw=;
 c=simple/simple; d=cressey.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789432754; v=1; x=1790037554;
 b=ScyL65R8PI/lwy1oPB1m6kVBWFjaChxce5FXzvbMKsfmTxujxKAhIv/ZgjbEyv7j1OLu6dV7
 i3LPdliXi+gTXLA3sEylNvPLWXXUddLpO7uHr3zsIv6q6fuyB7FM5VUsloxFNSf+9tXyI3j8y/V
 iBzR/wGy1Gm59rIrPRU5Gds1LMk8ZkE+7d28hvt3LIgdVT6Ib8T39qouyfWPZKq6MMAOZERbC+D
 ByRaw3wduBJNfWUO/f7c3CzzgcfI3Y9sKDiCV12QhKVOxHKTuPFHdEzTxnsv/hT4Y5KxyeLNGlX
 hruADVqDuVbiWqZslYQWyja4RUbpwGy2ucdPb5nuNINRw==
X-Envelope-To: dm-devel@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e9d5aa951aea8613;
	Tue, 15 Sep 2026 00:39:14 +0000
X-Mizu-Trace-ID: e9d5aa951aea8613
X-Migadu-Flow: FLOW_OUT
From: Ben Cressey <ben@cressey.dev>
Date: Tue, 15 Sep 2026 00:39:10 +0000
Subject: [PATCH] dm-crypt: reject the lmk IV mode with AEAD ciphers
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-dm-crypt-lmk-aead-v1-1-7ecae0b33493@cressey.dev>
X-B4-Tracking: v=1; b=H4sIAK2TqGoC/2WNyQ6CMBCGX4XM2QlQU4y+ivHQZZQKtM0UtxDe3
 RaPHr9/XSARO0pwqhZgerrkgs/Q7iowvfI3Qmczg2hE1xxbiXZCw5844zgNqEhZFLTvlCZ5ICk
 h9yLT1b23zfPlx+mh72TmMlQSWiVCzcqbvkhjrE14BR6I6836+4B1/QLEj2epqgAAAA==
X-Change-ID: 20260915-dm-crypt-lmk-aead-2e36abe57e55
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, Milan Broz <gmazyland@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Ben Cressey <ben@cressey.dev>
X-Mailer: b4 0.15.2

A "capi:" table line that pairs an AEAD cipher with the lmk IV mode,
for example "capi:gcm(aes)-lmk" with the integrity:28:aead option,
causes an oops when it is loaded. lmk sets tfms_count to 64, but
crypt_alloc_tfms_aead only allocates one transform, so crypt_setkey
reads past the end of the tfms_aead array and calls crypto_aead_setkey
on the values it finds there.

lmk exists for compatibility with Loop-AES, which uses CBC, so refuse
it with an AEAD cipher rather than allocate 64 AEAD transforms. The
check cannot go in crypt_iv_lmk_ctr with the other lmk checks, because
the IV constructor runs after crypt_set_key.

Fixes: 33d2f09fcb35 ("dm crypt: introduce new format of cipher with "capi:" prefix")
Cc: stable@vger.kernel.org
Signed-off-by: Ben Cressey <ben@cressey.dev>
Assisted-by: LLM
---
To reproduce, with slub_debug=P: dmsetup create x --table "0 <n> crypt
capi:gcm(aes)-lmk <32-byte key> 0 /dev/ram0 0 1 integrity:28:aead".
No integrity profile is needed on the underlying device; crypt_setkey
runs before dm-crypt checks for one.
---
 drivers/md/dm-crypt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9e170de50ad32..0bd22bda3e2de 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2894,8 +2894,13 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 		}
 	}
 
-	if (*ivmode && !strcmp(*ivmode, "lmk"))
+	if (*ivmode && !strcmp(*ivmode, "lmk")) {
+		if (crypt_integrity_aead(cc)) {
+			ti->error = "AEAD transforms not supported for LMK";
+			return -EINVAL;
+		}
 		cc->tfms_count = 64;
+	}
 
 	if (*ivmode && !strcmp(*ivmode, "essiv")) {
 		if (!*ivopts) {

---
base-commit: df2908090cda368b01ff43709f51890076c56157
change-id: 20260915-dm-crypt-lmk-aead-2e36abe57e55

