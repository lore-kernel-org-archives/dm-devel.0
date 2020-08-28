From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: [PATCH v3 0/2] dm-devel:dm-crypt: infrastructure for measurement of DM target data using IMA
Date: Fri, 28 Aug 2020 13:26:58 -0700
Message-ID: <20200828202700.23086-1-tusharsu@linux.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: zohar@linux.ibm.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

There are several device-mapper targets which contribute to verify
the integrity of the mapped devices e.g. dm-integrity, dm-verity,
dm-crypt etc.

But they do not use the capabilities provided by kernel integrity
subsystem (IMA). For instance, the IMA capability that measures several
in-memory constructs and files to detect if they have been accidentally
or maliciously altered. IMA also has the capability to include these
measurements in the IMA measurement list and use them to extend a TPM
PCR so that they can be quoted. These TPM PCR extend operations ensure
that the tampering with the order of constructs being measured, and
tampering with the measured constructs themselves - doesn't go
undetected. In general, this capability is used for remote attestation
of in-memory constructs and files of interest. As of today,device-mapper
targets don't use the benefits of extended TPM PCR quotes and ultimately
the benefits of remote attestation.

This series bridges this gap, so that all device-mapper targets
could take advantage of IMA's measuring and quoting abilities - thus
ultimately enabling remote attestation for device-mapper targets.

This series is based on the following repo/branch:
 repo: https://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
 branch: next-integrity
 commit d012a7190fc1 ("Linux 5.9-rc2") 

This series also has a dependency on the following patch series and
should be applied in the following order:
 1. https://patchwork.kernel.org/patch/11709527/
 2. https://patchwork.kernel.org/patch/11742047/
 3. https://patchwork.kernel.org/patch/11743265/

Change Log v3:
 - add dm-crypt as a supported data source to measure in ima.h.
 - Taken dependency on the updated base series v3 (2. above)
 - Taken dependency on the updated early boot measurement series v2
   (3. above).

Change Log v2:
 - Removed the references to "local" measurement from the description -
   as this series only support remote attestation, and not local
   integrity enforcement.
 - Taken dependency on the updated base series (2. above), which 
   introduced a boolean parameter measure_buf_hash as per community
   feedback to support measuring hash of the buffer, instead of the
   buffer itself.
 - Taken dependency on the updated early boot measurement series
   (3. above).

Tushar Sugandhi (2):
  dm-devel: collect target data and submit to IMA to measure
  dm-crypt: collect data and submit to DM to measure

 drivers/md/Makefile            |   1 +
 drivers/md/dm-crypt.c          | 171 +++++++++++++++++++
 drivers/md/dm-ima.c            | 298 +++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h  |  60 +++++++
 security/integrity/ima/Kconfig |   3 +-
 security/integrity/ima/ima.h   |   1 +
 6 files changed, 532 insertions(+), 2 deletions(-)
 create mode 100644 drivers/md/dm-ima.c

-- 
2.17.1
