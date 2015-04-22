From: Greg Walters <greg.walters@gatewaymedia.com>
Subject: Possible Bottleneck in dm-cache
Date: Wed, 22 Apr 2015 13:56:49 -0500
Message-ID: <5537EEF1.3030309@gatewaymedia.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5367020129199791233=="
Return-path: <dm-devel-bounces@redhat.com>
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
--===============5367020129199791233==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature";
	boundary="oIFs4jVwC7n4UtltLGA9x2nTLmTLffPxB"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oIFs4jVwC7n4UtltLGA9x2nTLmTLffPxB
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Good day!

Please CC me on any responses as I'm not subscribed to this list. I
think I'm seeing an interesting bottleneck in the dm-cache system and
hoping that you guys can shed some light on it for me. I've got a
dm-cache device setup with 3PAR storage as the origin device and a 1.2TB
FusionIO card as the cache device running on CentOS 6.6 with kernel
2.6.32-504.el6.x86_64. The FIO is chopped up a bit with LVM and is not
100% dedicated to cache. Here's the `lvs` and `dmsetup status` output
showing my setup:

**
# lvs vgFIO
  LV           VG    Attr       LSize   Pool     Origin             =20
Data%  Meta%  Move Log Cpy%Sync Convert
  lv_cache     vgFIO Cwi---C--- 864.24g
  mysql_cached vgFIO Cwi-aoC---   6.00t lv_cache [mysql_cached_corig]
  tmp          vgFIO -wi-ao---- 256.00g

# dmsetup status
vgFIO-mysql_cached: 0 12884803584 cache 8 28061/262144 128
14159744/14159744 19966771 45785332 1302688457 229213040 33859953
48019697 9150 1 writeback 2 migration_threshold 2048 mq 10
random_threshold 4 sequential_threshold 512 discard_promote_adjustment 1
read_promote_adjustment 4 write_promote_adjustment 8
vgFIO-mysql_cached_corig: 0 12884803584 linear
vg3PAR-sasdata2: 0 21474803712 linear
vgFIO-tmp: 0 536870912 linear
360002ac000000000000000040000c004: 0 12884901888 multipath 2 0 1 0 1 1 A
0 4 0 8:16 A 0 8:80 A 0 8:48 A 0 8:112 A 0
vgSlash-slash: 0 581238784 linear
vgSlash-swap: 0 4194304 linear
360002ac000000000000000050000c004: 0 21474836480 multipath 2 0 1 0 1 1 A
0 4 0 8:32 A 0 8:96 A 0 8:64 A 0 8:128 A 0
vgFIO-lv_cache_cdata: 0 1812447232 linear
vgFIO-lv_cache_cmeta: 0 2097152 linear
**


The commands I used to create this are:

**
lvcreate -L 1G -n lv_cache_meta vgFIO /dev/fioa
lvcreate -l 221246 -n lv_cache vgFIO /dev/fioa
lvcreate -l 1572852 -n mysql_cached vgFIO
/dev/mapper/360002ac000000000000000040000c004
lvconvert --type cache-pool --poolmetadata vgFIO/lv_cache_meta
--cachemode writeback vgFIO/lv_cache
lvconvert --type cache --cachepool vgFIO/lv_cache vgFIO/mysql_cached
**

The cached device is a mount for mysql to run on. Today mysql got very
busy and I saw odd throughput with a potential bottleneck on the cache
device cdata device. Given these device mappings:

**
# ls -l /dev/mapper/
total 0
lrwxrwxrwx 1 root root      7 Jan 27 02:10
360002ac0000000000000000e0000bc99 -> ../dm-4
lrwxrwxrwx 1 root root      7 Jan 27 02:10
360002ac0000000000000000f0000bc99 -> ../dm-6
lrwxrwxrwx 1 root root      7 Jan 27 02:10
360002ac000000000000000100000bc99 -> ../dm-5
lrwxrwxrwx 1 root root      7 Jan 27 02:10
360002ac000000000000000110000bc99 -> ../dm-7
crw-rw---- 1 root root 10, 58 Dec 30 00:17 control
lrwxrwxrwx 1 root root      7 Jan  2 22:03 vg3PAR-sasdata2 -> ../dm-8
lrwxrwxrwx 1 root root      8 Apr 22 18:07 vgFIO-lv_cache_cdata -> ../dm-=
10
lrwxrwxrwx 1 root root      8 Apr 22 18:07 vgFIO-lv_cache_cmeta -> ../dm-=
11
lrwxrwxrwx 1 root root      7 Apr 22 18:07 vgFIO-mysql_cached -> ../dm-9
lrwxrwxrwx 1 root root      8 Apr 22 18:07 vgFIO-mysql_cached_corig ->
=2E./dm-12
lrwxrwxrwx 1 root root      7 Jan  2 22:03 vgFIO-tmp -> ../dm-3
lrwxrwxrwx 1 root root      7 Apr 22 15:21 vgSlash-slash2 -> ../dm-1
lrwxrwxrwx 1 root root      7 Jan  2 22:03 vgSlash-swap -> ../dm-0
**

