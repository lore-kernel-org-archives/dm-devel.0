Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794745867;
	b=ZIwrXqzgoexeNDcxXlgdABeVN62ommJcAoLTJpriNZcSbNkf1xaWB9PgEuHAM00psG5w
	 AMpSjfuA0hFPacDTY5jfOVunM7ZgtkhGrpdxgRK8B2wSk2tdTMBSL6LoyKEDRifbPltyO
	 m6pbwtKAsNq6VQVqExE4IqHpHUB4Y0Gro64uPr2OyanyHwbjgZUJ7XqKxBISKt3uktjJT
	 qrwT0pHukKN5k116Zn6MwkQGj+Ob8HpL7uaZhPC264Rx3KFpBrXowrMlqsPHeQs8RFYwu
	 ZY6Kf25HD7ClEj9RfUbMelCBO42mI7fkix+Z53yubFCDyKScOtspyEVZtc64m7RwbIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794745867;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 Message-ID:MIME-Version:X-Scanned-By:X-Mimecast-Spam-Score:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=W1NX3pFKuRakR7SIfO2NNKbWc095G4Meefy9enNCxIM=;
	b=Jhdw6IpkyyJieIkSRxtdbe+9mHkgZPKYjSFlkvVcTcMgphGDbsQkpeoHCzb6UiTeY78Q
	 jWlaz3U9w4xyEd0uJCAHc7/pY30WMFiS5gHz+5VvGROCTfz6Cv18HEtwKKzotMHtfw4uh
	 pmz22sAAMgTwQwa3sVPNHlmJrVDzEf2CKFV8nucljaWVGDyvP2fFxXLa2ffJI7/Xly6D1
	 PW2dzgi2nEBFd20BSPwQhNrhaI04Z0zevXA7K5EOGz94AjpmWprtqwoCNxLVqoFs5V8uW
	 kPEOUAI4KjnTTvwvYsJLHaKAz62POhcOflHkl4oPfm4QKOgzZg4FVNsSADFGHB60sTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RxxJsDtK;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6DC606A31E
	for <dm-devel@lists.linux.dev>; Sun, 15 Nov 2026 12:31:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC6DC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=RxxJsDtK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794745865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=W1NX3pFKuRakR7SIfO2NNKbWc095G4Meefy9enNCxIM=;
	b=RxxJsDtKn2Eg/FrU+FatS6pEug1iNyaOR2vBbpD4cFj8bdiKSXp2l3NrB/eP+F04jGx7NH
	iS/5+XTLQc8AkchkkELg1PnyWceZUrVuKWVOpjR1V1NiPQCtPKlr9jVpFDjbE6zxSj3HZl
	rFh7a9HL8DdrwSLXD0CeU4TXfbeJ0W4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-335-LuxTgP5tOhqDkQvxPSwzQg-1; Sun,
 15 Nov 2026 07:31:01 -0500
X-MC-Unique: LuxTgP5tOhqDkQvxPSwzQg-1
X-Mimecast-MFC-AGG-ID: LuxTgP5tOhqDkQvxPSwzQg_1794745859
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4BFDB1955EA3;
	Sun, 15 Nov 2026 12:30:57 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E76D418004F7;
	Sun, 15 Nov 2026 12:30:48 +0000 (UTC)
Date: Sun, 15 Nov 2026 13:30:46 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Daejun Park <daejun7.park@samsung.com>, 
    Edward Adam Davis <eadavis@sina.com>, guolingxing <guolingxing@tju.edu.cn>, 
    Chen Cheng <chencheng@fnnas.com>, Jay Vadayath <jay@artiphishell.com>, 
    Josef Schlehofer <pepe.schlehofer@gmail.com>, 
    Kirtikumar Anandrao Ramchandani <kirtiar15502@gmail.com>, 
    Kyrylo Biryuk <illofspeed@gmail.com>, Li Youhong <liyouhong@kylinos.cn>, 
    Mark Bundschuh <mkbund@amazon.com>, Ming-Hung Tsai <mtsai@redhat.com>, 
    "shao.mingyin" <shao.mingyin@zte.com.cn>, 
    Sinan Polat <sinan86polat@gmail.com>, 
    Weijiang Zhou <weijiang.zhou@unisoc.com>, 
    wuyuehong <wuyuehong@cmss.chinamobile.com>, 
    xietangxin <xietangxin@h-partners.com>, 
    Yaohan Li <shunsheng1218@gmail.com>, 
    Yingjie Wang <x-professor@outlook.com>, Yingjie Wang <1075151112@qq.com>, 
    Zhao Feng <zhaofeng2@cmss.chinamobile.com>, dm-devel@lists.linux.dev
