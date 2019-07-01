From: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Subject: [RFC PATCH v6 0/1] Add dm verity root hash pkcs7 sig validation.
Date: Mon,  1 Jul 2019 11:19:57 -0700
Message-ID: <20190701181958.6493-1-jaskarankhurana@linux.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gmazyland@gmail.com, ebiggers@google.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, mdsakib@microsoft.com, mpatocka@redhat.com
List-Id: dm-devel.ids

Changes in v6:

Address comments from Milan Broz and Eric Biggers on v5.

-Keep the verification code under config DM_VERITY_VERIFY_ROOTHASH_SIG.

-Change the command line parameter to requires_signatures(bool) which will
force root hash to be signed and trusted if specified.

-Fix the signature not being present in verity_status. Merged the
https://git.kernel.org/pub/scm/linux/kernel/git/mbroz/linux.git/commit/?h=dm-cryptsetup&id=a26c10806f5257e255b6a436713127e762935ad3
made by Milan Broz and tested it.


Jaskaran Khurana (1):
  Add dm verity root hash pkcs7 sig validation.

 Documentation/device-mapper/verity.txt |   7 ++
 drivers/md/Kconfig                     |  12 +++
 drivers/md/Makefile                    |   5 +
 drivers/md/dm-verity-target.c          |  43 +++++++-
 drivers/md/dm-verity-verify-sig.c      | 133 +++++++++++++++++++++++++
 drivers/md/dm-verity-verify-sig.h      |  60 +++++++++++
 drivers/md/dm-verity.h                 |   2 +
 7 files changed, 257 insertions(+), 5 deletions(-)
 create mode 100644 drivers/md/dm-verity-verify-sig.c
 create mode 100644 drivers/md/dm-verity-verify-sig.h

-- 
2.17.1
