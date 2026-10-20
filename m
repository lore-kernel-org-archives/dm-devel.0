Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792504530;
	b=JRzte4SNRmQ4arD6WATov6CJkKQeE9fFqFKOdBK3Q63YceXkZ5UfEmUXGH+fDylu/jao
	 CoWfGQalAGxjn93pq5x8o7t9J1Lr4lUqicGEn7vcYfhCQSjr8T768FEFJa0NEZxfPAA3p
	 nSoaMovImV3jJ9BUh/4xkS9iKUUF0mXRWGMwzmrX9PZ4Bx1UsoO8WHJst21tknk3TVDR9
	 hPJ5cfnKSGPKuvyd9CaORGHT7UEdPdF56scsn1nzJlRU7VsT931DDIbsXDp/YyyFWARzv
	 yUd8BNcgeyLmUZfSvOhfDqGQ1VmbNSSp2KhUws/4qfG7GxlT+SeKUZGkHA9k9JJCoeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792504530;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=JAnllqrQb9QTdIrZZKbMxQUA7ATN5DReDP4RAaPzNbQ=;
	b=hDGxFTrP6Xk4/Ir34NsAZxfPOkmEsBLLextC3C0c50xcFh/yU9UMScUtpM7rBXy6+6d4
	 C4npo2wY9Zp8aAGq5ylB6Dht89pzVqrdZrcqMMuDTdWwujVbkMFX5maaN30NJz+8YTrGt
	 ELI5YH7dH8KqFyvz8bfAAuYJXTr4d4UnrsNagXdGOMhsPtp38JWUFdzJRxI+4CoX5oLrH
	 vSKZhBCcc+QNxZttfIUaoW2+QGVx3pgh0Xjfg1xERDc69s9Dv12uTe/R9M2nWQwPsN1J5
	 uthbo0MM1hyQcdQvvhbx2ra2wgLr4sgMoxsLLKHD4iENIRaVU3M0j1Q8866Im7NXS2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="DNj/Hzeq";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A4E606AB3B
	for <dm-devel@lists.linux.dev>; Tue, 20 Oct 2026 13:55:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1A4E606AB3B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DNj/Hzeq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792504528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=JAnllqrQb9QTdIrZZKbMxQUA7ATN5DReDP4RAaPzNbQ=;
	b=DNj/HzeqOJE4uMipt+9H9PeKdpZ2pu0yPUeHBmKHSh3xJ7ByJOkEzmEHkhVHxFSt3EKOcV
	WGPpSZSPhrDo0SmarzzA4/ymdC6aklAjUO4qDEy56xBkLXek/1QQ9K62MY9tx2qSJ50DIk
	Wir19iGk5Tij7RpM/WRnUt2l9bpFMPQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668--boxyqC6Mh29YkmcLnLOHA-1; Tue,
 20 Oct 2026 13:55:22 +0000
X-MC-Unique: -boxyqC6Mh29YkmcLnLOHA-1
X-Mimecast-MFC-AGG-ID: -boxyqC6Mh29YkmcLnLOHA_1792504517
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E6EC195C271;
	Tue, 20 Oct 2026 13:55:11 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68B9E195608D;
	Tue, 20 Oct 2026 13:55:06 +0000 (UTC)
Date: Tue, 20 Oct 2026 15:55:03 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ayoub Zaki <ayoub.zaki@embetrix.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Colin Ian King <colin.i.king@gmail.com>, 
    Elouan Da Costa Peixoto <elouandacostapeixoto@gmail.com>, 
    Fan Wu <wufan@kernel.org>, Hao Zhang <zhanghao1@kylinos.cn>, 
    Hemanth Selam <hemanth.selam@gmail.com>, Henry Wong <henry@stuffedcow.net>, 
    Itai Handler <itai.handler@gmail.com>, Matthew Sakai <msakai@redhat.com>, 
    Matthias Goergens <matthias.goergens@gmail.com>, 
    Peng Fan <peng.fan@nxp.com>, Thorsten Blum <blum@kernel.org>, 
    Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper changes for 7.4
