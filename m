From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2] blk: improve order of bio handling in generic_make_request()
Date: Fri, 10 Mar 2017 15:32:21 +1100
Message-ID: <87d1dphhuy.fsf@notabene.neil.brown.name>
References: <87h93blz6g.fsf@notabene.neil.brown.name> <71562c2c-97f4-9a0a-32ec-30e0702ca575@profitbricks.com> <87lgsjj9w8.fsf@notabene.neil.brown.name> <a674456d-fb93-437e-c50e-195e7a035ba4@kernel.dk> <87r328j00i.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <87r328j00i.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Jack Wang <jinpu.wang@profitbricks.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>, Pavel Machek <pavel@ucw.cz>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

--=-=-=
Content-Type: text/plain


I started looking further at the improvements we can make once
generic_make_request is fixed, and realised that I had missed an
important detail in this patch.
Several places test current->bio_list, and two actually edit the list.
With this change, that cannot see the whole lists, so it could cause a
regression.

So I've revised the patch to make sure that the entire list of queued
bios remains visible, and change the relevant code to look at both
the new list and the old list.

Following that there are some patches which make the rescuer thread
optional, and then starts removing it from some easy-to-fix places.

The series summary is below.

NeilBrown


NeilBrown (5):
      blk: improve order of bio handling in generic_make_request()
      blk: remove bio_set arg from blk_queue_split()
      blk: make the bioset rescue_workqueue optional.
      blk: use non-rescuing bioset for q->bio_split.
      block_dev: make blkdev_dio_pool a non-rescuing bioset


 block/bio.c                         |   39 +++++++++++++++++++++++++++------
 block/blk-core.c                    |   42 ++++++++++++++++++++++++++++-------
 block/blk-merge.c                   |    7 +++---
 block/blk-mq.c                      |    4 ++-
 drivers/block/drbd/drbd_main.c      |    2 +-
 drivers/block/drbd/drbd_req.c       |    2 +-
 drivers/block/pktcdvd.c             |    2 +-
 drivers/block/ps3vram.c             |    2 +-
 drivers/block/rsxx/dev.c            |    2 +-
 drivers/block/umem.c                |    2 +-
 drivers/block/zram/zram_drv.c       |    2 +-
 drivers/lightnvm/rrpc.c             |    2 +-
 drivers/md/bcache/super.c           |    4 ++-
 drivers/md/dm-crypt.c               |    2 +-
 drivers/md/dm-io.c                  |    2 +-
 drivers/md/dm.c                     |   32 +++++++++++++++------------
 drivers/md/md.c                     |    4 ++-
 drivers/md/raid10.c                 |    3 ++-
 drivers/md/raid5-cache.c            |    2 +-
 drivers/s390/block/dcssblk.c        |    2 +-
 drivers/s390/block/xpram.c          |    2 +-
 drivers/target/target_core_iblock.c |    2 +-
 fs/btrfs/extent_io.c                |    4 ++-
 fs/xfs/xfs_super.c                  |    2 +-
 include/linux/bio.h                 |    2 ++
 include/linux/blkdev.h              |    3 +--
 26 files changed, 114 insertions(+), 60 deletions(-)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljCLFUACgkQOeye3VZi
gbnoWA/8DKkzvIQ3LnMsWiX4lFZU4391O3AoQadW9ZNtbJwoh3+RRUWur75KTXUa
xSlhbhMrLlbsx+BBq9tI7lKQKpHrM3WKCTlWqaEZF7ApgZiZLRstclXjb2+Obz75
DVRSk8ypsfi6RGcFips98/Ol3TrshqBPWnQhuYSZJEAedHJx9/gCVh0d+fbijOLd
z7KYXRZVig9jwubcn6eGu82BSFT3BscptaSnAfvinS29wuzmRXyyNcFsL69B8THZ
BF3u6A9VHUXtiZNJAIE5xxG7xcEX/yzDsVy5d5KUwAff4Qc9P7szZclT1iCTGz/Q
Z00bWb1XRByMmGmE9aVX+9GZy0iHmZuougz0Pv8pKIAI1l6ciZPboG9nibQM1911
XYzdwbv88vdMcZ+iKPyuvASqA58hRB8eZx7S1xkCzBF1rIOe3d4WCxISZmt/KzFs
+ktPbyawVaeMO4Dl64bbdDhGtxg4CohdRGrUGUoGXRUSEuQKcEVnQXA9PxaRad2f
PijZTF7n9UJH3m/DM32R1+jCYuFw0kkyV5iOslwJFp5xJ2s1wJbJoTJg65CCgTyx
Xid1VKxhSvjXZZjqC05gJVaXwbL5rdnpFDlkbbK7mlY7yYCegQaXwuVZ+Zd6sM4l
+f8wd+NdwI9YT01WCo+Y+o0sVzrFagxsHqGjPT9ezNLJ/Wtz59Q=
=bzg3
-----END PGP SIGNATURE-----
--=-=-=--
