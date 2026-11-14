Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794685034;
	b=4qzmQ6mB7Rane9CtT3bCIYpJPfI7tTsL1Ekzzg5Pfi26UgbyjUkX6CU+0p3+9qBdxZRO
	 PMgCzsmwYI83JaCHZhgepVRB3vrSbCqTUMymck4HbSKisbJjfq4q8x9un3akkFqALwy62
	 Me3lXbKP21hKCwswV38k+WXQ4yrdG6dZEW3UNKJeMmsZXwymiRH+hcobBS52xgrk+Knsb
	 yUIm55KyWthyOY+M1tLO+5bVbj8oVMTUlLjyxzaHbtIG594Zta2pPvtgqUXU9v+dyU247
	 kZ4mRWBFhoGSEJ0XKROAtZTC2oZVfo1xdPHQbNk0j1cUX4pX+uy9ws87Xa4M9siSQcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794685034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=QGLMHkLcEdF2cQ9KeUVnz9Zxaf64JhgkVwoMNMb4SIk=;
	b=IwLtmcd7J/fuFgtQKYKby+MF+9/BIeOZbner8pUd0UvoplU43/mORI80iDiu+7e9u6Jl
	 rFKs9QfM5xfHqJxv1HHXTyKeatbdicCDZT+wBAQYBRMrYRRkDBucZBkXE4naZTlFhh0tY
	 R+sw2Xdu+KbMDf1RgTzyeONPPG+LhYMJcTJ2lZ9+i6dNdjMEGvVGq6it2sV05cMTG3Tpl
	 NIoNsWJoXzUohVnmwPpF1ByFLeuO7FB3xvuCtcfkq1baJsTt2dTvEWBwEjG0VfwXcBFw7
	 a4gej+fh21fo9ZOSudabtEL85hpmnSC7U0isgarGIbjPHfk3GTTtaFL9uumMT/g4xYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A4PY2rb2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 41160606A882;
	Sat, 14 Nov 2026 19:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A4PY2rb2
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1B89E1F000C4;
	Sat, 14 Nov 2026 19:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794685033;
	bh=QGLMHkLcEdF2cQ9KeUVnz9Zxaf64JhgkVwoMNMb4SIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4PY2rb2tDOdZKNdHEfOMv9xXAeKcXcftWYLIrhlBPQYbacEynu2g4uOu3GZxc/lI
	 AzGU9ucDBfGQLX55VxztUfZp4VgPHV2jmxAo8eAXBDvupWdJ47Yr7oMFNRA+Q8lJLv
	 4vp7vYhcXIfNRyUvouU8ObuAmx0jEIa31BN87kDcxxkSXcawdx2nz3q7Qq/DadOK2N
	 JFJ39DaKkU8WTXgpTqtM24lb1qiK9vUoKrwCMXiY1lJqHl46FgRvFKKApIHj2SImJr
	 dRfvZTPrGMDPwcT2CzKp2ElryQNYuslU90LamSkFGjiKcOq/B9XL4cXwmRBI39QFYY
	 1NZG6vqJH0m3g==
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
Subject: [PATCH v13 2/7] s390/cert_store: Return an owned reference from find_cs_keyring()
Date: Sat, 14 Nov 2026 21:36:26 +0200
Message-ID: <20261114193631.731615-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261114193631.731615-1-jarkko@kernel.org>
References: <20261114193631.731615-1-jarkko@kernel.org>
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

