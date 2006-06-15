From: "Singh, Santosh (STSD)" <santosh.singh3@hp.com>
Subject: RE: Next set of device-mapper  patches
Date: Thu, 15 Jun 2006 21:16:56 +0530
Message-ID: <3EC60E80D9AA7C4E910ACC9DA2003AC305FEAF58@BGEEXC02.asiapacific.cpqcorp.net>
References: <20060615152026.GK27639@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20060615152026.GK27639@agk.surrey.redhat.com>
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

I tried to patch on 2.6.16 as following and got the error below=20

linux-2.6.16]# patch -p1 < ../patches/patch-2.6.17-rc4

 ....
patching file drivers/usb/media/et61x251_tas5130d1b.c
patching file drivers/usb/media/ibmcam.c
patch unexpectedly ends in middle of line
patch: **** malformed patch at line 698588

patch -p1 < ../patches/patch-2.6.17-rc4-rc5
patching file drivers/video/matrox/matroxfb_base.h
can't find file to patch at input line 11918
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff -urN linux-2.6.17-rc4/fs/9p/fcall.c linux-2.6.17-rc5/fs/9p/fcall.c
|--- linux-2.6.17-rc4/fs/9p/fcall.c     2006-05-25 02:26:26.065239650
+0000
|+++ linux-2.6.17-rc5/fs/9p/fcall.c     2006-05-25 02:26:32.265906812
+0000
--------------------------
File to patch:=20


Could you advise me how to patch.

Regards
Santosh



-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Alasdair G Kergon
Sent: Thursday, June 15, 2006 8:50 PM
To: P S, Suresh (STSD)
Cc: device-mapper development
Subject: Re: [dm-devel] Next set of device-mapper patches

On Thu, Jun 15, 2006 at 08:42:59PM +0530, Singh, Santosh (STSD) wrote:
>  I am testing  the device-mapper ioctl support.
>   Which all the  patches required for this and can I I apply those=20
> patches on linux-2.6.16.
=20
Start from:

=20
########################################################################
######
  # Submitted upstream
=20
########################################################################
######
  =20
  dm-snapshot-unify-chunk_size.patch

...
and stop at:

  dm-export-blkdev_driver_ioctl.patch

Alasdair
--
agk@redhat.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
