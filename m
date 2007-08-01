From: "Ellison, Bob" <bob.ellison@ccur.com>
Subject: RE: encrypted filesystem not encrypted?
Date: Wed, 1 Aug 2007 12:12:04 -0400
Message-ID: <E5C8AFD1ADF9DF48AD935F49588E895506B36FFD@gamx.iccur.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Also, did you initialize the partition with random data before the
cryptsetup step? If not, you could be looking at stale, unencrypted
data.
e.g
       dd if=3D/dev/urandom of=3D/dev/sda3=20
    or
       /sbin/badblocks -c 10240 -s -w -t random -v /dev/sda3

Either will do; the choice is how secure you want your actual data
and/or how long you're willing to wait for the seeding to complete.
--
bob

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Jonathan Brassow
Sent: Wednesday, August 01, 2007 10:43 AM
To: device-mapper development
Subject: Re: [dm-devel] encrypted filesystem not encrypted?

I'm guessing that you are bypassing your crypt device.  Depends on =20
what your arguments are to the LVM commands.

cryptsetup will create a new device that sits on top of sda3 - you =20
should use that one.  Do not use sda3 directly.

  brassow

On Jul 31, 2007, at 8:08 PM, chris wrote:

> Hi all,
>
> I was not sure which list to send this to, so I choose a couple =20
> that looked like decent fits, please advise if there is one more =20
> specific to the encryption.
>
> I am currently working on a project where we are converting some of =20
> our filesystems to an encrypted fs using LVM2.  We are running =20
> RHEL:  "2.6.9-55.0.2.ELsmp #1 SMP Tue Jun 12 17:59:08 EDT 2007 i686 =20
> i686 i386 GNU/Linux"
>
> We setup an encrypted filesystem using one of the open partitions =20
> on the physical hard drive using "cryptsetup create /dev/sda3"  We =20
> have verified this using the cryptsetup status, This shows the =20
> filesystem as being encrypted as aes_plain 256 bit key.  We then =20
> created an LVM and mounted the filesystem using the LVM.
>
> All seems to be well, except when our testers ran the following =20
> command:
> head -c 5000 /dev/sda3
>
> They got some output that includes clear text and obviously not =20
> encrypted data (along with encrypted data).  Some things are date =20
> formatted strings like 20050912 which appears quite a few times in =20
> the mounted filesystem, and in the raw device (/dev/sda3).
>
> I can post the exact commands that were used to create the =20
> filesystem, but they are basically
> create partition ...sda3
> cryptsetup create /dev/sda3 (prompts for passphrase)
> pvcreate
> vgcreate
> lvcreate
> mount
>
> (TIA) any help (or light shed on this) is greatly appreciated!
>
> -chris
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