Subject: [git pull] device mapper fixes for 7.4
Message-ID: <44a2bbbf-26a6-931b-68f5-decd011ad19f@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: enX71tTClNQ9ytdko5G_e8Rod0J37Yn9Q_yajgRQUns_1794745859
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi Linus

The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-7.4/dm-fixes

for you to fetch changes up to e92cd41e8e5ee5616c6c7cd4378661d942f0a7c0:

  dm: fail a REQ_PREFLUSH bio with data when its preflush fails (2026-11-13 22:18:14 +0100)

Please, pull. Thanks.

Mikulas

----------------------------------------------------------------
dm:
 - fix infinite loop when removing a zoned device
 - fix misbehavior if kobject_init_and_add fails
 - fix refcount underflow if zone reset failed
 - fix misbehavior if we attempt to load a table after previous table
   load failed
 - fix use-after-free if we open a device read-only and then re-open it
   read-write
 - fix error being ignored if flush failed

dm-pcache:
 - fix misbehavior on flush failure

dm-raid:
 - validate array_position after it is read from the superblock

dm-cache:
 - fix a crash if dm_kcopyd_client_create fails
 - fix divide by zero on extremely large device
 - fix NULL pointer dereference on open failure
 - fix misbehavior if dm_bitset_cursor_begin fails

dm-snapshot:
 - properly advertise discard_granularity in the queue limits
 - fix data corruption on unaligned discards

dm-crypt:
 - fix a crash on invalid table line
 - fix scheduling in atomic context when using no_write_workqueue and
   asynchronous completion cipher
 - fix misbehavior if percpu_counter_init fails

dm-thin:
 - fix integer overflow if no_space_timeout is too high
 - fix data corruption if discard races with regular I/O
 - fix leak if __set_snapshot_details fails
 - fix parsing of feature arguments

dm-mpath:
 - fix buffer overflow when parsing the table string
 - fix integer overflow in queue_if_no_path_timeout_secs

dm-log-userspace:
 - fix open device leak on initialization error

dm-zoned:
 - back off when reclaim cannot make progress
 - do not reclaim a random zone into another random zone

dm-integrity:
 - don't recalculate with HMAC because of a dirty bitmap
 - don't attempt to commit journal on disabled device

dm-persistent-data:
 - don't ignore the return value of node_copy
 - fix buffer leak if find_leaf fails

dm-verity:
 - don't restart or panic on errors during system shutdown

dm-raid:
 - flush a work item in raid_dtr, fix use-after-free
-----BEGIN PGP SIGNATURE-----

iIoEABYKADIWIQRnH8MwLyZDhyYfesYTAyx9YGnhbQUCavmh5xQcbXBhdG9ja2FA
cmVkaGF0LmNvbQAKCRATAyx9YGnhbUIJAP0VOhn3E0tgcZD1ubnywmancR6pgsnR
e8iLmafZubLvSAEAwqc9m31fcb8LUUMfehLJhfn2KrFqK4qXmRkf7wYWQwM=
=L52n
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Chen Cheng (2):
      dm snapshot: split discards on chunk boundaries
      dm snapshot: fix discard writing into the next COW chunk

Daejun Park (1):
      dm: fail a REQ_PREFLUSH bio with data when its preflush fails

Edward Adam Davis (1):
      dm cache: reject kcopyd client destory if it setup failed

