From: Chandler Carruth <chandlerc@gmail.com>
Subject: Problem setting up RAID0 Array on Intel ICH7 fake-RAID.
Date: Wed, 06 Jul 2005 16:59:48 -0400
Message-ID: <42CC4644.8050306@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0542280333=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============0542280333==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig6EAE1383BCC298DF1E5B8D9C"

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6EAE1383BCC298DF1E5B8D9C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

I am attempting to install Gentoo Linux on a box with a RAID0 Array.
This is a brand new box, with Intel's ICH7 chipset, and accompanying
fake-RAID chip. The RAID array works in Windows, but despite all my
attempts, I cannot get it working in Linux. I am now using a LiveCD
designed specifically to run on boxes with fake-RAID arrays. The various
software versions are:

* Grub 0.96
* device-mapper version 1.00.19
* dmraid version 1.0.0.rc6

This is the most recent version I have been able to find. I am
attempting to compile a binary of dmraid version 1.0.0.rc8, but I am
doubtful about this solving the problem. Any ideas would be welcome. =]

# dmraid --debug --verbose -ay
DEBUG: _find_set: searching isw_bhibhdiifc
DEBUG: _find_set: not found isw_bhibhdiifc
ERROR: isw: volume ARRAY is broken
DEBUG: _find_set: searching isw_bhibhdiifc
DEBUG: _find_set: found isw_bhibhdiifc
ERROR: isw: volume ARRAY is broken
DEBUG : set status of set "isw_bhibhdiifc" to 16
INFO: Activating GROUP RAID set "isw_bhibhdiifc"
DEBUG: freeing devices of RAID set "isw_bhibhdiifc"
DEBUG: freeing device "isw_bhibhdiifc", path "/dev/sda"
DEBUG: freeing device "isw_bhibhdiifc", path "/dev/sda"

Please, any idea as to how to setup this RAID array?

-Chandler Carruth

--------------enig6EAE1383BCC298DF1E5B8D9C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFCzEZHtfRZW6zocDkRAq23AJ93v5TTYJM3/TFDrT3eQk80ZGMnxACfc8mp
Xf9sz7pDWH2V5RWslethUtE=
=SxuB
-----END PGP SIGNATURE-----

--------------enig6EAE1383BCC298DF1E5B8D9C--


--===============0542280333==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0542280333==--
