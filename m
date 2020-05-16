From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
Subject: next-20200514 - build issue in drivers/md/dm-zoned-target.c
Date: Sat, 16 May 2020 07:19:13 -0400
Message-ID: <367320.1589627953@turing-police>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1589627953_23225P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--==_Exmh_1589627953_23225P
Content-Type: text/plain; charset=us-ascii

Am seeing a build error in next-0514.  -0420 built OK.
building a 'make allmodconfig' on a RPi4 in 32-bit mode.

  MODPOST 7575 modules
ERROR: modpost: "__aeabi_uldivmod" [drivers/md/dm-zoned.ko] undefined!

objdump and 'make drivers/md/dm-zoned-target.s' tells
me that the problem is in function dmz_fixup_devices(), near here:

@ drivers/md/dm-zoned-target.c:806:             reg_dev->nr_zones = DIV_ROUND_UP(reg_dev->capacity,
        ldr     r0, [r6, #56]   @ reg_dev_166->capacity, reg_dev_166->capacity
        adds    r1, r3, r1      @ tmp316, _227, reg_dev_166->capacity
        adc     r0, r2, r0      @ tmp315, _227, reg_dev_166->capacity
        subs    r1, r1, #1      @, tmp316,
@ drivers/md/dm-zoned-target.c:805:             reg_dev->zone_nr_sectors = zoned_dev->zone_nr_sectors;
        strd    r2, [r6, #80]   @, reg_dev,
@ drivers/md/dm-zoned-target.c:806:             reg_dev->nr_zones = DIV_ROUND_UP(reg_dev->capacity,
        sbc     r0, r0, #0      @, tmp315,
        bl      __aeabi_uldivmod                @
@ drivers/md/dm-zoned-target.c:806:             reg_dev->nr_zones = DIV_ROUND_UP(reg_dev->capacity,
        str     r1, [r6, #64]   @ tmp306, reg_dev_166->nr_zones

git blame points at this commit:

commit 70978208ec91d798066f4c291bc98ff914bea222
Author: Hannes Reinecke <hare@suse.de>
Date:   Mon May 11 10:24:30 2020 +0200

    dm zoned: metadata version 2

Reverting that commit lets the build complete.



--==_Exmh_1589627953_23225P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.9.0 11/07/2018

iQIVAwUBXr/MMAdmEQWDXROgAQLTXQ/+OU15bnjwmP85lolwTjIv5S1rqgFkYmu/
57mmfcH6/P0JC/BvSfrQbaV7HdVx6xBYoywU4N24/huMaYLebX4gUd1ZVaF5QIVc
XYndVZmi5cJb91q1SfzkV6Z6pcYdscMiyv+ViMuHR81G/4vBq4/CVYzyxKaGJBK3
tj6mCALx/qvTN7EokTX+RQY3WHv75vKbS+RmgSwVNcQVuLT+PR6rJqYCIhKcpNIh
54vj3sXGkkzHmhoKRck0qQ/h0yXLugHQtqpufLcAkoWwIIqRkcDKoJMqq15dZ8S3
tA9wQ665Su47SbiUe6hjq7vJGcNAU0KsexfnRdKxGKElr8XYiHd2X2c5N9kCVh7i
cLljCXsewU0tByCTo2KvzT9m5iEqQepjHcYJWhrDtrl3PkOnoVKeUoJD0G53ayoN
mbyNxFm0IVY/+V6+FfuDuSVJ7lQK4jv6upibc+WUsA8LVi+sM+GeSCJx4Qx3Sfxd
iFKJWW6e7rlpTy+eQp3ipIzR2rXgasfCaXTJXzIDkQiQKmUpeRTiMttInpyyFmwL
mJRgcxq6HfXmREcy6yTRZf/IaTtxV2j3A6YZzoSFfg/pj52nX6dPbuaYPlhPDlaO
6tWHzUk5DqIdh8ydmeK3KUrsCdvNPt/ksUuMkEi/vFQPOyQ1qFYC+9sdDltY4bXL
AbbIXSkzR0A=
=LIvL
-----END PGP SIGNATURE-----

--==_Exmh_1589627953_23225P--
