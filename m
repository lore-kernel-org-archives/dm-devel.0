From: ebelcrom ebelcrom <ebelcrom@googlemail.com>
Subject: Device mapping without using initramfs
Date: Sun, 21 Jul 2013 00:21:44 +0200
Message-ID: <CACxrqpCvy_6V5ijupVBfdqGaOmY2Gwkhga1SshqtSxg-CQ4qxQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3926901123242031148=="
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
List-Id: dm-devel.ids

--===============3926901123242031148==
Content-Type: multipart/alternative; boundary=047d7b6249d653371304e1f8de2f

--047d7b6249d653371304e1f8de2f
Content-Type: text/plain; charset=ISO-8859-1

Hello folks,

I played around with dm-crypt without using initramfs for en-/decryption of
my root file system. The rootfs is encrypted plain with cryptsetup and the
key is stored at the disk containing the rootfs between MBR and the
partition. The kernel parameter given to it from the bootloader is
configured as it should be (cryptdevice, cryptkey, root mapper). The disk
driver (loaded before) is built-in as well as dm-crypt (loaded after). AES
support als ist built in as well as a 5 second root wait delay. The message
I got at boot time is this (cr_rootfs is the encrypted rootfs):

VFS: Cannot open root device "mapper/cr_rootfs" or unknown-block(0,0)

According to some hints in the web there is no need to have an initramfs.
Is that true? Is dm possible without initramfs? If yes what are the steps
to get there and what should I keep into account?

Any suggestions are welcome!

--047d7b6249d653371304e1f8de2f
Content-Type: text/html; charset=ISO-8859-1

<div dir="ltr"><div><div>Hello folks,<br><br></div>I played around with dm-crypt 
without using initramfs for en-/decryption of my root file system. The 
rootfs is encrypted plain with cryptsetup and the key is stored at the 
disk containing the rootfs between MBR and the partition. The kernel 
parameter given to it from the bootloader is configured as it should be 
(cryptdevice, cryptkey, root mapper). The disk driver (loaded before) is
 built-in as well as dm-crypt (loaded after). AES support als ist built 
in as well as a 5 second root wait delay. The message I got at boot 
time is this (cr_rootfs is the encrypted rootfs):<br>
</div><br>VFS: Cannot open root device &quot;mapper/cr_rootfs&quot; or unknown-block(0,0)<br><div><br>According
 to some hints in the web there is no need to have an initramfs. Is that
 true? Is dm possible without initramfs? If yes what are the steps to get there and what should I keep 
into account?<br>
<br></div>Any suggestions are welcome!</div>

--047d7b6249d653371304e1f8de2f--


--===============3926901123242031148==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3926901123242031148==--