Message-ID: <c19c2552-cecc-43ae-b6df-0d50edfce764@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DKr7WBntUYVLY7iUQJm42CWU_1jv07iS8EtwPE4R1xA_1792504517
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit fd73f4a6659897191fa0d40695fe370925dd3780:

  Linux 7.3-rc3 (2026-09-13 14:38:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.4/dm-changes

for you to fetch changes up to 334714e4bdf8868c17a7650a7502ba1c90a8721f:

  dm-verity: clear LSM integrity state on suspend (2026-10-13 17:31:14 +0200)

Please, pull. Thanks.

Mikulas

----------------------------------------------------------------
- dm
   - fix a bug in dm_accept_partial_bio that broke dm-writecache
     in persistent-memory mode
   - use assign_bit()

- dm-vdo
   - fix misbehavior on invalid metadata

- dm-crypt
   - use memzero_explicit
   - reject malformed keys
   - allow sector size up to page size

- dm-delay
   - advertise flush support if the user wants to delay flushes

- dm-writecache
   - reduce per-block metadata overhead by 8 bytes
   - report I/O error when flush failed
   - fix a quirk in statistics
   - fix a crash if we attempt to use a non-dax device
   - fix uncommitted_blocks underflow
   - fix REQ_FUA processing

- dm-verity
   - add the option DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE
   - clear LSM integrity state on suspend

- dm-thin
   - remove unnecessary locking in pool_map

- dm-mpath
   - small refactoring of the historical service time path selector

- dm-snapshot
   - fix crash if dm_io_client_create fails
   - make the chunk list being sorted by the chunk number

- dm-bufio
   - fix non-working memory limit
   - fix a race leading to an unsigned integer underflow
   - clean-up cache limit reading
-----BEGIN PGP SIGNATURE-----

iIoEABYKADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCatdtwhQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbR3yAP0VGMxhAZZt4AYgEukfh5v1ivCNX10l
ldE3aRh74G7OYAEApC9G2sm5EtQsvQ+SZvnsCCKgvl5l+J7ObprpLO8adg4=
=XKui
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Ayoub Zaki (1):
      dm-verity: add DM_VERITY_VERIFY_ROOTHASH_SIG_FORCE

Benjamin Marzinski (3):
      dm-mpath: streamline setup work in the HST path selector
      dm-mpath: standardize repeat_count handling in the HST path selector
      dm-mpath: check values in hst_status while holding spinlock

Colin Ian King (1):
      dm vdo: Fix spelling mistake "postive" -> "positive"

Elouan Da Costa Peixoto (1):
      dm-clone: remove unused memset

Fan Wu (1):
      dm-verity: clear LSM integrity state on suspend

Hao Zhang (1):
      dm thin: Remove unnecessary locking from pool_map()

Hemanth Selam (2):
      md: fix typos in comments
      md: fix typos in comments

Henry Wong (1):
      dm-writecache: Reduce metadata memory use by 8 bytes per cache block

Itai Handler (1):
      dm-crypt: allow encryption sector size up to PAGE_SIZE

Matthew Sakai (2):
      dm vdo indexer: prevent delta list overflow on load
      dm vdo indexer: validate record page numbers better

Matthias Goergens (1):
      dm-delay: advertise flush support

Mikulas Patocka (11):
      dm: fix a bug in dm_accept_partial_bio
      dm-writecache: report I/O error if flush failed
      dm-writecache: fix a quirk in statistics
      dm-writecache: fix a crash if we attempt to use non-dax device
      dm-writecache: fix uncommitted_blocks underflow
      dm-writecache: fix REQ_FUA processing
      dm-snapshot: fix crash if dm_io_client_create fails
      dm-snapshot: make the chunk list sorted by the chunk number
      dm-bufio: fix non-working memory limit
      dm-bufio: fix a race leading to an unsigned integer underflow
      dm-bufio: clean-up cache size reading

Peng Fan (1):
      dm: use assign_bit() where applicable

Thorsten Blum (2):
      dm-crypt: Use memzero_explicit() to wipe key material
      dm-crypt: Reject malformed raw keys in crypt_set_key()

 .../admin-guide/device-mapper/dm-crypt.rst         |  20 +++-
 Documentation/admin-guide/device-mapper/verity.rst |   5 +
 drivers/md/Kconfig                                 |  14 +++
 drivers/md/dm-bufio.c                              | 104 ++++++++++++---------
 drivers/md/dm-cache-metadata.c                     |   2 +-
 drivers/md/dm-clone-metadata.c                     |   3 -
 drivers/md/dm-crypt.c                              |  53 +++++++----
 drivers/md/dm-delay.c                              |   3 +-
 drivers/md/dm-exception-store.h                    |   2 +-
 drivers/md/dm-mpath.c                              |   5 +-
 drivers/md/dm-pcache/backing_dev.c                 |   2 +-
 drivers/md/dm-ps-historical-service-time.c         |  61 ++++--------
 drivers/md/dm-raid.c                               |   2 +-
 drivers/md/dm-raid1.c                              |   2 +-
 drivers/md/dm-snap-persistent.c                    |   7 +-
 drivers/md/dm-snap.c                               |  18 ++--
 drivers/md/dm-thin.c                               |   3 -
 drivers/md/dm-unstripe.c                           |   2 +-
 drivers/md/dm-vdo/block-map.c                      |   2 +-
 drivers/md/dm-vdo/dm-vdo-target.c                  |   2 +-
 drivers/md/dm-vdo/indexer/chapter-index.c          |  15 ++-
 drivers/md/dm-vdo/indexer/delta-index.c            |  17 +++-
 drivers/md/dm-vdo/indexer/volume.c                 |   6 --
 drivers/md/dm-verity-target.c                      |  39 ++++++--
 drivers/md/dm-verity-verify-sig.c                  |   4 +-
 drivers/md/dm-writecache.c                         |  93 +++++++++++-------
 drivers/md/dm-zone.c                               |   6 +-
 drivers/md/dm.c                                    |   2 +-
 drivers/md/persistent-data/dm-bitset.c             |   5 +-
 drivers/md/persistent-data/dm-btree-remove.c       |   2 +-
 30 files changed, 301 insertions(+), 200 deletions(-)

