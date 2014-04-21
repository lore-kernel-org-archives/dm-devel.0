From: Brian Bunker <brian@purestorage.com>
Subject: path coalescing problems revisited
Date: Mon, 21 Apr 2014 14:01:05 -0700
Message-ID: <660CC1BA-5E9E-4021-94CA-6FCAA6364DCB@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello all,

I had another instance of the LUN coalescing incorrectly coalescing LUNs wh=
ich do not have the same number. When I ran the check last time with =91mul=
tipath -v3=92, that fixed the problem. I am assuming because =91multipath=
=92 will reload the table? =


Again I have the state and can print it out at will. Is there a way to get =
information without losing the state?

3624a937025791645b7c328ab00010007 dm-4 ,
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- #:#:#:#  -    #:#    failed faulty running
  |- 7:0:0:5  sdt  65:48  active ready running
  |- 4:0:0:5  sdah 66:16  active ready running
  |- 6:0:0:5  sdav 66:240 active ready running
  |- 2:0:0:5  sdbj 67:208 active ready running
  |- 3:0:0:5  sdbw 68:160 active ready running
  |- 1:0:0:5  sdbz 68:208 active ready running
  `- 0:0:0:5  sdcp 69:208 active ready running
3624a937025791645b7c328ab00010004 dm-11 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 5:0:0:12 sddb 70:144 active ready running
  |- 7:0:0:12 sdaa 65:160 active ready running
  |- 4:0:0:12 sdao 66:128 active ready running
  |- 6:0:0:12 sdbc 67:96  active ready running
  |- 2:0:0:12 sdcd 69:16  active ready running
  |- 1:0:0:12 sdcx 70:80  active ready running
  |- 3:0:0:12 sdcz 70:112 active ready running
  `- 0:0:0:12 sddg 70:224 active ready running
3624a937025791645b7c328ab00010003 dm-7 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 7:0:0:8  sdw  65:96  active ready running
  |- 4:0:0:8  sdak 66:64  active ready running
  |- 6:0:0:8  sday 67:32  active ready running
  |- 2:0:0:8  sdbs 68:96  active ready running
  |- 1:0:0:8  sdci 69:96  active ready running
  |- 3:0:0:8  sdcj 69:112 active ready running
  |- 0:0:0:8  sdcw 70:64  active ready running
  `- 5:0:0:6  sdaq 66:160 active ready running
3624a937025791645b7c328ab00010002 dm-3 ,
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- #:#:#:#  -    #:#    failed faulty running
  |- 7:0:0:4  sds  65:32  active ready running
  |- 4:0:0:4  sdag 66:0   active ready running
  |- 6:0:0:4  sdau 66:224 active ready running
  |- 2:0:0:4  sdbi 67:192 active ready running
  |- 3:0:0:4  sdbt 68:112 active ready running
  |- 1:0:0:4  sdbu 68:128 active ready running
  `- 0:0:0:4  sdcn 69:176 active ready running
3624a937025791645b7c328ab0001015e dm-2 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 7:0:0:3  sdr  65:16  active ready running
  |- 4:0:0:3  sdaf 65:240 active ready running
  |- 6:0:0:3  sdat 66:208 active ready running
  |- 2:0:0:3  sdbh 67:176 active ready running
  |- 3:0:0:3  sdbr 68:80  active ready running
  |- 1:0:0:3  sdbq 68:64  active ready running
  |- 0:0:0:3  sdck 69:128 active ready running
  `- 5:0:0:3  sdab 65:176 active ready running
3624a937025791645b7c328ab0001015d dm-1 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 7:0:0:2  sdq  65:0   active ready running
  |- 4:0:0:2  sdae 65:224 active ready running
  |- 6:0:0:2  sdas 66:192 active ready running
  |- 2:0:0:2  sdbg 67:160 active ready running
  |- 3:0:0:2  sdbo 68:32  active ready running
  |- 1:0:0:2  sdbn 68:16  active ready running
  |- 0:0:0:2  sdch 69:80  active ready running
  `- 5:0:0:2  sdo  8:224  active ready running
3624a937025791645b7c328ab0001000c dm-10 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 5:0:0:11 sdcy 70:96  active ready running
  |- 7:0:0:11 sdz  65:144 active ready running
  |- 4:0:0:11 sdan 66:112 active ready running
  |- 6:0:0:11 sdbb 67:80  active ready running
  |- 2:0:0:11 sdca 68:224 active ready running
  |- 1:0:0:11 sdct 70:16  active ready running
  |- 3:0:0:11 sdcv 70:48  active ready running
  `- 0:0:0:11 sddf 70:208 active ready running
3624a937025791645b7c328ab0001015c dm-0 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 7:0:0:1  sdp  8:240  active ready running
  |- 4:0:0:1  sdad 65:208 active ready running
  |- 6:0:0:1  sdar 66:176 active ready running
  |- 2:0:0:1  sdbf 67:144 active ready running
  |- 3:0:0:1  sdbl 67:240 active ready running
  |- 1:0:0:1  sdbk 67:224 active ready running
  |- 0:0:0:1  sdcc 69:0   active ready running
  `- 5:0:0:1  sdn  8:208  active ready running
3624a937025791645b7c328ab0001000b dm-8 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 5:0:0:10 sdcl 69:144 active ready running
  |- 7:0:0:10 sdy  65:128 active ready running
  |- 4:0:0:10 sdam 66:96  active ready running
  |- 6:0:0:10 sdba 67:64  active ready running
  |- 2:0:0:10 sdbx 68:176 active ready running
  |- 1:0:0:10 sdcq 69:224 active ready running
  |- 3:0:0:10 sdcs 70:0   active ready running
  `- 0:0:0:10 sddc 70:160 active ready running
3624a937025791645b7c328ab0001000a dm-9 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 5:0:0:9  sdce 69:32  active ready running
  |- 7:0:0:9  sdx  65:112 active ready running
  |- 4:0:0:9  sdal 66:80  active ready running
  |- 6:0:0:9  sdaz 67:48  active ready running
  |- 2:0:0:9  sdbv 68:144 active ready running
  |- 1:0:0:9  sdcm 69:160 active ready running
  |- 3:0:0:9  sdco 69:192 active ready running
  `- 0:0:0:9  sdda 70:128 active ready running
3624a937025791645b7c328ab00010009 dm-6 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 7:0:0:7  sdv  65:80  active ready running
  |- 4:0:0:7  sdaj 66:48  active ready running
  |- 6:0:0:7  sdax 67:16  active ready running
  |- 2:0:0:7  sdbp 68:48  active ready running
  |- 1:0:0:7  sdcf 69:48  active ready running
  |- 3:0:0:7  sdcg 69:64  active ready running
  |- 0:0:0:7  sdcu 70:32  active ready running
  `- 5:0:0:5  sdap 66:144 active ready running
3624a937025791645b7c328ab00010008 dm-5 PURE,FlashArray
size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
  |- 7:0:0:6  sdu  65:64  active ready running
  |- 4:0:0:6  sdai 66:32  active ready running
  |- 6:0:0:6  sdaw 67:0   active ready running
  |- 2:0:0:6  sdbm 68:0   active ready running
  |- 3:0:0:6  sdby 68:192 active ready running
  |- 1:0:0:6  sdcb 68:240 active ready running
  |- 0:0:0:6  sdcr 69:240 active ready running
  `- 5:0:0:4  sdac 65:192 active ready running

See the LUN 4-7 to see what has happened.

Thanks,
Brian

Brian Bunker
brian@purestorage.com
