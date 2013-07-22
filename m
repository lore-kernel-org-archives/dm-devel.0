From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Device mapping without using initramfs
Date: Mon, 22 Jul 2013 13:27:40 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1307221319230.22240@file01.intranet.prod.int.rdu2.redhat.com>
References: <CACxrqpCvy_6V5ijupVBfdqGaOmY2Gwkhga1SshqtSxg-CQ4qxQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CACxrqpCvy_6V5ijupVBfdqGaOmY2Gwkhga1SshqtSxg-CQ4qxQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: ebelcrom ebelcrom <ebelcrom@googlemail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On Sun, 21 Jul 2013, ebelcrom ebelcrom wrote:

> Hello folks,
> 
> I played around with dm-crypt without using initramfs for en-/decryption of
> my root file system. The rootfs is encrypted plain with cryptsetup and the
> key is stored at the disk containing the rootfs between MBR and the
> partition. The kernel parameter given to it from the bootloader is
> configured as it should be (cryptdevice, cryptkey, root mapper). The disk
> driver (loaded before) is built-in as well as dm-crypt (loaded after). AES
> support als ist built in as well as a 5 second root wait delay. The message
> I got at boot time is this (cr_rootfs is the encrypted rootfs):
> 
> VFS: Cannot open root device "mapper/cr_rootfs" or unknown-block(0,0)
> 
> According to some hints in the web there is no need to have an initramfs. Is
> that true? Is dm possible without initramfs? If yes what are the steps to
> get there and what should I keep into account?
> 
> Any suggestions are welcome!

Hi

There is no way to activate dm-crypt on startup without initramfs. 
"cryptdevice" and "cryptkey" are parameters for initramfs code, not 
kernel.

Mikulas
