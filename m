Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794288809;
	b=fclqxwSXYsBT/6pzsAAtHJ05dvMUGOtV13YiAfcmFzVJKX++gCLddN0OnFlexdbeS9Bn
	 youxspbsTnVVH5cOyR99Bu+hHczKdhEH+q9oXNPAEKwQb6n6yNE9k85GWHGFgi4kwHrMp
	 hkZVXXwCf2e2FY5zB9bAHSrbDTDokWWORor0/0LjtOlKgj4Btmbq5WnKxOAOi6iiialux
	 Z336LVHbUCYT8zq5lkpBQuKZrtou1Mi6GpSe20dfIIM1mZ6iCHbSsigxtN36x1O05PfQb
	 Yu6lMhIewP+7czxyLuDmGfZj83v+8njxSl0/jWNyZ5Wf/DySOHwRXiXjTENuhcOznOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794288809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RsEoo2/BoCWyrVBYN7i/inWdIbQyOl/oxblqkLc3rh0=;
	b=Wy5Zd+f/bZr1MhvqG6ESnEhWDNKZVcsB3jdKYI2truwJG+k2E0hXhhvDDSPr4GNbc6Jo
	 n21E3U1jErzEwBjqymkt2AEZURFWSMm/f9DrGUKbW2Pj51aI2LMnLkPwknhWOIsiMjz2s
	 iH55tXxddNuvzi6Ohe68sniu6Yf8YCe3s9s63awZ0uhv7yrpLnHfZuwvDXjRJQNx6ovi5
	 EkfgMWt5SCzRq5DzO+CokbvaONf+JpUqD4nHvvDR3tPgBhrGPoDxPO+s6F2l/Au5OYWZB
	 75opxHno/NXhOaaKbzOYVwGG2y0Qb9jfKEnv4T1mS05SHFW9mMxeYBe2/CFNJF1DBXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=onth91xa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 196B8606A321;
	Tue, 10 Nov 2026 05:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=onth91xa
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 463C91F008A2;
	Tue, 10 Nov 2026 05:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794288808;
	bh=RsEoo2/BoCWyrVBYN7i/inWdIbQyOl/oxblqkLc3rh0=;
	h=From:To:Cc:Subject:Date;
	b=onth91xanp2MLhEGT+q+pDoOyFHUTKflK4eeGMREO7d+Q0miVEH1X6+SL4hF+8ppB
	 qEUTGrRPmeEpOvbfEVvGAOX61nPvSfKeekZ3fKIIuNceCpOKTrgZ2z6vrxu+gqFusX
	 pmmJZZGEJRxmyl3P26Se0B15GZqivOLPys0WIcNN+XLeUHywJpuX6bEU/yeLuAw0CX
	 SDrM+ms9IUH7RkGhYbsen1SRa1j75R/91WK0kxXeGdamd7b2XLZMoEDt8ynvPaMEq7
	 jENr0iVKTmqVIjXsZelCuLHmAcSn/xYyI2UMOdNii6FvLXvVFrp4HmhChmMVMa10h8
	 I8qsE5pi+JPwA==
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
Subject: [PATCH v9 0/3] KEYS: Replace assoc_array with rhashtable
Date: Tue, 10 Nov 2026 07:33:20 +0200
Message-ID: <20261110053323.2936729-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
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

The keyrings subsystem is the sole user of assoc_array. It has over 1700
lines of code, no test suite, and a long history of bugs, with LLMs now
finding more.

This unfortunate outcome has evolved over time by large from the shortage
of in-kernel callers, time bandwidth and 3rd party contributors.  What the
keyrings subsystem needs is just a generic key-value store, which performs
well with sparse key sets. Replace assoc_array with an rhashtable-backed
keyring index and remove assoc_array from the kernel.

CHANGES
=======

v9:
- Replace __free(kfree) with explicit cleanup so early goto out paths
  cannot bypass initialization of the link pointer. Preserve kleave()
  tracing on all exit paths.

v8:
- Fixed broken rebase.
- Restructured __key_link_begin() a bit as a response to a minor
  complaint from Sashiko.
- Fixed a minor glitch in __key_link_begin(): now also first invariant
  invokes kleave() on failure.

v7:
- Rebased.

v6:
- Eric Biggers: Set .insecure_elasticity = true in keyring_link_params and
  drop the -EBUSY retry loop in __key_link_begin().
- Addeded Reviewed-by's from Eric Bigger and Ignat Korchagin.

v5:
- Eric Biggers: Include <linux/jhash.h> explicitly in keyring.c.
- Eric Biggers: Document why hashing type/domain_tag pointers with SipHash
  and truncating the digest to 32 bits are safe.
- Eric Biggers: Rework the commit message for "KEYS: Replace assoc_array
  with rhashtable", including behavioral and operational changes.
- Retry rhashtable_insert_fast() on transient -EBUSY in __key_link_begin().

v4:
- Eric Biggers: Correct the kerneldoc summary for keyring_is_empty().
- Eric Biggers: Truncate keyring_index_key hash to u32 and drop index_id.
- Eric Biggers, David Howells: Use a proper struct instead of a two-element
  array to pass the edits.
