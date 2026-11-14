Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794674512;
	b=2u1W/qhCIxapaB/SJs2cgrXupuvioWzAPEVeYaeMg/34mubpGwRcW8QWbiKVNRx0aL2L
	 Ujl9VyC+CDxteZW0kAOe69CIQu5tsKRtdkzeAxCugSuqPt4F5cZqvTpCDFdRjIhrBtf8D
	 WweUgyp3JKyWnDIQNEt/OHzBxV+sug2G7pk7rtEiujFhMED60kBB3iNLCsZTXsvGgks59
	 FpCbgGN9Dmb4kfdEr0lxk1TUXmP+nea+mHKuRPU4fSDDjFaEZR984Ef0AdpgpkACRM+7y
	 FypNJJ8NI0H2WeovyIlLTbpqVHbv2NDWMwz5NBEoRTSzxiddmaScEVn6lls38ZxLD7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794674512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=QGLMHkLcEdF2cQ9KeUVnz9Zxaf64JhgkVwoMNMb4SIk=;
	b=U/YL+Lq/qA1VYrKzr0B5qlkTQkWpGbObFxO3T03oNv18hZ0bGTVs4DqpVl5w8p0rzKIe
	 Ns08vaEEKVGUVpQ8xvv7T+ArwlLzQ/1BZgcpyJPd+e5yUkIuIgroqFomGDTCVOkRSQUhK
	 d+zj9ViVdsJJYIKp14jkLBFBFaGuexkJ2yUc22981Y7N95fq6ltMi3gj0fmMHnTlew2LH
	 Agvcy0jO0LNAyHNLFTeCMRJTmdXwYQJPAVz2Qx/egpPeE3A9T26GBWvySrYFAB7aQB8g8
	 dP/eCeo00zk+lP3Tc8httmx4sYLDWicCUTuMqTtHqCiJErflztoIg429FfY4mX+BH7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NZ0MGD8t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 227FB606A33D;
	Sat, 14 Nov 2026 16:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NZ0MGD8t
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E75CB1F000C4;
	Sat, 14 Nov 2026 16:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794674511;
	bh=QGLMHkLcEdF2cQ9KeUVnz9Zxaf64JhgkVwoMNMb4SIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZ0MGD8t01kk72mCJla/VVrWoluaDqTOvP6SZ+Y+60ujxKtpisUbPaW9j45PMkVuJ
	 1qZ6hC352EpUHaxEgHm/Rwog7d/VBwdivckNXcWXyHLa3i4NI8TNmGZY5BQChkg8Y5
	 CAauqkYQth8kWaZ1IjTOG/KAoN19CnLkkgxVsULLf9YAvyBHAmEeS0NGIyWGTcPchJ
	 Kqx/MEOEhpelH35lyojH6W/CVJzffZjo8mxjaLaKNn4d9tYzVPUBqqz5I57i/NqCOE
	 P61fGmOQ5fS5mGwq1sW8XlACbos//PXxoi6gAUJLqscp7rTCQOeM1CE2PQ15+zpr5q
	 mWxKDjtEBhaqQ==
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
	Yonghong Song <yonghong.song@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v12 2/6] s390/cert_store: Return an owned reference from find_cs_keyring()
Date: Sat, 14 Nov 2026 18:41:35 +0200
Message-ID: <20261114164139.429814-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261114164139.429814-1-jarkko@kernel.org>
References: <20261114164139.429814-1-jarkko@kernel.org>
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

Return an owned reference from find_cs_keyring() so that it will not get
dropped.

Cc: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org # v6.6+
Fixes: 8cf57d7217c3 ("s390: add support for user-defined certificates")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/s390/kernel/cert_store.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kernel/cert_store.c b/arch/s390/kernel/cert_store.c
index bb218b42a2c9..0a10b31d68af 100644
--- a/arch/s390/kernel/cert_store.c
+++ b/arch/s390/kernel/cert_store.c
@@ -362,17 +362,13 @@ static struct key *find_cs_keyring(void)
 					&key_type_keyring, CERT_STORE_KEYRING_NAME,
 					false);
 	key_put(us_keyring);
-	if (!IS_ERR(cs_keyring_ref)) {
-		cs_keyring = key_ref_to_ptr(cs_keyring_ref);
-		key_ref_put(cs_keyring_ref);
-		goto found;
-	}
+	if (!IS_ERR(cs_keyring_ref))
+		return key_ref_to_ptr(cs_keyring_ref);
+
 	/* Search default locations: thread, process, session keyrings */
 	cs_keyring = request_key(&key_type_keyring, CERT_STORE_KEYRING_NAME, NULL);
 	if (IS_ERR(cs_keyring))
 		return NULL;
-	key_put(cs_keyring);
-found:
 	return cs_keyring;
 }
 
@@ -395,14 +391,16 @@ static void cleanup_cs_keys(void)
 
 	keyring_clear(cs_keyring);
 	key_invalidate(cs_keyring);
-	key_put(cs_keyring);
 
 	us_keyring = get_user_session_keyring();
-	if (IS_ERR(us_keyring))
+	if (IS_ERR(us_keyring)) {
+		key_put(cs_keyring);
 		return;
+	}
 
 	key_unlink(us_keyring, cs_keyring);
 	key_put(us_keyring);
+	key_put(cs_keyring);
 }
 
 static struct key *create_cs_keyring(void)
@@ -729,13 +727,12 @@ static int fill_cs_keyring(void)
 		goto cleanup_keys;
 
 	rc = add_certificates_to_keyring(vcssb, cs_keyring);
+	key_put(cs_keyring);
 	if (rc)
-		goto cleanup_cs_keyring;
+		goto cleanup_keys;
 
 	goto out;
 
-cleanup_cs_keyring:
-	key_put(cs_keyring);
 cleanup_keys:
 	cleanup_cs_keys();
 out:
-- 
2.47.3

