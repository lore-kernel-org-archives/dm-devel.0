Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281869;
	b=jK4MmbIgfXvr7hO2exrKustbyThNVXmJthvIKkKpXIFmJDjhDvbtVWH5xDuHiTFKS1OB
	 94jpTX9eLgZRYY8jQd8GlUJze/5kWa7LVbA6618l8Y59P+tNugFTcOS4nbg+TDNP9vsQA
	 /5zG3E0dCdWRz6CIQPz5kKZypmCkFQZLPSbpoXYglLEzjFwZJJKp6ch2xRndWD7wzCgDs
	 faLTV7JEmhK7ZV9XnOYdtMmwUQwC0Fb3ME3Fz1LLB+CjQzjZOCLmTq30nA1j4+NWCiYSg
	 SYNR/OTkDTLLCKJ/5hYjr8xg21kvwhn4m6Ukz4Nj48rb3/2DOtgNjWd4AwPpJZg+WQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=d57Xwxdq7ggCiZHh4PGNXJufaWf8Hx04l8Vo55VakVk=;
	b=AUdQtfDyOwRWzyIKu/Vc8tfe2UMMKRcN1VF/G1qtDUZhImBZ5FpWWYh+TC2zBKhaFmbg
	 DpExW0ZrxbEgXOoiAS5+CbgICuq12YuISc9+ExW/hgKAJLSiGWdYc1NOUKGWRInZGdtsD
	 MPla2vvoU5YxK5J+7SKlPVVwNAX2kIU2GiUWa4drq8EE10diFg8VZX+WTqg/EP0FW9vWE
	 eFZoWmlFBfuFNqQca4qjw2NBCX0BJf0h4+FuPWANDAfnD6DDSA12V60TxMsnqGY7xzPFd
	 mRbsPVm74/iiEA99+nsHMj2IpCouePjHq1r9iK9yjzZAp4nE6dAfi5Ud9RSKHVhabSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bsfVIp2D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 8341C60A6F79;
	Tue, 10 Nov 2026 03:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bsfVIp2D
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 792771F008A5;
	Tue, 10 Nov 2026 03:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794281869;
	bh=d57Xwxdq7ggCiZHh4PGNXJufaWf8Hx04l8Vo55VakVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bsfVIp2Du7+TXWzzv1AVkg0BHW0AFsZkouQiHfPJWSa2x5FGJe2ANFH0D2Clrwet+
	 iR16SnW1I/mNLfeEjaYkfLIEimyDJiKfL/QHxUJQ6IHkbuY4q4HbDJ332UY0P4vD0t
	 /RE+U06aE2/NAX5vLQjvjuDzwypa6ciwFVtPEIggzPQd/A+nsoHDnZ6rE+voj29qQ/
	 LL1SK2K/KJShnBqE0fMgLQAceCTjZb3vAgoACCjyxgT8mRBWWF+gne6bmQPwClA6I5
	 c/4nDAiNrC1h6D3p1M4QB1FbuAOqYJ/FpijRP8Evecbhkmq9fJQ0lXs/8QKnSzovQB
	 YNgvt+MK3ZBmA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	dm-devel@lists.linux.dev,
	fsverity@lists.linux.dev,
	keyrings@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Alex Shi <alexs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ignat Korchagin <ignat@linux.win>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	James Morris <jmorris@namei.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Song Liu <song@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Yanteng Si <si.yanteng@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>
Subject: [PATCH v7 1/3] KEYS: Introduce keyring_is_empty()
Date: Tue, 10 Nov 2026 05:37:36 +0200
Message-ID: <20261110033738.2495880-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110033738.2495880-1-jarkko@kernel.org>
References: <20261110033738.2495880-1-jarkko@kernel.org>
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

Introduce keyring_is_empty() in order to decouple for BPF, dm-verity and
fs-verity how keyring internally manages the keys.

Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 drivers/md/dm-verity-verify-sig.c                      |  2 +-
 fs/verity/signature.c                                  |  2 +-
 include/linux/key.h                                    |  1 +
 kernel/bpf/keys.c                                      |  2 +-
 security/keys/keyring.c                                | 10 ++++++++++
 .../selftests/dm-verity/test-dm-verity-keyring.sh      |  2 +-
 6 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
index 0c65c7a31da8..bd5143aae4fa 100644
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
index 2f49c5d9d987..b45b39b829b2 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -70,7 +70,7 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 		return 0;
 	}
 
-	if (fsverity_keyring->keys.nr_leaves_on_tree == 0) {
+	if (keyring_is_empty(fsverity_keyring)) {
 		/*
 		 * The ".fs-verity" keyring is empty, due to builtin signatures
 		 * being supported by the kernel but not actually being used.
diff --git a/include/linux/key.h b/include/linux/key.h
index 420412aab926..9ff10b780865 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -439,6 +439,7 @@ extern int restrict_link_reject(struct key *keyring,
 				struct key *restriction_key);
 
 extern int keyring_clear(struct key *keyring);
+bool keyring_is_empty(const struct key *keyring);
 
 extern key_ref_t keyring_search(key_ref_t keyring,
 				struct key_type *type,
diff --git a/kernel/bpf/keys.c b/kernel/bpf/keys.c
index bffc356839ac..24e0416abc99 100644
--- a/kernel/bpf/keys.c
+++ b/kernel/bpf/keys.c
@@ -29,7 +29,7 @@ struct bpf_key *bpf_lookup_keyring(void)
 
 	if (!bpf_keyring)
 		return NULL;
-	if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
+	if (keyring_is_empty(bpf_keyring) ||
 	    !READ_ONCE(bpf_keyring->restrict_link))
 		return NULL;
 
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 5281da9d5bf7..ac48d6204915 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -443,6 +443,16 @@ static void keyring_destroy(struct key *keyring)
 	assoc_array_destroy(&keyring->keys, &keyring_assoc_array_ops);
 }
 
+/**
+ * keyring_is_empty - Check whether a keyring is empty
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

