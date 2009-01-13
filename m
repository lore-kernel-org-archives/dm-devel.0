From: dwu <dwu@redhat.com>
Subject: An multipath performance issue on RHEL 5
Date: Tue, 13 Jan 2009 17:11:23 +0800
Message-ID: <496C5ABB.8040602@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
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

A customer has done a test of multipath on RHEL 5, and he found that the=20
speed is 30-40MB/sec, but it can reach 160MB/sec when using EMC=20
powerpath or using multipath on RHEL 4. That customer just uses the=20
default configuration and I found there was a little difference between=20
the configurationfor EMC DGC in the hwtable of multipath on RHEL4 and=20
RHEL5. But I don't think that will impact performance. I have no idea=20
now. Who can help me? thanks.


r +=3D store_hwe_ext(hw,
"DGC",
"*",
GROUP_BY_PRIO,
DEFAULT_GETUID,
"/sbin/mpath_prio_emc /dev/%n",
"1 emc",
"1 queue_if_no_path",
"emc_clariion",
-FAILBACK_IMMEDIATE,
"LUNZ",
0, //no_path_retry,
0, //rr_weight,
0); //rr_min_io

{
.vendor =3D "DGC",
.product =3D ".*",
.bl_product =3D "LUNZ",
.getuid =3D DEFAULT_GETUID,
.getprio =3D "/sbin/mpath_prio_emc /dev/%n",
.features =3D "1 queue_if_no_path",
.hwhandler =3D "1 emc",
.selector =3D DEFAULT_SELECTOR,
.pgpolicy =3D GROUP_BY_PRIO,
.pgfailback =3D -FAILBACK_IMMEDIATE,
.rr_weight =3D RR_WEIGHT_NONE,
.no_path_retry =3D (300 / DEFAULT_CHECKINT),
.minio =3D DEFAULT_MINIO,
.checker_name =3D EMC_CLARIION,
},




[root@clnode2 ~]# hdparm -t /dev/mapper/mpath0

/dev/mapper/mpath0:
Timing buffered disk reads: 118 MB in 3.01 seconds =3D 39.22 MB/sec
[root@clnode2 ~]# hdparm -t /dev/mapper/mpath5

/dev/mapper/mpath5:
Timing buffered disk reads: 132 MB in 3.04 seconds =3D 43.38 MB/sec
[root@clnode2 tmp]# hdparm -t /dev/sdm

/dev/sdm:
Timing buffered disk reads: 112 MB in 3.04 seconds =3D 36.89 MB/sec
[root@clnode2 tmp]# hdparm -t /dev/sdaa

/dev/sdaa:
Timing buffered disk reads: 108 MB in 3.02 seconds =3D 35.81 MB/sec
[root@clnode2 tmp]# hdparm -t /dev/sdf

/dev/sdf:
Timing buffered disk reads: read() failed: Input/output error
[root@clnode2 tmp]# hdparm -t /dev/sdt

/dev/sdt:
Timing buffered disk reads: read() failed: Input/output error


[root@clnode2 tmp]# multipath -l
mpath2 (36006016067a21a001c72ef78bdd0dd11) dm-9 DGC,RAID 10
[size=3D43G][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D0][active]
\_ 1:0:0:1 sdp 8:240 [active][undef]
\_ 2:0:0:1 sdb 8:16 [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
\_ 2:0:1:1 sdi 8:128 [active][undef]
\_ 1:0:1:1 sdw 65:96 [active][undef]
mpath1 (36006016067a21a00901b9565bdd0dd11) dm-10 DGC,RAID 10
[size=3D3.5G][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D0][active]
\_ 2:0:0:3 sdd 8:48 [active][undef]
\_ 1:0:0:3 sdr 65:16 [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
\_ 2:0:1:3 sdk 8:160 [active][undef]
\_ 1:0:1:3 sdy 65:128 [active][undef]
mpath0 (36006016067a21a00029dbb1dbed0dd11) dm-0 DGC,RAID 10
[size=3D30G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
\_ 2:0:1:0 sdh 8:112 [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
\_ 2:0:0:0 sda 8:0 [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
\_ 1:0:0:0 sdo 8:224 [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
\_ 1:0:1:0 sdv 65:80 [active][undef]
mpath6 (36006016067a21a007c189b0cbed0dd11) dm-8 DGC,RAID 10
[size=3D1.0G][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D0][active]
\_ 2:0:1:6 sdn 8:208 [active][undef]
\_ 1:0:1:6 sdab 65:176 [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
\_ 2:0:0:6 sdg 8:96 [active][undef]
\_ 1:0:0:6 sdu 65:64 [active][undef]
mpath5 (36006016067a21a00c4aece82bdd0dd11) dm-6 DGC,RAID 10
[size=3D43G][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D0][active]
\_ 2:0:1:5 sdm 8:192 [active][undef]
\_ 1:0:1:5 sdaa 65:160 [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
\_ 2:0:0:5 sdf 8:80 [active][undef]
\_ 1:0:0:5 sdt 65:48 [active][undef]
mpath4 (36006016067a21a004cf7526fbdd0dd11) dm-7 DGC,RAID 10
[size=3D43G][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D0][active]
\_ 2:0:1:4 sdl 8:176 [active][undef]
\_ 1:0:1:4 sdz 65:144 [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
\_ 2:0:0:4 sde 8:64 [active][undef]
\_ 1:0:0:4 sds 65:32 [active][undef]
mpath3 (36006016067a21a00300e128dbdd0dd11) dm-11 DGC,RAID 10
[size=3D43G][features=3D1 queue_if_no_path][hwhandler=3D1 emc]
\_ round-robin 0 [prio=3D0][active]
\_ 2:0:0:2 sdc 8:32 [active][undef]
\_ 1:0:0:2 sdq 65:0 [active][undef]
\_ round-robin 0 [prio=3D0][enabled]
\_ 2:0:1:2 sdj 8:144 [active][undef]
\_ 1:0:1:2 sdx 65:112 [active][undef]

--=20
=E5=90=B4=E5=BE=B7=E6=96=B0  Mark Wu <dwu@redhat.com>    =20
Associate Technical Support Engineer            =20
Global Support Services
Red Hat China
Tel: +86 10 6533 9338
