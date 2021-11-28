Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD002C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 29 Nov 2021 06:56:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-QtvQhvBaM5Ce71IHJ5VizA-1; Mon, 29 Nov 2021 01:56:36 -0500
X-MC-Unique: QtvQhvBaM5Ce71IHJ5VizA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE0ED1030C23;
	Mon, 29 Nov 2021 06:56:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9652E100E125;
	Mon, 29 Nov 2021 06:56:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 457DF1802E27;
	Mon, 29 Nov 2021 06:56:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AS5rMre027028 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 28 Nov 2021 00:53:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4FF1FC23DB5; Sun, 28 Nov 2021 05:53:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B2E4C23DB3
	for <dm-devel@redhat.com>; Sun, 28 Nov 2021 05:53:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 322EE185A7B2
	for <dm-devel@redhat.com>; Sun, 28 Nov 2021 05:53:22 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-336-LTedDHyPN7CG9DuadI7EFg-1; Sun, 28 Nov 2021 00:53:20 -0500
X-MC-Unique: LTedDHyPN7CG9DuadI7EFg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CC2B1212FE;
	Sun, 28 Nov 2021 05:53:18 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5BCCD13446;
	Sun, 28 Nov 2021 05:53:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id puH8Ck0Zo2G7fAAAMHmgww
	(envelope-from <wqu@suse.com>); Sun, 28 Nov 2021 05:53:17 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Sun, 28 Nov 2021 13:52:48 +0800
Message-Id: <20211128055259.39249-1-wqu@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AS5rMre027028
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 29 Nov 2021 01:55:52 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH RFC 00/11] btrfs: split bio at btrfs_map_bio()
	time
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

[BACKGROUND]

Currently btrfs never uses bio_split() to split its bio against RAID
stripe boundaries.

Instead inside btrfs we check our stripe boundary everytime we allocate
a new bio, and ensure the new bio never cross stripe boundaries.

[PROBLEMS]

Although this works fine, it's against the common practice used in
stacked drivers, and is making the effort to convert to iomap harder.

There is also an hidden burden, every time we allocate a new bio, we uses
BIO_MAX_BVECS, but since we know the boundaries, for RAID0/RAID10 we can
only fit at most 16 pages (fixed 64K stripe size, and 4K page size),
wasting the 256 slots we allocated.

[CHALLENGES]

To change the situation, this patchset attempts to improve the situation
by moving the bio split into btrfs_map_bio() time, so upper layer should
no longer bother the bio split against RAID stripes or even chunk
boundaries.

But there are several challenges:

- Conflicts in various endio functions
  There is a special endio function, end_workqueue_bio(), that if a bio
  has this endio function, and get split, we will double free the
  btrfs_end_io_wq_cache.

  And some hidden RAID56 endio also has this problem.

  For RAID56 problems, it's remaining to be solved in the v1 version.
  But for end_workqueue_bio() it can be moved after bios been split.

- Checksum verification
  Currently we rely on btrfs_bio::csum to contain the checksum for the
  whole bio.
  If one bio get split, csum will no longer points to the correct
  location for the split bio.

  This can be solved by introducing btrfs_bio::offset_to_original, and
  use that new member to calculate where we should read csum from.

  For the parent bio, it still has btrfs_bio::csum for the whole bio,
  thus it can still free it correctly.

- Independent endio for each split bio
  Unlike stack drivers, for RAID10 btrfs needs to try its best effort to
  read every sectors, to handle the following case:

  Dev 1	(missing) | D1 (X) |
  Dev 2 (OK)	  | D1 (V) |
  Dev 3 (OK)	  | D2 (V) |
  Dev 4 (OK)	  | D2 (X) |

  In the above RAID10 case, dev1 is missing, and although dev4 is fine,
  its D2 sector is corrupted (by bit rot or whatever).

  If we use bio_chain(), read bio for both D1 and D2 will be split, and
  since D1 is missing, the whole D1 and D2 read will be marked as error,
  thus we will try to read from dev2 and dev4.

  But D2 in dev4 has csum mismatch, we can only rebuild D1 and D2
  correctly from dev2:D1 and dev3:D2.

  This patchset resolve this by saving bi_iter into btrfs_bio::iter, and
  uses that at endio to iterate only the split part of an bio.
  Other than this, existing read/write page endio functions can handle
  them properly without problem.

[RFC]
The patchset is only lightly tested, as there is still some endio
conflicts in the ancient RAID56 code.

But despite that, regular buffered read/write and repair should work
without problem.

This patchset is sent because above mentioned challenges, all the
solutions need extra review/feedback, not only from btrfs community but
also block layer community, to determine if this is really the best
solution.

Qu Wenruo (11):
  btrfs: update an stale comment on btrfs_submit_bio_hook()
  btrfs: refactor btrfs_map_bio()
  btrfs: move btrfs_bio_wq_end_io() calls into submit_stripe_bio()
  btrfs: introduce btrfs_bio_split() helper
  btrfs: save bio::bi_iter into btrfs_bio::iter before submitting
  btrfs: make end_bio_extent_readpage() to handle split bio properly
  btrfs: make end_bio_extent_*_writepage() to handle split biot properly
  btrfs: allow btrfs_map_bio() to split bio according to chunk stripe
    boundaries
  btrfs: remove bio split operations in btrfs_submit_direct()
  btrfs: remove btrfs_bio_ctrl::len_to_stripe_boundary
  btrfs: temporarily disable RAID56

 fs/btrfs/compression.c |   7 +-
 fs/btrfs/ctree.h       |   5 +-
 fs/btrfs/disk-io.c     |   9 +-
 fs/btrfs/extent_io.c   | 183 +++++++++++++++++++++++++++--------------
 fs/btrfs/extent_io.h   |   3 +-
 fs/btrfs/inode.c       | 153 +++++++++++-----------------------
 fs/btrfs/raid56.c      |   2 +
 fs/btrfs/volumes.c     | 138 ++++++++++++++++++++++++-------
 fs/btrfs/volumes.h     |  72 +++++++++++++++-
 9 files changed, 358 insertions(+), 214 deletions(-)

-- 
2.34.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

