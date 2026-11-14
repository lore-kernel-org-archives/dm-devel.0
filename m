Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794672745;
	b=bsX16GJPfTc9U0eZgtfq6vveOKdlFyVKP6bQpD+cushvYkcgV53PWwuiuW4vut1QkBT/
	 OUuP4ioRjlppwrye2lZJ65qZUlKkshbedjqGpJRAsbVf750Hu/ZtPzyn1GyRNAZ2J6KVu
	 K4YNB8oZdRDrSKgd7CD6K7WuPvHuQI1KdkgWWHZ0faTi6pIytU/VrZ7mtARTI+tZ3DDz5
	 uMzXNZiUFJDYxiLZCFVSZFYz73fNgmTb7ZWhIhSiraPMubXHRYd23Z1+77UvPB39xYH/y
	 TLm5RB+U8RfdwhV/+ahzAdSpGV/Hd6WDrc60rodv+F1prEL0TeGbLHkWna20kkDHHMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794672745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=I0LV/JQpN8yDGYTTWcI8HQY8CmcG+PtzomAV8QbPhzo=;
	b=yK+XDEgTE+X97lM2NhyZHp+PasfXfCHXW0K8+iaw7SyblWiHhL8t/iLF0PET9rAJUm9n
	 +AFRxkr1N9COJkcPMk1vVkpCEf/TBr8J+alyNavMHK4Hy8UBr4VejK7LEhPfkXCFTArKy
	 GyNMj1YlwITOU0NAX9PJIXIwoaE33ZVpXQ52l+a3FYuySeLXGscEbt7DkKEBAbpw4C5bR
	 /Axbzay3h23kF1c122uE9dJKlFCfE2NDzZCJgSJC1l6Lm57xwwAA8IQUh/TFRbI+Q6VQp
	 lVrYUBsKN62oz1keoQJqxPaXK4Qas4GhdmSk4DrtyNtpXnQ5ky/qmvYBXTs6iz6DNew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cY0hz8bN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EC6B0606A33B;
	Sat, 14 Nov 2026 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cY0hz8bN
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ED1361F000C9;
	Sat, 14 Nov 2026 16:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794672744;
	bh=I0LV/JQpN8yDGYTTWcI8HQY8CmcG+PtzomAV8QbPhzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cY0hz8bNYhXf9O8n4uRhQOzSP6DAXLGTdDeDBam8K8sTTtff5pwce1qXEv0/lYWvl
	 ae5IXyOOZ6yGkighwoKxBhGuCPl64DMW9MxZa2Z2j6uDK7bmnS+0CIDe76B6C7VGgH
	 YV4r3+ekqWPoLPMncwaoY42i8otFlzkPK3r8CxfEF2orckBaKnnJr9xWm7l930mO0V
	 RflBGE250Ach2i9/mdTnZCk79JdqA2ss5JrrYUkIGfvGDH6JtCAAyZ/8q0CDlYvAa9
	 LXib2QScwUOP/jbQ91Sg/gMGupVi2a5n5A8lwTzwTL5mGP2P3EOaXn3xlmbxdGHMak
	 f+vVnRAtkaFEg==
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
Subject: [PATCH v11 1/6] s390/cert_store: Pin the user session keyring
Date: Sat, 14 Nov 2026 18:12:06 +0200
Message-ID: <20261114161211.376859-2-jarkko@kernel.org>
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

The user session keyring stays alive only because the session keyring is
pinned by current_cred().

Pin the reference at:

1. find_cs_keyring()
2. cleanup_cs_keys()
3. create_cs_keyring()

Cc: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org # v6.1+
Fixes: 8cf57d7217c3 ("s390: add support for user-defined certificates")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/s390/kernel/cert_store.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/cert_store.c b/arch/s390/kernel/cert_store.c
index 998f2da56175..bb218b42a2c9 100644
--- a/arch/s390/kernel/cert_store.c
+++ b/arch/s390/kernel/cert_store.c
@@ -307,7 +307,6 @@ static struct key *get_user_session_keyring(void)
 			   PTR_ERR(us_keyring_ref));
 		return ERR_PTR(-ENOKEY);
 	}
-	key_ref_put(us_keyring_ref);
 	return key_ref_to_ptr(us_keyring_ref);
 }
 
@@ -352,11 +351,17 @@ static int invalidate_keyring_keys(struct key *keyring)
 static struct key *find_cs_keyring(void)
 {
 	key_ref_t cs_keyring_ref;
+	struct key *us_keyring;
 	struct key *cs_keyring;
 
-	cs_keyring_ref = keyring_search(make_key_ref(get_user_session_keyring(), true),
+	us_keyring = get_user_session_keyring();
+	if (IS_ERR(us_keyring))
+		return NULL;
+
+	cs_keyring_ref = keyring_search(make_key_ref(us_keyring, true),
 					&key_type_keyring, CERT_STORE_KEYRING_NAME,
 					false);
+	key_put(us_keyring);
 	if (!IS_ERR(cs_keyring_ref)) {
 		cs_keyring = key_ref_to_ptr(cs_keyring_ref);
 		key_ref_put(cs_keyring_ref);
@@ -373,6 +378,7 @@ static struct key *find_cs_keyring(void)
 
 static void cleanup_cs_keys(void)
 {
+	struct key *us_keyring;
 	struct key *cs_keyring;
 
 	cs_keyring = find_cs_keyring();
@@ -390,20 +396,33 @@ static void cleanup_cs_keys(void)
 	keyring_clear(cs_keyring);
 	key_invalidate(cs_keyring);
 	key_put(cs_keyring);
-	key_unlink(get_user_session_keyring(), cs_keyring);
+
+	us_keyring = get_user_session_keyring();
+	if (IS_ERR(us_keyring))
+		return;
+
+	key_unlink(us_keyring, cs_keyring);
+	key_put(us_keyring);
 }
 
 static struct key *create_cs_keyring(void)
 {
 	static struct key *cs_keyring;
+	struct key *us_keyring;
 
 	/* Cleanup previous cs_keyring and all associated keys if any. */
 	cleanup_cs_keys();
+
+	us_keyring = get_user_session_keyring();
+	if (IS_ERR(us_keyring))
+		return NULL;
+
 	cs_keyring = keyring_alloc(CERT_STORE_KEYRING_NAME, GLOBAL_ROOT_UID,
 				   GLOBAL_ROOT_GID, current_cred(),
 				   (KEY_POS_ALL & ~KEY_POS_SETATTR) | KEY_USR_VIEW | KEY_USR_READ,
 				   KEY_ALLOC_NOT_IN_QUOTA | KEY_ALLOC_SET_KEEP,
-				   NULL, get_user_session_keyring());
+				   NULL, us_keyring);
+	key_put(us_keyring);
 	if (IS_ERR(cs_keyring)) {
 		pr_dbf_msg("Can't allocate cert_store keyring");
 		return NULL;
-- 
2.47.3