- Eric Biggers: __keyring_link(): Call key_put() in the rollback of
  rhashtable_replace_fast().
- Eric Biggers: Retract from using __free(kfree) in keyring_get_index().
- Eric Biggers: Reuse keyring_link_key() in keyring_obj_cmpfn().
- Eric Biggers: Document why keyring_index_free() uses queue_rcu_work().
- Eric Biggers: Fix the commit message for "KEYS: Replace assoc_array with
  rhashtable".

v3:
- Since David is away for the next week I decided to address the
  low hanging fruit that I reported myself.
- Unified and sanitized function and variable naming and removed
  unnecessary asymmetry e.g., by renaming keyring_remove_all_links
  as keyring_index_free, 'links' as 'index' and '_edit' as 'edit'.
- Flattened the implementation by refactoring out some useless
  wrappers and other constructs.
- Addressed continuation after triggered WARN_ON() on at the three
  sites that I've described in my email response to the previous
  patch set version.
- Reworked keyring_read() so that it triggers the scheduler between
  the iterations.
- Dropped "Assisted-by: LLM" tag because checkpatch.pl told me so.

v2:
- Tried to address all the issues pointed out by David and Eric. Tell me
  if something was ignored, as that would be an unintentional mishap.
- Updated and trimmed the source code comments.
- For assoc_array_edit I decided to go with two-element pointer array,
  which shifts a bit what David suggested.
- Dropped is_keyring flag. It was so obvious call so I mention it here
  just in case because too obvious maxes out my self-doubt ;-)
- Used cleanup.h primitives where I possibly could especially in order
  to make fallible initializations more bug-resistant.
- The already-ack'd bug fixes are included but will be dropped as soon
  as I've sent them over to Linus.

VERSIONS
========

- v8:
  https://lore.kernel.org/keyrings/20261110044043.2608600-1-jarkko@kernel.org/
- v7:
  https://lore.kernel.org/keyrings/20261110033738.2495880-1-jarkko@kernel.org/
- v6:
  https://lore.kernel.org/keyrings/20261107195605.3929659-1-jarkko@kernel.org/
- v5:
  https://lore.kernel.org/keyrings/20261105031401.956609-1-jarkko@kernel.org/
- v4:
  https://lore.kernel.org/keyrings/20261029232437.2581640-1-jarkko@kernel.org/
- v3:
  https://lore.kernel.org/keyrings/20261025001105.1824178-1-jarkko@kernel.org/
- v2:
  https://lore.kernel.org/keyrings/20261023120953.1206778-1-jarkko@kernel.org/
- v1:
  https://lore.kernel.org/keyrings/20261016215326.4110064-1-jarkko@kernel.org/

Cc: bpf@vger.kernel.org
Cc: dm-devel@lists.linux.dev
Cc: fsverity@lists.linux.dev
Cc: keyrings@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Howells <dhowells@redhat.com>
Cc: Dongliang Mu <dzm91@hust.edu.cn>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Emil Tsalapatis <emil@etsalapatis.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Ignat Korchagin <ignat@linux.win>
Cc: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: James Morris <jmorris@namei.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Song Liu <song@kernel.org>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: Yonghong Song <yonghong.song@linux.dev>

Jarkko Sakkinen (3):
  KEYS: Introduce keyring_is_empty()
  KEYS: Replace assoc_array with rhashtable
  lib: Remove assoc_array

 Documentation/core-api/assoc_array.rst        |  564 ------
 Documentation/core-api/index.rst              |    1 -
 .../zh_CN/core-api/assoc_array.rst            |  473 -----
 .../translations/zh_CN/core-api/index.rst     |    1 -
 drivers/md/dm-verity-verify-sig.c             |    2 +-
 fs/verity/signature.c                         |    2 +-
 include/keys/keyring-type.h                   |    1 -
 include/linux/assoc_array.h                   |   88 -
 include/linux/assoc_array_priv.h              |  178 --
 include/linux/key-type.h                      |    1 -
 include/linux/key.h                           |   29 +-
 kernel/bpf/keys.c                             |    2 +-
 lib/Kconfig                                   |   14 -
 lib/Makefile                                  |    1 -
 lib/assoc_array.c                             | 1724 -----------------
 security/keys/Kconfig                         |    1 -
 security/keys/internal.h                      |   14 +-
 security/keys/key.c                           |   22 +-
 security/keys/keyring.c                       | 1013 +++++-----
 security/keys/request_key.c                   |    8 +-
 .../dm-verity/test-dm-verity-keyring.sh       |    2 +-
 21 files changed, 490 insertions(+), 3651 deletions(-)
 delete mode 100644 Documentation/core-api/assoc_array.rst
 delete mode 100644 Documentation/translations/zh_CN/core-api/assoc_array.rst
 delete mode 100644 include/linux/assoc_array.h
 delete mode 100644 include/linux/assoc_array_priv.h
 delete mode 100644 lib/assoc_array.c

--
2.47.3

