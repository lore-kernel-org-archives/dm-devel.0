From: Satya Tangirala <satyat@google.com>
Subject: [PATCH 0/3] add support for inline encryption to device mapper
Date: Wed,  9 Sep 2020 23:44:19 +0000
Message-ID: <20200909234422.76194-1-satyat@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>, Satya Tangirala <satyat@google.com>
List-Id: dm-devel.ids

This patch series adds support for inline encryption to the device mapper.

Patch 1 introduces the "passthrough" keyslot manager.

The regular keyslot manager is designed for inline encryption hardware that
have only a small fixed number of keyslots. A DM device itself does not
actually have only a small fixed number of keyslots - it doesn't actually
have any keyslots in the first place, and programming an encryption context
into a DM device doesn't make much semantic sense. It is possible for a DM
device to set up a keyslot manager with some "sufficiently large" number of
keyslots in its request queue, so that upper layers can use the inline
encryption capabilities of the DM device's underlying devices, but the
memory being allocated for the DM device's keyslots is a waste since they
won't actually be used by the DM device.

The passthrough keyslot manager solves this issue - when the block layer
sees that a request queue has a passthrough keyslot manager, it doesn't
attempt to program any encryption context into the keyslot manager. The
passthrough keyslot manager only allows the device to expose its inline
encryption capabilities, and a way for upper layers to evict keys if
necessary.

There also exist inline encryption hardware that can handle encryption
contexts directly, and allow users to pass them a data request along with
the encryption context (as opposed to inline encryption hardware that
require users to first program a keyslot with an encryption context, and
then require the users to pass the keyslot index with the data request).
Such devices can also make use of the passthrough keyslot manager.

Patch 2 introduces the changes for inline encryption support for the device
mapper. A DM device only exposes the intersection of the crypto
capabilities of its underlying devices. This is so that in case a bio with
an encryption context is eventually mapped to an underlying device that
doesn't support that encryption context, the blk-crypto-fallback's cipher
tfms are allocated ahead of time by the call to blk_crypto_start_using_key.

Each DM target can now also specify that it "may_passthrough_inline_crypto"
to opt-in to supporting passing through the underlying inline encryption
capabilities.  This flag is needed because it doesn't make much semantic
sense for certain targets like dm-crypt to expose the underlying inline
encryption capabilities to the upper layers. Again, the DM exposes inline
encryption capabilities of the underlying devices only if all of them
opt-in to passing through inline encryption support.

This patch doesn't handle the possibility that the crypto capabilities of a
DM device may change at runtime after the initial table is loaded. While it
may be possible to handle the case with (possibly quite) some effort, the
use case might be unlikely enough in practice that it doesn't matter right
now. This patch also only exposes the intersection of the underlying
device's capabilities, which has the effect of causing en/decryption of a
bio to fall back to the kernel crypto API (if the fallback is enabled)
whenever any of the underlying devices doesn't support the encryption
context of the bio - it might be possible to make the bio only fall back to
the kernel crypto API if the bio's target underlying device doesn't support
the bio's encryption context, but again, the use case may be uncommon
enough in the first place not to warrant worrying about it right now.

Patch 3 makes some DM targets opt-in to passing through inline encryption
support. It does not (yet) try to enable this option with dm-raid, since
users can "hot add" disks to a raid device, which makes this not completely
straightforward (we'll need to ensure that any "hot added" disks must have
a superset of the inline encryption capabilities of the rest of the disks
in the raid device, due to the way Patch 2 of this series works).

Eric Biggers (2):
  dm: add support for passing through inline crypto support
  dm: enable may_passthrough_inline_crypto on some targets

Satya Tangirala (1):
  block: keyslot-manager: Introduce passthrough keyslot manager

 block/blk-crypto.c              |  1 +
 block/keyslot-manager.c         | 75 +++++++++++++++++++++++++++
 drivers/md/dm-core.h            |  4 ++
 drivers/md/dm-flakey.c          |  1 +
 drivers/md/dm-linear.c          |  1 +
 drivers/md/dm-table.c           | 52 +++++++++++++++++++
 drivers/md/dm-zero.c            |  1 +
 drivers/md/dm.c                 | 92 ++++++++++++++++++++++++++++++++-
 include/linux/device-mapper.h   |  6 +++
 include/linux/keyslot-manager.h |  9 ++++
 10 files changed, 241 insertions(+), 1 deletion(-)

-- 
2.28.0.618.gf4bc123cb7-goog