Jay Vadayath (1):
      dm-raid: bound array_position before indexing failed_devices

Josef Schlehofer (1):
      dm-crypt: defer async write submission to write thread

Kirtikumar Anandrao Ramchandani (2):
      dm: Reject table setup after queue or disk teardown
      dm cache: validate the discard block size before narrowing

Kyrylo Biryuk (2):
      dm zoned: back off when reclaim cannot make progress
      dm zoned: do not reclaim a random zone into another random zone

Li Youhong (1):
      dm-raid: fix use-after-free in raid_dtr()

Mark Bundschuh (1):
      dm: fix infinite loop in dm_blk_do_report_zones()

Mikulas Patocka (10):
      dm-sysfs: fix misbehavior if kobject_init_and_add fails
      dm-cache: fix NULL pointer dereference on open failure
      dm-cache: fix ending a cursor that never began
      dm-thin: fix data corruption if discard races with regular I/O
      dm-thin: fix leak if __set_snapshot_details fails
      dm-thin: fix parsing of feature arguments
      dm persistent data: test return value of node_copy
      dm persistent data: don't ignore writeback errors
      dm persistent data: don't leak bufio buffer if find_leaf fails
      dm-integrity: don't attempt to commit journal on disabled device

Ming-Hung Tsai (1):
      dm: fix use-after-free when dm_get_device() widens the open mode

Sinan Polat (1):
      dm-integrity: don't recalculate with HMAC because of a dirty bitmap

Weijiang Zhou (1):
      dm-verity: don't restart or panic on errors during system shutdown

Yaohan Li (1):
      dm: avoid double-dropping the zone reset submission reference

Yingjie Wang (2):
      dm thin: avoid wrapping no_space_timeout
      dm mpath: cap queue_if_no_path_timeout_secs

Zhao Feng (1):
      dm crypt: fix use of uninitialized percpu_counter in ctr error path

guolingxing (1):
      dm-pcache: do not advance dirty_tail after backing flush failure

shao.mingyin@zte.com.cn (2):
      dm mpath: fix buffer overflow in parse_hw_handler()
      dm log userspace: drop the device reference on error

wuyuehong (1):
      dm snapshot: fix discard_granularity unit in snapshot_io_hints

xietangxin (1):
      dm-crypt: reject integrity_key_size with non-authenc AEAD ciphers

 drivers/md/dm-cache-metadata.c                   |   4 +-
 drivers/md/dm-cache-target.c                     |  15 ++-
 drivers/md/dm-crypt.c                            |  22 ++--
 drivers/md/dm-integrity.c                        |  30 ++++-
 drivers/md/dm-ioctl.c                            |   2 +-
 drivers/md/dm-log-userspace-base.c               |   6 +-
 drivers/md/dm-mpath.c                            |   6 +-
 drivers/md/dm-pcache/backing_dev.c               |   4 +-
 drivers/md/dm-pcache/backing_dev.h               |   2 +-
 drivers/md/dm-pcache/cache_writeback.c           |  28 +++--
 drivers/md/dm-raid.c                             |   5 +-
 drivers/md/dm-snap.c                             |  18 +--
 drivers/md/dm-sysfs.c                            |  17 ++-
 drivers/md/dm-table.c                            | 142 +++++++++++++----------
 drivers/md/dm-thin-metadata.c                    |   5 +-
 drivers/md/dm-thin.c                             |   7 +-
 drivers/md/dm-verity-target.c                    |  27 +++--
 drivers/md/dm-zone.c                             |   2 +
 drivers/md/dm-zoned-reclaim.c                    |  18 ++-
 drivers/md/dm.c                                  |  21 +++-
 drivers/md/dm.h                                  |  18 ++-
 drivers/md/persistent-data/dm-btree-remove.c     |  13 ++-
 drivers/md/persistent-data/dm-btree.c            |   8 +-
 drivers/md/persistent-data/dm-space-map-common.c |   9 +-
 24 files changed, 298 insertions(+), 131 deletions(-)