The iostat output below (a representative second of output from `iostat
-mx 1`) shows the top-level mounted device (dm-9) with very high
utilization and the cache cdata device (dm-10) also with high
utilization while all of the other devices remain rather idle.

**
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           3.12    0.00    1.79    3.99    0.00   91.10

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sda              31.00     0.00   10.00    0.00     0.23     0.00  =20
47.20     0.05    4.80   3.10   3.10
sdb               0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
dm-1              0.00     0.00   42.00    0.00     0.23     0.00  =20
11.24     0.08    1.90   0.74   3.10
fioa              0.00     0.00  415.00  516.00    25.89     6.20  =20
70.58     0.00    0.73   0.00   0.00
dm-3              0.00     0.00    0.00   16.00     0.00     0.06   =20
8.00     0.03    2.00   0.12   0.20
sdc               0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
sdd               0.00     0.00    0.00    3.00     0.00     0.19 =20
128.00     0.00    1.00   1.00   0.30
sde               0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
sdf               0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
sdg               0.00     0.00    0.00    3.00     0.00     0.19 =20
128.00     0.00    0.67   0.67   0.20
sdh               0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
sdi               0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
sdj               0.00     0.00    0.00    4.00     0.00     0.25 =20
128.00     0.00    1.00   1.00   0.40
sdk               0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
dm-4              0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
sdl               0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
dm-5              0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
sdm               0.00     0.00    0.00    3.00     0.00     0.19 =20
128.00     0.00    1.00   1.00   0.30
sdn               0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
dm-6              0.00     0.00    0.00   13.00     0.00     0.81 =20
128.00     0.01    0.92   0.77   1.00
dm-8              0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
sdo               0.00     0.00   16.00  100.00     1.03     6.20 =20
127.66     0.08    0.69   0.69   8.00
sdp               0.00     0.00   17.00   99.00     1.12     6.14 =20
128.28     0.08    0.66   0.66   7.60
sdq               0.00     0.00   14.00  103.00     1.26     6.44 =20
134.77     0.09    0.74   0.73   8.50
sdr               0.00     0.00   16.00  101.00     1.30     6.31 =20
133.33     0.09    0.74   0.74   8.70
dm-7             61.00     0.00   63.00  403.00     4.72    25.09 =20
131.02     0.34    0.74   0.56  25.90
dm-9              0.00     0.00  125.00  887.00     4.73     6.16  =20
22.04     2.82    2.79   0.96  97.50
dm-10             0.00     0.00  416.00  861.00    25.95     6.13  =20
51.46     2.05    1.61   0.63  80.30
dm-11             0.00     0.00    0.00    0.00     0.00     0.00   =20
0.00     0.00    0.00   0.00   0.00
dm-12             0.00     0.00  124.00  416.00     4.72    25.91 =20
116.15     0.40    0.75   0.49  26.30
**

Does the cache cdata device look like a bottleneck to you? Removing the
cache with `lvremove vgFIO/lv_cache` resulted in a massive increase in
throughput even before the cache finished flushing. Anyone have any
tuning/debugging/troubleshooting steps they can suggest?

Thanks,
Greg


--oIFs4jVwC7n4UtltLGA9x2nTLmTLffPxB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVN+7xAAoJEEinbUlq9amyMHMP/RAZE8R/N6anMW1PCCzqpJvg
VfkkIuu6bzPxcKG287ECTXnKswJ79vyj2LQ/r3Z121AmXVaZIRvXh3zNN4aFHXIp
ePNxPb55U6lV8n/844IqovgvWLHP1vFLYhmDITbQup3c3Zj8qEBxLFrlPyAM+075
9zw7KIvBhmKg6zn/LlviXOf1tN140GlH83pfa0tV1F2vjG6mBp4uaU2pSAlAmMJw
h2L1lk1HgBdPDdhRd6AXYeyAYiHEMj3ds87eKJhMb16JWcDJHI4u1DNMFslfQOkV
UFGNWwRbWjHkVKYjexcEbutLuE5pcIrt4tQyiyog/nlSZR/aAfCyV6wgwBRV+lpY
U0NtWV9kI94Fzw2ZCUmXs6iJbeFSKLAk7WqoHHGHH//P3Dcuca/zhphl7bMhkmWn
xuRgA81IOw/eJ8ecYaC7vR26t3ZspnfnIAsUECw5rVBvmkN5rJKyrqFyf4MyKn6c
pfM9xlpFZDiThB6jSGyvvqPqPCddUK038pcckV8GAQYmBXXUjEaCSq3Ok2EDwlyI
heIJLJQ6ntwyiT6izUjQBfHwfndiMAh70frOcSDw+0j7KO/hrDzjN+IF1FLILBct
UNPA/BplTuJBFe1YrevpAMu8bR45mC7g8WYyWweBeXqquhL+aj+p3SbW0T1TgtFB
eD9vHu/v7EggJI78akwc
=+d5k
-----END PGP SIGNATURE-----

--oIFs4jVwC7n4UtltLGA9x2nTLmTLffPxB--


--===============5367020129199791233==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5367020129199791233==--
