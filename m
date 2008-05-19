From: "Craig Simpson" <csimpson@visto.com>
Subject: "[undef] [ready] [orphan]" ?
Date: Mon, 19 May 2008 15:02:22 -0700
Message-ID: <ABFD05FF09D13E4883B757E75603624DF9BF7A@ex-sea1.vistocorp.com>
References: <ABFD05FF09D13E4883B757E75603624D011E9515@ex-sea1.vistocorp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <ABFD05FF09D13E4883B757E75603624D011E9515@ex-sea1.vistocorp.com>
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


My multipathing seems to be working. As seen below.=20

multipathd -k
multipathd> show multipaths status
name    failback  queueing paths dm-st
mpath0  immediate off      4     active
asm01   immediate off      4     active
asm02   immediate off      4     active
asm03   immediate off      4     active
asm04   immediate off      4     active
asm05   immediate off      4     active
asm06   immediate off      4     active
asm07   immediate off      4     active
asm08   immediate off      4     active
asm09   immediate off      4     active
asm10   immediate off      4     active
mpath11 immediate off      4     active
mpath12 immediate off      4     active
mpath13 immediate off      4     active
mpath14 immediate off      4     active
mpath15 immediate off      4     active
mpath16 immediate off      4     active
mpath17 immediate off      4     active
mpath18 immediate off      4     active
mpath19 immediate off      4     active
mpath20 immediate off      4     active
ocr1    immediate off      4     active
ocr2    immediate off      4     active
vote1   immediate off      4     active
vote2   immediate off      4     active
vote3   immediate off      4     active
mpath26 immediate off      4     active


BUT I am getting this error:

I don't get the "[undef] [ready] [orphan]" part. It seems that I have 4
paths and all is good.=20

