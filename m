From: behanw@converseincode.com
Subject: [PATCH RFC 0/6] LLVMLinux: Patches to enable the kernel to be compiled with clang/LLVM
Date: Tue,  2 Sep 2014 15:32:27 -0700
Message-ID: <1409697153-7006-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-crypto-owner@vger.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
To: agk@redhat.com, clm@fb.com, davem@davemloft.net, dm-devel@redhat.com, fabf@skynet.be, herbert@gondor.apana.org.au, jbacik@fb.com, snitzer@redhat.com
Cc: akpm@linux-foundation.org, james.l.morris@oracle.com, john.johansen@canonical.com, linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org, neilb@suse.de, serge@hallyn.com, torvalds@linux-foundation.org, Behan Webster <behanw@converseincode.com>
List-Id: dm-devel.ids

=46rom: Behan Webster <behanw@converseincode.com>

These patches remove the use of Variable Length Arrays In Structs (VLAI=
S) in
crypto related code. Presented here for comments as a whole (since they=
 all do
the same thing in the same way). Once everyone is happy I will submit t=
hem
individually to their appropriate maintainers.

The LLVMLinux project aims to fully build the Linux kernel using both g=
cc and
clang (the C front end for the LLVM compiler infrastructure project).=20


Jan-Simon M=C3=B6ller (4):
  crypto, dm: LLVMLinux: Remove VLAIS usage from dm-crypt
  crypto: LLVMLinux: Remove VLAIS usage from crypto/hmac.c
  crypto: LLVMLinux: Remove VLAIS usage from libcrc32c.c
  crypto: LLVMLinux: Remove VLAIS usage from crypto/testmgr.c

Vin=C3=ADcius Tinti (2):
  apparmor: LLVMLinux: Remove VLAIS
  btrfs: LLVMLinux: Remove VLAIS

 crypto/hmac.c              | 27 +++++++++++++--------------
 crypto/testmgr.c           | 16 ++++++++--------
 drivers/md/dm-crypt.c      | 38 ++++++++++++++++++--------------------
 fs/btrfs/hash.c            | 18 +++++++++---------
 lib/libcrc32c.c            | 18 +++++++++---------
 security/apparmor/crypto.c | 19 +++++++++----------
 6 files changed, 66 insertions(+), 70 deletions(-)

--=20
1.9.1
