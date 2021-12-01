Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B44C433F5
	for <dm-devel@archiver.kernel.org>; Wed,  1 Dec 2021 07:48:20 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-vCqs5gK7OgKXo6nbLUaqZw-1; Wed, 01 Dec 2021 02:48:16 -0500
X-MC-Unique: vCqs5gK7OgKXo6nbLUaqZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF8E4760C6;
	Wed,  1 Dec 2021 07:48:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 601115D6CF;
	Wed,  1 Dec 2021 07:48:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E75161809CB7;
	Wed,  1 Dec 2021 07:48:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B15IIqA008733 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 1 Dec 2021 00:18:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A094B492C3B; Wed,  1 Dec 2021 05:18:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C4D1492C38
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8326F802E5E
	for <dm-devel@redhat.com>; Wed,  1 Dec 2021 05:18:18 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-512-eotrEMWjM-OOAkSZsD1i7g-1; Wed, 01 Dec 2021 00:18:16 -0500
X-MC-Unique: eotrEMWjM-OOAkSZsD1i7g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1D4B61FD2F;
	Wed,  1 Dec 2021 05:18:15 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2003713425;
	Wed,  1 Dec 2021 05:18:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 9GSjN5UFp2EGbwAAMHmgww
	(envelope-from <wqu@suse.com>); Wed, 01 Dec 2021 05:18:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Date: Wed,  1 Dec 2021 13:17:39 +0800
Message-Id: <20211201051756.53742-1-wqu@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B15IIqA008733
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 01 Dec 2021 02:47:50 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: [dm-devel] [PATCH 00/17] btrfs: split bio at btrfs_map_bio() time
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

Although this behavior works fine, it's against the common practice used in
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
  We want the existing granularity, instead of chained endio, thus we
  must make the involved endio functions to handle split bios.

  Although most endio functions are already doing their works
  independent of the bio size, they are not yet fully handling split
  bio.

  This patch will convert them to use saved bi_iter and only iterate
  the split range instead of the whole bio.
  This change involved 3 types of IOs:

  * Buffered IO
    Including both data and metadata
  * Direct IO
  * Compressed IO

  Their endio functions needs different level of updates to handle split
  bios.

  Furthermore, there is another endio, end_workqueue_bio(), it can't
  handle split bios at all, thus we change the timing so that
  btrfs_bio_wq_end_io() is only called after the bio being split.

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
  read every sectors, to handle the following case: (X means bad, either
  unable to read or failed to pass checksum verification, V means good)

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

- Bad RAID56 naming/functionality
  There are quite some RAID56 call sites relies on specific behavior on
  __btrfs_map_block(), like returning @map_length as stripe_len other
  than real mapped length.

  This is handled by some small cleanups specific for RAID56.

[NEED FEEDBACK]
In this refactor, btrfs is utilizing a lot of call sites like:

 btrfs_bio_save_iter();	// Save bi_iter into some other location
 __bio_for_each_segment(bvec, bio, iter, btrfs_bio->iter) {
	/* Doing endio for each bvec */
 }

And manually implementing an endio which does some work of
__bio_chain_endio() but with extra btrfs specific workload.

I'm wondering if block layer is fine to provide some *enhanced* chain
bio facilities?

[CHANGELOG]
RFC->v1:
- Better patch split
  Now patch 01~06 are refactors/cleanups/preparations.
  While 07~13 are the patches that doing the conversion while can handle
  both old and new bio split timings.
  Finally patch 14~16 convert the bio split call sites one by one to
  newer facility.
  The final patch is just a small clean up.

- Various bug fixes
  During the full fstests run, various stupid bugs are exposed and
  fixed.

Qu Wenruo (17):
  btrfs: update an stale comment on btrfs_submit_bio_hook()
  btrfs: save bio::bi_iter into btrfs_bio::iter before submitting
  btrfs: use correct bio size for error message in btrfs_end_dio_bio()
  btrfs: refactor btrfs_map_bio()
  btrfs: move btrfs_bio_wq_end_io() calls into submit_stripe_bio()
  btrfs: replace btrfs_dio_private::refs with
    btrfs_dio_private::pending_bytes
  btrfs: introduce btrfs_bio_split() helper
  btrfs: make data buffered read path to handle split bio properly
  btrfs: make data buffered write endio function to be split bio
    compatible
  btrfs: make metadata write endio functions to be split bio compatible
  btrfs: make dec_and_test_compressed_bio() to be split bio compatible
  btrfs: return proper mapped length for RAID56 profiles in
    __btrfs_map_block()
  btrfs: allow btrfs_map_bio() to split bio according to chunk stripe
    boundaries
  btrfs: remove buffered IO stripe boundary calculation
  btrfs: remove stripe boundary calculation for compressed IO
  btrfs: remove the stripe boundary calculation for direct IO
  btrfs: unexport btrfs_get_io_geometry()

 fs/btrfs/btrfs_inode.h |  10 +-
 fs/btrfs/compression.c |  70 +++-----------
 fs/btrfs/disk-io.c     |   9 +-
 fs/btrfs/extent_io.c   | 189 +++++++++++++++++++++++++------------
 fs/btrfs/extent_io.h   |   2 +
 fs/btrfs/inode.c       | 210 ++++++++++++++++-------------------------
 fs/btrfs/raid56.c      |  14 ++-
 fs/btrfs/raid56.h      |   2 +-
 fs/btrfs/scrub.c       |   4 +-
 fs/btrfs/volumes.c     | 157 ++++++++++++++++++++++--------
 fs/btrfs/volumes.h     |  75 +++++++++++++--
 11 files changed, 435 insertions(+), 307 deletions(-)

-- 
2.34.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

