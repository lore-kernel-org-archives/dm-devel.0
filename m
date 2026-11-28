Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795845256;
	b=wsZn5nVb/DKX9yrwqEvMIxqjczPdjDJKBZG/JHQUh6vpxh7kAxDRhU2DhenUvUwBWa1Z
	 rUeVRjgYlX7HhiFgWKWvZTrz1eqeOlLdMmNFclD1pa8aGv5jvWUhEwGQAUi0LCuLFE8Hs
	 fLlU1b09/gQpAlpEWthF8ZIV3PKpbV3PLCEvUfYROJaRezJoSsl9vvO2/Z4eo1/Maqs3d
	 vsaU5z7t/JufhxzWMwptDi9i1Mmn+UtVyO2ucknFqcJKrddVhVbVg/sbZJNmrZTy/3EEO
	 99UA9T0NtQx9wv+nv3YhcfizY3lcReiSeX9G1GAV/VkA2cZgrq/m0PHUu4yeEv6Z4bQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795845256;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=X9FBltTUwff2tPanCPPyIupEKHVxJvg55atPtDXrasI=;
	b=YkmnQh/sCClgAoFqgc4gYW3TTLJK3m78sYO9xZn+MUppb7W6kh8wAbUKK0VDRT7cJ3nE
	 yG6hJ6W9WpaChRPSNb/xM0xHZiAaq+qZYNxH8D1qb5fWmWOlFQgyyAoZYHbd5EShCyXBf
	 3YOeJLx1QDoXUrwwMrScBqaTiKxILg+HJY4bJ8NhQMJ0SdiB1wpI1bC2q6THf9v0oLQws
	 Go+cgljZEJjrH0Ut5rivX9M1gvC9wiNq/QRhExjdWpeMf+58ZkgU5bWmO32s/5nzw+oPf
	 XuKN828t9fexhpEBZyIn5jwmWW9N6c8BTfU2gFGcBGSGgCz4YtnV1EjIp0UejFPBEEQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=izPuJxh1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2ED606A31C;
	Sat, 28 Nov 2026 05:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=izPuJxh1
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795845255;
	b=18z3b0DvInRal4Gg24nULKEFl5QQFbqOc3Sl2tnGMu3J3py3l/kEjmJpoNSqP31/WYGb
	 Uurk9fgJ1/ovam/6ghbEB5l1NNr0T/Mae6+bC5fT0G9Otv7zVs3ZI/+0oqi5zAqluu/Oc
	 5cq5Ptbq+LlehJMVspnK3tugwViBPDuNAqIQc25O9YWgFd0zDVH/zQSEOiOGGC0tSU3r9
	 56LNrD4dO/W30GLHjUF4ELCrDFSnzvpCkRIWsOi4j1Tadwl0kS8aLMIy609FX3A6pFbXe
	 /1tnERUWcKzCKUQRq6O+z43UUELbs+tsGdDEsreyD2ZAcVzn8vGs5WHhzBbal1YMNBA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795845255;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=X9FBltTUwff2tPanCPPyIupEKHVxJvg55atPtDXrasI=;
	b=jlcnbEVMvQ48Jrd5r4cxjAThgpEyQCFbF/G4bMZYzs0RXtCZQuelxhObm0fiPu+fMQyB
	 h1jwDrE8gnrP7itERwf8zJNMLcd6vV8ID5Pqq6Y4S5v2/vKe+B/yA+Eyx+ByKgZvHOl85
	 xOkgzeUx4PjPDdh//QZIc61bmt0n4UncfIZaQM5S2FO1W698upF8C4AcyMsjiLplC6+t3
	 IbrvTSl9O5p/XS9lXpKAM1ImuKRZrIOcA4g6np2DYkpyKm+4C1bhTmukt8eNx947ncGXN
	 0AwaTg528/j02XJdQJQXtP95jYm7dlx6WSa6zgI2NFszgeP62bKjNSFB7iwQlJ49uQQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C94381F00897;
	Sat, 28 Nov 2026 05:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795845255;
	bh=X9FBltTUwff2tPanCPPyIupEKHVxJvg55atPtDXrasI=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=izPuJxh1MaLIgx1C4/tN3BVA7yWtTKH8UoanafEeuf2frCIzE5NacJNsEV4bDjWjg
	 1wInhK3p24NSRDjg5mbDNF7vQTZB4kh4cR9wx33ta1tfnztt6rGpzsBO5EYvd6bF3C
	 qnRUlgNu4hvwBBqoS8CPQjZ+IvYNEsHq1JqwMSyEj03nc5burDKd3+wH9sfja1xgLS
	 ink6ULr3ua02WzHpv3NrwDIU2LOkJ2n3Ssu3BnxUp22qlRoHTGIDKn8n9kHklnBj9/
	 Zjg77/vK62dDaYUZYp+vCl0yvkrwnUU6wLI3BODhHbMtdwSUNRs59HX3R9xEGjnYrx
	 h7bZ3K5PR7QMw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2AC9A4DFD5;
	Sat, 28 Nov 2026 05:54:13 +0000 (UTC)
