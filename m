From: "Daniel Keisling" <Daniel.Keisling@ppdi.com>
Subject: RE: RE: Temporarily squelching multipathd errors
Date: Fri, 16 Jan 2009 14:59:47 -0600
Message-ID: <65F9ACC78BD8304BAAEB817634C62D4C074412D3@AUSMAIL01.americas.ppdi.local>
References: <E154952FA1D141C18A9A128FEC40B34D@pitagora.it><65F9ACC78BD8304BAAEB817634C62D4C06EAFB63@AUSMAIL01.americas.ppdi.local>
	<20081126174317.GA19425@mars.virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <20081126174317.GA19425@mars.virtualiron.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Right now I'm deleting the LUN, immediately creating a new LUN, and
presenting it back to the system with the same SCSI ID.  Since it's a
snapshot, the LUN geometry is always the same.  I've tried unpresenting
the LUN, deleting the SCSI devices, recreating/presenting the LUN, and
then doing a SCSI rescan, but the multipath errors are always there. =20

Here's the multipath listings.  I am only deleting/presenting the
"mpath33" map, but you can see the multipath errors and the other paths
having a fault:

Unmounting /dev/mapper/mpath33p1...
Multipath listing before LUN is deleted...
cred_arch (3600508b400106fcd0000700011f30000) dm-52 HP,HSV210
[size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 1:0:4:17 sdgh 131:208 [active][ready]
 \_ 0:0:4:17 sdfx 131:48  [active][ready]
 \_ 0:0:6:17 sdgb 131:112 [active][ready]
 \_ 1:0:3:17 sdgf 131:176 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:3:17 sdfv 131:16  [active][ready]
 \_ 0:0:5:17 sdfz 131:80  [active][ready]
 \_ 1:0:2:17 sdgd 131:144 [active][ready]
 \_ 1:0:5:17 sdgj 131:240 [active][ready]
mpath19 (3600508b400106fcc000070002acb0000) dm-31 HP,HSV210
[size=3D10G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:71 sdap 66:144  [active][ready]
 \_ 0:0:6:71 sdch 69:80   [active][ready]
 \_ 1:0:3:71 sddz 128:16  [active][ready]
 \_ 1:0:4:71 sdev 129:112 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:71 sdbl 67:240  [active][ready]
 \_ 1:0:2:71 sddd 70:176  [active][ready]
 \_ 1:0:5:71 sdfr 130:208 [active][ready]
 \_ 0:0:3:71 sdt  65:48   [active][ready]
mpath21 (3600508b400106fcc000070002ac30000) dm-35 HP,HSV210
[size=3D90G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:73 sdar 66:176  [active][ready]
 \_ 0:0:6:73 sdcj 69:112  [active][ready]
 \_ 1:0:3:73 sdeb 128:48  [active][ready]
 \_ 1:0:4:73 sdex 129:144 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:73 sdbn 68:16   [active][ready]
 \_ 1:0:2:73 sddf 70:208  [active][ready]
 \_ 1:0:5:73 sdft 130:240 [active][ready]
 \_ 0:0:3:73 sdv  65:80   [active][ready]
limsd (3600508b400106fcc0000700027b30000) dm-7 HP,HSV210
[size=3D80G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:9  sdad 65:208  [active][ready]
 \_ 0:0:6:9  sdbv 68:144  [active][ready]
 \_ 1:0:3:9  sddn 71:80   [active][ready]
 \_ 1:0:4:9  sdej 128:176 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:9  sdaz 67:48   [active][ready]
 \_ 1:0:2:9  sdcr 69:240  [active][ready]
 \_ 1:0:5:9  sdff 130:16  [active][ready]
 \_ 0:0:3:9  sdh  8:112   [active][ready]
ph1t_arch (3600508b400106fcd0000700006880000) dm-23 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:20 sdal 66:80   [active][ready]
 \_ 0:0:6:20 sdcd 69:16   [active][ready]
 \_ 1:0:3:20 sddv 71:208  [active][ready]
 \_ 1:0:4:20 sder 129:48  [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:20 sdbh 67:176  [active][ready]
 \_ 1:0:2:20 sdcz 70:112  [active][ready]
 \_ 1:0:5:20 sdfn 130:144 [active][ready]
 \_ 0:0:3:20 sdp  8:240   [active][ready]
mpath18 (3600508b400106fcc000070002acf0000) dm-30 HP,HSV210
[size=3D30G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:70 sdao 66:128  [active][ready]
 \_ 0:0:6:70 sdcg 69:64   [active][ready]
 \_ 1:0:3:70 sddy 128:0   [active][ready]
 \_ 1:0:4:70 sdeu 129:96  [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:70 sdbk 67:224  [active][ready]
 \_ 1:0:2:70 sddc 70:160  [active][ready]
 \_ 1:0:5:70 sdfq 130:192 [active][ready]
 \_ 0:0:3:70 sds  65:32   [active][ready]
mpath20 (3600508b400106fcc000070002ac70000) dm-33 HP,HSV210
[size=3D80G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:72 sdaq 66:160  [active][ready]
 \_ 0:0:6:72 sdci 69:96   [active][ready]
 \_ 1:0:3:72 sdea 128:32  [active][ready]
 \_ 1:0:4:72 sdew 129:128 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:72 sdbm 68:0    [active][ready]
 \_ 1:0:2:72 sdde 70:192  [active][ready]
 \_ 1:0:5:72 sdfs 130:224 [active][ready]
 \_ 0:0:3:72 sdu  65:64   [active][ready]
cret_arch (3600508b400106fcc0000700027c20000) dm-12 HP,HSV210
[size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:12 sdag 66:0    [active][ready]
 \_ 0:0:6:12 sdby 68:192  [active][ready]
 \_ 1:0:3:12 sddq 71:128  [active][ready]
 \_ 1:0:4:12 sdem 128:224 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:12 sdbc 67:96   [active][ready]
 \_ 1:0:2:12 sdcu 70:32   [active][ready]
 \_ 1:0:5:12 sdfi 130:64  [active][ready]
 \_ 0:0:3:12 sdk  8:160   [active][ready]
raw3 (3600508b400106fcc0000700027a20000) dm-4 HP,HSV210
[size=3D4.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:5  sdaa 65:160  [active][ready]
 \_ 0:0:6:5  sdbs 68:96   [active][ready]
 \_ 1:0:3:5  sddk 71:32   [active][ready]
 \_ 1:0:4:5  sdeg 128:128 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:5  sdaw 67:0    [active][ready]
 \_ 1:0:2:5  sdco 69:192  [active][ready]
 \_ 0:0:3:5  sde  8:64    [active][ready]
 \_ 1:0:5:5  sdfc 129:224 [active][ready]
case (3600508b400106fcc0000700027c50000) dm-14 HP,HSV210
[size=3D30G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:13 sdah 66:16   [active][ready]
 \_ 0:0:6:13 sdbz 68:208  [active][ready]
 \_ 1:0:3:13 sddr 71:144  [active][ready]
 \_ 1:0:4:13 sden 128:240 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:13 sdbd 67:112  [active][ready]
 \_ 1:0:2:13 sdcv 70:48   [active][ready]
 \_ 1:0:5:13 sdfj 130:80  [active][ready]
 \_ 0:0:3:13 sdl  8:176   [active][ready]
limsd_arch (3600508b400106fcc0000700027b60000) dm-9 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:10 sdae 65:224  [active][ready]
 \_ 0:0:6:10 sdbw 68:160  [active][ready]
 \_ 1:0:3:10 sddo 71:96   [active][ready]
 \_ 1:0:4:10 sdek 128:192 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:10 sdba 67:64   [active][ready]
 \_ 1:0:2:10 sdcs 70:0    [active][ready]
 \_ 1:0:5:10 sdfg 130:32  [active][ready]
 \_ 0:0:3:10 sdi  8:128   [active][ready]
mpath33 (3600508b400106fcd0000700012030000) dm-55 HP,HSV210
[size=3D20G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:74 sdgl 132:16  [active][ready]
 \_ 0:0:6:74 sdgn 132:48  [active][ready]
 \_ 1:0:3:74 sdgp 132:80  [active][ready]
 \_ 1:0:4:74 sdgq 132:96  [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 1:0:2:74 sdgo 132:64  [active][ready]
 \_ 0:0:3:74 sdgk 132:0   [active][ready]
 \_ 0:0:5:74 sdgm 132:32  [active][ready]
 \_ 1:0:5:74 sdgr 132:112 [active][ready]
raw2 (3600508b400106fcc00007000279f0000) dm-44 HP,HSV210
[size=3D4.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:6:4  sdbr 68:80   [active][ready]
 \_ 1:0:3:4  sddj 71:16   [active][ready]
 \_ 1:0:4:4  sdef 128:112 [active][ready]
 \_ 0:0:4:4  sdz  65:144  [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:4  sdav 66:240  [active][ready]
 \_ 1:0:2:4  sdcn 69:176  [active][ready]
 \_ 0:0:3:4  sdd  8:48    [active][ready]
 \_ 1:0:5:4  sdfb 129:208 [active][ready]
raw1 (3600508b400106fcc0000700027940000) dm-42 HP,HSV210
[size=3D4.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:6:3  sdbq 68:64   [active][ready]
 \_ 1:0:3:3  sddi 71:0    [active][ready]
 \_ 1:0:4:3  sdee 128:96  [active][ready]
 \_ 0:0:4:3  sdy  65:128  [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:3  sdau 66:224  [active][ready]
 \_ 1:0:2:3  sdcm 69:160  [active][ready]
 \_ 0:0:3:3  sdc  8:32    [active][ready]
 \_ 1:0:5:3  sdfa 129:192 [active][ready]
cret (3600508b400106fcc0000700027bd0000) dm-11 HP,HSV210
[size=3D10G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:11 sdaf 65:240  [active][ready]
 \_ 0:0:6:11 sdbx 68:176  [active][ready]
 \_ 1:0:3:11 sddp 71:112  [active][ready]
 \_ 1:0:4:11 sdel 128:208 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:11 sdbb 67:80   [active][ready]
 \_ 1:0:2:11 sdct 70:16   [active][ready]
 \_ 1:0:5:11 sdfh 130:48  [active][ready]
 \_ 0:0:3:11 sdj  8:144   [active][ready]
case_arch (3600508b400106fcc0000700027ca0000) dm-16 HP,HSV210
[size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:14 sdai 66:32   [active][ready]
 \_ 0:0:6:14 sdca 68:224  [active][ready]
 \_ 1:0:3:14 sdds 71:160  [active][ready]
 \_ 1:0:4:14 sdeo 129:0   [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:14 sdbe 67:128  [active][ready]
 \_ 1:0:2:14 sdcw 70:64   [active][ready]
 \_ 1:0:5:14 sdfk 130:96  [active][ready]
 \_ 0:0:3:14 sdm  8:192   [active][ready]
limst_arch (3600508b400106fcd0000700006920000) dm-26 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:22 sdan 66:112  [active][ready]
 \_ 0:0:6:22 sdcf 69:48   [active][ready]
 \_ 1:0:3:22 sddx 71:240  [active][ready]
 \_ 1:0:4:22 sdet 129:80  [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:22 sdbj 67:208  [active][ready]
 \_ 1:0:2:22 sddb 70:144  [active][ready]
 \_ 1:0:5:22 sdfp 130:176 [active][ready]
 \_ 0:0:3:22 sdr  65:16   [active][ready]
orabackup (3600508b400106fcd000070000a560000) dm-19 HP,HSV210
[size=3D150G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:5:15 sdbf 67:144  [active][ready]
 \_ 1:0:2:15 sdcx 70:80   [active][ready]
 \_ 1:0:5:15 sdfl 130:112 [active][ready]
 \_ 0:0:3:15 sdn  8:208   [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:4:15 sdaj 66:48   [active][ready]
 \_ 0:0:6:15 sdcb 68:240  [active][ready]
 \_ 1:0:3:15 sddt 71:176  [active][ready]
 \_ 1:0:4:15 sdep 129:16  [active][ready]
oracle_bin (3600508b400106fcc0000700027810000) dm-36 HP,HSV210
[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:6:1  sdbo 68:32   [active][ready]
 \_ 1:0:3:1  sddg 70:224  [active][ready]
 \_ 1:0:4:1  sdec 128:64  [active][ready]
 \_ 0:0:4:1  sdw  65:96   [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:1  sdas 66:192  [active][ready]
 \_ 0:0:3:1  sda  8:0     [active][ready]
 \_ 1:0:2:1  sdck 69:128  [active][ready]
 \_ 1:0:5:1  sdey 129:160 [active][ready]
ph1t (3600508b400106fcd0000700006830000) dm-21 HP,HSV210
[size=3D150G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:19 sdak 66:64   [active][ready]
 \_ 0:0:6:19 sdcc 69:0    [active][ready]
 \_ 1:0:3:19 sddu 71:192  [active][ready]
 \_ 1:0:4:19 sdeq 129:32  [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:19 sdbg 67:160  [active][ready]
 \_ 1:0:2:19 sdcy 70:96   [active][ready]
 \_ 1:0:5:19 sdfm 130:128 [active][ready]
 \_ 0:0:3:19 sdo  8:224   [active][ready]
cred (3600508b400106fcd0000700011ee0000) dm-51 HP,HSV210
[size=3D20G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 1:0:3:16 sdge 131:160 [active][ready]
 \_ 0:0:4:16 sdfw 131:32  [active][ready]
 \_ 0:0:6:16 sdga 131:96  [active][ready]
 \_ 1:0:4:16 sdgg 131:192 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:3:16 sdfu 131:0   [active][ready]
 \_ 0:0:5:16 sdfy 131:64  [active][ready]
 \_ 1:0:2:16 sdgc 131:128 [active][ready]
 \_ 1:0:5:16 sdgi 131:224 [active][ready]
oracle_crs (3600508b400106fcc00007000278b0000) dm-39 HP,HSV210
[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:6:2  sdbp 68:48   [active][ready]
 \_ 1:0:3:2  sddh 70:240  [active][ready]
 \_ 1:0:4:2  sded 128:80  [active][ready]
 \_ 0:0:4:2  sdx  65:112  [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:2  sdat 66:208  [active][ready]
 \_ 0:0:3:2  sdb  8:16    [active][ready]
 \_ 1:0:2:2  sdcl 69:144  [active][ready]
 \_ 1:0:5:2  sdez 129:176 [active][ready]
limst (3600508b400106fcd00007000068d0000) dm-24 HP,HSV210
[size=3D400G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:5:21 sdbi 67:192  [active][ready]
 \_ 1:0:2:21 sdda 70:128  [active][ready]
 \_ 1:0:5:21 sdfo 130:160 [active][ready]
 \_ 0:0:3:21 sdq  65:0    [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:4:21 sdam 66:96   [active][ready]
 \_ 0:0:6:21 sdce 69:32   [active][ready]
 \_ 1:0:3:21 sddw 71:224  [active][ready]
 \_ 1:0:4:21 sdes 129:64  [active][ready]
ph1d (3600508b400106fcc0000700027a50000) dm-5 HP,HSV210
[size=3D90G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:7  sdab 65:176  [active][ready]
 \_ 0:0:6:7  sdbt 68:112  [active][ready]
 \_ 1:0:3:7  sddl 71:48   [active][ready]
 \_ 1:0:4:7  sdeh 128:144 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:7  sdax 67:16   [active][ready]
 \_ 1:0:2:7  sdcp 69:208  [active][ready]
 \_ 1:0:5:7  sdfd 129:240 [active][ready]
 \_ 0:0:3:7  sdf  8:80    [active][ready]
ph1d_arch (3600508b400106fcc0000700027a80000) dm-6 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:8  sdac 65:192  [active][ready]
 \_ 0:0:6:8  sdbu 68:128  [active][ready]
 \_ 1:0:3:8  sddm 71:64   [active][ready]
 \_ 1:0:4:8  sdei 128:160 [active][ready]
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:8  sday 67:32   [active][ready]
 \_ 1:0:2:8  sdcq 69:224  [active][ready]
 \_ 1:0:5:8  sdfe 130:0   [active][ready]
 \_ 0:0:3:8  sdg  8:96    [active][ready]


Multipath listing after LUN is deleted and before LUN is added...

sdab: checker msg is "tur checker reports path is down"
sdae: checker msg is "tur checker reports path is down"
sdaf: checker msg is "tur checker reports path is down"
sdah: checker msg is "tur checker reports path is down"
sdaj: checker msg is "tur checker reports path is down"
sdal: checker msg is "tur checker reports path is down"
sdam: checker msg is "tur checker reports path is down"
sdan: checker msg is "tur checker reports path is down"
sdap: checker msg is "tur checker reports path is down"
sdar: checker msg is "tur checker reports path is down"
sdas: checker msg is "tur checker reports path is down"
sdat: checker msg is "tur checker reports path is down"
sdau: checker msg is "tur checker reports path is down"
sdav: checker msg is "tur checker reports path is down"
sdaw: checker msg is "tur checker reports path is down"
sdax: checker msg is "tur checker reports path is down"
sday: checker msg is "tur checker reports path is down"
sdaz: checker msg is "tur checker reports path is down"
sda: checker msg is "tur checker reports path is down"
sdba: checker msg is "tur checker reports path is down"
sdbb: checker msg is "tur checker reports path is down"
sdbc: checker msg is "tur checker reports path is down"
sdbd: checker msg is "tur checker reports path is down"
sdbe: checker msg is "tur checker reports path is down"
sdbf: checker msg is "tur checker reports path is down"
sdbg: checker msg is "tur checker reports path is down"
sdbh: checker msg is "tur checker reports path is down"
sdbi: checker msg is "tur checker reports path is down"
sdbj: checker msg is "tur checker reports path is down"
sdbk: checker msg is "tur checker reports path is down"
sdbl: checker msg is "tur checker reports path is down"
sdbm: checker msg is "tur checker reports path is down"
sdbn: checker msg is "tur checker reports path is down"
sdbo: checker msg is "tur checker reports path is down"
sdbp: checker msg is "tur checker reports path is down"
sdbs: checker msg is "tur checker reports path is down"
sdbt: checker msg is "tur checker reports path is down"
sdbu: checker msg is "tur checker reports path is down"
sdbv: checker msg is "tur checker reports path is down"
sdbw: checker msg is "tur checker reports path is down"
sdby: checker msg is "tur checker reports path is down"
sdb: checker msg is "tur checker reports path is down"
sdca: checker msg is "tur checker reports path is down"
sdcb: checker msg is "tur checker reports path is down"
sdcc: checker msg is "tur checker reports path is down"
sdcd: checker msg is "tur checker reports path is down"
sdce: checker msg is "tur checker reports path is down"
sdcg: checker msg is "tur checker reports path is down"
sdch: checker msg is "tur checker reports path is down"
sdci: checker msg is "tur checker reports path is down"
sdck: checker msg is "tur checker reports path is down"
sdcl: checker msg is "tur checker reports path is down"
sdcm: checker msg is "tur checker reports path is down"
sdcn: checker msg is "tur checker reports path is down"
sdco: checker msg is "tur checker reports path is down"
sdcp: checker msg is "tur checker reports path is down"
sdcq: checker msg is "tur checker reports path is down"
sdcr: checker msg is "tur checker reports path is down"
sdcs: checker msg is "tur checker reports path is down"
sdct: checker msg is "tur checker reports path is down"
sdcu: checker msg is "tur checker reports path is down"
sdcv: checker msg is "tur checker reports path is down"
sdcw: checker msg is "tur checker reports path is down"
sdcx: checker msg is "tur checker reports path is down"
sdcy: checker msg is "tur checker reports path is down"
sdcz: checker msg is "tur checker reports path is down"
sdc: checker msg is "tur checker reports path is down"
sddb: checker msg is "tur checker reports path is down"
sddc: checker msg is "tur checker reports path is down"
sddd: checker msg is "tur checker reports path is down"
sdde: checker msg is "tur checker reports path is down"
sddf: checker msg is "tur checker reports path is down"
sddg: checker msg is "tur checker reports path is down"
sddh: checker msg is "tur checker reports path is down"
sddi: checker msg is "tur checker reports path is down"
sddj: checker msg is "tur checker reports path is down"
sddk: checker msg is "tur checker reports path is down"
sddl: checker msg is "tur checker reports path is down"
sddm: checker msg is "tur checker reports path is down"
sddn: checker msg is "tur checker reports path is down"
sddp: checker msg is "tur checker reports path is down"
sddq: checker msg is "tur checker reports path is down"
sddr: checker msg is "tur checker reports path is down"
sdds: checker msg is "tur checker reports path is down"
sddt: checker msg is "tur checker reports path is down"
sddu: checker msg is "tur checker reports path is down"
sddv: checker msg is "tur checker reports path is down"
sddw: checker msg is "tur checker reports path is down"
sddx: checker msg is "tur checker reports path is down"
sddy: checker msg is "tur checker reports path is down"
sdd: checker msg is "tur checker reports path is down"
sdea: checker msg is "tur checker reports path is down"
sdeb: checker msg is "tur checker reports path is down"
sdec: checker msg is "tur checker reports path is down"
sded: checker msg is "tur checker reports path is down"
sdee: checker msg is "tur checker reports path is down"
sdef: checker msg is "tur checker reports path is down"
sdeg: checker msg is "tur checker reports path is down"
sdei: checker msg is "tur checker reports path is down"
sdej: checker msg is "tur checker reports path is down"
sdek: checker msg is "tur checker reports path is down"
sdel: checker msg is "tur checker reports path is down"
sdem: checker msg is "tur checker reports path is down"
sden: checker msg is "tur checker reports path is down"
sdeo: checker msg is "tur checker reports path is down"
sdep: checker msg is "tur checker reports path is down"
sdes: checker msg is "tur checker reports path is down"
sdet: checker msg is "tur checker reports path is down"
sdeu: checker msg is "tur checker reports path is down"
sdev: checker msg is "tur checker reports path is down"
sdew: checker msg is "tur checker reports path is down"
sdex: checker msg is "tur checker reports path is down"
sdey: checker msg is "tur checker reports path is down"
sdez: checker msg is "tur checker reports path is down"
sde: checker msg is "tur checker reports path is down"
sdfa: checker msg is "tur checker reports path is down"
sdfb: checker msg is "tur checker reports path is down"
sdfc: checker msg is "tur checker reports path is down"
sdfd: checker msg is "tur checker reports path is down"
sdfe: checker msg is "tur checker reports path is down"
sdff: checker msg is "tur checker reports path is down"
sdfg: checker msg is "tur checker reports path is down"
sdfh: checker msg is "tur checker reports path is down"
sdfi: checker msg is "tur checker reports path is down"
sdfj: checker msg is "tur checker reports path is down"
sdfk: checker msg is "tur checker reports path is down"
sdfl: checker msg is "tur checker reports path is down"
sdfm: checker msg is "tur checker reports path is down"
sdfn: checker msg is "tur checker reports path is down"
sdfo: checker msg is "tur checker reports path is down"
sdfp: checker msg is "tur checker reports path is down"
sdfq: checker msg is "tur checker reports path is down"
sdfr: checker msg is "tur checker reports path is down"
sdfs: checker msg is "tur checker reports path is down"
sdft: checker msg is "tur checker reports path is down"
sdfv: checker msg is "tur checker reports path is down"
sdfz: checker msg is "tur checker reports path is down"
sdf: checker msg is "tur checker reports path is down"
sdgb: checker msg is "tur checker reports path is down"
sdgd: checker msg is "tur checker reports path is down"
sdge: checker msg is "tur checker reports path is down"
sdgf: checker msg is "tur checker reports path is down"
sdgg: checker msg is "tur checker reports path is down"
sdgh: checker msg is "tur checker reports path is down"
sdgi: checker msg is "tur checker reports path is down"
sdgj: checker msg is "tur checker reports path is down"
sdgk: checker msg is "tur checker reports path is down"
sdgl: checker msg is "tur checker reports path is down"
sdgm: checker msg is "tur checker reports path is down"
sdgn: checker msg is "tur checker reports path is down"
sdgo: checker msg is "tur checker reports path is down"
sdgp: checker msg is "tur checker reports path is down"
sdgq: checker msg is "tur checker reports path is down"
sdgr: checker msg is "tur checker reports path is down"
sdg: checker msg is "tur checker reports path is down"
sdh: checker msg is "tur checker reports path is down"
sdi: checker msg is "tur checker reports path is down"
sdj: checker msg is "tur checker reports path is down"
sdk: checker msg is "tur checker reports path is down"
sdl: checker msg is "tur checker reports path is down"
sdm: checker msg is "tur checker reports path is down"
sdn: checker msg is "tur checker reports path is down"
sdo: checker msg is "tur checker reports path is down"
sdp: checker msg is "tur checker reports path is down"
sdr: checker msg is "tur checker reports path is down"
sds: checker msg is "tur checker reports path is down"
sdt: checker msg is "tur checker reports path is down"
sdu: checker msg is "tur checker reports path is down"
sdv: checker msg is "tur checker reports path is down"
sdx: checker msg is "tur checker reports path is down"
sdy: checker msg is "tur checker reports path is down"
sdz: checker msg is "tur checker reports path is down"
cred_arch (3600508b400106fcd0000700011f30000) dm-52 HP,HSV210
[size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 1:0:4:17 sdgh 131:208 [active][faulty]
 \_ 0:0:4:17 sdfx 131:48  [active][ready]=20
 \_ 0:0:6:17 sdgb 131:112 [active][faulty]
 \_ 1:0:3:17 sdgf 131:176 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:3:17 sdfv 131:16  [active][faulty]
 \_ 0:0:5:17 sdfz 131:80  [active][faulty]
 \_ 1:0:2:17 sdgd 131:144 [active][faulty]
 \_ 1:0:5:17 sdgj 131:240 [active][faulty]
mpath19 (3600508b400106fcc000070002acb0000) dm-31 HP,HSV210
[size=3D10G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:71 sdap 66:144  [active][faulty]
 \_ 0:0:6:71 sdch 69:80   [active][faulty]
 \_ 1:0:3:71 sddz 128:16  [active][ready]=20
 \_ 1:0:4:71 sdev 129:112 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:71 sdbl 67:240  [active][faulty]
 \_ 1:0:2:71 sddd 70:176  [active][faulty]
 \_ 1:0:5:71 sdfr 130:208 [active][faulty]
 \_ 0:0:3:71 sdt  65:48   [active][faulty]
mpath21 (3600508b400106fcc000070002ac30000) dm-35 HP,HSV210
[size=3D90G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:73 sdar 66:176  [active][faulty]
 \_ 0:0:6:73 sdcj 69:112  [active][ready]=20
 \_ 1:0:3:73 sdeb 128:48  [active][faulty]
 \_ 1:0:4:73 sdex 129:144 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:73 sdbn 68:16   [active][faulty]
 \_ 1:0:2:73 sddf 70:208  [active][faulty]
 \_ 1:0:5:73 sdft 130:240 [active][faulty]
 \_ 0:0:3:73 sdv  65:80   [active][faulty]
limsd (3600508b400106fcc0000700027b30000) dm-7 HP,HSV210
[size=3D80G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:9  sdad 65:208  [active][ready]=20
 \_ 0:0:6:9  sdbv 68:144  [active][faulty]
 \_ 1:0:3:9  sddn 71:80   [active][faulty]
 \_ 1:0:4:9  sdej 128:176 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:9  sdaz 67:48   [active][faulty]
 \_ 1:0:2:9  sdcr 69:240  [active][faulty]
 \_ 1:0:5:9  sdff 130:16  [active][faulty]
 \_ 0:0:3:9  sdh  8:112   [active][faulty]
ph1t_arch (3600508b400106fcd0000700006880000) dm-23 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:20 sdal 66:80   [active][faulty]
 \_ 0:0:6:20 sdcd 69:16   [active][faulty]
 \_ 1:0:3:20 sddv 71:208  [active][faulty]
 \_ 1:0:4:20 sder 129:48  [active][ready]=20
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:20 sdbh 67:176  [active][faulty]
 \_ 1:0:2:20 sdcz 70:112  [active][faulty]
 \_ 1:0:5:20 sdfn 130:144 [active][faulty]
 \_ 0:0:3:20 sdp  8:240   [active][faulty]
mpath18 (3600508b400106fcc000070002acf0000) dm-30 HP,HSV210
[size=3D30G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:70 sdao 66:128  [active][ready]=20
 \_ 0:0:6:70 sdcg 69:64   [active][faulty]
 \_ 1:0:3:70 sddy 128:0   [active][faulty]
 \_ 1:0:4:70 sdeu 129:96  [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:70 sdbk 67:224  [active][faulty]
 \_ 1:0:2:70 sddc 70:160  [active][faulty]
 \_ 1:0:5:70 sdfq 130:192 [active][faulty]
 \_ 0:0:3:70 sds  65:32   [active][faulty]
mpath20 (3600508b400106fcc000070002ac70000) dm-33 HP,HSV210
[size=3D80G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:72 sdaq 66:160  [active][ready]=20
 \_ 0:0:6:72 sdci 69:96   [active][faulty]
 \_ 1:0:3:72 sdea 128:32  [active][faulty]
 \_ 1:0:4:72 sdew 129:128 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:72 sdbm 68:0    [active][faulty]
 \_ 1:0:2:72 sdde 70:192  [active][faulty]
 \_ 1:0:5:72 sdfs 130:224 [active][faulty]
 \_ 0:0:3:72 sdu  65:64   [active][faulty]
cret_arch (3600508b400106fcc0000700027c20000) dm-12 HP,HSV210
[size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:12 sdag 66:0    [active][ready]=20
 \_ 0:0:6:12 sdby 68:192  [active][faulty]
 \_ 1:0:3:12 sddq 71:128  [active][faulty]
 \_ 1:0:4:12 sdem 128:224 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:12 sdbc 67:96   [active][faulty]
 \_ 1:0:2:12 sdcu 70:32   [active][faulty]
 \_ 1:0:5:12 sdfi 130:64  [active][faulty]
 \_ 0:0:3:12 sdk  8:160   [active][faulty]
raw3 (3600508b400106fcc0000700027a20000) dm-4 HP,HSV210
[size=3D4.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:5  sdaa 65:160  [active][ready]=20
 \_ 0:0:6:5  sdbs 68:96   [active][faulty]
 \_ 1:0:3:5  sddk 71:32   [active][faulty]
 \_ 1:0:4:5  sdeg 128:128 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:5  sdaw 67:0    [active][faulty]
 \_ 1:0:2:5  sdco 69:192  [active][faulty]
 \_ 0:0:3:5  sde  8:64    [active][faulty]
 \_ 1:0:5:5  sdfc 129:224 [active][faulty]
case (3600508b400106fcc0000700027c50000) dm-14 HP,HSV210
[size=3D30G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:13 sdah 66:16   [active][faulty]
 \_ 0:0:6:13 sdbz 68:208  [active][ready]=20
 \_ 1:0:3:13 sddr 71:144  [active][faulty]
 \_ 1:0:4:13 sden 128:240 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:13 sdbd 67:112  [active][faulty]
 \_ 1:0:2:13 sdcv 70:48   [active][faulty]
 \_ 1:0:5:13 sdfj 130:80  [active][faulty]
 \_ 0:0:3:13 sdl  8:176   [active][faulty]
limsd_arch (3600508b400106fcc0000700027b60000) dm-9 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:10 sdae 65:224  [active][faulty]
 \_ 0:0:6:10 sdbw 68:160  [active][faulty]
 \_ 1:0:3:10 sddo 71:96   [active][ready]=20
 \_ 1:0:4:10 sdek 128:192 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:10 sdba 67:64   [active][faulty]
 \_ 1:0:2:10 sdcs 70:0    [active][faulty]
 \_ 1:0:5:10 sdfg 130:32  [active][faulty]
 \_ 0:0:3:10 sdi  8:128   [active][faulty]
mpath33 (3600508b400106fcd0000700012030000) dm-55 HP,HSV210
[size=3D20G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
 \_ 0:0:4:74 sdgl 132:16  [active][faulty]
 \_ 0:0:6:74 sdgn 132:48  [active][faulty]
 \_ 1:0:3:74 sdgp 132:80  [active][faulty]
 \_ 1:0:4:74 sdgq 132:96  [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 1:0:2:74 sdgo 132:64  [active][faulty]
 \_ 0:0:3:74 sdgk 132:0   [active][faulty]
 \_ 0:0:5:74 sdgm 132:32  [active][faulty]
 \_ 1:0:5:74 sdgr 132:112 [active][faulty]
raw2 (3600508b400106fcc00007000279f0000) dm-44 HP,HSV210
[size=3D4.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:6:4  sdbr 68:80   [active][ready]=20
 \_ 1:0:3:4  sddj 71:16   [active][faulty]
 \_ 1:0:4:4  sdef 128:112 [active][faulty]
 \_ 0:0:4:4  sdz  65:144  [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:4  sdav 66:240  [active][faulty]
 \_ 1:0:2:4  sdcn 69:176  [active][faulty]
 \_ 0:0:3:4  sdd  8:48    [active][faulty]
 \_ 1:0:5:4  sdfb 129:208 [active][faulty]
raw1 (3600508b400106fcc0000700027940000) dm-42 HP,HSV210
[size=3D4.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:6:3  sdbq 68:64   [active][ready]=20
 \_ 1:0:3:3  sddi 71:0    [active][faulty]
 \_ 1:0:4:3  sdee 128:96  [active][faulty]
 \_ 0:0:4:3  sdy  65:128  [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:3  sdau 66:224  [active][faulty]
 \_ 1:0:2:3  sdcm 69:160  [active][faulty]
 \_ 0:0:3:3  sdc  8:32    [active][faulty]
 \_ 1:0:5:3  sdfa 129:192 [active][faulty]
cret (3600508b400106fcc0000700027bd0000) dm-11 HP,HSV210
[size=3D10G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:11 sdaf 65:240  [active][faulty]
 \_ 0:0:6:11 sdbx 68:176  [active][ready]=20
 \_ 1:0:3:11 sddp 71:112  [active][faulty]
 \_ 1:0:4:11 sdel 128:208 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:11 sdbb 67:80   [active][faulty]
 \_ 1:0:2:11 sdct 70:16   [active][faulty]
 \_ 1:0:5:11 sdfh 130:48  [active][faulty]
 \_ 0:0:3:11 sdj  8:144   [active][faulty]
case_arch (3600508b400106fcc0000700027ca0000) dm-16 HP,HSV210
[size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:14 sdai 66:32   [active][ready]=20
 \_ 0:0:6:14 sdca 68:224  [active][faulty]
 \_ 1:0:3:14 sdds 71:160  [active][faulty]
 \_ 1:0:4:14 sdeo 129:0   [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:14 sdbe 67:128  [active][faulty]
 \_ 1:0:2:14 sdcw 70:64   [active][faulty]
 \_ 1:0:5:14 sdfk 130:96  [active][faulty]
 \_ 0:0:3:14 sdm  8:192   [active][faulty]
limst_arch (3600508b400106fcd0000700006920000) dm-26 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:22 sdan 66:112  [active][faulty]
 \_ 0:0:6:22 sdcf 69:48   [active][ready]=20
 \_ 1:0:3:22 sddx 71:240  [active][faulty]
 \_ 1:0:4:22 sdet 129:80  [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:22 sdbj 67:208  [active][faulty]
 \_ 1:0:2:22 sddb 70:144  [active][faulty]
 \_ 1:0:5:22 sdfp 130:176 [active][faulty]
 \_ 0:0:3:22 sdr  65:16   [active][faulty]
orabackup (3600508b400106fcd000070000a560000) dm-19 HP,HSV210
[size=3D150G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
 \_ 0:0:5:15 sdbf 67:144  [active][faulty]
 \_ 1:0:2:15 sdcx 70:80   [active][faulty]
 \_ 1:0:5:15 sdfl 130:112 [active][faulty]
 \_ 0:0:3:15 sdn  8:208   [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:4:15 sdaj 66:48   [active][faulty]
 \_ 0:0:6:15 sdcb 68:240  [active][faulty]
 \_ 1:0:3:15 sddt 71:176  [active][faulty]
 \_ 1:0:4:15 sdep 129:16  [active][faulty]
oracle_bin (3600508b400106fcc0000700027810000) dm-36 HP,HSV210
[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:6:1  sdbo 68:32   [active][faulty]
 \_ 1:0:3:1  sddg 70:224  [active][faulty]
 \_ 1:0:4:1  sdec 128:64  [active][faulty]
 \_ 0:0:4:1  sdw  65:96   [active][ready]=20
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:1  sdas 66:192  [active][faulty]
 \_ 0:0:3:1  sda  8:0     [active][faulty]
 \_ 1:0:2:1  sdck 69:128  [active][faulty]
 \_ 1:0:5:1  sdey 129:160 [active][faulty]
ph1t (3600508b400106fcd0000700006830000) dm-21 HP,HSV210
[size=3D150G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D100][active]
 \_ 0:0:4:19 sdak 66:64   [active][ready]=20
 \_ 0:0:6:19 sdcc 69:0    [active][faulty]
 \_ 1:0:3:19 sddu 71:192  [active][faulty]
 \_ 1:0:4:19 sdeq 129:32  [active][ready]=20
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:19 sdbg 67:160  [active][faulty]
 \_ 1:0:2:19 sdcy 70:96   [active][faulty]
 \_ 1:0:5:19 sdfm 130:128 [active][faulty]
 \_ 0:0:3:19 sdo  8:224   [active][faulty]
cred (3600508b400106fcd0000700011ee0000) dm-51 HP,HSV210
[size=3D20G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D100][active]
 \_ 1:0:3:16 sdge 131:160 [active][faulty]
 \_ 0:0:4:16 sdfw 131:32  [active][ready]=20
 \_ 0:0:6:16 sdga 131:96  [active][ready]=20
 \_ 1:0:4:16 sdgg 131:192 [active][faulty]
\_ round-robin 0 [prio=3D30][enabled]
 \_ 0:0:3:16 sdfu 131:0   [active][ready]=20
 \_ 0:0:5:16 sdfy 131:64  [active][ready]=20
 \_ 1:0:2:16 sdgc 131:128 [active][ready]=20
 \_ 1:0:5:16 sdgi 131:224 [active][faulty]
oracle_crs (3600508b400106fcc00007000278b0000) dm-39 HP,HSV210
[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
 \_ 0:0:6:2  sdbp 68:48   [active][faulty]
 \_ 1:0:3:2  sddh 70:240  [active][faulty]
 \_ 1:0:4:2  sded 128:80  [active][faulty]
 \_ 0:0:4:2  sdx  65:112  [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:2  sdat 66:208  [active][faulty]
 \_ 0:0:3:2  sdb  8:16    [active][faulty]
 \_ 1:0:2:2  sdcl 69:144  [active][faulty]
 \_ 1:0:5:2  sdez 129:176 [active][faulty]
limst (3600508b400106fcd00007000068d0000) dm-24 HP,HSV210
[size=3D400G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D100][active]
 \_ 0:0:5:21 sdbi 67:192  [active][faulty]
 \_ 1:0:2:21 sdda 70:128  [active][ready]=20
 \_ 1:0:5:21 sdfo 130:160 [active][faulty]
 \_ 0:0:3:21 sdq  65:0    [active][ready]=20
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:4:21 sdam 66:96   [active][faulty]
 \_ 0:0:6:21 sdce 69:32   [active][faulty]
 \_ 1:0:3:21 sddw 71:224  [active][faulty]
 \_ 1:0:4:21 sdes 129:64  [active][faulty]
ph1d (3600508b400106fcc0000700027a50000) dm-5 HP,HSV210
[size=3D90G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:7  sdab 65:176  [active][faulty]
 \_ 0:0:6:7  sdbt 68:112  [active][faulty]
 \_ 1:0:3:7  sddl 71:48   [active][faulty]
 \_ 1:0:4:7  sdeh 128:144 [active][ready]=20
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:7  sdax 67:16   [active][faulty]
 \_ 1:0:2:7  sdcp 69:208  [active][faulty]
 \_ 1:0:5:7  sdfd 129:240 [active][faulty]
 \_ 0:0:3:7  sdf  8:80    [active][faulty]
ph1d_arch (3600508b400106fcc0000700027a80000) dm-6 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:8  sdac 65:192  [active][ready]=20
 \_ 0:0:6:8  sdbu 68:128  [active][faulty]
 \_ 1:0:3:8  sddm 71:64   [active][faulty]
 \_ 1:0:4:8  sdei 128:160 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:8  sday 67:32   [active][faulty]
 \_ 1:0:2:8  sdcq 69:224  [active][faulty]
 \_ 1:0:5:8  sdfe 130:0   [active][faulty]
 \_ 0:0:3:8  sdg  8:96    [active][faulty]


Multipath output after LUN is added...

sdab: checker msg is "tur checker reports path is down"
sdae: checker msg is "tur checker reports path is down"
sdaf: checker msg is "tur checker reports path is down"
sdaj: checker msg is "tur checker reports path is down"
sdak: checker msg is "tur checker reports path is down"
sdal: checker msg is "tur checker reports path is down"
sdam: checker msg is "tur checker reports path is down"
sdan: checker msg is "tur checker reports path is down"
sdap: checker msg is "tur checker reports path is down"
sdar: checker msg is "tur checker reports path is down"
sdas: checker msg is "tur checker reports path is down"
sdat: checker msg is "tur checker reports path is down"
sdau: checker msg is "tur checker reports path is down"
sdav: checker msg is "tur checker reports path is down"
sdaw: checker msg is "tur checker reports path is down"
sdax: checker msg is "tur checker reports path is down"
sday: checker msg is "tur checker reports path is down"
sdaz: checker msg is "tur checker reports path is down"
sda: checker msg is "tur checker reports path is down"
sdba: checker msg is "tur checker reports path is down"
sdbb: checker msg is "tur checker reports path is down"
sdbc: checker msg is "tur checker reports path is down"
sdbd: checker msg is "tur checker reports path is down"
sdbe: checker msg is "tur checker reports path is down"
sdbf: checker msg is "tur checker reports path is down"
sdbg: checker msg is "tur checker reports path is down"
sdbh: checker msg is "tur checker reports path is down"
sdbi: checker msg is "tur checker reports path is down"
sdbj: checker msg is "tur checker reports path is down"
sdbk: checker msg is "tur checker reports path is down"
sdbl: checker msg is "tur checker reports path is down"
sdbm: checker msg is "tur checker reports path is down"
sdbn: checker msg is "tur checker reports path is down"
sdbo: checker msg is "tur checker reports path is down"
sdbp: checker msg is "tur checker reports path is down"
sdbs: checker msg is "tur checker reports path is down"
sdbt: checker msg is "tur checker reports path is down"
sdbu: checker msg is "tur checker reports path is down"
sdbv: checker msg is "tur checker reports path is down"
sdbw: checker msg is "tur checker reports path is down"
sdby: checker msg is "tur checker reports path is down"
sdbz: checker msg is "tur checker reports path is down"
sdb: checker msg is "tur checker reports path is down"
sdca: checker msg is "tur checker reports path is down"
sdcb: checker msg is "tur checker reports path is down"
sdcc: checker msg is "tur checker reports path is down"
sdcd: checker msg is "tur checker reports path is down"
sdce: checker msg is "tur checker reports path is down"
sdcg: checker msg is "tur checker reports path is down"
sdch: checker msg is "tur checker reports path is down"
sdci: checker msg is "tur checker reports path is down"
sdck: checker msg is "tur checker reports path is down"
sdcl: checker msg is "tur checker reports path is down"
sdcm: checker msg is "tur checker reports path is down"
sdcn: checker msg is "tur checker reports path is down"
sdco: checker msg is "tur checker reports path is down"
sdcp: checker msg is "tur checker reports path is down"
sdcq: checker msg is "tur checker reports path is down"
sdcr: checker msg is "tur checker reports path is down"
sdcs: checker msg is "tur checker reports path is down"
sdct: checker msg is "tur checker reports path is down"
sdcu: checker msg is "tur checker reports path is down"
sdcv: checker msg is "tur checker reports path is down"
sdcw: checker msg is "tur checker reports path is down"
sdcx: checker msg is "tur checker reports path is down"
sdcy: checker msg is "tur checker reports path is down"
sdcz: checker msg is "tur checker reports path is down"
sdc: checker msg is "tur checker reports path is down"
sddb: checker msg is "tur checker reports path is down"
sddc: checker msg is "tur checker reports path is down"
sddd: checker msg is "tur checker reports path is down"
sdde: checker msg is "tur checker reports path is down"
sddf: checker msg is "tur checker reports path is down"
sddg: checker msg is "tur checker reports path is down"
sddh: checker msg is "tur checker reports path is down"
sddi: checker msg is "tur checker reports path is down"
sddj: checker msg is "tur checker reports path is down"
sddk: checker msg is "tur checker reports path is down"
sddm: checker msg is "tur checker reports path is down"
sddn: checker msg is "tur checker reports path is down"
sddp: checker msg is "tur checker reports path is down"
sddq: checker msg is "tur checker reports path is down"
sddr: checker msg is "tur checker reports path is down"
sdds: checker msg is "tur checker reports path is down"
sddt: checker msg is "tur checker reports path is down"
sddu: checker msg is "tur checker reports path is down"
sddv: checker msg is "tur checker reports path is down"
sddw: checker msg is "tur checker reports path is down"
sddx: checker msg is "tur checker reports path is down"
sddy: checker msg is "tur checker reports path is down"
sdd: checker msg is "tur checker reports path is down"
sdea: checker msg is "tur checker reports path is down"
sdeb: checker msg is "tur checker reports path is down"
sdee: checker msg is "tur checker reports path is down"
sdef: checker msg is "tur checker reports path is down"
sdeg: checker msg is "tur checker reports path is down"
sdeh: checker msg is "tur checker reports path is down"
sdei: checker msg is "tur checker reports path is down"
sdej: checker msg is "tur checker reports path is down"
sdek: checker msg is "tur checker reports path is down"
sdel: checker msg is "tur checker reports path is down"
sdem: checker msg is "tur checker reports path is down"
sden: checker msg is "tur checker reports path is down"
sdeo: checker msg is "tur checker reports path is down"
sdep: checker msg is "tur checker reports path is down"
sdes: checker msg is "tur checker reports path is down"
sdet: checker msg is "tur checker reports path is down"
sdeu: checker msg is "tur checker reports path is down"
sdev: checker msg is "tur checker reports path is down"
sdew: checker msg is "tur checker reports path is down"
sdex: checker msg is "tur checker reports path is down"
sdey: checker msg is "tur checker reports path is down"
sdez: checker msg is "tur checker reports path is down"
sde: checker msg is "tur checker reports path is down"
sdfa: checker msg is "tur checker reports path is down"
sdfb: checker msg is "tur checker reports path is down"
sdfc: checker msg is "tur checker reports path is down"
sdfd: checker msg is "tur checker reports path is down"
sdfe: checker msg is "tur checker reports path is down"
sdff: checker msg is "tur checker reports path is down"
sdfg: checker msg is "tur checker reports path is down"
sdfh: checker msg is "tur checker reports path is down"
sdfi: checker msg is "tur checker reports path is down"
sdfj: checker msg is "tur checker reports path is down"
sdfk: checker msg is "tur checker reports path is down"
sdfl: checker msg is "tur checker reports path is down"
sdfm: checker msg is "tur checker reports path is down"
sdfn: checker msg is "tur checker reports path is down"
sdfo: checker msg is "tur checker reports path is down"
sdfp: checker msg is "tur checker reports path is down"
sdfq: checker msg is "tur checker reports path is down"
sdfr: checker msg is "tur checker reports path is down"
sdfs: checker msg is "tur checker reports path is down"
sdft: checker msg is "tur checker reports path is down"
sdfv: checker msg is "tur checker reports path is down"
sdfz: checker msg is "tur checker reports path is down"
sdf: checker msg is "tur checker reports path is down"
sdgb: checker msg is "tur checker reports path is down"
sdgd: checker msg is "tur checker reports path is down"
sdge: checker msg is "tur checker reports path is down"
sdgf: checker msg is "tur checker reports path is down"
sdgg: checker msg is "tur checker reports path is down"
sdgh: checker msg is "tur checker reports path is down"
sdgi: checker msg is "tur checker reports path is down"
sdgj: checker msg is "tur checker reports path is down"
sdgk: checker msg is "tur checker reports path is down"
sdgl: checker msg is "tur checker reports path is down"
sdgm: checker msg is "tur checker reports path is down"
sdgn: checker msg is "tur checker reports path is down"
sdgo: checker msg is "tur checker reports path is down"
sdgp: checker msg is "tur checker reports path is down"
sdgq: checker msg is "tur checker reports path is down"
sdgr: checker msg is "tur checker reports path is down"
sdg: checker msg is "tur checker reports path is down"
sdh: checker msg is "tur checker reports path is down"
sdi: checker msg is "tur checker reports path is down"
sdj: checker msg is "tur checker reports path is down"
sdk: checker msg is "tur checker reports path is down"
sdl: checker msg is "tur checker reports path is down"
sdm: checker msg is "tur checker reports path is down"
sdn: checker msg is "tur checker reports path is down"
sdo: checker msg is "tur checker reports path is down"
sdp: checker msg is "tur checker reports path is down"
sdq: checker msg is "tur checker reports path is down"
sdr: checker msg is "tur checker reports path is down"
sds: checker msg is "tur checker reports path is down"
sdt: checker msg is "tur checker reports path is down"
sdu: checker msg is "tur checker reports path is down"
sdv: checker msg is "tur checker reports path is down"
sdx: checker msg is "tur checker reports path is down"
cred_arch (3600508b400106fcd0000700011f30000) dm-52 HP,HSV210
[size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 1:0:4:17 sdgh 131:208 [active][faulty]
 \_ 0:0:4:17 sdfx 131:48  [active][ready]=20
 \_ 0:0:6:17 sdgb 131:112 [active][faulty]
 \_ 1:0:3:17 sdgf 131:176 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:3:17 sdfv 131:16  [active][faulty]
 \_ 0:0:5:17 sdfz 131:80  [active][faulty]
 \_ 1:0:2:17 sdgd 131:144 [active][faulty]
 \_ 1:0:5:17 sdgj 131:240 [active][faulty]
mpath19 (3600508b400106fcc000070002acb0000) dm-31 HP,HSV210
[size=3D10G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:71 sdap 66:144  [active][faulty]
 \_ 0:0:6:71 sdch 69:80   [active][faulty]
 \_ 1:0:3:71 sddz 128:16  [active][ready]=20
 \_ 1:0:4:71 sdev 129:112 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:71 sdbl 67:240  [active][faulty]
 \_ 1:0:2:71 sddd 70:176  [active][faulty]
 \_ 1:0:5:71 sdfr 130:208 [active][faulty]
 \_ 0:0:3:71 sdt  65:48   [active][faulty]
mpath21 (3600508b400106fcc000070002ac30000) dm-35 HP,HSV210
[size=3D90G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:73 sdar 66:176  [active][faulty]
 \_ 0:0:6:73 sdcj 69:112  [active][ready]=20
 \_ 1:0:3:73 sdeb 128:48  [active][faulty]
 \_ 1:0:4:73 sdex 129:144 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:73 sdbn 68:16   [active][faulty]
 \_ 1:0:2:73 sddf 70:208  [active][faulty]
 \_ 1:0:5:73 sdft 130:240 [active][faulty]
 \_ 0:0:3:73 sdv  65:80   [active][faulty]
limsd (3600508b400106fcc0000700027b30000) dm-7 HP,HSV210
[size=3D80G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:9  sdad 65:208  [active][ready]=20
 \_ 0:0:6:9  sdbv 68:144  [active][faulty]
 \_ 1:0:3:9  sddn 71:80   [active][faulty]
 \_ 1:0:4:9  sdej 128:176 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:9  sdaz 67:48   [active][faulty]
 \_ 1:0:2:9  sdcr 69:240  [active][faulty]
 \_ 1:0:5:9  sdff 130:16  [active][faulty]
 \_ 0:0:3:9  sdh  8:112   [active][faulty]
ph1t_arch (3600508b400106fcd0000700006880000) dm-23 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:20 sdal 66:80   [active][faulty]
 \_ 0:0:6:20 sdcd 69:16   [active][faulty]
 \_ 1:0:3:20 sddv 71:208  [active][faulty]
 \_ 1:0:4:20 sder 129:48  [active][ready]=20
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:20 sdbh 67:176  [active][faulty]
 \_ 1:0:2:20 sdcz 70:112  [active][faulty]
 \_ 1:0:5:20 sdfn 130:144 [active][faulty]
 \_ 0:0:3:20 sdp  8:240   [active][faulty]
mpath18 (3600508b400106fcc000070002acf0000) dm-30 HP,HSV210
[size=3D30G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:70 sdao 66:128  [active][ready]=20
 \_ 0:0:6:70 sdcg 69:64   [active][faulty]
 \_ 1:0:3:70 sddy 128:0   [active][faulty]
 \_ 1:0:4:70 sdeu 129:96  [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:70 sdbk 67:224  [active][faulty]
 \_ 1:0:2:70 sddc 70:160  [active][faulty]
 \_ 1:0:5:70 sdfq 130:192 [active][faulty]
 \_ 0:0:3:70 sds  65:32   [active][faulty]
mpath20 (3600508b400106fcc000070002ac70000) dm-33 HP,HSV210
[size=3D80G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:72 sdaq 66:160  [active][ready]=20
 \_ 0:0:6:72 sdci 69:96   [active][faulty]
 \_ 1:0:3:72 sdea 128:32  [active][faulty]
 \_ 1:0:4:72 sdew 129:128 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:72 sdbm 68:0    [active][faulty]
 \_ 1:0:2:72 sdde 70:192  [active][faulty]
 \_ 1:0:5:72 sdfs 130:224 [active][faulty]
 \_ 0:0:3:72 sdu  65:64   [active][faulty]
cret_arch (3600508b400106fcc0000700027c20000) dm-12 HP,HSV210
[size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:12 sdag 66:0    [active][ready]=20
 \_ 0:0:6:12 sdby 68:192  [active][faulty]
 \_ 1:0:3:12 sddq 71:128  [active][faulty]
 \_ 1:0:4:12 sdem 128:224 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:12 sdbc 67:96   [active][faulty]
 \_ 1:0:2:12 sdcu 70:32   [active][faulty]
 \_ 1:0:5:12 sdfi 130:64  [active][faulty]
 \_ 0:0:3:12 sdk  8:160   [active][faulty]
raw3 (3600508b400106fcc0000700027a20000) dm-4 HP,HSV210
[size=3D4.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:5  sdaa 65:160  [active][ready]=20
 \_ 0:0:6:5  sdbs 68:96   [active][faulty]
 \_ 1:0:3:5  sddk 71:32   [active][faulty]
 \_ 1:0:4:5  sdeg 128:128 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:5  sdaw 67:0    [active][faulty]
 \_ 1:0:2:5  sdco 69:192  [active][faulty]
 \_ 0:0:3:5  sde  8:64    [active][faulty]
 \_ 1:0:5:5  sdfc 129:224 [active][faulty]
case (3600508b400106fcc0000700027c50000) dm-14 HP,HSV210
[size=3D30G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:13 sdah 66:16   [active][ready]=20
 \_ 0:0:6:13 sdbz 68:208  [active][faulty]
 \_ 1:0:3:13 sddr 71:144  [active][faulty]
 \_ 1:0:4:13 sden 128:240 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:13 sdbd 67:112  [active][faulty]
 \_ 1:0:2:13 sdcv 70:48   [active][faulty]
 \_ 1:0:5:13 sdfj 130:80  [active][faulty]
 \_ 0:0:3:13 sdl  8:176   [active][faulty]
limsd_arch (3600508b400106fcc0000700027b60000) dm-9 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:10 sdae 65:224  [active][faulty]
 \_ 0:0:6:10 sdbw 68:160  [active][faulty]
 \_ 1:0:3:10 sddo 71:96   [active][ready]=20
 \_ 1:0:4:10 sdek 128:192 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:10 sdba 67:64   [active][faulty]
 \_ 1:0:2:10 sdcs 70:0    [active][faulty]
 \_ 1:0:5:10 sdfg 130:32  [active][faulty]
 \_ 0:0:3:10 sdi  8:128   [active][faulty]
mpath33 (3600508b400106fcd0000700012030000) dm-55 HP,HSV210
[size=3D20G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
 \_ 0:0:4:74 sdgl 132:16  [active][faulty]
 \_ 0:0:6:74 sdgn 132:48  [active][faulty]
 \_ 1:0:3:74 sdgp 132:80  [active][faulty]
 \_ 1:0:4:74 sdgq 132:96  [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 1:0:2:74 sdgo 132:64  [active][faulty]
 \_ 0:0:3:74 sdgk 132:0   [active][faulty]
 \_ 0:0:5:74 sdgm 132:32  [active][faulty]
 \_ 1:0:5:74 sdgr 132:112 [active][faulty]
raw2 (3600508b400106fcc00007000279f0000) dm-44 HP,HSV210
[size=3D4.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D100][active]
 \_ 0:0:6:4  sdbr 68:80   [active][ready]=20
 \_ 1:0:3:4  sddj 71:16   [active][faulty]
 \_ 1:0:4:4  sdef 128:112 [active][faulty]
 \_ 0:0:4:4  sdz  65:144  [active][ready]=20
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:4  sdav 66:240  [active][faulty]
 \_ 1:0:2:4  sdcn 69:176  [active][faulty]
 \_ 0:0:3:4  sdd  8:48    [active][faulty]
 \_ 1:0:5:4  sdfb 129:208 [active][faulty]
raw1 (3600508b400106fcc0000700027940000) dm-42 HP,HSV210
[size=3D4.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D100][active]
 \_ 0:0:6:3  sdbq 68:64   [active][ready]=20
 \_ 1:0:3:3  sddi 71:0    [active][faulty]
 \_ 1:0:4:3  sdee 128:96  [active][faulty]
 \_ 0:0:4:3  sdy  65:128  [active][ready]=20
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:3  sdau 66:224  [active][faulty]
 \_ 1:0:2:3  sdcm 69:160  [active][faulty]
 \_ 0:0:3:3  sdc  8:32    [active][faulty]
 \_ 1:0:5:3  sdfa 129:192 [active][faulty]
cret (3600508b400106fcc0000700027bd0000) dm-11 HP,HSV210
[size=3D10G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:11 sdaf 65:240  [active][faulty]
 \_ 0:0:6:11 sdbx 68:176  [active][ready]=20
 \_ 1:0:3:11 sddp 71:112  [active][faulty]
 \_ 1:0:4:11 sdel 128:208 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:11 sdbb 67:80   [active][faulty]
 \_ 1:0:2:11 sdct 70:16   [active][faulty]
 \_ 1:0:5:11 sdfh 130:48  [active][faulty]
 \_ 0:0:3:11 sdj  8:144   [active][faulty]
case_arch (3600508b400106fcc0000700027ca0000) dm-16 HP,HSV210
[size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:14 sdai 66:32   [active][ready]=20
 \_ 0:0:6:14 sdca 68:224  [active][faulty]
 \_ 1:0:3:14 sdds 71:160  [active][faulty]
 \_ 1:0:4:14 sdeo 129:0   [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:14 sdbe 67:128  [active][faulty]
 \_ 1:0:2:14 sdcw 70:64   [active][faulty]
 \_ 1:0:5:14 sdfk 130:96  [active][faulty]
 \_ 0:0:3:14 sdm  8:192   [active][faulty]
limst_arch (3600508b400106fcd0000700006920000) dm-26 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:22 sdan 66:112  [active][faulty]
 \_ 0:0:6:22 sdcf 69:48   [active][ready]=20
 \_ 1:0:3:22 sddx 71:240  [active][faulty]
 \_ 1:0:4:22 sdet 129:80  [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:22 sdbj 67:208  [active][faulty]
 \_ 1:0:2:22 sddb 70:144  [active][faulty]
 \_ 1:0:5:22 sdfp 130:176 [active][faulty]
 \_ 0:0:3:22 sdr  65:16   [active][faulty]
orabackup (3600508b400106fcd000070000a560000) dm-19 HP,HSV210
[size=3D150G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D0][active]
 \_ 0:0:5:15 sdbf 67:144  [active][faulty]
 \_ 1:0:2:15 sdcx 70:80   [active][faulty]
 \_ 1:0:5:15 sdfl 130:112 [active][faulty]
 \_ 0:0:3:15 sdn  8:208   [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:4:15 sdaj 66:48   [active][faulty]
 \_ 0:0:6:15 sdcb 68:240  [active][faulty]
 \_ 1:0:3:15 sddt 71:176  [active][faulty]
 \_ 1:0:4:15 sdep 129:16  [active][faulty]
oracle_bin (3600508b400106fcc0000700027810000) dm-36 HP,HSV210
[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D100][active]
 \_ 0:0:6:1  sdbo 68:32   [active][faulty]
 \_ 1:0:3:1  sddg 70:224  [active][faulty]
 \_ 1:0:4:1  sdec 128:64  [active][ready]=20
 \_ 0:0:4:1  sdw  65:96   [active][ready]=20
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:1  sdas 66:192  [active][faulty]
 \_ 0:0:3:1  sda  8:0     [active][faulty]
 \_ 1:0:2:1  sdck 69:128  [active][faulty]
 \_ 1:0:5:1  sdey 129:160 [active][faulty]
ph1t (3600508b400106fcd0000700006830000) dm-21 HP,HSV210
[size=3D150G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:19 sdak 66:64   [active][faulty]
 \_ 0:0:6:19 sdcc 69:0    [active][faulty]
 \_ 1:0:3:19 sddu 71:192  [active][faulty]
 \_ 1:0:4:19 sdeq 129:32  [active][ready]=20
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:19 sdbg 67:160  [active][faulty]
 \_ 1:0:2:19 sdcy 70:96   [active][faulty]
 \_ 1:0:5:19 sdfm 130:128 [active][faulty]
 \_ 0:0:3:19 sdo  8:224   [active][faulty]
cred (3600508b400106fcd0000700011ee0000) dm-51 HP,HSV210
[size=3D20G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D100][active]
 \_ 1:0:3:16 sdge 131:160 [active][faulty]
 \_ 0:0:4:16 sdfw 131:32  [active][ready]=20
 \_ 0:0:6:16 sdga 131:96  [active][ready]=20
 \_ 1:0:4:16 sdgg 131:192 [active][faulty]
\_ round-robin 0 [prio=3D30][enabled]
 \_ 0:0:3:16 sdfu 131:0   [active][ready]=20
 \_ 0:0:5:16 sdfy 131:64  [active][ready]=20
 \_ 1:0:2:16 sdgc 131:128 [active][ready]=20
 \_ 1:0:5:16 sdgi 131:224 [active][faulty]
oracle_crs (3600508b400106fcc00007000278b0000) dm-39 HP,HSV210
[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:6:2  sdbp 68:48   [active][faulty]
 \_ 1:0:3:2  sddh 70:240  [active][faulty]
 \_ 1:0:4:2  sded 128:80  [active][ready]=20
 \_ 0:0:4:2  sdx  65:112  [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:2  sdat 66:208  [active][faulty]
 \_ 0:0:3:2  sdb  8:16    [active][faulty]
 \_ 1:0:2:2  sdcl 69:144  [active][faulty]
 \_ 1:0:5:2  sdez 129:176 [active][faulty]
limst (3600508b400106fcd00007000068d0000) dm-24 HP,HSV210
[size=3D400G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:5:21 sdbi 67:192  [active][faulty]
 \_ 1:0:2:21 sdda 70:128  [active][ready]=20
 \_ 1:0:5:21 sdfo 130:160 [active][faulty]
 \_ 0:0:3:21 sdq  65:0    [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:4:21 sdam 66:96   [active][faulty]
 \_ 0:0:6:21 sdce 69:32   [active][faulty]
 \_ 1:0:3:21 sddw 71:224  [active][faulty]
 \_ 1:0:4:21 sdes 129:64  [active][faulty]
ph1d (3600508b400106fcc0000700027a50000) dm-5 HP,HSV210
[size=3D90G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:7  sdab 65:176  [active][faulty]
 \_ 0:0:6:7  sdbt 68:112  [active][faulty]
 \_ 1:0:3:7  sddl 71:48   [active][ready]=20
 \_ 1:0:4:7  sdeh 128:144 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:7  sdax 67:16   [active][faulty]
 \_ 1:0:2:7  sdcp 69:208  [active][faulty]
 \_ 1:0:5:7  sdfd 129:240 [active][faulty]
 \_ 0:0:3:7  sdf  8:80    [active][faulty]
ph1d_arch (3600508b400106fcc0000700027a80000) dm-6 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D50][active]
 \_ 0:0:4:8  sdac 65:192  [active][ready]=20
 \_ 0:0:6:8  sdbu 68:128  [active][faulty]
 \_ 1:0:3:8  sddm 71:64   [active][faulty]
 \_ 1:0:4:8  sdei 128:160 [active][faulty]
\_ round-robin 0 [prio=3D0][enabled]
 \_ 0:0:5:8  sday 67:32   [active][faulty]
 \_ 1:0:2:8  sdcq 69:224  [active][faulty]
 \_ 1:0:5:8  sdfe 130:0   [active][faulty]
 \_ 0:0:3:8  sdg  8:96    [active][faulty]
tunefs.ocfs2 1.2.7
Changing volume uuid from 9ae66bce-bb02-4ee6-a28a-06db530a1933 to
59cd99d4-1f78-4e34-aeae-f13cc7deb721
Updating on-disk superblock by force.
DANGER: YOU MUST BE ABSOLUTELY SURE THAT NO OTHER NODE IS USING THIS
FILESYSTEM BEFORE CONTINUING.
Proceed (y/N): Changed volume uuid
Wrote Superblock
Changing label of /dev/mapper/mpath33p1 to ss_cred-
tunefs.ocfs2 1.2.7
tunefs.ocfs2: Node slot 0's journal is dirty. Run fsck.ocfs2 to replay
all dirty journals. Fscking /dev/mapper/mpath33p1
Checking OCFS2 filesystem in /dev/mapper/mpath33p1:
  label:              creq
  uuid:               59 cd 99 d4 1f 78 4e 34 ae ae f1 3c c7 de b7 21=20
  number of blocks:   5241198
  bytes per block:    4096
  number of clusters: 5241198
  bytes per cluster:  4096
  max slots:          4

/dev/mapper/mpath33p1 is clean.  It will be checked after 20 additional
mounts.
Mounting /dev/mapper/mpath33p1 as /orasnapbackup/cred/bkup

Multipath output after LUN is mounted...
sdgk: checker msg is "tur checker reports path is down"
sdgm: checker msg is "tur checker reports path is down"
sdgo: checker msg is "tur checker reports path is down"
sdgr: checker msg is "tur checker reports path is down"
cred_arch (3600508b400106fcd0000700011f30000) dm-52 HP,HSV210
[size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 1:0:4:17 sdgh 131:208 [active][ready]=20
 \_ 0:0:4:17 sdfx 131:48  [active][ready]=20
 \_ 0:0:6:17 sdgb 131:112 [active][ready]=20
 \_ 1:0:3:17 sdgf 131:176 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:3:17 sdfv 131:16  [active][ready]=20
 \_ 0:0:5:17 sdfz 131:80  [active][ready]=20
 \_ 1:0:2:17 sdgd 131:144 [active][ready]=20
 \_ 1:0:5:17 sdgj 131:240 [active][ready]=20
mpath19 (3600508b400106fcc000070002acb0000) dm-31 HP,HSV210
[size=3D10G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:71 sdap 66:144  [active][ready]=20
 \_ 0:0:6:71 sdch 69:80   [active][ready]=20
 \_ 1:0:3:71 sddz 128:16  [active][ready]=20
 \_ 1:0:4:71 sdev 129:112 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:71 sdbl 67:240  [active][ready]=20
 \_ 1:0:2:71 sddd 70:176  [active][ready]=20
 \_ 1:0:5:71 sdfr 130:208 [active][ready]=20
 \_ 0:0:3:71 sdt  65:48   [active][ready]=20
mpath21 (3600508b400106fcc000070002ac30000) dm-35 HP,HSV210
[size=3D90G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:73 sdar 66:176  [active][ready]=20
 \_ 0:0:6:73 sdcj 69:112  [active][ready]=20
 \_ 1:0:3:73 sdeb 128:48  [active][ready]=20
 \_ 1:0:4:73 sdex 129:144 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:73 sdbn 68:16   [active][ready]=20
 \_ 1:0:2:73 sddf 70:208  [active][ready]=20
 \_ 1:0:5:73 sdft 130:240 [active][ready]=20
 \_ 0:0:3:73 sdv  65:80   [active][ready]=20
limsd (3600508b400106fcc0000700027b30000) dm-7 HP,HSV210
[size=3D80G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:9  sdad 65:208  [active][ready]=20
 \_ 0:0:6:9  sdbv 68:144  [active][ready]=20
 \_ 1:0:3:9  sddn 71:80   [active][ready]=20
 \_ 1:0:4:9  sdej 128:176 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:9  sdaz 67:48   [active][ready]=20
 \_ 1:0:2:9  sdcr 69:240  [active][ready]=20
 \_ 1:0:5:9  sdff 130:16  [active][ready]=20
 \_ 0:0:3:9  sdh  8:112   [active][ready]=20
ph1t_arch (3600508b400106fcd0000700006880000) dm-23 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:20 sdal 66:80   [active][ready]=20
 \_ 0:0:6:20 sdcd 69:16   [active][ready]=20
 \_ 1:0:3:20 sddv 71:208  [active][ready]=20
 \_ 1:0:4:20 sder 129:48  [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:20 sdbh 67:176  [active][ready]=20
 \_ 1:0:2:20 sdcz 70:112  [active][ready]=20
 \_ 1:0:5:20 sdfn 130:144 [active][ready]=20
 \_ 0:0:3:20 sdp  8:240   [active][ready]=20
mpath18 (3600508b400106fcc000070002acf0000) dm-30 HP,HSV210
[size=3D30G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:70 sdao 66:128  [active][ready]=20
 \_ 0:0:6:70 sdcg 69:64   [active][ready]=20
 \_ 1:0:3:70 sddy 128:0   [active][ready]=20
 \_ 1:0:4:70 sdeu 129:96  [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:70 sdbk 67:224  [active][ready]=20
 \_ 1:0:2:70 sddc 70:160  [active][ready]=20
 \_ 1:0:5:70 sdfq 130:192 [active][ready]=20
 \_ 0:0:3:70 sds  65:32   [active][ready]=20
mpath20 (3600508b400106fcc000070002ac70000) dm-33 HP,HSV210
[size=3D80G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:72 sdaq 66:160  [active][ready]=20
 \_ 0:0:6:72 sdci 69:96   [active][ready]=20
 \_ 1:0:3:72 sdea 128:32  [active][ready]=20
 \_ 1:0:4:72 sdew 129:128 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:72 sdbm 68:0    [active][ready]=20
 \_ 1:0:2:72 sdde 70:192  [active][ready]=20
 \_ 1:0:5:72 sdfs 130:224 [active][ready]=20
 \_ 0:0:3:72 sdu  65:64   [active][ready]=20
cret_arch (3600508b400106fcc0000700027c20000) dm-12 HP,HSV210
[size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:12 sdag 66:0    [active][ready]=20
 \_ 0:0:6:12 sdby 68:192  [active][ready]=20
 \_ 1:0:3:12 sddq 71:128  [active][ready]=20
 \_ 1:0:4:12 sdem 128:224 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:12 sdbc 67:96   [active][ready]=20
 \_ 1:0:2:12 sdcu 70:32   [active][ready]=20
 \_ 1:0:5:12 sdfi 130:64  [active][ready]=20
 \_ 0:0:3:12 sdk  8:160   [active][ready]=20
raw3 (3600508b400106fcc0000700027a20000) dm-4 HP,HSV210
[size=3D4.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:5  sdaa 65:160  [active][ready]=20
 \_ 0:0:6:5  sdbs 68:96   [active][ready]=20
 \_ 1:0:3:5  sddk 71:32   [active][ready]=20
 \_ 1:0:4:5  sdeg 128:128 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:5  sdaw 67:0    [active][ready]=20
 \_ 1:0:2:5  sdco 69:192  [active][ready]=20
 \_ 0:0:3:5  sde  8:64    [active][ready]=20
 \_ 1:0:5:5  sdfc 129:224 [active][ready]=20
case (3600508b400106fcc0000700027c50000) dm-14 HP,HSV210
[size=3D30G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:13 sdah 66:16   [active][ready]=20
 \_ 0:0:6:13 sdbz 68:208  [active][ready]=20
 \_ 1:0:3:13 sddr 71:144  [active][ready]=20
 \_ 1:0:4:13 sden 128:240 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:13 sdbd 67:112  [active][ready]=20
 \_ 1:0:2:13 sdcv 70:48   [active][ready]=20
 \_ 1:0:5:13 sdfj 130:80  [active][ready]=20
 \_ 0:0:3:13 sdl  8:176   [active][ready]=20
limsd_arch (3600508b400106fcc0000700027b60000) dm-9 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:10 sdae 65:224  [active][ready]=20
 \_ 0:0:6:10 sdbw 68:160  [active][ready]=20
 \_ 1:0:3:10 sddo 71:96   [active][ready]=20
 \_ 1:0:4:10 sdek 128:192 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:10 sdba 67:64   [active][ready]=20
 \_ 1:0:2:10 sdcs 70:0    [active][ready]=20
 \_ 1:0:5:10 sdfg 130:32  [active][ready]=20
 \_ 0:0:3:10 sdi  8:128   [active][ready]=20
mpath33 (3600508b400106fcd0000700012030000) dm-55 HP,HSV210
[size=3D20G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:74 sdgl 132:16  [active][ready]=20
 \_ 0:0:6:74 sdgn 132:48  [active][ready]=20
 \_ 1:0:3:74 sdgp 132:80  [active][ready]=20
 \_ 1:0:4:74 sdgq 132:96  [active][ready]=20
\_ round-robin 0 [prio=3D0][enabled]
 \_ 1:0:2:74 sdgo 132:64  [active][faulty]
 \_ 0:0:3:74 sdgk 132:0   [active][faulty]
 \_ 0:0:5:74 sdgm 132:32  [active][faulty]
 \_ 1:0:5:74 sdgr 132:112 [active][faulty]
raw2 (3600508b400106fcc00007000279f0000) dm-44 HP,HSV210
[size=3D4.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:6:4  sdbr 68:80   [active][ready]=20
 \_ 1:0:3:4  sddj 71:16   [active][ready]=20
 \_ 1:0:4:4  sdef 128:112 [active][ready]=20
 \_ 0:0:4:4  sdz  65:144  [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:4  sdav 66:240  [active][ready]=20
 \_ 1:0:2:4  sdcn 69:176  [active][ready]=20
 \_ 0:0:3:4  sdd  8:48    [active][ready]=20
 \_ 1:0:5:4  sdfb 129:208 [active][ready]=20
raw1 (3600508b400106fcc0000700027940000) dm-42 HP,HSV210
[size=3D4.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:6:3  sdbq 68:64   [active][ready]=20
 \_ 1:0:3:3  sddi 71:0    [active][ready]=20
 \_ 1:0:4:3  sdee 128:96  [active][ready]=20
 \_ 0:0:4:3  sdy  65:128  [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:3  sdau 66:224  [active][ready]=20
 \_ 1:0:2:3  sdcm 69:160  [active][ready]=20
 \_ 0:0:3:3  sdc  8:32    [active][ready]=20
 \_ 1:0:5:3  sdfa 129:192 [active][ready]=20
cret (3600508b400106fcc0000700027bd0000) dm-11 HP,HSV210
[size=3D10G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:11 sdaf 65:240  [active][ready]=20
 \_ 0:0:6:11 sdbx 68:176  [active][ready]=20
 \_ 1:0:3:11 sddp 71:112  [active][ready]=20
 \_ 1:0:4:11 sdel 128:208 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:11 sdbb 67:80   [active][ready]=20
 \_ 1:0:2:11 sdct 70:16   [active][ready]=20
 \_ 1:0:5:11 sdfh 130:48  [active][ready]=20
 \_ 0:0:3:11 sdj  8:144   [active][ready]=20
case_arch (3600508b400106fcc0000700027ca0000) dm-16 HP,HSV210
[size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:14 sdai 66:32   [active][ready]=20
 \_ 0:0:6:14 sdca 68:224  [active][ready]=20
 \_ 1:0:3:14 sdds 71:160  [active][ready]=20
 \_ 1:0:4:14 sdeo 129:0   [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:14 sdbe 67:128  [active][ready]=20
 \_ 1:0:2:14 sdcw 70:64   [active][ready]=20
 \_ 1:0:5:14 sdfk 130:96  [active][ready]=20
 \_ 0:0:3:14 sdm  8:192   [active][ready]=20
limst_arch (3600508b400106fcd0000700006920000) dm-26 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:22 sdan 66:112  [active][ready]=20
 \_ 0:0:6:22 sdcf 69:48   [active][ready]=20
 \_ 1:0:3:22 sddx 71:240  [active][ready]=20
 \_ 1:0:4:22 sdet 129:80  [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:22 sdbj 67:208  [active][ready]=20
 \_ 1:0:2:22 sddb 70:144  [active][ready]=20
 \_ 1:0:5:22 sdfp 130:176 [active][ready]=20
 \_ 0:0:3:22 sdr  65:16   [active][ready]=20
orabackup (3600508b400106fcd000070000a560000) dm-19 HP,HSV210
[size=3D150G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:5:15 sdbf 67:144  [active][ready]=20
 \_ 1:0:2:15 sdcx 70:80   [active][ready]=20
 \_ 1:0:5:15 sdfl 130:112 [active][ready]=20
 \_ 0:0:3:15 sdn  8:208   [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:4:15 sdaj 66:48   [active][ready]=20
 \_ 0:0:6:15 sdcb 68:240  [active][ready]=20
 \_ 1:0:3:15 sddt 71:176  [active][ready]=20
 \_ 1:0:4:15 sdep 129:16  [active][ready]=20
oracle_bin (3600508b400106fcc0000700027810000) dm-36 HP,HSV210
[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:6:1  sdbo 68:32   [active][ready]=20
 \_ 1:0:3:1  sddg 70:224  [active][ready]=20
 \_ 1:0:4:1  sdec 128:64  [active][ready]=20
 \_ 0:0:4:1  sdw  65:96   [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:1  sdas 66:192  [active][ready]=20
 \_ 0:0:3:1  sda  8:0     [active][ready]=20
 \_ 1:0:2:1  sdck 69:128  [active][ready]=20
 \_ 1:0:5:1  sdey 129:160 [active][ready]=20
ph1t (3600508b400106fcd0000700006830000) dm-21 HP,HSV210
[size=3D150G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:19 sdak 66:64   [active][ready]=20
 \_ 0:0:6:19 sdcc 69:0    [active][ready]=20
 \_ 1:0:3:19 sddu 71:192  [active][ready]=20
 \_ 1:0:4:19 sdeq 129:32  [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:19 sdbg 67:160  [active][ready]=20
 \_ 1:0:2:19 sdcy 70:96   [active][ready]=20
 \_ 1:0:5:19 sdfm 130:128 [active][ready]=20
 \_ 0:0:3:19 sdo  8:224   [active][ready]=20
cred (3600508b400106fcd0000700011ee0000) dm-51 HP,HSV210
[size=3D20G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 1:0:3:16 sdge 131:160 [active][ready]=20
 \_ 0:0:4:16 sdfw 131:32  [active][ready]=20
 \_ 0:0:6:16 sdga 131:96  [active][ready]=20
 \_ 1:0:4:16 sdgg 131:192 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:3:16 sdfu 131:0   [active][ready]=20
 \_ 0:0:5:16 sdfy 131:64  [active][ready]=20
 \_ 1:0:2:16 sdgc 131:128 [active][ready]=20
 \_ 1:0:5:16 sdgi 131:224 [active][ready]=20
oracle_crs (3600508b400106fcc00007000278b0000) dm-39 HP,HSV210
[size=3D50G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:6:2  sdbp 68:48   [active][ready]=20
 \_ 1:0:3:2  sddh 70:240  [active][ready]=20
 \_ 1:0:4:2  sded 128:80  [active][ready]=20
 \_ 0:0:4:2  sdx  65:112  [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:2  sdat 66:208  [active][ready]=20
 \_ 0:0:3:2  sdb  8:16    [active][ready]=20
 \_ 1:0:2:2  sdcl 69:144  [active][ready]=20
 \_ 1:0:5:2  sdez 129:176 [active][ready]=20
limst (3600508b400106fcd00007000068d0000) dm-24 HP,HSV210
[size=3D400G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:5:21 sdbi 67:192  [active][ready]=20
 \_ 1:0:2:21 sdda 70:128  [active][ready]=20
 \_ 1:0:5:21 sdfo 130:160 [active][ready]=20
 \_ 0:0:3:21 sdq  65:0    [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:4:21 sdam 66:96   [active][ready]=20
 \_ 0:0:6:21 sdce 69:32   [active][ready]=20
 \_ 1:0:3:21 sddw 71:224  [active][ready]=20
 \_ 1:0:4:21 sdes 129:64  [active][ready]=20
ph1d (3600508b400106fcc0000700027a50000) dm-5 HP,HSV210
[size=3D90G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:7  sdab 65:176  [active][ready]=20
 \_ 0:0:6:7  sdbt 68:112  [active][ready]=20
 \_ 1:0:3:7  sddl 71:48   [active][ready]=20
 \_ 1:0:4:7  sdeh 128:144 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:7  sdax 67:16   [active][ready]=20
 \_ 1:0:2:7  sdcp 69:208  [active][ready]=20
 \_ 1:0:5:7  sdfd 129:240 [active][ready]=20
 \_ 0:0:3:7  sdf  8:80    [active][ready]=20
ph1d_arch (3600508b400106fcc0000700027a80000) dm-6 HP,HSV210
[size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
\_ round-robin 0 [prio=3D200][active]
 \_ 0:0:4:8  sdac 65:192  [active][ready]=20
 \_ 0:0:6:8  sdbu 68:128  [active][ready]=20
 \_ 1:0:3:8  sddm 71:64   [active][ready]=20
 \_ 1:0:4:8  sdei 128:160 [active][ready]=20
\_ round-robin 0 [prio=3D40][enabled]
 \_ 0:0:5:8  sday 67:32   [active][ready]=20
 \_ 1:0:2:8  sdcq 69:224  [active][ready]=20
 \_ 1:0:5:8  sdfe 130:0   [active][ready]=20
 \_ 0:0:3:8  sdg  8:96    [active][ready]=20



> -----Original Message-----
> From: dm-devel-bounces@redhat.com=20
> [mailto:dm-devel-bounces@redhat.com] On Behalf Of Konrad Rzeszutek
> Sent: Wednesday, November 26, 2008 11:43 AM
> To: device-mapper development
> Subject: Re: [dm-devel] RE: Temporarily squelching multipathd errors
>=20
> On Fri, Nov 21, 2008 at 01:54:01PM -0600, Daniel Keisling wrote:
> > I am still getting multipath errors when unpresenting and presenting
> > LUNs.  I've traced it down to getting path failures=20
> everytime I either
> > remove or add a LUN to the system.  The strange thing is=20
> that I get path
> > errors for maps that aren't related to the LUNs I am=20
> deleting or adding.
> > In this case, I am deleting the LUN with the map 'mpath18,'=20
> but other
> > maps complain whenever the LUN is deleted:
> >=20
> > Nov 21 13:47:05 ausracdbd01 multipathd: checker failed path=20
> 67:208 in
> > map orabackup_hs
> > Nov 21 13:47:05 ausracdbd01 kernel: device-mapper:=20
> multipath: Failing
> > path 67:208.
> > Nov 21 13:47:08 ausracdbd01 multipathd: checker failed path=20
> 70:160 in
> > map mpath18
> > Nov 21 13:47:08 ausracdbd01 kernel: device-mapper:=20
> multipath: Failing
> > path 70:160.
> > Nov 21 13:47:09 ausracdbd01 multipathd: checker failed path=20
> 69:0 in map
> > orabackup_hs
> > Nov 21 13:47:09 ausracdbd01 kernel: device-mapper:=20
> multipath: Failing
> > path 69:0.
> > Nov 21 13:47:10 ausracdbd01 multipathd: checker failed path=20
> 65:192 in
> > map ph1d
> > Nov 21 13:47:10 ausracdbd01 kernel: device-mapper:=20
> multipath: Failing
> > path 65:192.
> > Nov 21 13:47:10 ausracdbd01 multipathd: checker failed path=20
> 65:224 in
> > map limsd
> > Nov 21 13:47:10 ausracdbd01 kernel: device-mapper:=20
> multipath: Failing
> > path 65:224.
> > Nov 21 13:47:10 ausracdbd01 multipathd: checker failed path=20
> 65:240 in
> > map limsd_arch
> >=20
>=20
> Can you attach the 'multipath -ll' output? Run the program before
> you delete/add the LUNs and after, please.
>=20
> How do you delete/add the LUNs? Are you re-using the LUN=20
> number, or are you
> actually deleting a LUN, deleting the block device as well, and then
> when adding (with a new LUN number higher than the deleted=20
> one), rescanning=20
> the SCSI host channel to get the new block device for the LUN?
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>=20
>=20

______________________________________________________________________
This email transmission and any documents, files or previous email
messages attached to it may contain information that is confidential or
legally privileged. If you are not the intended recipient or a person
responsible for delivering this transmission to the intended recipient,
you are hereby notified that you must not read this transmission and
that any disclosure, copying, printing, distribution or use of this
transmission is strictly prohibited. If you have received this transmissi=
on
in error, please immediately notify the sender by telephone or return ema=
il
and delete the original transmission and its attachments without reading
or saving in any manner.
