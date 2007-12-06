From: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.24-rc4-mm1
Date: Thu, 06 Dec 2007 14:18:08 -0500
Message-ID: <4374.1196968688@turing-police.cc.vt.edu>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<3941.1196941764@turing-police.cc.vt.edu>
	<20071206040420.6c89c675.akpm@linux-foundation.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0239864864=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: Your message of "Thu, 06 Dec 2007 04:04:20 PST."
	<20071206040420.6c89c675.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--===============0239864864==
Content-Type: multipart/signed; boundary="==_Exmh_1196968688_2829P";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit

--==_Exmh_1196968688_2829P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <4359.1196968680.1@turing-police.cc.vt.edu>

On Thu, 06 Dec 2007 04:04:20 PST, Andrew Morton said:

> > >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc4/2.6.24-rc4-mm1/
> > 
> > Something in here broke LVM support - an initrd that has worked fine for
> > quite some time suddenly couldn't mount /dev/VolGroup00/root so we get the
> > infamous "Kernel panic - not syncing: Attempted to kill init!" when we
> > fall off the end of the initrd and haven't pivoted to the real disk.
> > 
> > It finds the disk OK:
> > 
> > [   81.202310] sd 0:0:0:0: [sda] 156301488 512-byte hardware sectors (80026 MB)
> > [   81.214466] sd 0:0:0:0: [sda] Write Protect is off
> > [   81.226467] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > [   81.238436] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> > [   81.250780]  sda: sda1 sda2
> > [   75.396119] sd 0:0:0:0: [sda] Attached SCSI disk
> > 
> > but then the lvm command says it can't find the volume group VolGroup00 (which
> > is actually sda2 - sda1 is a small /boot partition, rest of disk is LVM).
> > 
> > A quick look at the rc4-mm1 announcement doesn't have any obviously tempting
> > patch names to start at, so it looks like it's time to play mm-bisect.  It may
> > take me a day or two, as I have some time management issues this week...
> > 
> 
> OK, thanks.
> 
> First step would be to eliminate rewrite-rd.patch: maybe the ramdisk driver
> in which that initrd resides is bust.
> 
> After that, agk-dm-dm-*.patch are of course the ones to look at.

How did I not notice them? Yeah, those guys would be on the suspicious list...

> Please keep dm-devel@redhat.com cc'ed.

I've gotten it down to about 128 patches, but it's interesting what ended
up bracketed by GOOD/BAD:

powerpc-invalid-size-for-swapper_pg_dir-with-config_pte_64bit=y.patch   GOOD
#GREGKH-DRIVER-START
gregkh-driver-nozomi.patch
    gregkh-moby-patch-tree....
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch BAD

Would I be remiss in hypothesising that something in gregkh-driver-kobject-*
changed something, and now we need a agk-dm-dm-kobject-fixupage.patch?

The actual bug is probably elsewhere, but it *manifests* due to gregkh-driver
tree.  Will probably be tomorrow before I get it down further...


--==_Exmh_1196968688_2829P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHWErwcC3lWbTT17ARAsngAJwLlTr9tXk1Zkr+aQHNE8LugdDNcQCg9P3D
t0sh0PbMYAA20nTc/mO2/0g=
=FDNe
-----END PGP SIGNATURE-----

--==_Exmh_1196968688_2829P--


--===============0239864864==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0239864864==--
