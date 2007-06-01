From: Valdis.Kletnieks@vt.edu
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Fri, 01 Jun 2007 13:07:07 -0400
Message-ID: <10553.1180717627@turing-police.cc.vt.edu>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528094358.GM25091@agk.fab.redhat.com> <5201e28f0705290225v14fdac44hb0382a4137a84d01@mail.gmail.com> <20070529220500.GA6513@agk.fab.redhat.com> <5201e28f0705300212g3be16464u5ee1a4c80db27a11@mail.gmail.com> <465DAC72.1010201@cfl.rr.com> <5201e28f0705310414u1a9aebc4je135748274543946@mail.gmail.com> <465F9197.7060002@gmail.com> <Pine.LNX.4.64.0705312144400.6705@asgard.lang.hm>
            <465FC7B1.3060309@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180717627_9513P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762807AbXFARIq@vger.kernel.org>
In-Reply-To: Your message of "Fri, 01 Jun 2007 16:16:01 +0900."
             <465FC7B1.3060309@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: david@lang.hm, Stefan Bader <Stefan.Bader@de.ibm.com>, Phillip Susi <psusi@cfl.rr.com>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, ric@emc.com
List-Id: dm-devel.ids

--==_Exmh_1180717627_9513P
Content-Type: text/plain; charset=us-ascii

On Fri, 01 Jun 2007 16:16:01 +0900, Tejun Heo said:
> Don't those thingies usually have NV cache or backed by battery such
> that ORDERED_DRAIN is enough?

Probably *most* do, but do you really want to bet the user's data on it?

> The problem is that the interface between the host and a storage device
> (ATA or SCSI) is not built to communicate that kind of information
> (grouped flush, relaxed ordering...).  I think battery backed
> ORDERED_DRAIN combined with fine-grained host queue flush would be
> pretty good.  It doesn't require some fancy new interface which isn't
> gonna be used widely anyway and can achieve most of performance gain if
> the storage plays it smart.

Yes, that would probably be "pretty good".  But how do you get the storage
device to *reliably* tell the truth about what it actually implements? (Consider
the number of devices that downright lie about their implementation of cache
flushing....)

--==_Exmh_1180717627_9513P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGYFI7cC3lWbTT17ARAhCrAKCXsUNK/FKgCgP7h3595UvrISnw+QCg3+P5
1+0QmgTXUfe91UZEeK9GIVE=
=BTOx
-----END PGP SIGNATURE-----

--==_Exmh_1180717627_9513P--
