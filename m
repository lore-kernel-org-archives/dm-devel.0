Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D00AC7618E
	for <dm-devel@archiver.kernel.org>; Mon, 24 Apr 2023 17:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682356113;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jukdOvKn77YGq8xG1GN8DpU8ZVilkvRse0huo4gbfmU=;
	b=GAPlnRd2nk6iXRhgY76vQ+yMY266uPmZSqLybI931gl4NLv4wnoABECgOfAjH5T6l1rpAj
	pceiFLtMMaM6Cp14JBmyISD7L83czHvskupjSvDhvkKBSYthwDB0kUWRbn9Tg6mjw0Hccb
	PV+1nU2R/yMdQgzg1UtNp+TJG39hmQg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-427-w0-IpIpINzOacZ6CLzthRw-1; Mon, 24 Apr 2023 13:08:32 -0400
X-MC-Unique: w0-IpIpINzOacZ6CLzthRw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20EB6185A791;
	Mon, 24 Apr 2023 17:08:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CB517492B03;
	Mon, 24 Apr 2023 17:08:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BCEAC194658F;
	Mon, 24 Apr 2023 17:08:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DD1DD194658D
 for <dm-devel@listman.corp.redhat.com>; Mon, 24 Apr 2023 17:06:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CDD0B1400AFC; Mon, 24 Apr 2023 17:06:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C59C214171FF
 for <dm-devel@redhat.com>; Mon, 24 Apr 2023 17:06:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7994185A78F
 for <dm-devel@redhat.com>; Mon, 24 Apr 2023 17:06:24 +0000 (UTC)
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com
 [209.85.160.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-CPbuzdctOA25jjIw2Z5Ewg-1; Mon, 24 Apr 2023 13:06:23 -0400
X-MC-Unique: CPbuzdctOA25jjIw2Z5Ewg-1
Received: by mail-qt1-f178.google.com with SMTP id
 d75a77b69052e-3ef38bea86aso23133491cf.3
 for <dm-devel@redhat.com>; Mon, 24 Apr 2023 10:06:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1682355982; x=1684947982;
 h=content-transfer-encoding:content-disposition:mime-version
 :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=7yklLbqlcqtrLAi6NPm1yED06AEzT2zgjyK/N8/omp4=;
 b=TJwFl75cnAKBYD+60tHnzffke7ETG3JfIHUw0eQsWw9evShVUpkFEB6kOXPpOS9dx9
 JTPd/1zi7kF+BnNT5H3A1Zf8YGu4Qur0+mFY66CMFDXM2nyRs6Tcu3++9xP3THQlxc2Y
 t+sRr2KFyuzXD1881W7MHwIJEbwsz01Ppl1XQfN0AFVcMVvtwncHDaXVsrNhLzjx+E4H
 i94gYszWPQ7wgKAy9dvTmd5HHKs6H8qc0lJNt8pNQNDaZQ78ggUZQ2rqQaT1eAQSDrF3
 eWdNyZ5weUVNv/BSbEwf0as/EOYWGaARxwom6lCZfQLk3CQ4TocYTzC/SUTK96neVxAA
 zHDg==
X-Gm-Message-State: AAQBX9f0g0fk/I5SjaL5sP+qruvPc/i3QqPkG7amGRX7OX9ifMnmQyry
 31b3kabb4UCNYfkvWTz2YvorpeQ=
X-Google-Smtp-Source: AKy350brVxKaGhLDydvLKmragyduatuEbwboVV80UVjcEanKSaEuXYLIfGeTGTYCa2/6OOHlbVAMkg==
X-Received: by 2002:a05:622a:44d:b0:3ef:4100:cd0c with SMTP id
 o13-20020a05622a044d00b003ef4100cd0cmr21666840qtx.63.1682355982319; 
 Mon, 24 Apr 2023 10:06:22 -0700 (PDT)
Received: from localhost ([217.138.198.173]) by smtp.gmail.com with ESMTPSA id
 k2-20020a05620a0b8200b0074a6c29df4dsm3695999qkh.119.2023.04.24.10.06.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 24 Apr 2023 10:06:21 -0700 (PDT)
Date: Mon, 24 Apr 2023 13:06:20 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <ZEa3DOLC3GAX/MVx@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [git pull] device mapper changes for 6.4
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Michael =?iso-8859-1?Q?Wei=DF?= <michael.weiss@aisec.fraunhofer.de>,
 Yangtao Li <frank.li@vivo.com>, Yu Zhe <yuzhe@nfschina.com>,
 Tom Rix <trix@redhat.com>, Joe Thornber <ejt@redhat.com>,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, Yeongjin Gil <youngjin.gil@samsung.com>,
 Li Lingfeng <lilingfeng3@huawei.com>, Alasdair G Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

The following changes since commit 666eed46769d929c3e13636134ecfc67d75ef548=
:

  dm: fix __send_duplicate_bios() to always allow for splitting IO (2023-03=
-30 15:54:32 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git =
tags/for-6.4/dm-changes

for you to fetch changes up to 38d11da522aacaa05898c734a1cec86f1e611129:

  dm: don't lock fs when the map is NULL in process of resume (2023-04-19 1=
1:51:37 -0400)

Please pull, thanks.
Mike

----------------------------------------------------------------
- Split dm-bufio's rw_semaphore and rbtree. Offers improvements to
  dm-bufio's locking to allow increased concurrent IO -- particularly
  for read access for buffers already in dm-bufio's cache.

- Also split dm-bio-prison-v1's spinlock and rbtree with comparable
  aim at improving concurrent IO (for the DM thinp target).

- Both the dm-bufio and dm-bio-prison-v1 scaling of the number of
  locks and rbtrees used are managed by dm_num_hash_locks(). And the
  hash function used by both is dm_hash_locks_index().

- Allow DM targets to require DISCARD, WRITE_ZEROES and SECURE_ERASE
  to be split at the target specified boundary (in terms of
  max_discard_sectors, max_write_zeroes_sectors and
  max_secure_erase_sectors respectively).

- DM verity error handling fix for check_at_most_once on FEC.

- Update DM verity target to emit audit events on verification failure
  and more.

- DM core ->io_hints improvements needed in support of new discard
  support that is added to the DM "zero" and "error" targets.

- Fix missing kmem_cache_destroy() call in initialization error path
  of both the DM integrity and DM clone targets.

- A couple fixes for DM flakey, also add "error_reads" feature.

- Fix DM core's resume to not lock FS when the DM map is NULL;
  otherwise initial table load can race with FS mount that takes
  superblock's ->s_umount rw_semaphore.

- Various small improvements to both DM core and DM targets.
-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJfWUX4UqZ4x1O2wixSPxCi2dA1oFAmRGtWwACgkQxSPxCi2d
A1pBqgf/W7op3/PdXBI+tlb7j05MEvMaZx0vz3l+qF36SMglaP1yZLZPiU9MCX2V
Sm2t4p7VEn5gAxvmzqa0/pLINC7u/m1IW9O6y3qdOEFAgwJ2st+/yaDqgguN5kiA
uOzecyDfR7n0WU5rkaO2EUneO7MrYweLR3IROFNFNHndl4bVJOafDcOJvmsI4YYe
5PIMHb+AGND+O2lIVOvSiPD6e85trcRWkr2X6DUYlllV3XEaBLke5MP1OAp+o/Y5
MFPfznnuiEvcFAzsBoDebC5j7RBQjHw12Bp8ltZV1ZFbdvluw9q1GD2/uyR5UolV
jmerZXKThV7lRJYqilUmt74Rxl2JSg=3D=3D
=3DzPkM
-----END PGP SIGNATURE-----

----------------------------------------------------------------
Joe Thornber (8):
      dm bufio: remove unused dm_bufio_release_move interface
      dm bufio: add LRU abstraction
      dm bufio: add dm_buffer_cache abstraction
      dm bufio: improve concurrent IO performance
      dm bufio: add lock_history optimization for cache iterators
      dm thin: speed up cell_defer_no_holder()
      dm bio prison v1: improve concurrent IO performance
      dm: improve hash_locks sizing and hash function

Li Lingfeng (1):
      dm: don't lock fs when the map is NULL in process of resume

Michael Wei=DF (1):
      dm verity: emit audit events on verification failure and more

Mike Snitzer (16):
      dm bufio: use WARN_ON in dm_bufio_client_destroy and dm_bufio_exit
      dm bufio: never crash if dm_bufio_in_request()
      dm bufio: don't bug for clear developer oversight
      dm bufio: move dm_bufio_client members to avoid spanning cachelines
      dm: split discards further if target sets max_discard_granularity
      dm bio prison v1: add dm_cell_key_has_valid_range
      dm: add dm_num_hash_locks()
      dm bufio: prepare to intelligently size dm_buffer_cache's buffer_tree=
s
      dm bufio: intelligently size dm_buffer_cache's buffer_trees
      dm bio prison v1: prepare to intelligently size dm_bio_prison's priso=
n_regions
      dm bio prison v1: intelligently size dm_bio_prison's prison_regions
      dm clone: call kmem_cache_destroy() in dm_clone_init() error path
      dm integrity: call kmem_cache_destroy() in dm_integrity_init() error =
path
      dm: allow targets to require splitting WRITE_ZEROES and SECURE_ERASE
      dm: unexport dm_get_queue_limits()
      dm ioctl: fix nested locking in table_clear() to remove deadlock conc=
ern

Mikulas Patocka (8):
      dm bufio: use waitqueue_active in __free_buffer_wake
      dm bufio: use multi-page bio vector
      dm table: allow targets without devices to set ->io_hints
      dm zero: add discard support
      dm error: add discard support
      dm flakey: fix a crash with invalid table line
      dm flakey: remove trailing space in the table line
      dm flakey: add an "error_reads" option

Tom Rix (1):
      dm raid: remove unused d variable

Yangtao Li (3):
      dm: push error reporting down to dm_register_target()
      dm mirror: add DMERR message if alloc_workqueue fails
      dm: add helper macro for simple DM target module init and exit

Yeongjin Gil (1):
      dm verity: fix error handling for check_at_most_once on FEC

Yu Zhe (1):
      dm: remove unnecessary (void*) conversions

 .../admin-guide/device-mapper/dm-flakey.rst        |    4 +
 drivers/md/dm-bio-prison-v1.c                      |   94 +-
 drivers/md/dm-bio-prison-v1.h                      |   15 +
 drivers/md/dm-bufio.c                              | 1988 ++++++++++++++--=
----
 drivers/md/dm-cache-target.c                       |    1 -
 drivers/md/dm-clone-target.c                       |    2 +-
 drivers/md/dm-crypt.c                              |   20 +-
 drivers/md/dm-delay.c                              |   26 +-
 drivers/md/dm-dust.c                               |   19 +-
 drivers/md/dm-ebs-target.c                         |   19 +-
 drivers/md/dm-era-target.c                         |   22 +-
 drivers/md/dm-flakey.c                             |   71 +-
 drivers/md/dm-integrity.c                          |   15 +-
 drivers/md/dm-io.c                                 |    4 +-
 drivers/md/dm-ioctl.c                              |   12 +-
 drivers/md/dm-kcopyd.c                             |    4 +-
 drivers/md/dm-linear.c                             |    6 +-
 drivers/md/dm-log-writes.c                         |   21 +-
 drivers/md/dm-log.c                                |   24 +-
 drivers/md/dm-mpath.c                              |    5 +-
 drivers/md/dm-raid.c                               |   22 +-
 drivers/md/dm-raid1.c                              |   24 +-
 drivers/md/dm-snap-persistent.c                    |    2 +-
 drivers/md/dm-snap.c                               |   12 +-
 drivers/md/dm-stripe.c                             |    4 +-
 drivers/md/dm-switch.c                             |   20 +-
 drivers/md/dm-table.c                              |    6 +-
 drivers/md/dm-target.c                             |   20 +-
 drivers/md/dm-thin.c                               |  125 +-
 drivers/md/dm-unstripe.c                           |   14 +-
 drivers/md/dm-verity-fec.c                         |    4 +-
 drivers/md/dm-verity-target.c                      |   42 +-
 drivers/md/dm-writecache.c                         |   22 +-
 drivers/md/dm-zero.c                               |   31 +-
 drivers/md/dm-zoned-metadata.c                     |    6 +-
 drivers/md/dm-zoned-target.c                       |   16 +-
 drivers/md/dm.c                                    |   47 +-
 drivers/md/dm.h                                    |   22 +
 include/linux/device-mapper.h                      |   40 +-
 include/linux/dm-bufio.h                           |    6 -
 include/uapi/linux/dm-ioctl.h                      |    4 +-
 41 files changed, 1777 insertions(+), 1084 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

