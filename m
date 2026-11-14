Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794672756;
	b=forEhtKPBfl6s7beZvl4o+aREThZnklyILZwN/I8LMFYXlsf+PHv99zWMvoj0jUw+IIV
	 4khLpxLu6QhofL0moprrkRKAO/YraPcTg5zWaSHTxkmfczukq6AeROk9Wa8Dbpc/S47zE
	 1YwYIluUhWpPtItwNPnczVB/uTimBLWI61V2wtpa+RC8jJNBQttYYZrGymtAlYvCYFY56
	 rBxT/6N7nxCb7FUIi9Znf0TM8tjBZWyGIpHskB+ck1/LgRL599Xrwts2B4dv8ryc1mjkI
	 DitFxKj8h9lc9LoujD8p3P4u+PA50R28h5OG//eTeicyCJhtO/bDdvBqO8Bmfu2ycag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794672756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1vAd48PROWC1DL7Ri9U//2H4TkpRv3p3sVkb4Xn4KlA=;
	b=kHtdhAfmCqocwDQnCMk2NDD6Zz9eHfuern6A1+WU0X2yqF3pdjlwr3ULZOfzzF89rf8R
	 FJYlKynct+vBqh3b+G9qjRyZyDNmYyyGHalPpCsGcRGl/7wjtMMEOdF2fuJAdlUB9/XlG
	 JIBXkbvNzWSbK3r+XxfQE8Y5QJwkdLhrs0htjwgMpkHh+AJ3otethqexfnVqXhV2QmquB
	 u2gwGSWYBzl8hIavP6UQx1ZkADcJiNJQ837ifEUceX22NuKnPdyb/LN3v7y128Fq2kLmV
	 3xydM+brstZKhI0V+LJ+DagOeyQvhc/Yx5ciDeDnJHP1vvseH0lg7r9JqdOBkCx/t0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HyiiFIj6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id BA7E5606A336;
	Sat, 14 Nov 2026 16:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HyiiFIj6
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A1A601F000C5;
	Sat, 14 Nov 2026 16:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794672756;
	bh=1vAd48PROWC1DL7Ri9U//2H4TkpRv3p3sVkb4Xn4KlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HyiiFIj69tA2/PbphKiG4hUTVOjP21cRYgIPcVK4SnXJcpZCqMB0AwlyARJxtrJix
	 KWtIB8LIHljnTiBSsmFHCZjzXLSgJ5hvyoe69RT5WtXnUqYFyNuq+5jiTsQ+KhN1Wt
	 XFFZOlZhuqXxsjGjXlvp/TpyiIfzqlSA8K8r7AWKlvSPs4kgJArKbmnQudGLk3o9ll
	 c8n+/c2b2DHLPahErUWxjfZ4a8IL81js9eDMO8MGVWPXftBiq5IhdCTG1qABWhpD7x
	 L1X55eWj7iDKaOdwWCbsB4zFO0QTPbdPdG5yuV4O0BjDBSRiyWZgEtuJ4fYPfXrLgK
	 GPGHKct0qMn7w==
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
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Alex Shi <alexs@kernel.org>,
	Anastasia Eskova <anastasia.eskova@ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ignat Korchagin <ignat@linux.win>,
	Heiko Carstens <hca@linux.ibm.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	James Morris <jmorris@namei.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Song Liu <song@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Yonghong Song <yonghong.song@linux.dev>
Subject: [PATCH v11 4/6] KEYS: Introduce keyring_is_empty()
Date: Sat, 14 Nov 2026 18:12:09 +0200
Message-ID: <20261114161211.376859-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261114161211.376859-1-jarkko@kernel.org>
References: <20261114161211.376859-1-jarkko@kernel.org>
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
Reviewed-by: Ignat Korchagin <ignat@linux.win>
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
index 357f56360810..3d12dc4b5974 100644
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

