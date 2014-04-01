From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 8/9] dm crypt: offload writes to thread
Date: Tue, 1 Apr 2014 14:01:48 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1404011355500.12362@file01.intranet.prod.int.rdu2.redhat.com>
References: <1396037476-26595-1-git-send-email-snitzer@redhat.com>
	<1396037476-26595-9-git-send-email-snitzer@redhat.com>
	<533AE8DC.5080004@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="185206533-1446336986-1396375308=:12362"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <533AE8DC.5080004@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ondrej Kozina <okozina@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--185206533-1446336986-1396375308=:12362
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by mx3-phx2.redhat.com id s31I2EjG017945



On Tue, 1 Apr 2014, Ondrej Kozina wrote:

> On 03/28/2014 09:11 PM, Mike Snitzer wrote:
> > From: Mikulas Patocka <mpatocka@redhat.com>
> >=20
> > Submitting write bios directly in the encryption thread caused seriou=
s
> > performance degradation.  On a multiprocessor machine, encryption req=
uests
> > finish in a different order than they were submitted.  Consequently, =
write
> > requests would be submitted in a different order and it could cause s=
evere
> > performance degradation.
> > (...)
>=20
> Hi,
>=20
> originally I planed to post result of performance testing but unfortuna=
tely I
> crashed the test machine several times with <in_subject> patch applied =
and
> onward:
>=20
> The test set up looks following:
>=20
> the base is kernel-3.14-rc8 with applied "[PATCH 2/9] block: use kmallo=
c
> alignment for bio slab"
>=20
> On top of base I compiled various dm-crypt modules:
>=20
> <no_patch>		=3D raw 3.14-rc8 dm-crypt module
> <no_percpu>		=3D "[PATCH 1/9]"
> <per_bio_data>		=3D <no_percpu> + "[PATCH 3/9]"
> <unbound>		=3D <per_bio_data> + "[PATCH 4/9]"
> <dont_allocate_wfix>	=3D <unbound> + "[PATCH 5/9]" + "[PATCH 6/9]"
> <remove_io_pool>	=3D <dont_allocate_wfix> + "[PATCH 7/9]"
> <offload>		=3D <remove_io_pool> + "[PATCH 8/9]"
> <sort>			=3D <offload> + "[PATCH 9/9]"
>=20
> All the modules above went through tests that are available here (origi=
nally
> write by Milan Broz, I have made only few modifications):
>=20
> http://okozina.fedorapeople.org/dmcrypt-tests.tar.xz
>=20
> All tests passed on single device tests with "test_disk" script
>=20
> Testing md raid5 backing device ("test_md" script) fails in test
> 2/dmcrypt-all-verify.sh. The failure occurs after it pushes data throug=
h
> dm-crypt device using "null" cipher:
>=20
> dmsetup create crypt --table "0 </dev/md0 bsize> crypt cipher_null-ecb-=
null -
> 0 /dev/md0 0"
>=20
> steps to reproduce is to load module with <offload> or <sort> dm-crypt
> modules:
>=20
> create md raid5 over 3 devices:
>=20
> 1) mdadm -C -l 5 -n 3 -c 64 --assume-clean /dev/md0 /dev/sd[xyz]
> 2) run 2/dmcrypt-all-verify.sh

I tried to run "./dmcrypt-all-verify.sh --dev /dev/md0 --testdir=20
/mnt/test" and the result was this.

That script is somehow buggy because it attempts to copy files that I hav=
e=20
in /usr/src to the test filesystem. It fills up the test filesystem and=20
fails. I don't know why is it trying to copy files not related to the tes=
t.

cp: nelze vytvo=F8it oby=E8ejn=FD soubor ,,/mnt/test/tst/usr/src/patch-3.=
5.xz":=20
Na za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/rpm" nelze vytvo=F8it: Na za=F8=ED=
zen=ED nen=ED=20
voln=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/patch-3.5.2.xz": Na za=F8=EDzen=ED nen=ED voln=E9=
 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/cryptsetup-1.6.3.tar.bz2": Na za=F8=EDzen=ED nen=ED=
 voln=E9=20
m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor ,,/mnt/test/tst/usr/src/patch-3.=
12.xz":=20
Na za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/dm-raid5-release.patch": Na za=F8=EDzen=ED nen=ED=
 voln=E9=20
