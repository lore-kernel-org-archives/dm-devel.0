From: Ladislav Michnovic <lmichnovic@suse.cz>
Subject: Probably broken device mapper in latest vanilla	kernel
Date: Tue, 12 Feb 2008 12:52:10 +0100
Message-ID: <47B1886A.2010308@suse.cz>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello.

I tried latest vanilla kernel 2.6.25_rc1 on the friend's notebook. The
root partition is set on LVM and this kernel don't see it when booting.
It doesn't creates /dev/mapper directory. The device mapper is probably
broken in that kernel. The machine boots seamlessly with the latest
2.6.24 kernel.

- --
 Best Regards Ladislav Michnovi=C4=8D.

Package Maintainer
- -----------------------------------------------------------------------
SUSE LINUX, s.r.o.                         e-mail: lmichnovic@suse.cz
Lihovarsk=C3=A1 1060/12                         tel: +420 284 028 950
190 00 Prague 9                            fax: +420 284 028 951
Czech Republic                             http://www.suse.cz/
Key fingerprint:
FF0B B0B7 7AFD D5FB 7A72 8B09 9035 2A8A 9AC3 D35A
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHsYhqkDUqiprD01oRAk7qAJ0XG/ueSUPoiDP1YptYXbr/yBwynACeLTmw
6WA265bgU5uJ0+SXO1Zkaz0=3D
=3Dsr2P
-----END PGP SIGNATURE-----
