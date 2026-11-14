Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794674515;
	b=xPySmv2W7P9scswhyZY139l9zSXLe4pE2Kf3CrvJb+uwNIz2A0fcf7TQZ/Ui3vWgyjRg
	 tJfqROArzHTttA+3KmigkbhvCm0afL/SWkhMsX3QPe7mOPCHT6XhPFCKGFZYEp5M5wx+L
	 wupa9qOUIVn7GCY4EvWwW9K22ztRPQQ3zgBeQvQT9S9N7DJM/F9ASv0imTPcRSLX3qYFY
	 nV7NkLUqFQgQgwShzOnXXkW5DbsMJYrMJyfO9faRSjhmgjFesYngpxIfyWDuOQHVOXkeE
	 is2CNBuf6i7MO+U2D3MjnGrs0w4rXInCrXf7Xa8CpV8tAQAel+3B3IeyND54hyYX5/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794674515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=wtntVWCmOd4/XWlAfSZf6wHdSPZhz7QPwsNN7uqUuIw=;
	b=cdVIRNznPjMWIUHf5N0lSmVcePWS8+s99qizBnbDomuJFWG1KLXfpCr/elCgTsJ/lhZy
	 r9LkW8NUv0CS6/blZthl2I6S1WOzgMT6kstLtARXlB7uWlnnBVcEFJ1EEZhFolo5z9j/n
	 lxwAAUyEFUHwwmooLLw7jcoAAA5KmjB4xAoJ6DeiUsSemZRtZSxsKH2DrL0Dxfqb3FXL8
	 cIq04PzIPclvWiMzuvXW2CEb+CDXAqsNiC7Ql8KbqXM3+1NSdCSkUy5AbLA6QiiMDX8Q2
	 oRtKfZtdWD/8MEJTxD+9Dmc5cpIVwSAqrxsyXQfEEYDTyUYMcu1Fc4vbAxgQvDn5A7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jlt8pkqz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 989DB606A32E;
	Sat, 14 Nov 2026 16:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jlt8pkqz
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BC82F1F000C5;
	Sat, 14 Nov 2026 16:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794674515;
	bh=wtntVWCmOd4/XWlAfSZf6wHdSPZhz7QPwsNN7uqUuIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jlt8pkqz2BQn0K8phAaK0vhWhzEI/CvfIumAnasE3ro+GZeoy3IWk5ec5gKx8Lnrp
	 xA+qYInfI5/ncXAquh9toxnOrqHOR3zAm7E136czd0jEJo4snAR1Vvz94dfOA/Zp2L
	 u8cUSIZGil4ct8o2R3JhJe4g4weitJabbHegpxJRfA6QONvWyC2uq8J1VhlUez2Zld
	 C0Sy68fYVawO/kX3+2WPHSAO9aln9gtG4mAfN8wvIVksBunTe4JNIlylMc/fXyft7N
	 usfwTmCu4Av4E0pcEEtJ4+maCrEzEpp/6nAa0QAtJVDhTNlDhnN7A+jSk898cTV4ar
	 o7njKrwFuh1OQ==
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
Subject: [PATCH v12 3/6] s390/cert_store: Skip keys that disappeared during invalidation
Date: Sat, 14 Nov 2026 18:41:36 +0200
Message-ID: <20261114164139.429814-4-jarkko@kernel.org>
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

key_lookup() can return NULL for an unlinked key. Skip such keys instead.

Cc: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org # v6.6+
Fixes: 8cf57d7217c3 ("s390: add support for user-defined certificates")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/s390/kernel/cert_store.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/s390/kernel/cert_store.c b/arch/s390/kernel/cert_store.c
index 0a10b31d68af..03391b379dad 100644
--- a/arch/s390/kernel/cert_store.c
+++ b/arch/s390/kernel/cert_store.c
@@ -331,8 +331,13 @@ static int invalidate_keyring_keys(struct key *keyring)
 		goto out;
 	}
 
+	rc = 0;
+
 	for (key_index = 0; key_index < num_keys; key_index++) {
 		current_key = key_lookup(key_array[key_index]);
+		if (IS_ERR(current_key))
+			continue;
+
 		pr_dbf_msg("Invalidating key %08x", current_key->serial);
 
 		key_invalidate(current_key);
-- 
2.47.3