m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/linux-3.14-rc6" nelze vytvo=F8it:=
 Na=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/linux-2.6.39" nelze vytvo=F8it: N=
a=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/openssh-6.1p1.tar.gz": Na za=F8=EDzen=ED nen=ED v=
oln=E9=20
m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/LVM2.2.02.98-test" nelze vytvo=F8=
it: Na=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/linux-3.10" nelze vytvo=F8it: Na=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/patch-3.14-rc4.xz": Na za=F8=EDzen=ED nen=ED voln=
=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/patch-3.14-rc8.xz": Na za=F8=EDzen=ED nen=ED voln=
=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/gcc-4.7.3-build64" nelze vytvo=F8=
it: Na=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/binutils-2.23.2.tar.bz2": Na za=F8=EDzen=ED nen=ED=
 voln=E9=20
m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/linux-3.2.7" nelze vytvo=F8it: Na=
=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/fio-2.0.15.tar.bzip.bz2": Na za=F8=EDzen=ED nen=ED=
 voln=E9=20
m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/fio-2.0.15" nelze vytvo=F8it: Na=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/gcc-4.7.3.tar.bz2": Na za=F8=EDzen=ED nen=ED voln=
=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor ,,/mnt/test/tst/usr/src/patch-3.=
9.xz":=20
Na za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor ,,/mnt/test/tst/usr/src/lvm.tar.=
gz": Na=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/gcc-4.6.3-build-arm" nelze vytvo=F8=
it:=20
Na za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/patch-3.9.2.xz": Na za=F8=EDzen=ED nen=ED voln=E9=
 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/linux-3.14" nelze vytvo=F8it: Na=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/linux-3.9.3-no-quota" nelze vytvo=
=F8it:=20
Na za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/patch-3.9.3-4.xz": Na za=F8=EDzen=ED nen=ED voln=E9=
 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/patch-3.9.5-6.xz": Na za=F8=EDzen=ED nen=ED voln=E9=
 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/patch-3.9.7-8.xz": Na za=F8=EDzen=ED nen=ED voln=E9=
 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/patch-3.10.4.xz": Na za=F8=EDzen=ED nen=ED voln=E9=
 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/patch-3.10.8.xz": Na za=F8=EDzen=ED nen=ED voln=E9=
 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/patch-3.10.8-9.xz": Na za=F8=EDzen=ED nen=ED voln=
=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor=20
,,/mnt/test/tst/usr/src/patch-3.11.3.xz": Na za=F8=EDzen=ED nen=ED voln=E9=
 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/linux-3.3" nelze vytvo=F8it: Na z=
a=F8=EDzen=ED=20
nen=ED voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/linux-3.5.4" nelze vytvo=F8it: Na=
=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/linux-3.7.2" nelze vytvo=F8it: Na=
=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/linux-3.9.4" nelze vytvo=F8it: Na=
=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/src/linux-3.9.8" nelze vytvo=F8it: Na=
=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/local" nelze vytvo=F8it: Na za=F8=EDz=
en=ED nen=ED=20
voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/hppa64-linux-gnu" nelze vytvo=F8it: N=
a=20
za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/X11R6" nelze vytvo=F8it: Na za=F8=EDz=
en=ED nen=ED=20
voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/hppa64-linux" nelze vytvo=F8it: Na za=
=F8=EDzen=ED=20
nen=ED voln=E9 m=EDsto
cp: adres=E1=F8 ,,/mnt/test/tst/usr/man" nelze vytvo=F8it: Na za=F8=EDzen=
=ED nen=ED=20
voln=E9 m=EDsto
cp: nelze vytvo=F8it oby=E8ejn=FD soubor ,,/mnt/test/tst/usr/patch-3.9-rc=
7.xz":=20
Na za=F8=EDzen=ED nen=ED voln=E9 m=EDsto
## 0 STACKTRACE() called from ./dmcrypt-all-verify.sh:116
## 1 c_usr_verify() called from ./dmcrypt-all-verify.sh:167
## 2 run_test() called from ./dmcrypt-all-verify.sh:256

Mikulas
--185206533-1446336986-1396375308=:12362
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 7bit


--185206533-1446336986-1396375308=:12362--
