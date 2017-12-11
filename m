From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH v2 2/2] dm unstripe: Add documentation for unstripe target
Date: Mon, 11 Dec 2017 16:21:18 -0700
Message-ID: <20171211232118.GC11218@localhost.localdomain>
References: <20171211160019.20518-1-scott.bauer@intel.com>
 <20171211160019.20518-3-scott.bauer@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171211160019.20518-3-scott.bauer@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Scott Bauer <scott.bauer@intel.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, jonathan.derrick@intel.com
List-Id: dm-devel.ids

On Mon, Dec 11, 2017 at 09:00:19AM -0700, Scott Bauer wrote:
> +Example scripts:
> +====================
> +
> +dmsetup create nvmset1 --table '0 1 dm-unstripe /dev/nvme0n1 1 2 0'
> +dmsetup create nvmset0 --table '0 1 dm-unstripe /dev/nvme0n1 0 2 0'
> +
> +There will now be two mappers:
> +/dev/mapper/nvmset1
> +/dev/mapper/nvmset0
> +
> +that will expose core 0 and core 1.
> +
> +
> +In a Raid 0 with 4 drives of stripe size 128K:
> +dmsetup create raid_disk0 --table '0 1 dm-unstripe /dev/nvme0n1 0 4 256'
> +dmsetup create raid_disk1 --table '0 1 dm-unstripe /dev/nvme0n1 1 4 256'
> +dmsetup create raid_disk2 --table '0 1 dm-unstripe /dev/nvme0n1 2 4 256'
> +dmsetup create raid_disk3 --table '0 1 dm-unstripe /dev/nvme0n1 3 4 256'

While this device mapper is intended for H/W RAID where the member disks
are hidden, we can test it using DM software striping so we don't need
any particular hardware.

Here's a little test script I wrote for that. It sets up a striped
device backed by files, unstripes it into different sets, then compares
each to its original backing file after writing random data to it,
cleaning up the test artifacts before exiting. The parameters at the
top can be modified to test different striping scenarios.

---
#!/bin/bash

MEMBER_SIZE=$((128 * 1024 * 1024))
NUM=4
SEQ_END=$((${NUM}-1))
CHUNK=256
BS=4096

RAID_SIZE=$((${MEMBER_SIZE}*${NUM}/512))
DM_PARMS="0 ${RAID_SIZE} striped ${NUM} ${CHUNK}"
COUNT=$((${MEMBER_SIZE} / ${BS}))

for i in $(seq 0 ${SEQ_END}); do
  dd if=/dev/zero of=member-${i} bs=${MEMBER_SIZE} count=1 oflag=direct
  losetup /dev/loop${i} member-${i}
  DM_PARMS+=" /dev/loop${i} 0"
done

echo $DM_PARMS | dmsetup create raid0
for i in $(seq 0 ${SEQ_END}); do
  echo "0 1 dm-unstripe /dev/mapper/raid0 ${i} ${NUM} ${CHUNK}" | dmsetup create set-${i}
done;

for i in $(seq 0 ${SEQ_END}); do
  dd if=/dev/urandom of=/dev/mapper/set-${i} bs=${BS} count=${COUNT} oflag=direct
  diff /dev/mapper/set-${i} member-${i}
done;

for i in $(seq 0 ${SEQ_END}); do
  dmsetup remove set-${i}
done
dmsetup remove raid0

for i in $(seq 0 ${SEQ_END}); do
  losetup -d /dev/loop${i}
  rm -f member-${i}
done
--