From: Wesley Atwell via B4 Relay <devnull+atwellwea.gmail.com@kernel.org>
Date: Fri, 27 Nov 2026 22:54:01 -0700
Subject: [PATCH] dm crypt: reject an integrity option without a profile
 delimiter
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261127-dmcrypt-integrity-option-v1-1-1dc42a7be52a@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/x3MSwrDIBAA0KvIrJ0SpcTGq5Qu/EySWcTIKKUh5
 O6lfQd4JzQSpgZenSD05sZ7Aa+MVpDWUBZCzuAV2MGOxliHeUty1I5cOi3C/cC9dt4LjpM1NA0
 uPswMWkEVmvnzr58vrSCGRhgllLT+wryhu93hur62wNd9gwAAAA==
X-Change-ID: 20261127-dmcrypt-integrity-option-6921e907b81f
To: Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Benjamin Marzinski <bmarzins@redhat.com>, 
 Alasdair Kergon <agk@redhat.com>, dm-devel@lists.linux.dev
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795845253; l=2162;
 i=atwellwea@gmail.com; s=20261127; h=from:subject:message-id;
 bh=J18/+zV/EaKtI4zWNPjGJ/UhgvJdrouclOkKfrVrgS4=;
 b=EdAgMGbBdCBC9RcaOp+gp4JM/8IxlumfnV53toaLD0yaxXzg1+jnUyTRvD4oy6tSimKydxswq
 PWlj3WJUpnQDPaCyriN78LxRp/lHPp5+NWaWTLaO43UbQ4j4ouPJySq
X-Developer-Key: i=atwellwea@gmail.com; a=ed25519;
 pk=Buny5Y3000rYoA3OYcxvjG5W3dpuSWh28lf8IVDjANo=
X-Endpoint-Received: by B4 Relay for atwellwea@gmail.com/20261127 with
 auth_id=1671
X-Original-From: Wesley Atwell <atwellwea@gmail.com>
Reply-To: atwellwea@gmail.com
Content-Transfer-Encoding: 7bit

From: Wesley Atwell <atwellwea@gmail.com>

An administrator creating an authenticated encrypted mapping with
dmsetup can omit the second colon from integrity:<bytes>:<type>. The
existing sscanf() conversion still reports one successful assignment
for integrity:16. The following strchr() then returns NULL; advancing
that pointer and passing it to strcasecmp() causes a kernel Oops and
kills dmsetup instead of rejecting the table.

Check for the required delimiter before advancing to the profile. Return
-EINVAL with the existing invalid-integrity error when it is absent.
Valid aead and none profiles continue to load normally.

OpenAI Codex identified the unchecked parser path during source review,
helped prepare the dmsetup/KVM reproducer, and proposed the guard.
Fedora dmsetup reproduced the Oops on the unmodified dm-7.4 tree. After
the change, a fully initialized dm-integrity and dm-crypt stack
completed read/write I/O, while integrity:16 returned -EINVAL without
an Oops.

Fixes: ef43aa38063a ("dm crypt: add cryptographic data integrity protection (authenticated encryption)")
Cc: stable@vger.kernel.org
Signed-off-by: Wesley Atwell <atwellwea@gmail.com>
---
 drivers/md/dm-crypt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 02038a9cd..8deba9d43 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3145,8 +3145,13 @@ static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **ar
 				ti->error = "Invalid integrity arguments";
 				return -EINVAL;
 			}
+			sval = strchr(opt_string + strlen("integrity:"), ':');
+			if (!sval) {
+				ti->error = "Invalid integrity arguments";
+				return -EINVAL;
+			}
+			sval++;
 			cc->used_tag_size = val;
-			sval = strchr(opt_string + strlen("integrity:"), ':') + 1;
 			if (!strcasecmp(sval, "aead")) {
 				set_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags);
 			} else if (strcasecmp(sval, "none")) {

---
base-commit: e92cd41e8e5ee5616c6c7cd4378661d942f0a7c0
change-id: 20261127-dmcrypt-integrity-option-6921e907b81f

Best regards,
-- 
Wesley Atwell <atwellwea@gmail.com>


