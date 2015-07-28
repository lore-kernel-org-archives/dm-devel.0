From: Andreas Hartmann <andihartmann@01019freenet.de>
Subject: AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command: READ FPDMA QUEUED
 errors since Linux 4.0
Date: Tue, 28 Jul 2015 19:40:50 +0200
Message-ID: <55B7BEA2.30205@01019freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-pci-owner@vger.kernel.org>
Sender: linux-pci-owner@vger.kernel.org
To: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com
Cc: linux-pci <linux-pci@vger.kernel.org>
List-Id: dm-devel.ids

Hello!

After long and heavy bisecting, I found this commit
"dm crypt: don't allocate pages for a partial request" [1] being the
cause of the ata errors and AMD-Vi IO_PAGE_FAULTs.

That's the bisect I did with Linus' repository
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/


git bisect start
# good: [3466b547e37b988723dc93465b7cb06b4b1f731f] Merge branches 'pnp',
'pm-cpuidle' and 'pm-cpufreq'
git bisect good 3466b547e37b988723dc93465b7cb06b4b1f731f
# bad: [cd50b70ccd5c87794ec28bfb87b7fba9961eb0ae] Merge tag
'pm+acpi-3.20-rc1-3' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect bad cd50b70ccd5c87794ec28bfb87b7fba9961eb0ae
# good: [27a22ee4c7d5839fd7e3e441c9d675c8a5c4c22c] Merge branch 'kbuild'
of git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild
git bisect good 27a22ee4c7d5839fd7e3e441c9d675c8a5c4c22c
# good: [c189cb8ef62832f33b6cf757350a0270532a1ad8] Merge tag
'vfio-v3.20-rc1' of git://github.com/awilliam/linux-vfio
git bisect good c189cb8ef62832f33b6cf757350a0270532a1ad8
# good: [295324556c427d60b41668ab81a43f604533f456] Merge branch
'i2c/for-3.20' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
git bisect good 295324556c427d60b41668ab81a43f604533f456
# good: [1acd2de5facd7fbea499aea64a3a3d0ec7bb9b51] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
git bisect good 1acd2de5facd7fbea499aea64a3a3d0ec7bb9b51
# good: [fde9f50f80fe89a9115b4bfa773017272597d85d] target: Add sanity
checks for DPO/FUA bit usage

git bisect good fde9f50f80fe89a9115b4bfa773017272597d85d


# bad: [22aa66a3ee5b61e0f4a0bfeabcaa567861109ec3] dm snapshot: fix a
possible invalid memory access on unload


git bisect bad 22aa66a3ee5b61e0f4a0bfeabcaa567861109ec3


# bad: [7145c241a1bf2841952c3e297c4080b357b3e52d] dm crypt: avoid
deadlock in mempools


git bisect bad 7145c241a1bf2841952c3e297c4080b357b3e52d


# good: [37527b869207ad4c208b1e13967d69b8bba1fbf9] dm io: reject
unsupported DISCARD requests with EOPNOTSUPP


git bisect good 37527b869207ad4c208b1e13967d69b8bba1fbf9


# bad: [cf2f1abfbd0dba701f7f16ef619e4d2485de3366] dm crypt: don't
allocate pages for a partial request


git bisect bad cf2f1abfbd0dba701f7f16ef619e4d2485de3366


# good: [f3396c58fd8442850e759843457d78b6ec3a9589] dm crypt: use unbound
workqueue for request processing

git bisect good f3396c58fd8442850e759843457d78b6ec3a9589


# first bad commit: [cf2f1abfbd0dba701f7f16ef619e4d2485de3366] dm crypt:
don't allocate pages for a partial request


How can I verify (e.g. w/ a patch to Linux 4.0.9) if this patch is
really the culprit?

I'm heavily relying upon encryption:

There are 3 disks:
- One 240 GB SSD (crypted LVM, swap and boot partition)
- Two SATA rotational 3 TB disks (WD ST3000DM001-1CH166, encrypted raid
  /dev/md0, LVM)
- All in all 29 logical volumes with xfs as filesystem (besides swap
  and bootpartition - the latter is ext4).

The system is based on an AMD FX8350 processor (8 core) w/ 24GB RAM.
Motherboard is a Gigabyte GA-990XA-UD3. You can find a complete dmesg
output here [2].



I would be glad to get some assistance!


Thanks in advance,
kind regards,
Andreas Hartmann


[1]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=cf2f1abfbd0dba701f7f16ef619e4d2485de3366

[2] http://article.gmane.org/gmane.linux.kernel.pci/43539
