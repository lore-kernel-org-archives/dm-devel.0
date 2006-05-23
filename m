From: <Thomas.vonSteiger@swisscom.com>
Subject: RE: [Consult-list] Re: dm-multipath has greatthroughputbut
	we'd like more!
Date: Tue, 23 May 2006 11:11:25 +0200
Message-ID: <D98EDC8DA509404185E74C0DFA2BF42D2458AD@sg1255z.corproot.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: rgautier@redhat.com
Cc: nstrug@redhat.com, dm-devel@redhat.com, consult-list@redhat.com
List-Id: dm-devel.ids

Here you can see vmstat during bonnie++ running on i686/ext3/multibus:
My Test SAN Disk's on HDS and has RAID6 / 1 x 14Gb LUN=20

vmstat 10
procs -----------memory---------- ---swap-- -----io---- --system--
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
id wa
 0  0    160 4048392   9160  24120    0    0    14    33   75    21  0
0 99  0
 0  0    160 4048264   9176  24104    0    0     0     6 1022    73  0
0 100  0
 2  0    160 2083800  11176 1944024    0    0    21 147243 1672   340  0
33 61  6 -->Writing intelligently
 2  0    160  15832   6692 3991588    0    0     0 203957 1730   281  0
42 40 18
 2  0    160  16856   6900 3992160    0    0     3 210644 1845   534  0
44 35 20
 1  0    160  16280   3896 3999844    0    0     8 190240 1756   530  0
36 27 37
 1  1    160  15768   3912 4007368    0    0 10711 94211 1472   426  0
13 52 34 -->Rewriting
 0  1    160  16744   3688 4007072    0    0 23499 21111 1269   486  0
4 62 35
 0  3    160  15248   1608 4009672    0    0 42230 36842 1456   826  0
6 57 36
 0  3    160  15928   1380 4009380    0    0 57532 57172 1667  1095  0
9 53 38
 0  3    160  16256   1552 4009468    0    0 64524 62128 1701  1200  0
10 49 41
 0  2    160  15744   1440 4009840    0    0 57516 59324 1682  1089  0
10 60 30
 0  2    160  16384   1420 4007520    0    0 56010 63978 1656  1069  0
11 57 32
 0  2    160  16512   1744 4007196    0    0 50093 54305 1591  1007  0
8 56 35
 0  2    160  16128   1680 4009600    0    0 60890 68262 1704  1155  0
10 54 36
 0  2    160  15640   1540 4011040    0    0 23447 27152 1284   486  0
4 62 34
 0  2    160  15624   1576 4010484    0    0 59322 55898 1645  1119  0
9 56 35
 0  2    160  16632   1472 4008508    0    0 59285 55417 1691  1126  0
10 59 31
 2  0    160  16440   1436 4009844    0    0 55198 65543 1655  1046  0
9 57 34
 0  2    160  16304   1412 4009348    0    0 63486 53479 1716  1194  0
10 59 31
 0  2    160  15664   1416 4009344    0    0 64524 63261 1737  1209  0
10 54 35
 0  2    160  16288   1408 4009872    0    0 64724 69324 1765  1232  0
10 48 42
 0  1    160  15816   1492 4013168    0    0 65955 20070 1605  1209  0
5 69 26
 1  0    160  16416   1772 4012888    0    0 91166     3 1727  1599  0
4 74 22 -->Reading intelligently
 0  1    160  16200   2080 4013880    0    0 95948     4 1769  1688  0
4 74 22
 0  1    160  16840   2268 4014992    0    0 87630     9 1701  1548  0
4 74 22
 0  1    160  15816   2300 4018340    0    0 89235     2 1714  1569  0
4 74 22
 0  1    160  15624   1812 4022208    0    0 104858     4 1840  1833  0
4 74 22
 0  1    160  16840   1904 4024456    0    0 100705     5 1808  1767  0
4 74 21
 0  1    160  16264   2296 4027184    0    0 68154     6 1563  1243  0
4 75 22
 0  0    160  16904   2600 4028960    0    0 53223     1 1444   984  0
3 79 18
 0  3    160  16136   6984 4024576    0    0  2064   150 1334  1386  0
0 81 19
 0  0    160 4050056   9084  24196    0    0  2108   406 1355   740  0
5 76 19
 0  0    160 4050184   9116  24164    0    0     0    26 1026    72  0
0 100  0


