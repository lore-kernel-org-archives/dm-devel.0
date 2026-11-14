Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794685041;
	b=tCgjSl/m4LZlE/zEm2o8lsRlITSZh83+k4z+locpfQGe++lzpmzftdxbOLhY0wofz1GH
	 Gcc0LhXVGS2XzwA0P7eA5q6E7eZxBjGwkUL5lGOw4WRVUgwUhRN3P2VRvPoeZ/IS9uU6n
	 UaY0Q9rfrm1uX8MKHC2lUyMJZT0YymrvmmUYWXtDfwRdiXJrQtWglTt+Awt3jQvtpkLqR
	 rSreHEvbiNMHLFYc0JjlN6FSoyAVdfg8WKW16DuE6o0I/xrHoUeRr6V+0AvLXDMvblmgf
	 vcxkYM77qNmq1WzMDoxlxdDJaScWrEx9QlcPpFMhZZ3Y5GTac2xBZOZjZXJDjjvqpAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794685041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=K9K7bqq7xK+KT7MgV6hqZn0DRh0a3ePkLyyaTd2Fqn8=;
	b=VOokwV0rf1hcKMKuPpzbk3uYyaxiwFXhBo7n+OJGJIvYXhm+Mh3F8sAeV1L2osxvnqZH
	 hSScUI5p/JRtRqN0yuzYFS8hU9Z+vZLnhwQW2cAB5ZPWE+xV/O1Zlv9pjhs+riSX4DeO6
	 gLwc7JfMg/jNwmA0WVXzgXpspNXhYLXUeIyYFJGPQYVeZLR6aC1GNIZ9pLqqF1XwEdQ0c
	 M70+ltoF1A4fOoRiXGQBrNxNC8wtPTWF/j5YYQBPll7A2/cLeyyZen3wlnk0BgEQLZ3VI
	 qCDr34P+Hke9/kZx7Y1M2EASqNGrugY6Tpyrmjsi7u4t38G/7ckR4Mx4A7ZSEws+cVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SHpcVMrS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B09A4606A89F;
	Sat, 14 Nov 2026 19:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SHpcVMrS
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A30101F000C6;
	Sat, 14 Nov 2026 19:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794685041;
	bh=K9K7bqq7xK+KT7MgV6hqZn0DRh0a3ePkLyyaTd2Fqn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHpcVMrSi7UbyrGVVXGvlWEc8UDn2o4HmbUkyBepV6cxUgSUdVSCfK0yfibs5GEoG
	 rzWn74sw+VxL+A48nKkHQXtkNcHfsly/B+vDo5SbWI9HkpphA9HeSjz+ANAfRVAIfU
	 BSy2x2Api8pZRFazGQi9VashXZfmT9zNwVfmijfy8XZOxS8b59mFQdG8T+msUZJH4r
	 P+jy7yvbsFkyS2jrWVCqqj3Ha8jzzdBpZIyDCIMwcfzCAq1TIQ/qa2YaseW73556pE
	 79SIgCapUPJoYePABLOE9jyz0b7JtUSjWJeh1AXqdRHMT1fGb3u/1cqnITohFqmQKU
	 Tv+BZGjWJ86eA==
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
Subject: [PATCH v13 4/7] s390/cert_store: Read-lock keyring semaphore in invalidate_keyring_keys()
Date: Sat, 14 Nov 2026 21:36:28 +0200
Message-ID: <20261114193631.731615-5-jarkko@kernel.org>
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

key_type->read() requires the caller to hold key->sem for reading.
Acquire keyring->sem across the two key_type_keyring.read() calls in
invalidate_keyring_keys() so the keyring cannot be modified between the
size query and the payload read.

Cc: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org # v6.6+
Fixes: 8cf57d7217c3 ("s390: add support for user-defined certificates")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/s390/kernel/cert_store.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/cert_store.c b/arch/s390/kernel/cert_store.c
index bec95991edae..7d339fe2f6fc 100644
--- a/arch/s390/kernel/cert_store.c
+++ b/arch/s390/kernel/cert_store.c
@@ -319,13 +319,17 @@ static int invalidate_keyring_keys(struct key *keyring)
 	struct key *current_key;
 	int rc;
 
+	down_read(&keyring->sem);
 	keyring_payload_len = key_type_keyring.read(keyring, NULL, 0);
 	num_keys = keyring_payload_len / sizeof(key_serial_t);
 	key_array = kzalloc_objs(key_serial_t, num_keys);
-	if (!key_array)
+	if (!key_array) {
+		up_read(&keyring->sem);
 		return -ENOMEM;
+	}
 
 	rc = key_type_keyring.read(keyring, (char *)key_array, keyring_payload_len);
+	up_read(&keyring->sem);
 	if (rc != keyring_payload_len) {
 		pr_dbf_msg("Couldn't read keyring payload");
 		goto out;
-- 
2.47.3

