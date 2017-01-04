From: Milan Broz <gmazyland@gmail.com>
Subject: [RFC PATCH 0/4] Data integrity protection with
	dm-integrity and dm-crypt
Date: Wed,  4 Jan 2017 20:23:50 +0100
Message-ID: <cover.1483551181.git.gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

Hello,

following patches are the first iteration of our work on providing
data integrity protection on the block device level.

This covering mail is very simple introduction to motivation of this work,
more rigorous description will come in the form of some paper later.

Our main goal is to provide an option to implement strong data integrity
protection on the low block device level, without need of any specialized
hardware - just as an extension of device-mapper infrastructure.

The solution is meant to be used over a standard common-off-the-shelf device.
N.B. we are not replacing nor disputing a need to implement some data integrity
protection on the higher level. But the state of integrity protection
on higher level is in sad state in Linux in general and we believe that
this target can provide at least something to the rescue :)

My special focus (and my academic motivation) is to provide cryptographically
strong data protection in combination with full disk encryption algorithms.

In principle, so-called authenticated encryption provides guaranties that data
were not tampered with, so only authorised user can decrypt, change or verify data
integrity.
N.B. Current full disk encryption algorithms provide only confidentiality,
they does NOT provide any data integrity protection (because of its
length-preserving nature).
Corrupted data cannot be easily detected (except detection that decrypted
data seems to be garbage).

I. dm-integrity - a "simulated" data integrity profile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Any integrity protection requires additional data to store data protection tags.
Because we are operating on the sector level, we need an additional
per-sector metadata for any integrity (or other) tags.

Attached patches include new dm-integrity target that provides basic logic
to store additional metadata per-sector.

On top of it we can provide data integrity protection, either inside
dm-integrity itself or in stacked device like dm-crypt.

The basic idea of dm-integrity is to "simulate" DIF/IP profile over
a normal block device and store a per-sector metadata in interleaved metadata
sectors. It using existing implementation of integrity profile metadata
already present in kernel, just registering own configurable profile.

To provide atomic update of data + metadata sectors, dm-integrity implements
also optional data journal.

The dm-integrity target can operate in two modes:
    * it can use metadata itself and calculate non-cryptographic data integrity
      (for example CRC or hash-based checksum)

    * it can receive bio structure with attached integrity fields and
      just provide handler for these metadata (read/store them to metadata sectors).
      It is up to higher target how the metadata are used.

The second mode is used for the dm-crypt authenticated encryption extension.

II. dm-crypt and authenticated encryption
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The second part adds possibility to use Authenticated Encryption with Additional
Data (AEAD) algorithms for dm-crypt.

These algorithms can encrypt data and also produce additional authentication
tag that provides cryptographically sound integrity protection.
There can be also additional data (that are only authenticated but not encrypted),
in disk encryption is it for example sector number (so the sector fails
integrity validation if ciphertext sector is relocated).

This authentication tag is then stored into metadata space provided
by underlying dm-integrity target. On top of this we can also store
another metadata like randomly generated, Initialization Vector (IV).
(This could increase security of disk-encryption model. Basically if IV
can be randomly regenerated on every write, ciphertext sector will change
pseudo-randomly on every write, even with the same written data.
This is the best possible achievable security scenario for disk-encryption.)

In principle we can use any authenticated mode provided by kernel crypto API
(but not all authenticated mode are secure in this environment, this applies
mainly for standard GCM mode).

We can also compose AEAD mode using existing disk encryption mode (XTS) and
combine it with keyed hash (HMAC) like HMAC(SHA256).

For illustration, the dm-crypt authenticated encryption uses following format:

 |-ADDITIONAL DATA-|------ DATA -------|-- AUTH TAG --| 
 | (authenticated) | (auth+encryption) |              |
 | sector_LE |  IV |  sector in/out    |  tag in/out  |

Sector_LE is sector number in little-endian, IV is authenticated as well.

The logic is in principle compatible with IEEE 1619.1 standard recommendation.

~~~~~~~~~~~~~~~~~~~

For more information please see individual patches.

The price for this solution is obviously storage space and performance.
Our solution can be quite easily extended of other information stored in metadata,
for example of Forward Error Correction (FEC) codes.
(I plan to experiment with this later).

I will try to provide some testing examples soon (we have already experimental
support in LUKS userspace based on experimental LUKS2 format).

(I hope I can show more on DevConf.cz talk later this January in Brno,
I hope we can discuss it there as well.)

Any constructive feedback welcome!

Thanks,
Milan (and Mikulas)

Mikulas Patocka (2):
  Add sector start offset to dm-bufio interface.
  Add the dm-integrity target

Milan Broz (2):
  dm-table: Add flag to allow own target handling of integrity metadata.
  Add cryptographic data integrity protection (authenticated encryption)
    to dm-crypt.

 Documentation/device-mapper/dm-crypt.txt     |   16 +
 Documentation/device-mapper/dm-integrity.txt |  189 ++
 drivers/md/Kconfig                           |   10 +
 drivers/md/Makefile                          |    1 +
 drivers/md/dm-bufio.c                        |   51 +-
 drivers/md/dm-bufio.h                        |    7 +
 drivers/md/dm-crypt.c                        |  857 ++++++--
 drivers/md/dm-integrity.c                    | 3031 ++++++++++++++++++++++++++
 drivers/md/dm-table.c                        |   11 +
 include/linux/device-mapper.h                |    6 +
 10 files changed, 4029 insertions(+), 150 deletions(-)
 create mode 100644 Documentation/device-mapper/dm-integrity.txt
 create mode 100644 drivers/md/dm-integrity.c

-- 
2.11.0