-----Original Message-----
From: Bob Gautier [mailto:rgautier@redhat.com]=20
Sent: Tuesday, May 23, 2006 9:29 AM
To: von Steiger Thomas, IT-SDL-SEE-HSE-LXE
Cc: dm-devel@redhat.com; consult-list@redhat.com; nstrug@redhat.com
Subject: RE: [Consult-list] Re: [dm-devel] dm-multipath has
greatthroughputbut we'd like more!

On Mon, 2006-05-22 at 19:21 +0200, Thomas.vonSteiger@swisscom.com wrote:
> Interessting Discussion!
>=20
> If you are running in a big enterprise SAN then it's possible that=20
> your server shares the HDS Port with 30 other servers.
>=20
> I have done
> "bonnie++ -d /iotest -s 6g -f -n 0 -u root" on AMD LS20 IBM Blade=20
> 2x2Gb's qla HBA's / 3Gb Mem and "bonnie++ -d /iotest -s 8g -f -n 0 -u=20
> root" on Intel HS20 IBM Blade / 2x2Gb's qla HBA's / 4Gb Mem.
> SAN Storage (HDS USP100) with dm-multipath (failover and multibus) for
> ext3 and ext2.
> OS are RHEL4/U3.
>=20
> Results are in the att bonnue1.html
>=20
> Defaults from /etc/multipath.conf:
> defaults {
>    udev_dir                /dev
>    polling_interval        10
>    selector                "round-robin 0"
>    default_path_grouping_policy   multibus
>    getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>    prio_callout            /bin/true
>    path_checker            readsector0
>    rr_min_io               100
>    rr_weight               priorities
>    failback                immediate
>    no_path_retry           20
>    user_friendly_name      yes
> }
>=20
> Thomas
>=20
>=20
>=20
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Nicholas C. Strugnell
> Sent: Thursday, May 18, 2006 11:43 AM
> To: rgautier@redhat.com
> Cc: device-mapper development; consult-list@redhat.com
> Subject: Re: [Consult-list] Re: [dm-devel] dm-multipath has=20
> greatthroughput but we'd like more!
>=20
> On Thu, 2006-05-18 at 10:04 +0200, Nicholas C. Strugnell wrote:=20
> > On Thu, 2006-05-18 at 08:44 +0100, Bob Gautier wrote:
> > > On Thu, 2006-05-18 at 02:25 -0500, Jonathan E Brassow wrote:
> > > > The system bus isn't a limiting factor is it?  64-bit PCI-X will

> > > > get
> > > > 8.5 GB/s (plenty), but 32-bit PCI 33MHz got 133MB/s.
> > > >=20
> > > > Can your disks sustain that much bandwidth? 10 striped drives=20
> > > > might get better than 200MB/s if done right, I suppose.
> > > >=20
> >=20
>=20
> > It might make sense to test raw writes to a device with dd and see=20
> > if that gets comparable performance figures - I'll just try that=20
> > myself actually.
>=20
> write throughput to EVA 8000 (8GB write cache), host DL380 with=20
> 2x2Gb/s HBAs, 2GB RAM
>=20
> testing 4GB files:
>=20
> on filesystems: bonnie++ -d /mnt/tmp -s 4g -f -n 0 -u root
>=20
> ext3: 129MB/s sd=3D0.43
>=20
> ext2: 202MB/s sd=3D21.34
> q
> on raw: 216MB/s sd=3D3.93  (dd if=3D/dev/zero=20
> of=3D/dev/mpath/3600508b4001048ba0000b00001400000 bs=3D4k count=3D10485=
76)
>=20
>=20
> NB I did not have exclusive access to the SAN or this particular=20
> storage array - this is a big corp. SAN network under quite heavy load

> and disk array under moderate load - not even sure if I had exclusive=20
> access to the disks. All values averaged over 20 runs.
>=20
> The very low deviation of write speed on ext3 vs. exr2 or raw is=20
> interesting - not sure if it means anything.
>=20
> In any case, we don't manage to get very close to the theoretical=20
> throughput of the 2 HBAs, 512MB/s

Thanks both of you for the interesting figures.  It looks like ext3 is
putting a heavier load on a machine than ext2 -- Thomas' CPU load in the
ext3 cases is quite high -- so maybe that's keeping throughput limited.

On the other hand, I still don't see why, if I can drive *two* HBAs at a
total of about 200MB/s, I can only drive *one* at about half that.

By the way, when we did our tests, the SAN was quiet lightly loaded, and
we were watching its write cache level quite closely to ensure we didn't
cause any problems for other users.

Bob G

>=20
> Nick
>=20
>=20
>=20
