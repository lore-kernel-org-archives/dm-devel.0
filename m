Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2221369997;
	Fri, 16 Oct 2026 21:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792187649; cv=none; b=SJMLE4BQjyw2sVSlgy6OkmFssrBS5CC4JUoWNtBSDpTbM4DGcGCfCPX++T6V1MurCKoO+x5yhIJ0d666mzb2B/nvJbLJZBSxS+1ou2wNi1ZVZvKuMShteM6/ADeU91Om6cLW69YdcIOaK6+CVP5+AzwIkB5Kuy4YJweLzF6roLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792187649; c=relaxed/simple;
	bh=ZWM0sMHH8wKCZK3iuYqtS4+tjmbExVll3Zlm0HAqbFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoY+thC9PH15mHSP1ckMLknJZHj4/jigXBDL3/qpk3etc5tmiTDaAnbvD9LtTyOrAc7WN+kLtso1A4IT9T/OrrFhodUn6o82hGLrXXOOSvPASSHKJCTuzWdWGnLC+TRwsY5oBnUVBHe68wFaQkEDATgIGqnVhhv95L8guap7O9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7x35s3S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7x35s3S"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DFA4F1F000C5;
	Fri, 16 Oct 2026 21:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792187648;
	bh=YrzgZm1IM3e48u8hZMm1oRsSxJM6fwWMAcAQ5sfnEQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7x35s3S8/J0gSwHp+bXSXmf5l0QYXJnj4e5Q7hwDj2GQzVSnjGSYK+69w9r+SsEl
	 M7IMqCv3vLB9dfVEqIrWWAVxgBGrLZHP0FgA/xlost8UYny+SQlobRKx/6EW4CZHL7
	 XjEP+i//gjC7gTZe6F8Xd5noK6QhpQnddTYPCD3Fqp8TPaseJ//DCV/1kIEuWHSe8J
	 fTgyw6oEm0P4Avy1box+vAoravVaIpUJRFmtXa7radifnDKT1pfmv93+SZwfh9bE/2
	 xu2wjctkK3hIyHhEYbxTETOgtiowK1JnHgtQyDuc9/rj2+OK4Y3dbGLqMWEX54kXhQ
	 /fztsYip/TK3w==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list),
	fsverity@lists.linux.dev (open list:FSVERITY: READ-ONLY FILE-BASED AUTHENTICITY PRO...),
	linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM),
	linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [RFC PATCH 4/6] keys: Add keyring_is_empty() for {fs,dm}-verity
Date: Sat, 17 Oct 2026 00:53:02 +0300
Message-ID: <20261016215326.4110064-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261016215326.4110064-1-jarkko@kernel.org>
References: <20261016215326.4110064-1-jarkko@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity and dm-verity read assoc_array's nr_leaves_on_tree directly to
check whether a keyring is empty.

Add keyring_is_empty() and use it in the both callers.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/md/dm-verity-verify-sig.c                      |  2 +-
 fs/verity/signature.c                                  |  2 +-
 include/linux/key.h                                    |  1 +
 security/keys/keyring.c                                | 10 ++++++++++
 .../selftests/dm-verity/test-dm-verity-keyring.sh      |  2 +-
 5 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index b2b55c41e2cb..2ccb71bfb3ca 100644
--- a/drivers/md/dm-verity-verify-sig.c
+++ b/drivers/md/dm-verity-verify-sig.c
@@ -153,7 +153,7 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
 	if (ret != -ENOKEY && ret != -EKEYREJECTED)
 		return ret;
 
-	if (dm_verity_keyring->keys.nr_leaves_on_tree &&
+	if (!keyring_is_empty(dm_verity_keyring) &&
 	    dm_verity_keyring->restrict_link)
 		ret = verify_pkcs7_signature(root_hash, root_hash_len,
 					     sig_data, sig_len,
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 0302a4e506ec..890d33b9d812 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -67,7 +67,7 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 		return 0;
 	}
 
-	if (fsverity_keyring->keys.nr_leaves_on_tree == 0) {
+	if (keyring_is_empty(fsverity_keyring)) {
 		/*
 		 * The ".fs-verity" keyring is empty, due to builtin signatures
 		 * being supported by the kernel but not actually being used.
diff --git a/include/linux/key.h b/include/linux/key.h
index 26139c3adf62..d82253b06c54 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -436,6 +436,7 @@ extern int restrict_link_reject(struct key *keyring,
 				struct key *restriction_key);
 
 extern int keyring_clear(struct key *keyring);
+bool keyring_is_empty(const struct key *keyring);
 
 extern key_ref_t keyring_search(key_ref_t keyring,
 				struct key_type *type,
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 9ccce0db0665..613d1db41611 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -443,6 +443,16 @@ static void keyring_destroy(struct key *keyring)
 	assoc_array_destroy(&keyring->keys, &keyring_assoc_array_ops);
 }
 
+/**
+ * keyring_is_empty - Check whether a keyring contains any links
+ * @keyring: The keyring to check.
+ */
+bool keyring_is_empty(const struct key *keyring)
+{
+	return READ_ONCE(keyring->keys.nr_leaves_on_tree) == 0;
+}
+EXPORT_SYMBOL(keyring_is_empty);
+
 /*
  * Describe a keyring for /proc.
  */
diff --git a/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh b/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh
index 1f9601ef22f8..792449d356cf 100755
--- a/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh
+++ b/tools/testing/selftests/dm-verity/test-dm-verity-keyring.sh
@@ -746,7 +746,7 @@ test_keyring_inactive_when_empty() {
     log_info "TEST: Verify dm-verity keyring is inactive when sealed empty"
 
     # When keyring_unsealed=0, the keyring is sealed immediately while empty
-    # This means it should NOT be used for verification (nr_leaves_on_tree=0)
+    # An empty keyring should NOT be used for verification.
 
     log_info "Keyring state (should be empty and sealed):"
     list_keyring_keys
-- 
2.47.3

