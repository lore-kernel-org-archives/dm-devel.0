From: Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>
Subject: [PATCH] Fix loopback file with kpartx -av
Date: Tue, 2 Feb 2016 16:37:51 -0500
Message-ID: <56B121AF.6090100@canonical.com>
References: <1453297965-32278-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<CABr-GnfeNpQPcuoRSLHTA5q8E3OF8as1zOTY7SP=bwMwtC=MFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0889591000587934189=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GnfeNpQPcuoRSLHTA5q8E3OF8as1zOTY7SP=bwMwtC=MFQ@mail.gmail.com>
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

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============0889591000587934189==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature";
	boundary="pFvhU98KgkPGKFretRFFR37uIE6NefcR7"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pFvhU98KgkPGKFretRFFR37uIE6NefcR7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le 2016-01-20 09:53, Christophe Varoqui a =C3=A9crit :
> Applied,
> thanks.
>=20

This patch apparently breaks the use of loopback-mounted files if you
try to use them directly with kpartx -av.

For instance:
qemu-img create foo.img 20M
sgdisk -n 1 foo.img
kpartx -av foo.img


Fails with the following error:
device-mapper: reload ioctl on loop0p1 failed: No such device
create/reload failed on loop0p1
add map loop0p1 (0:0): 0 4192256 linear 0:0 2048


This can be fixed by stat()'ing the loop device again after picking it:

--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -322,6 +322,11 @@ main(int argc, char **argv){
                        loopcreated =3D 1;
                }
                device =3D loopdev;
+
+               if (stat(device, &buf)) {
+                       printf("failed to stat() %s\n", device);
+                       exit (1);
+               }
        }

        off =3D find_devname_offset(device);




--=20
Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>
Freenode: cyphermox, Jabber: mathieu.tl@gmail.com
4096R/65B58DA1 818A D123 0992 275B 23C2  CF89 C67B B4D6 65B5 8DA1


--pFvhU98KgkPGKFretRFFR37uIE6NefcR7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJWsSGxAAoJEABpWkBMnr2n1y8P/1DaHpXl20RNGkDOqnF+sPfF
3F0hU2h0a1zXoSd5wGi9Qi/mGlYGieQk0BCGIQdCKJHi/N/45SFTTNPJNeA6Lcjt
fi8vzo+mFKP/+CSPhJ3KIpWDGnhf+VsazVDUQxJCh80C/eQGJkbvdIEZN4rwpCdn
mM7h7xMPl92NUKRcgDDhwElaYnfR4i//ymaGzdyiXcRTMTSUQGBC0w0ZN9v9m3C+
4AalmVMmwkTrQg8A07RYIc+OnqYu3+JDzvn8bbubGzLx/c9SzY2V0qpgMgwDSmCA
Zzl458IOjXL/dLAskvlKOpnKGmFAHLaRBXPWqoMCkEoT3BYR596XxeT+OVOf1ajb
pnLbty6ayFj64ah1p7mfE8xu0Czr1/aC2TG0GH8P3AJSm07KSre2G3wpGCks0cVL
BBiyNXp7gD1YDBhC+SS0Rbo6BuA5MDX5FCKFYMBl4a0r2qjMDNw7ulGb/RLuWlDh
aoBvI2n3vyzF/QHN2XZLIdI0d/WREdXtcMXaVzxfCLas4hHa10ohuiL012Zq6hgb
FZ4dxV94z6PaZX8y8nroU5Lvem9aqJ8zb08U+h038FhBVAa2uLgC/LjmoK6jBJ43
Qu64tiQgpr9jzAHfXkWOhwZAroC7m7T1Vycp63xZHLyeYDJyr33Ed73mHIh4vweu
CXOtWF+G7Xa/FzcofLMO
=2/70
-----END PGP SIGNATURE-----

--pFvhU98KgkPGKFretRFFR37uIE6NefcR7--


--===============0889591000587934189==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0889591000587934189==--
