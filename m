From: Jaskaran Khurana <jaskarankhurana@linux.microsoft.com>
Subject: [RFC PATCH v3 0/1] Add dm verity root hash pkcs7 sig validation.
Date: Fri,  7 Jun 2019 15:31:39 -0700
Message-ID: <20190607223140.16979-1-jaskarankhurana@linux.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, jmorris@namei.org, scottsh@microsoft.com, ebiggers@google.com, mpatocka@redhat.com
List-Id: dm-devel.ids

This patch set adds in-kernel pkcs7 signature checking for the roothash of
the dm-verity hash tree.
The verification is to support cases where the roothash is not secured by
Trusted Boot, UEFI Secureboot or similar technologies.
One of the use cases for this is for dm-verity volumes mounted after boot,
the root hash provided during the creation of the dm-verity volume has to
be secure and thus in-kernel validation implemented here will be used
before we trust the root hash and allow the block device to be created.

Why we are doing validation in the Kernel?

The reason is to still be secure in cases where the attacker is able to
compromise the user mode application in which case the user mode validation
could not have been trusted.
The root hash signature validation in the kernel along with existing
dm-verity implementation gives a higher level of confidence in the
executable code or the protected data. Before allowing the creation of
the device mapper block device the kernel code will check that the detached
pkcs7 signature passed to it validates the roothash and the signature is
trusted by builtin keys set at kernel creation. The kernel should be
secured using Verified boot, UEFI Secure Boot or similar technologies so we
can trust it.

What about attacker mounting non dm-verity volumes to run executable
code?

This verification can be used to have a security architecture where a LSM
can enforce this verification for all the volumes and by doing this it can
ensure that all executable code runs from signed and trusted dm-verity
volumes.

Further patches will be posted that build on this and enforce this
verification based on policy for all the volumes on the system.

How are these changes tested?

veritysetup part of cryptsetup library was modified to take a optional
root-hash-sig parameter.

Commandline used to test the changes:

veritysetup open  <data_device> <name> <hash_device> <root_hash>
 --root-hash-sig=<root_hash_pkcs7_detached_sig>

The changes for veritysetup are in a topic branch for now at:
https://github.com/jaskarankhurana/veritysetup/tree/veritysetup_add_sig

Changelog:

v3:
  - Code review feedback given by Sasha Levin.
  - Removed EXPORT_SYMBOL_GPL since this was not required.
  - Removed "This file is released under the GPLv2" since we have SPDX
    identifier.  
  - Inside verity_verify_root_hash changed EINVAL to ENOKEY when the key
    descriptor is not specified but due to force option being set it is
    expected.
  - Moved CONFIG check to inside verity_verify_get_sig_from_key.  
     (Did not move the sig_opts_cleanup to inside verity_dtr as the
     sig_opts do not need to be allocated for the entire duration the block
     device is active unlike the verity structure, note verity_dtr is called
     only if verity_ctr fails or after the lifetime of the block device.)

v2:
  - Code review feedback to pass the signature binary blob as a key that can be
Jaskaran Khurana (1):
  Adds in-kernel pkcs7 sig checking the roothash of the dm-verity hash
    tree

 drivers/md/Kconfig                |  23 ++++++
 drivers/md/Makefile               |   2 +-
 drivers/md/dm-verity-target.c     |  34 +++++++-
 drivers/md/dm-verity-verify-sig.c | 132 ++++++++++++++++++++++++++++++
 drivers/md/dm-verity-verify-sig.h |  30 +++++++
 5 files changed, 216 insertions(+), 5 deletions(-)
 create mode 100644 drivers/md/dm-verity-verify-sig.c
 create mode 100644 drivers/md/dm-verity-verify-sig.h

-- 
2.17.1
