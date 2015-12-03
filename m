From: Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH v2 0/2] dm verity: add support for error correction
Date: Thu,  3 Dec 2015 14:26:29 +0000
Message-ID: <1449152791-33586-1-git-send-email-samitolvanen@google.com>
References: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446688954-29589-1-git-send-email-samitolvanen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Mandeep Baines <msb@chromium.org>, Will Drewry <wad@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Mark Salyzyn <salyzyn@google.com>, Sami Tolvanen <samitolvanen@google.com>
List-Id: dm-devel.ids

Changes since v1:

  - Added CONFIG_DM_VERITY_FEC and split error correction into
    dm-verity-fec.[ch] to further separate the functionality from the
    rest of dm-verity. Follows the same pattern as dm-uevent.

  - Added missing dependencies for REED_SOLOMON to Kconfig.

  - Renamed dm-verity.c to dm-verity-target.c to allow an optional
    object to be added. Follows the naming convention of dm-cache and
    dm-era.

  - Changed the algorithm to work with one or more small buffers (~4k)
    instead of a single large one. The more buffers we can allocate,
    the faster it will work, but we don't have to preallocate a large
    amount of memory anymore.

  - Changed memory allocation to use mempools. v2 preallocates all the
    memory required for each worker thread to guarantee forward
    progress in case of memory pressure. The code attempts to allocate
    more buffers (using GFP_NOIO) and uses them if available.

  - Added graceful handling of IO errors, which are now treated as any
    other corruption.

  - Rebased against linux-dm/for-next.

Sami Tolvanen (2):
  dm verity: add support for forward error correction
  dm verity: ignore zero blocks

 Documentation/device-mapper/verity.txt         |  30 +
 drivers/md/Kconfig                             |  12 +
 drivers/md/Makefile                            |   5 +
 drivers/md/dm-verity-fec.c                     | 836 +++++++++++++++++++++++++
 drivers/md/dm-verity-fec.h                     | 146 +++++
 drivers/md/{dm-verity.c => dm-verity-target.c} | 320 ++++++----
 drivers/md/dm-verity.h                         | 129 ++++
 7 files changed, 1343 insertions(+), 135 deletions(-)
 create mode 100644 drivers/md/dm-verity-fec.c
 create mode 100644 drivers/md/dm-verity-fec.h
 rename drivers/md/{dm-verity.c => dm-verity-target.c} (82%)
 create mode 100644 drivers/md/dm-verity.h

-- 
2.6.0.rc2.230.g3dd15c0
