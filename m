Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792758520;
	b=ISWEHRIRX6MmAc1Logu+7myU/1awBowabKOvEfFNI5KrEP1eTktP9P3vRhB9B0uDavi2
	 zWl10Ep9UInCYqXy2R/+pCEbN+9sbyItERIyJw26gDt8+vD3D7C+Ii4DcZvsHZHCgFEl+
	 VukiBsSOonbfSeWpnv7jiKORSAtkTVg8+7aRYEfCS544MUJ9XDqEzrXNNhaN6JNhN9gyl
	 450QZDTVohcgPfAw0cvOgfgtemKbCZ1Zyxi2D6+Kip2OWYuLoVjLKqfablXpkCyBKUlcT
	 bJgvseoTagYdN5ldt4VhBjZQdxWRRuYPd3LKAQ2vGA8KfdPzpl1kXkgTDX4mCcmBSsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792758520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=d0/08Y7FCHEGVevGTNjTfPTBox7sBeP1ImWEFHXBc7U=;
	b=arTF8pZ1aiDHTSNJWnJvzS2yRpbkOARpIF+Ad7i9hmaqOiPbQAL4LNapkFYacs3skELF
	 3Oy3/w2lmoLvgs2VgLVFlDnIoEL7f9b953SYZlu7BBQVRXx+PjDJpX4n4+T8WjQD0hqEU
	 24Onb/cfgWoVpR+LWO5EwFrILm1bCj7swzkok9g/mUmuUb7UqYwzXq9LWTtJynWq+hSN4
	 sby4Nfez0mTsHMoD6vItWFdNxW1aWIvcyReNmjvDYErHhgwlK9wKZM0xgdBGy81ZDl/+S
	 J6rd+5x27SF5TfzL00u5oADhr8KWR1V5k7A1TC5QpaWr3LFCAnav1YZ+vrVmSk/WmnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D9h5ueCh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id A234F606A31B;
	Fri, 23 Oct 2026 12:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D9h5ueCh
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A11871F01825;
	Fri, 23 Oct 2026 12:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792758519;
	bh=d0/08Y7FCHEGVevGTNjTfPTBox7sBeP1ImWEFHXBc7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9h5ueCh/HmoVl/YWOMqX73NXQvEpRAPoVC1sghyt5i02VbbQSXIwe7GdWztENeam
	 lz5tRuAbBNIco6cIBhYN7G12385d4luQqEok6GjvhOuPU0Dz2sz2paszfrBra4M7LQ
	 Ec9n/o0SODRbxLsTSpy3Ppd5LyT5HNHFORySsTg+HvDnb8ENZ0mhVyZkD9rz66Uug0
	 ykLTxnv8ldhqGa19X6R7XIzcXjbMuGrx7EWFG4D93qEHIJ1mGLUP7cF9UVaW5ml8HF
	 9OWg7QeZ7MsR3BW2YNd1JuQ/zxpBGl22lWXo8cbuRjEBXzxWfCWAsfoQXR4S4E9S2h
	 RHVCwgvVyOvNg==
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
	Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH v2 4/6] KEYS: Introduce keyring_is_empty()
Date: Fri, 23 Oct 2026 15:09:24 +0300
Message-ID: <20261023120953.1206778-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023120953.1206778-1-jarkko@kernel.org>
References: <20261023120953.1206778-1-jarkko@kernel.org>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce keyring_is_empty() in order to decouple for dm-verity and
fs-verity how keyring internally manages the keys.

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
index 3b8af14fb323..df2034fc5436 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -439,6 +439,7 @@ extern int restrict_link_reject(struct key *keyring,
 				struct key *restriction_key);
 
 extern int keyring_clear(struct key *keyring);
+bool keyring_is_empty(const struct key *keyring);
 
 extern key_ref_t keyring_search(key_ref_t keyring,
 				struct key_type *type,
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 5281da9d5bf7..4642754db6bf 100644
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

