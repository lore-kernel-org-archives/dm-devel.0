Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=93.188.205.243
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793870380;
	b=2bUgqmVJMdnPsPNRFTwEvye1UwVSpbsbaXqv5cs/6vS364x+7ZDn6LecXHZ8Bun3c+uB
	 GSE1RpEIIcG6uNkOB5XmLziB75FAxXBkHxrRWXV42+sedNhbAfzFgRB0MwVXFFdGLQP9p
	 Zmiqp+m9TciwS8ieqEFxtEiueIuAtEOAHDceLMZbsA6ng1NbAoKfL3ci+mw7DL6wFZbcD
	 ZvkYfn96SgoAkLr2M6C0RRtCcqrTVK4FAp/ewwR0ozAmQV4YfTPMrXJP/f7v0U4gAhreT
	 /b7L+rmdj2XZOVXPEk8KlFVN3iyDbwshHt5aTe6VinKG4mFnEWUhX6g4AZfjgToS0UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793870380;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-KSMG-AntiPhishing:X-KSMG-AntiSpam-Auth:
	 X-KSMG-AntiSpam-Envelope-From:X-KSMG-AntiSpam-Info:
	 X-KSMG-AntiSpam-Interceptor-Info:X-KSMG-AntiSpam-Lua-Profiles:
	 X-KSMG-AntiSpam-Method:X-KSMG-AntiSpam-Rate:X-KSMG-AntiSpam-Status:
	 X-KSMG-AntiSpam-Version:X-KSMG-AntiVirus:X-KSMG-AntiVirus-Status:
	 X-KSMG-LinksScanning:X-KSMG-Message-Action:X-KSMG-Rule-ID;
	bh=woa/Lo/pD+OHC6mF7/FTcOM9HNtR7yZDJ2YEh+iEG7Q=;
	b=oP5xhZ1OS6K/UQTDbxKzsCTiWtlRE02v0vb3LoCRdMAzJMUiochu79YS6uwi2zh2BcsJ
	 3VrsSyGvIvXwMmxZia4zn0kPWRaQeo5BvNbtlXroHzFBhoaxYjaSOWlpuwXS08p/GabXY
	 PNXRT4s1T2Zb1y/ZBTKlAYmTyytoaxHMVqfZgg1QDf55Q7kAZbngKciTwjp7AHMj3OPHx
	 by+64OUqm0NvzVKHA4WTQQD8vfCrwbuf51fL3YOLWiqxCgPQg4TIH6QOQOGvE63pX9wqD
	 gsnM7PkpccDy7ZdnF5HcVWnwaj62asb1J2aoOHpgFjyRdHCNzeyUYCNQ5ysvs4cDcyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=astralinux.ru;
	spf=pass smtp.mailfrom=astralinux.ru;
	dkim=pass header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=KQTeaWQl;
	arc=none smtp.remote-ip=93.188.205.243
Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46C7606A332
	for <dm-devel@lists.linux.dev>; Thu,  5 Nov 2026 09:19:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C46C7606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=astralinux.ru header.i=@astralinux.ru header.a=rsa-sha256 header.s=mail header.b=KQTeaWQl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1793870368;
	bh=UTXQAGDVCQXDYHLZmlVdJk+MO0ORvqhA0qwsqyZrZKM=;
	h=From:To:Cc:Subject:Date:From;
	b=KQTeaWQlCsVrxNFsFGRbvpsHai4yKJ4Wczkk0hjNXT4OXOr3xTEXdImifVbp5NbSd
	 B33QntsIdl6F5+1AhPWz7WQUKI5aFU71Rh7BMO6yYjvvczj+xDBpGLIprbAvxVebSG
	 MjTBT48hwqxmLWi7Upb9YUe2ftEiLcG61cgzBFHWbILqoFqyYWyY9wCJ5Jf9JbzGaI
	 80NddhFe9evMFQ7hFi47qoIWlHEjmnrgkWrJnQenFl0P5HCs0CSHntkKrGlwOcJ9MD
	 T/XxyQz/T8LIVSD4jjmf3I4H5GAPYGojFWmUN2iwPqC6Ytl0arRi0hlThCpMRAYowu
	 a7XELWWp5myuA==
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id B71241FA28;
	Thu,  5 Nov 2026 12:19:28 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.205.207.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Thu,  5 Nov 2026 12:19:26 +0300 (MSK)
Received: from DESKTOP-D46TNHI (unknown [10.198.31.238])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4jKxb21G5Wz2DQS;
	Thu, 05 Nov 2026 12:19:26 +0300 (MSK)
From: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH 5.10/5.15] dm-verity: fix buffer overflow in FEC calculation
Date: Thu,  5 Nov 2026 12:19:01 +0300
Message-ID: <20261105091903.1866-1-mdmitrichenko@astralinux.ru>
X-Mailer: git-send-email 2.54.0.windows.1
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: mdmitrichenko@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 133 0.3.133 d508d579b02cdb6df47808421a9b9e12fc9fb75b, {date_rfc_vio_soft_silent}, {Tracking_from_domain_doesnt_match_to}, new-mail.astralinux.ru:7.1.1;astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 207251 [Nov 05 2026]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.27
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2026/11/05 07:56:00 #28800192
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Mikulas Patocka <mpatocka@redhat.com>

commit 31d6e6c0ba8d5a7bd59660035a089307100c5e8e upstream.

There's a buffer overflow in dm-verity-fec:

if (neras && *neras <= v->fec->roots)
	fio->erasures[(*neras)++] = i;

This allows *neras to reach roots + 1 (the post-increment pushes it past
roots). This value is then passed as no_eras to decode_rs8(). Inside the
RS decoder (lib/reed_solomon/decode_rs.c:113-121), the erasure locator
polynomial loop writes lambda[j] where j can reach nroots + 1 — one
element past the end of lambda[] (which is sized nroots + 1, valid
indices 0..nroots). The out-of-bounds write lands on syn[0], corrupting
the syndrome buffer.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Cc: stable@vger.kernel.org
Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[mdmitrichenko: Omit the erasures array size cleanup. The older
 implementation already allocates 253 entries, more than the
 maximum of 24 roots.]
Signed-off-by: Mikhail Dmitrichenko <mdmitrichenko@astralinux.ru>
---
Backport fix for CVE-2026-72098.

 drivers/md/dm-verity-fec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 3c027b15476a3..9eb07b820848b 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -256,7 +256,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 				     (unsigned long long)block, PTR_ERR(bbuf));
 
 			/* assume the block is corrupted */
-			if (neras && *neras <= v->fec->roots)
+			if (neras && *neras < v->fec->roots)
 				fio->erasures[(*neras)++] = i;
 
 			continue;
@@ -274,7 +274,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
 			 * skip if we have already found the theoretical
 			 * maximum number (i.e. fec->roots) of erasures
 			 */
-			if (neras && *neras <= v->fec->roots &&
+			if (neras && *neras < v->fec->roots &&
 			    fec_is_erasure(v, io, want_digest, bbuf))
 				fio->erasures[(*neras)++] = i;
 		}
-- 
2.43.0

