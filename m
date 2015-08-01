From: Andreas Hartmann <andihartmann@freenet.de>
Subject: Re: [dm-devel] AMD-Vi IO_PAGE_FAULTs and ata3.00: failed command:
 READ FPDMA QUEUED errors since Linux 4.0
Date: Sat, 1 Aug 2015 16:20:23 +0200
Message-ID: <55BCD5A7.2080708@maya.org>
References: <55B7BEA2.30205@01019freenet.de>
 <20150728175054.GB24782@redhat.com> <55B7D054.4070308@maya.org>
 <20150728192908.GA25264@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150728192908.GA25264@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, mpatocka@redhat.com, Milan Broz <mbroz@redhat.com>
Cc: linux-pci <linux-pci@vger.kernel.org>
List-Id: dm-devel.ids

On 07/28/2015 at 09:29 PM, Mike Snitzer wrote:
[...]
> Mikulas was saying to biect what is causing ATA to fail.

Some good news and some bad news. The good news first:

Your patchset

f3396c58fd8442850e759843457d78b6ec3a9589,
cf2f1abfbd0dba701f7f16ef619e4d2485de3366,
7145c241a1bf2841952c3e297c4080b357b3e52d,
94f5e0243c48aa01441c987743dc468e2d6eaca2,
dc2676210c425ee8e5cb1bec5bc84d004ddf4179,
0f5d8e6ee758f7023e4353cca75d785b2d4f6abe,
b3c5fd3052492f1b8d060799d4f18be5a5438add

seems to works fine w/ 3.18.19 !!

Why did I test it with 3.18.x now? Because I suddenly got two ata errors
(ata1 and ata2) with clean 3.19.8 (w/o the AMD-Vi IO_PAGE_FAULTs) during
normal operation. This means: 3.19 must already be broken, too.

Therefore, I applied your patchset to 3.18.x and it seems to work like a
charme - I don't get any AMD-Vi IO_PAGE_FAULTs on boot and no ata errors
(until now).


Next I did: I tried to bisect between 3.18 and 3.19 with your patchset
applied, because w/ this patchset applied, the problem can be seen
easily and directly on boot. Unfortunately, this does work only a few
git bisect rounds until I got stuck because of interferences with your
extra patches applied:

git bisect start
# good: [b2776bf7149bddd1f4161f14f79520f17fc1d71d] Linux 3.18
git bisect good b2776bf7149bddd1f4161f14f79520f17fc1d71d
# bad: [bfa76d49576599a4b9f9b7a71f23d73d6dcff735] Linux 3.19
git bisect bad bfa76d49576599a4b9f9b7a71f23d73d6dcff735
# good: [54850e73e86e3bc092680d1bdb84eb322f982ab1] zram: change
parameter from vaild_io_request()
git bisect good 54850e73e86e3bc092680d1bdb84eb322f982ab1
# bad: [dab363f938a53ddaee60bfecc1aebdbb3d3af5f0] Merge tag
'staging-3.19-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect bad dab363f938a53ddaee60bfecc1aebdbb3d3af5f0
# bad: [26178ec11ef3c6c814bf16a0a2b9c2f7242e3c64] x86: mm: consolidate
VM_FAULT_RETRY handling
git bisect bad 26178ec11ef3c6c814bf16a0a2b9c2f7242e3c64
# bad: [e7cf773d431a63a2417902696fcc9e0ebdc83bbe] Merge tag
'usb-3.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
git bisect bad e7cf773d431a63a2417902696fcc9e0ebdc83bbe
# good: [9ea18f8cab5f1c36cdd0f09717e35ceb48c36a87] Merge branch
'for-3.19/drivers' of git://git.kernel.dk/linux-block
git bisect good 9ea18f8cab5f1c36cdd0f09717e35ceb48c36a87
Bisecting: 251 revisions left to test after this (roughly 8 steps)
error: Your local changes to the following files would be overwritten by
checkout:
        drivers/md/dm-crypt.c
Please, commit your changes or stash them before you can switch branches.
Aborting


Do you have any idea how to proceed at this point?


Thanks,
Andreas