multipathd> show paths
hcil     dev  dev_t   pri dm_st   chk_st  next_check
0:0:0:26 sdaa 65:160  0   [active][ready] XXXXXXXXX. 38/40
0:0:0:27 sdab 65:176  1   [undef] [ready] [orphan]
0:0:0:28 sdac 65:192  0   [undef] [ready] [orphan]
0:0:0:29 sdad 65:208  1   [undef] [ready] [orphan]
0:0:0:30 sdae 65:224  0   [undef] [ready] [orphan]
0:0:0:31 sdaf 65:240  1   [undef] [ready] [orphan]
0:0:0:32 sdag 66:0    0   [undef] [ready] [orphan]
0:0:0:33 sdah 66:16   1   [undef] [ready] [orphan]
0:0:0:34 sdai 66:32   0   [undef] [ready] [orphan]
0:0:0:35 sdaj 66:48   1   [undef] [ready] [orphan]
0:0:0:36 sdak 66:64   0   [undef] [ready] [orphan]
0:0:0:37 sdal 66:80   1   [undef] [ready] [orphan]
0:0:0:38 sdam 66:96   0   [undef] [ready] [orphan]
0:0:0:39 sdan 66:112  1   [undef] [ready] [orphan]
0:0:1:0  sdao 66:128  1   [active][ready] XXXXXXXXX. 38/40
0:0:1:1  sdap 66:144  0   [active][ready] XXXXXXXXX. 38/40
0:0:1:2  sdaq 66:160  1   [active][ready] XXXXXXXXX. 38/40
0:0:1:3  sdar 66:176  0   [active][ready] XXXXXXXXX. 38/40
0:0:1:4  sdas 66:192  1   [active][ready] XXXXXXXXX. 38/40
0:0:1:5  sdat 66:208  0   [active][ready] XXXXXXXXX. 38/40
0:0:1:6  sdau 66:224  1   [active][ready] XXXXXXXXX. 38/40
0:0:1:7  sdav 66:240  0   [active][ready] XXXXXXXXX. 38/40
0:0:1:8  sdaw 67:0    1   [active][ready] XXXXXXXXX. 38/40
0:0:1:9  sdax 67:16   0   [active][ready] XXXXXXXXX. 38/40
0:0:1:10 sday 67:32   1   [active][ready] XXXXXXXXX. 38/40
0:0:1:11 sdaz 67:48   0   [active][ready] XXXXXXXXX. 38/40
0:0:0:0  sda  8:0     0   [active][ready] XXXXXXXXX. 38/40
0:0:1:12 sdba 67:64   1   [active][ready] XXXXXXXXX. 38/40
0:0:1:13 sdbb 67:80   0   [active][ready] XXXXXXXXX. 38/40
0:0:1:14 sdbc 67:96   1   [active][ready] XXXXXXXXX. 38/40
0:0:1:15 sdbd 67:112  0   [active][ready] XXXXXXXXX. 38/40
0:0:1:16 sdbe 67:128  1   [active][ready] XXXXXXXXX. 38/40
0:0:1:17 sdbf 67:144  0   [active][ready] XXXXXXXXX. 38/40
0:0:1:18 sdbg 67:160  1   [active][ready] XXXXXXXXX. 38/40
0:0:1:19 sdbh 67:176  0   [active][ready] XXXXXXXXX. 38/40
0:0:1:20 sdbi 67:192  1   [active][ready] XXXXXXXXX. 38/40
0:0:1:21 sdbj 67:208  0   [active][ready] XXXXXXXXX. 38/40
0:0:1:22 sdbk 67:224  1   [active][ready] XXXXXXXXX. 38/40
0:0:1:23 sdbl 67:240  0   [active][ready] XXXXXXXXX. 38/40
0:0:1:24 sdbm 68:0    1   [active][ready] XXXXXXXXX. 38/40
0:0:1:25 sdbn 68:16   0   [active][ready] XXXXXXXXX. 38/40
0:0:1:26 sdbo 68:32   1   [active][ready] XXXXXXXXX. 38/40
0:0:1:27 sdbp 68:48   0   [undef] [ready] [orphan]
0:0:1:28 sdbq 68:64   1   [undef] [ready] [orphan]
0:0:1:29 sdbr 68:80   0   [undef] [ready] [orphan]
0:0:1:30 sdbs 68:96   1   [undef] [ready] [orphan]
0:0:1:31 sdbt 68:112  0   [undef] [ready] [orphan]
0:0:1:32 sdbu 68:128  1   [undef] [ready] [orphan]
0:0:1:33 sdbv 68:144  0   [undef] [ready] [orphan]
0:0:1:34 sdbw 68:160  1   [undef] [ready] [orphan]
0:0:1:35 sdbx 68:176  0   [undef] [ready] [orphan]
0:0:1:36 sdby 68:192  1   [undef] [ready] [orphan]
0:0:1:37 sdbz 68:208  0   [undef] [ready] [orphan]
0:0:0:1  sdb  8:16    1   [active][ready] XXXXXXXXX. 38/40
0:0:1:38 sdca 68:224  1   [undef] [ready] [orphan]
0:0:1:39 sdcb 68:240  0   [undef] [ready] [orphan]
1:0:0:0  sdch 69:80   0   [active][ready] XXXXXXXXX. 38/40
1:0:0:1  sdci 69:96   1   [active][ready] XXXXXXXXX. 38/40
1:0:0:2  sdcj 69:112  0   [active][ready] XXXXXXXXX. 38/40
1:0:0:3  sdck 69:128  1   [active][ready] XXXXXXXXX. 38/40
1:0:0:4  sdcl 69:144  0   [active][ready] XXXXXXXXX. 38/40
1:0:0:5  sdcm 69:160  1   [active][ready] XXXXXXXXX. 38/40
1:0:0:6  sdcn 69:176  0   [active][ready] XXXXXXXXX. 38/40
1:0:0:7  sdco 69:192  1   [active][ready] XXXXXXXXX. 38/40
1:0:0:8  sdcp 69:208  0   [active][ready] XXXXXXXXX. 38/40
1:0:0:9  sdcq 69:224  1   [active][ready] XXXXXXXXX. 38/40
1:0:0:10 sdcr 69:240  0   [active][ready] XXXXXXXXX. 38/40
1:0:0:11 sdcs 70:0    1   [active][ready] XXXXXXXXX. 38/40
1:0:0:12 sdct 70:16   0   [active][ready] XXXXXXXXX. 38/40
1:0:0:13 sdcu 70:32   1   [active][ready] XXXXXXXXX. 38/40
1:0:0:14 sdcv 70:48   0   [active][ready] XXXXXXXXX. 38/40
1:0:0:15 sdcw 70:64   1   [active][ready] XXXXXXXXX. 38/40
1:0:0:16 sdcx 70:80   0   [active][ready] XXXXXXXXX. 38/40
1:0:0:17 sdcy 70:96   1   [active][ready] XXXXXXXXX. 38/40
1:0:0:18 sdcz 70:112  0   [active][ready] XXXXXXXXX. 38/40
0:0:0:2  sdc  8:32    0   [active][ready] XXXXXXXXX. 38/40
1:0:0:19 sdda 70:128  1   [active][ready] XXXXXXXXX. 38/40
1:0:0:20 sddb 70:144  0   [active][ready] XXXXXXXXX. 38/40
1:0:0:21 sddc 70:160  1   [active][ready] XXXXXXXXX. 38/40
1:0:0:22 sddd 70:176  0   [active][ready] XXXXXXXXX. 38/40
1:0:0:23 sdde 70:192  1   [active][ready] XXXXXXXXX. 38/40
1:0:0:24 sddf 70:208  0   [active][ready] XXXXXXXXX. 38/40
1:0:0:25 sddg 70:224  1   [active][ready] XXXXXXXXX. 38/40
1:0:0:26 sddh 70:240  0   [active][ready] XXXXXXXXX. 38/40
1:0:0:27 sddi 71:0    1   [undef] [ready] [orphan]
1:0:0:28 sddj 71:16   0   [undef] [ready] [orphan]
1:0:0:29 sddk 71:32   1   [undef] [ready] [orphan]
1:0:0:30 sddl 71:48   0   [undef] [ready] [orphan]
1:0:0:31 sddm 71:64   1   [undef] [ready] [orphan]
1:0:0:32 sddn 71:80   0   [undef] [ready] [orphan]
1:0:0:33 sddo 71:96   1   [undef] [ready] [orphan]
1:0:0:34 sddp 71:112  0   [undef] [ready] [orphan]
1:0:0:35 sddq 71:128  1   [undef] [ready] [orphan]
1:0:0:36 sddr 71:144  0   [undef] [ready] [orphan]
1:0:0:37 sdds 71:160  1   [undef] [ready] [orphan]
1:0:0:38 sddt 71:176  0   [undef] [ready] [orphan]
1:0:0:39 sddu 71:192  1   [undef] [ready] [orphan]
1:0:1:0  sddv 71:208  1   [active][ready] XXXXXXXXX. 38/40
1:0:1:1  sddw 71:224  0   [active][ready] XXXXXXXXX. 38/40
1:0:1:2  sddx 71:240  1   [active][ready] XXXXXXXXX. 38/40
1:0:1:3  sddy 128:0   0   [active][ready] XXXXXXXXX. 38/40
1:0:1:4  sddz 128:16  1   [active][ready] XXXXXXXXX. 38/40
0:0:0:3  sdd  8:48    1   [active][ready] XXXXXXXXX. 38/40
1:0:1:5  sdea 128:32  0   [active][ready] XXXXXXXXX. 38/40
1:0:1:6  sdeb 128:48  1   [active][ready] XXXXXXXXX. 38/40
1:0:1:7  sdec 128:64  0   [active][ready] XXXXXXXXX. 38/40
1:0:1:8  sded 128:80  1   [active][ready] XXXXXXXXX. 38/40
1:0:1:9  sdee 128:96  0   [active][ready] XXXXXXXXX. 38/40
1:0:1:10 sdef 128:112 1   [active][ready] XXXXXXXXX. 38/40
1:0:1:11 sdeg 128:128 0   [active][ready] XXXXXXXXX. 38/40
1:0:1:12 sdeh 128:144 1   [active][ready] XXXXXXXXX. 38/40
1:0:1:13 sdei 128:160 0   [active][ready] XXXXXXXXX. 38/40
1:0:1:14 sdej 128:176 1   [active][ready] XXXXXXXXX. 38/40
1:0:1:15 sdek 128:192 0   [active][ready] XXXXXXXXX. 38/40
1:0:1:16 sdel 128:208 1   [active][ready] XXXXXXXXX. 38/40
1:0:1:17 sdem 128:224 0   [active][ready] XXXXXXXXX. 38/40
1:0:1:18 sden 128:240 1   [active][ready] XXXXXXXXX. 38/40
1:0:1:19 sdeo 129:0   0   [active][ready] XXXXXXXXX. 38/40
1:0:1:20 sdep 129:16  1   [active][ready] XXXXXXXXX. 38/40
1:0:1:21 sdeq 129:32  0   [active][ready] XXXXXXXXX. 38/40
1:0:1:22 sder 129:48  1   [active][ready] XXXXXXXXX. 38/40
1:0:1:23 sdes 129:64  0   [active][ready] XXXXXXXXX. 38/40
1:0:1:24 sdet 129:80  1   [active][ready] XXXXXXXXX. 38/40
1:0:1:25 sdeu 129:96  0   [active][ready] XXXXXXXXX. 38/40
1:0:1:26 sdev 129:112 1   [active][ready] XXXXXXXXX. 38/40
1:0:1:27 sdew 129:128 0   [undef] [ready] [orphan]
1:0:1:28 sdex 129:144 1   [undef] [ready] [orphan]
1:0:1:29 sdey 129:160 0   [undef] [ready] [orphan]
1:0:1:30 sdez 129:176 1   [undef] [ready] [orphan]
0:0:0:4  sde  8:64    0   [active][ready] XXXXXXXXX. 38/40
1:0:1:31 sdfa 129:192 0   [undef] [ready] [orphan]
1:0:1:32 sdfb 129:208 1   [undef] [ready] [orphan]
1:0:1:33 sdfc 129:224 0   [undef] [ready] [orphan]
1:0:1:34 sdfd 129:240 1   [undef] [ready] [orphan]
1:0:1:35 sdfe 130:0   0   [undef] [ready] [orphan]
1:0:1:36 sdff 130:16  1   [undef] [ready] [orphan]
1:0:1:37 sdfg 130:32  0   [undef] [ready] [orphan]
1:0:1:38 sdfh 130:48  1   [undef] [ready] [orphan]
1:0:1:39 sdfi 130:64  0   [undef] [ready] [orphan]
0:0:0:5  sdf  8:80    1   [active][ready] XXXXXXXXX. 38/40
0:0:0:6  sdg  8:96    0   [active][ready] XXXXXXXXX. 38/40
0:0:0:7  sdh  8:112   1   [active][ready] XXXXXXXXX. 38/40
0:0:0:8  sdi  8:128   0   [active][ready] XXXXXXXXX. 38/40
0:0:0:9  sdj  8:144   1   [active][ready] XXXXXXXXX. 38/40
0:0:0:10 sdk  8:160   0   [active][ready] XXXXXXXXX. 38/40
0:0:0:11 sdl  8:176   1   [active][ready] XXXXXXXXX. 38/40
0:0:0:12 sdm  8:192   0   [active][ready] XXXXXXXXX. 38/40
0:0:0:13 sdn  8:208   1   [active][ready] XXXXXXXXX. 38/40
0:0:0:14 sdo  8:224   0   [active][ready] XXXXXXXXX. 38/40
0:0:0:15 sdp  8:240   1   [active][ready] XXXXXXXXX. 38/40
0:0:0:16 sdq  65:0    0   [active][ready] XXXXXXXXX. 38/40
0:0:0:17 sdr  65:16   1   [active][ready] XXXXXXXXX. 38/40
0:0:0:18 sds  65:32   0   [active][ready] XXXXXXXXX. 38/40
0:0:0:19 sdt  65:48   1   [active][ready] XXXXXXXXX. 38/40
0:0:0:20 sdu  65:64   0   [active][ready] XXXXXXXXX. 38/40
0:0:0:21 sdv  65:80   1   [active][ready] XXXXXXXXX. 38/40
0:0:0:22 sdw  65:96   0   [active][ready] XXXXXXXXX. 38/40
0:0:0:23 sdx  65:112  1   [active][ready] XXXXXXXXX. 38/40
0:0:0:24 sdy  65:128  0   [active][ready] XXXXXXXXX. 38/40
0:0:0:25 sdz  65:144  1   [active][ready] XXXXXXXXX. 38/40





--
=20
Craig Simpson


"In the circle the beginning and the end are common"
 ~ Heraclitis (540-480BC)

=20
