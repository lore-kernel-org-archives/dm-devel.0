From: Valdis.Kletnieks@vt.edu
Subject: Re: 2.6.27-rc5-mmotm0829 - lvm issues at boot, possible disk_devt() related?
Date: Mon, 01 Sep 2008 05:15:58 -0400
Message-ID: <7045.1220260558@turing-police.cc.vt.edu>
References: <4963.1220240176@turing-police.cc.vt.edu>
            <48BBA0B0.5070309@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1220260557_4797P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758374AbYIAJlg@vger.kernel.org>
In-Reply-To: Your message of "Mon, 01 Sep 2008 09:58:40 +0200."
             <48BBA0B0.5070309@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

--==_Exmh_1220260557_4797P
Content-Type: text/plain; charset=us-ascii

On Mon, 01 Sep 2008 09:58:40 +0200, Tejun Heo said:

> Yeah, I made a mistake converting two of them and devt lookup fails when
> the disk is zero sized.  Bartlomiej debugged the problem and posted a
> patch and I followed up with an updated patch.  It should be fine in the
> next round.
> 
>   http://article.gmane.org/gmane.linux.kernel.next/2663
>   http://article.gmane.org/gmane.linux.kernel.next/2676
> 
> If you're seeing other problems, please let me know.

Confirming - 2.6.27-rc5-mmotm0829 plus the merge of the 2 above patches
does find the LVM volumes and come up.  Thanks for the clue.. :)

--==_Exmh_1220260557_4797P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIu7LNcC3lWbTT17ARAk3JAKDWhw+6mgL97kR88bdONijSEwd6YgCgribv
PeS8S4SHIWwfW1Rb9+b5vUQ=
=7mPo
-----END PGP SIGNATURE-----

--==_Exmh_1220260557_4797P--
