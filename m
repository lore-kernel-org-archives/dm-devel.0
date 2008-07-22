From: "Vardaris, C - SPLXM" <Christos.Vardaris@klm.com>
Subject: Losing paths
Date: Tue, 22 Jul 2008 13:22:54 +0200
Message-ID: <E6D1DDD48426A44EB25DF27F5AAE7A6505B96797@KL1010XG.cs.ad.klmcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0357655900=="
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.


--===============0357655900==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C8EBED.4949CC97"

This is a multi-part message in MIME format.


------_=_NextPart_001_01C8EBED.4949CC97
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

To all,=0D=0A=0D=0A =0D=0A=0D=0AIs it normal DM behavior that we are (tempo=
rary) losing paths from=0D=0A'unaffected' LUN's when we unmap a SAN LUN fro=
m the storage side=2E=0D=0A=0D=0AWe are using an IBM SVC (4=2E2=2E1) and RH=
 AS 4=2E6=2E We are using the=0D=0Amultipath=2Econf file supplied by IBM fo=
r the SVC=2E=0D=0A=0D=0A =0D=0A=0D=0AIt's normal that you loose the paths o=
f the LUN which you unmap (4 paths=0D=0Ain our case), but why we are also l=
osing paths from 'unaffected' LUN's=2E=0D=0A=0D=0AUnmapping a LUN is not a =
normal storage admin action but could happen=0D=0Aaccidentally=2E=0D=0A=0D=
=0AWe also see the same behavior when we give a new LUN to the Linux=0D=0As=
erver=2E The minute we map the LUN, paths from other LUN's are=0D=0Atempora=
rily disappearing=2E=0D=0A=0D=0A =0D=0A=0D=0AWe tried several settings/HBA =
firmware etc=2E but can not eliminate this=0D=0Abehavior of DM=2E=0D=0A=0D=
=0A =0D=0A=0D=0A =0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 65:176: t=
ur checker reports path is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju mu=
ltipathd: checker failed path 65:176 in map=0D=0A360050768018180a4f80000000=
00001d2=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8=
000000000001d2:=0D=0Aremaining active paths: 3=0D=0A=0D=0AJul  2 13:36:54 k=
l1108ju kernel: device-mapper: dm-multipath: Failing=0D=0Apath 65:176=2E=0D=
=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 65:192: tur checker reports p=
ath is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: checker fa=
iled path 65:192 in map=0D=0A360050768018180a4f8000000000001d3=0D=0A=0D=0AJ=
ul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3:=0D=
=0Aremaining active paths: 3=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: de=
vice-mapper: dm-multipath: Failing=0D=0Apath 65:192=2E=0D=0A=0D=0AJul  2 13=
:36:54 kl1108ju multipathd: 65:208: tur checker reports path is=0D=0Adown=
=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: checker failed path 65:208=
 in map=0D=0A360050768018180a4f800000000000354=0D=0A=0D=0AJul  2 13:36:54 k=
l1108ju multipathd: 360050768018180a4f800000000000354:=0D=0Aremaining activ=
e paths: 3=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: device-mapper: dm-mu=
ltipath: Failing=0D=0Apath 65:208=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju mu=
ltipathd: 65:240: tur checker reports path is=0D=0Adown=0D=0A=0D=0AJul  2 1=
3:36:54 kl1108ju multipathd: checker failed path 65:240 in map=0D=0A3600507=
68018180a4f8000000000001d1=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: devi=
ce-mapper: dm-multipath: Failing=0D=0Apath 65:240=2E=0D=0A=0D=0AJul  2 13:3=
6:54 kl1108ju multipathd: 360050768018180a4f8000000000001d1:=0D=0Aremaining=
 active paths: 3=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 67:0: tur =
checker reports path is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multi=
pathd: checker failed path 67:0 in map=0D=0A360050768018180a4f8000000000001=
d0=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath:=
 Failing=0D=0Apath 67:0=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: =
360050768018180a4f8000000000001d0:=0D=0Aremaining active paths: 3=0D=0A=0D=
=0AJul  2 13:36:54 kl1108ju multipathd: 67:32: tur checker reports path is=
=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: checker failed p=
ath 67:32 in map=0D=0A360050768018180a4f8000000000001ce=0D=0A=0D=0AJul  2 1=
3:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing=0D=0Apath 67:=
32=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f800=
0000000001ce:=0D=0Aremaining active paths: 3=0D=0A=0D=0AJul  2 13:36:54 kl1=
108ju kernel: device-mapper: dm-multipath: Failing=0D=0Apath 67:48=2E=0D=0A=
=0D=0AJul  2 13:36:54 kl1108ju multipathd: 67:48: tur checker reports path =
is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: device-mapper: dm-=
multipath: Failing=0D=0Apath 67:64=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju m=
ultipathd: checker failed path 67:48 in map=0D=0A360050768018180a4f80000000=
00001d2=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multi=
path: Failing=0D=0Apath 67:80=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multip=
athd: 360050768018180a4f8000000000001d2:=0D=0Aremaining active paths: 2=0D=
=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Fail=
ing=0D=0Apath 67:96=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 67:6=
4: tur checker reports path is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108j=
u kernel: device-mapper: dm-multipath: Failing=0D=0Apath 67:112=2E=0D=0A=0D=
=0AJul  2 13:36:54 kl1108ju multipathd: checker failed path 67:64 in map=0D=
=0A360050768018180a4f8000000000001d3=0D=0A=0D=0AJul  2 13:36:54 kl1108ju ke=
rnel: device-mapper: dm-multipath: Failing=0D=0Apath 67:128=2E=0D=0A=0D=0AJ=
ul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3:=0D=
=0Aremaining active paths: 2=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: de=
vice-mapper: dm-multipath: Failing=0D=0Apath 67:160=2E=0D=0A=0D=0AJul  2 13=
:36:54 kl1108ju multipathd: 67:80: tur checker reports path is=0D=0Adown=0D=
=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Fail=
ing=0D=0Apath 67:176=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: che=
cker failed path 67:80 in map=0D=0A360050768018180a4f800000000000354=0D=0A=
=0D=0AJul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing=
=0D=0Apath 67:192=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 360050=
768018180a4f800000000000354:=0D=0Aremaining active paths: 2=0D=0A=0D=0AJul =
 2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing=0D=0Apath=
 67:208=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 67:96: tur check=
er reports path is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: de=
vice-mapper: dm-multipath: Failing=0D=0Apath 67:224=2E=0D=0A=0D=0AJul  2 13=
:36:54 kl1108ju multipathd: checker failed path 67:96 in map=0D=0A360050768=
018180a4f8000000000001d4=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: device=
-mapper: dm-multipath: Failing=0D=0Apath 67:240=2E=0D=0A=0D=0AJul  2 13:36:=
54 kl1108ju multipathd: 360050768018180a4f8000000000001d4:=0D=0Aremaining a=
ctive paths: 3=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: device-mapper: d=
m-multipath: Failing=0D=0Apath 65:0=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju =
multipathd: 67:112: tur checker reports path is=0D=0Adown=0D=0A=0D=0AJul  2=
 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing=0D=0Apath 6=
5:32=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: checker failed path=
 67:112 in map=0D=0A360050768018180a4f8000000000001d1=0D=0A=0D=0AJul  2 13:=
36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing=0D=0Apath 65:48=
=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f80000=
00000001d1:=0D=0Aremaining active paths: 2=0D=0A=0D=0AJul  2 13:36:54 kl110=
8ju kernel: device-mapper: dm-multipath: Failing=0D=0Apath 65:64=2E=0D=0A=
=0D=0AJul  2 13:36:54 kl1108ju multipathd: 67:128: tur checker reports path=
 is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: device-mapper: dm=
-multipath: Failing=0D=0Apath 65:80=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju =
multipathd: checker failed path 67:128 in map=0D=0A360050768018180a4f800000=
0000001d0=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: device-mapper: dm-mul=
tipath: Failing=0D=0Apath 65:96=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju mult=
ipathd: 360050768018180a4f8000000000001d0:=0D=0Aremaining active paths: 2=
=0D=0A=0D=0AJul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: F=
ailing=0D=0Apath 65:112=2E=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: =
67:160: tur checker reports path is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl=
1108ju kernel: device-mapper: dm-multipath: Failing=0D=0Apath 65:128=2E=0D=
=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: checker failed path 67:160 in=
 map=0D=0A360050768018180a4f8000000000001ce=0D=0A=0D=0AJul  2 13:36:54 kl11=
08ju multipathd: 360050768018180a4f8000000000001ce:=0D=0Aremaining active p=
aths: 2=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 67:176: tur checker=
 reports path is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: =
checker failed path 67:176 in map=0D=0A360050768018180a4f8000000000001d2=0D=
=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f80000000000=
01d2:=0D=0Aremaining active paths: 1=0D=0A=0D=0AJul  2 13:36:54 kl1108ju mu=
ltipathd: 67:192: tur checker reports path is=0D=0Adown=0D=0A=0D=0AJul  2 1=
3:36:54 kl1108ju multipathd: checker failed path 67:192 in map=0D=0A3600507=
68018180a4f8000000000001d3=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: =
360050768018180a4f8000000000001d3:=0D=0Aremaining active paths: 1=0D=0A=0D=
=0AJul  2 13:36:54 kl1108ju multipathd: 67:208: tur checker reports path is=
=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: checker failed p=
ath 67:208 in map=0D=0A360050768018180a4f800000000000354=0D=0A=0D=0AJul  2 =
13:36:54 kl1108ju multipathd: 360050768018180a4f800000000000354:=0D=0Aremai=
ning active paths: 1=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 67:224=
: tur checker reports path is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju=
 multipathd: checker failed path 67:224 in map=0D=0A360050768018180a4f80000=
00000001d4=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 360050768018180a=
4f8000000000001d4:=0D=0Aremaining active paths: 2=0D=0A=0D=0AJul  2 13:36:5=
4 kl1108ju multipathd: 67:240: tur checker reports path is=0D=0Adown=0D=0A=
=0D=0AJul  2 13:36:54 kl1108ju multipathd: checker failed path 67:240 in ma=
p=0D=0A360050768018180a4f8000000000001d1=0D=0A=0D=0AJul  2 13:36:54 kl1108j=
u multipathd: 360050768018180a4f8000000000001d1:=0D=0Aremaining active path=
s: 1=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 65:0: tur checker repo=
rts path is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: check=
er failed path 65:0 in map=0D=0A360050768018180a4f8000000000001d0=0D=0A=0D=
=0AJul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d0:=
=0D=0Aremaining active paths: 1=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipa=
thd: 65:32: tur checker reports path is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:5=
4 kl1108ju multipathd: checker failed path 65:32 in map=0D=0A36005076801818=
0a4f8000000000001ce=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 3600507=
68018180a4f8000000000001ce:=0D=0Aremaining active paths: 1=0D=0A=0D=0AJul  =
2 13:36:54 kl1108ju multipathd: 65:48: tur checker reports path is=0D=0Adow=
n=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: checker failed path 65:48=
 in map=0D=0A360050768018180a4f8000000000001d2=0D=0A=0D=0AJul  2 13:36:54 k=
l1108ju multipathd: 360050768018180a4f8000000000001d2:=0D=0AEntering recove=
ry mode: max_retries=3D5=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 36=
0050768018180a4f8000000000001d2:=0D=0Aremaining active paths: 0=0D=0A=0D=0A=
Jul  2 13:36:54 kl1108ju multipathd: 65:64: tur checker reports path is=0D=
=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: checker failed path=
 65:64 in map=0D=0A360050768018180a4f8000000000001d3=0D=0A=0D=0AJul  2 13:3=
6:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3:=0D=0AEntering =
recovery mode: max_retries=3D5=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipat=
hd: 360050768018180a4f8000000000001d3:=0D=0Aremaining active paths: 0=0D=0A=
=0D=0AJul  2 13:36:54 kl1108ju multipathd: 65:80: tur checker reports path =
is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: checker failed=
 path 65:80 in map=0D=0A360050768018180a4f800000000000354=0D=0A=0D=0AJul  2=
 13:36:54 kl1108ju multipathd: 360050768018180a4f800000000000354:=0D=0AEnte=
ring recovery mode: max_retries=3D5=0D=0A=0D=0AJul  2 13:36:54 kl1108ju mul=
tipathd: 360050768018180a4f800000000000354:=0D=0Aremaining active paths: 0=
=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 65:96: tur checker reports=
 path is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: checker =
failed path 65:96 in map=0D=0A360050768018180a4f8000000000001d4=0D=0A=0D=0A=
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d4:=0D=
=0Aremaining active paths: 1=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd=
: 65:112: tur checker reports path is=0D=0Adown=0D=0A=0D=0AJul  2 13:36:54 =
kl1108ju multipathd: checker failed path 65:112 in map=0D=0A360050768018180=
a4f8000000000001d1=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 36005076=
8018180a4f8000000000001d1:=0D=0AEntering recovery mode: max_retries=3D5=0D=
=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f80000000000=
01d1:=0D=0Aremaining active paths: 0=0D=0A=0D=0AJul  2 13:36:54 kl1108ju mu=
ltipathd: 65:128: tur checker reports path is=0D=0Adown=0D=0A=0D=0AJul  2 1=
3:36:54 kl1108ju multipathd: checker failed path 65:128 in map=0D=0A3600507=
68018180a4f8000000000001d0=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: =
360050768018180a4f8000000000001d0:=0D=0AEntering recovery mode: max_retries=
=3D5=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000=
000000001d0:=0D=0Aremaining active paths: 0=0D=0A=0D=0AJul  2 13:36:54 kl11=
08ju multipathd: 360050768018180a4f8000000000001d2:=0D=0AEntering recovery =
mode: max_retries=3D5=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 36005=
0768018180a4f8000000000001d2:=0D=0AEntering recovery mode: max_retries=3D5=
=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f80000000=
00001d3:=0D=0AEntering recovery mode: max_retries=3D5=0D=0A=0D=0AJul  2 13:=
36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3:=0D=0AEntering=
 recovery mode: max_retries=3D5=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipa=
thd: 360050768018180a4f800000000000354:=0D=0AEntering recovery mode: max_re=
tries=3D5=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 360050768018180a4=
f800000000000354:=0D=0AEntering recovery mode: max_retries=3D5=0D=0A=0D=0AJ=
ul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d0:=0D=
=0AEntering recovery mode: max_retries=3D5=0D=0A=0D=0AJul  2 13:36:54 kl110=
8ju multipathd: 360050768018180a4f8000000000001d0:=0D=0AEntering recovery m=
ode: max_retries=3D5=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 360050=
768018180a4f8000000000001d1:=0D=0AEntering recovery mode: max_retries=3D5=
=0D=0A=0D=0AJul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f80000000=
00001d1:=0D=0AEntering recovery mode: max_retries=3D5=0D=0A=0D=0AJul  2 13:=
36:55 kl1108ju multipathd: 360050768018180a4f8000000000001d0:=0D=0AEntering=
 recovery mode: max_retries=3D5=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipa=
thd: 65:176: tur checker reports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:24=
 kl1108ju multipathd: 65:176: reinstated=0D=0A=0D=0AJul  2 13:37:24 kl1108j=
u multipathd: 360050768018180a4f8000000000001d2:=0D=0Aqueue_if_no_path enab=
led=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f80000=
00000001d2:=0D=0ARecovered to normal mode=0D=0A=0D=0AJul  2 13:37:24 kl1108=
ju multipathd: 360050768018180a4f8000000000001d2:=0D=0Aremaining active pat=
hs: 1=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 65:192: tur checker r=
eports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 65:1=
92: reinstated=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018=
180a4f8000000000001d3:=0D=0Aqueue_if_no_path enabled=0D=0A=0D=0AJul  2 13:3=
7:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3:=0D=0ARecovered=
 to normal mode=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 36005076801=
8180a4f8000000000001d3:=0D=0Aremaining active paths: 1=0D=0A=0D=0AJul  2 13=
:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3:=0D=0Aswitch =
to path group #2=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 3600507680=
18180a4f8000000000001d3:=0D=0Aswitch to path group #2=0D=0A=0D=0AJul  2 13:=
37:24 kl1108ju multipathd: 65:208: tur checker reports path is=0D=0Aup=0D=
=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 65:208: reinstated=0D=0A=0D=
=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354:=
=0D=0Aqueue_if_no_path enabled=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipat=
hd: 360050768018180a4f800000000000354:=0D=0ARecovered to normal mode=0D=0A=
=0D=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f80000000000035=
4:=0D=0Aremaining active paths: 1=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multi=
pathd: 360050768018180a4f800000000000354:=0D=0Aswitch to path group #2=0D=
=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f80000000000=
0354:=0D=0Aswitch to path group #2=0D=0A=0D=0AJul  2 13:37:24 kl1108ju mult=
ipathd: 65:240: tur checker reports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37=
:24 kl1108ju multipathd: 65:240: reinstated=0D=0A=0D=0AJul  2 13:37:24 kl11=
08ju multipathd: 360050768018180a4f8000000000001d1:=0D=0Aqueue_if_no_path e=
nabled=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f80=
00000000001d1:=0D=0ARecovered to normal mode=0D=0A=0D=0AJul  2 13:37:24 kl1=
108ju multipathd: 360050768018180a4f8000000000001d1:=0D=0Aremaining active =
paths: 1=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f=
8000000000001d1:=0D=0Aswitch to path group #2=0D=0A=0D=0AJul  2 13:37:24 kl=
1108ju multipathd: 360050768018180a4f8000000000001d1:=0D=0Aswitch to path g=
roup #2=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:0: tur checker r=
eports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:0=
: reinstated=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 36005076801818=
0a4f8000000000001d0:=0D=0Aqueue_if_no_path enabled=0D=0A=0D=0AJul  2 13:37:=
24 kl1108ju multipathd: 360050768018180a4f8000000000001d0:=0D=0ARecovered t=
o normal mode=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 3600507680181=
80a4f8000000000001d0:=0D=0Aremaining active paths: 1=0D=0A=0D=0AJul  2 13:3=
7:24 kl1108ju multipathd: 67:32: tur checker reports path is=0D=0Aup=0D=0A=
=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:32: reinstated=0D=0A=0D=0AJul=
  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001ce:=0D=0Ar=
emaining active paths: 2=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67=
:48: tur checker reports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:24 kl1108j=
u multipathd: 67:48: reinstated=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipa=
thd: 360050768018180a4f8000000000001d2:=0D=0Aremaining active paths: 2=0D=
=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:64: tur checker reports pa=
th is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:64: reinst=
ated=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000=
000000001d3:=0D=0Aremaining active paths: 2=0D=0A=0D=0AJul  2 13:37:24 kl11=
08ju multipathd: 67:80: tur checker reports path is=0D=0Aup=0D=0A=0D=0AJul =
 2 13:37:24 kl1108ju multipathd: 67:80: reinstated=0D=0A=0D=0AJul  2 13:37:=
24 kl1108ju multipathd: 360050768018180a4f800000000000354:=0D=0Aremaining a=
ctive paths: 2=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:96: tur c=
hecker reports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipat=
hd: 67:96: reinstated=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 36005=
0768018180a4f8000000000001d4:=0D=0Aremaining active paths: 2=0D=0A=0D=0AJul=
  2 13:37:24 kl1108ju multipathd: 67:112: tur checker reports path is=0D=0A=
up=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:112: reinstated=0D=0A=
=0D=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d=
1:=0D=0Aremaining active paths: 2=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multi=
pathd: 67:128: tur checker reports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:=
24 kl1108ju multipathd: 67:128: reinstated=0D=0A=0D=0AJul  2 13:37:24 kl110=
8ju multipathd: 360050768018180a4f8000000000001d0:=0D=0Aremaining active pa=
ths: 2=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:160: tur checker =
reports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:=
160: reinstated=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 36005076801=
8180a4f8000000000001ce:=0D=0Aremaining active paths: 3=0D=0A=0D=0AJul  2 13=
:37:24 kl1108ju multipathd: 67:176: tur checker reports path is=0D=0Aup=0D=
=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:176: reinstated=0D=0A=0D=
=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d2:=
=0D=0Aremaining active paths: 3=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipa=
thd: 67:192: tur checker reports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:24=
 kl1108ju multipathd: 67:192: reinstated=0D=0A=0D=0AJul  2 13:37:24 kl1108j=
u multipathd: 360050768018180a4f8000000000001d3:=0D=0Aremaining active path=
s: 3=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000=
000000001d3:=0D=0Aswitch to path group #1=0D=0A=0D=0AJul  2 13:37:24 kl1108=
ju multipathd: 360050768018180a4f8000000000001d3:=0D=0Aswitch to path group=
 #1=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:208: tur checker rep=
orts path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:208=
: reinstated=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 36005076801818=
0a4f800000000000354:=0D=0Aremaining active paths: 3=0D=0A=0D=0AJul  2 13:37=
:24 kl1108ju multipathd: 360050768018180a4f800000000000354:=0D=0Aswitch to =
path group #1=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 3600507680181=
80a4f800000000000354:=0D=0Aswitch to path group #1=0D=0A=0D=0AJul  2 13:37:=
24 kl1108ju multipathd: 67:224: tur checker reports path is=0D=0Aup=0D=0A=
=0D=0AJul  2 13:37:24 kl1108ju multipathd: 67:224: reinstated=0D=0A=0D=0AJu=
l  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d4:=0D=0A=
remaining active paths: 3=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 6=
7:240: tur checker reports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:24 kl110=
8ju multipathd: 67:240: reinstated=0D=0A=0D=0AJul  2 13:37:24 kl1108ju mult=
ipathd: 360050768018180a4f8000000000001d1:=0D=0Aremaining active paths: 3=
=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f80000000=
00001d1:=0D=0Aswitch to path group #1=0D=0A=0D=0AJul  2 13:37:24 kl1108ju m=
ultipathd: 360050768018180a4f8000000000001d1:=0D=0Aswitch to path group #1=
=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 65:0: tur checker reports =
path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 65:0: reins=
tated=0D=0A=0D=0AJul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f800=
0000000001d0:=0D=0Aremaining active paths: 3=0D=0A=0D=0AJul  2 13:37:25 kl1=
108ju multipathd: 65:32: tur checker reports path is=0D=0Aup=0D=0A=0D=0AJul=
  2 13:37:25 kl1108ju multipathd: 65:32: reinstated=0D=0A=0D=0AJul  2 13:37=
:25 kl1108ju multipathd: 360050768018180a4f8000000000001ce:=0D=0Aremaining =
active paths: 4=0D=0A=0D=0AJul  2 13:37:25 kl1108ju multipathd: 65:48: tur =
checker reports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:25 kl1108ju multipa=
thd: 65:48: reinstated=0D=0A=0D=0AJul  2 13:37:25 kl1108ju multipathd: 3600=
50768018180a4f8000000000001d2:=0D=0Aremaining active paths: 4=0D=0A=0D=0AJu=
l  2 13:37:25 kl1108ju multipathd: 65:64: tur checker reports path is=0D=0A=
up=0D=0A=0D=0AJul  2 13:37:25 kl1108ju multipathd: 65:64: reinstated=0D=0A=
=0D=0AJul  2 13:37:25 kl1108ju multipathd: 360050768018180a4f8000000000001d=
3:=0D=0Aremaining active paths: 4=0D=0A=0D=0AJul  2 13:37:25 kl1108ju multi=
pathd: 65:80: tur checker reports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:2=
5 kl1108ju multipathd: 65:80: reinstated=0D=0A=0D=0AJul  2 13:37:25 kl1108j=
u multipathd: 360050768018180a4f800000000000354:=0D=0Aremaining active path=
s: 4=0D=0A=0D=0AJul  2 13:37:25 kl1108ju multipathd: 65:96: tur checker rep=
orts path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:25 kl1108ju multipathd: 65:96:=
 reinstated=0D=0A=0D=0AJul  2 13:37:25 kl1108ju multipathd: 360050768018180=
a4f8000000000001d4:=0D=0Aremaining active paths: 4=0D=0A=0D=0AJul  2 13:37:=
25 kl1108ju multipathd: 65:112: tur checker reports path is=0D=0Aup=0D=0A=
=0D=0AJul  2 13:37:25 kl1108ju multipathd: 65:112: reinstated=0D=0A=0D=0AJu=
l  2 13:37:25 kl1108ju multipathd: 360050768018180a4f8000000000001d1:=0D=0A=
remaining active paths: 4=0D=0A=0D=0AJul  2 13:37:25 kl1108ju multipathd: 6=
5:128: tur checker reports path is=0D=0Aup=0D=0A=0D=0AJul  2 13:37:25 kl110=
8ju multipathd: 65:128: reinstated=0D=0A=0D=0A =0D=0A=0D=0A =0D=0A=0D=0AKin=
d regards,=0D=0A=0D=0AChris   =0D=0A=0D=0A =0D=0A=0D=0A =0D=0A=0D=0A =0D=0A=
=0D=0A =0D=0A=0D=0A =0D=0A=0D=0A=0D=0A=0D=0A*******************************=
***************************************=0D=0AFor information, services and =
offers, please visit our web site:=0Ahttp://www=2Eklm=2Ecom=2E This e-mail =
and any attachment may contain=0Aconfidential and privileged material inten=
ded for the addressee=0Aonly=2E If you are not the addressee, you are notif=
ied that no part=0Aof the e-mail or any attachment may be disclosed, copied=
 or=0Adistributed, and that any other action related to this e-mail or=0Aat=
tachment is strictly prohibited, and may be unlawful=2E If you have=0Arecei=
ved this e-mail by error, please notify the sender immediately=0Aby return =
e-mail, and delete this message=2E =0D=0A=0D=0AKoninklijke Luchtvaart Maats=
chappij NV (KLM), its subsidiaries=0Aand/or its employees shall not be liab=
le for the incorrect or=0Aincomplete transmission of this e-mail or any att=
achments, nor=0Aresponsible for any delay in receipt=2E=0D=0AKoninklijke Lu=
chtvaart Maatschappij N=2EV=2E (also known as KLM Royal=0ADutch Airlines) i=
s registered in Amstelveen, The Netherlands, with=0Aregistered number 33014=
286 =0D=0A*****************************************************************=
*****
------_=_NextPart_001_01C8EBED.4949CC97
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:o=3D"urn:schemas-microsoft-com:office:office" xmlns:w=3D"urn:sc=
hemas-microsoft-com:office:word" xmlns=3D"http://www=2Ew3=2Eorg/TR/REC-html=
40">=0D=0A=0D=0A<head>=0D=0A<meta http-equiv=3DContent-Type content=3D"text=
/html; charset=3Dus-ascii">=0D=0A<meta name=3DGenerator content=3D"Microsof=
t Word 11 (filtered medium)">=0D=0A<style>=0D=0A<!--=0D=0A /* Style Definit=
ions */=0D=0A p=2EMsoNormal, li=2EMsoNormal, div=2EMsoNormal=0D=0A	{margin:=
0in;=0D=0A	margin-bottom:=2E0001pt;=0D=0A	font-size:11=2E0pt;=0D=0A	font-fa=
mily:Arial;}=0D=0Aa:link, span=2EMsoHyperlink=0D=0A	{color:blue;=0D=0A	text=
-decoration:underline;}=0D=0Aa:visited, span=2EMsoHyperlinkFollowed=0D=0A	{=
color:purple;=0D=0A	text-decoration:underline;}=0D=0Aspan=2EEmailStyle17=0D=
=0A	{mso-style-type:personal-compose;=0D=0A	font-family:Arial;=0D=0A	color:=
windowtext;}=0D=0A@page Section1=0D=0A	{size:595=2E35pt 842=2E0pt;=0D=0A	ma=
rgin:1=2E0in 89=2E85pt 1=2E0in 89=2E85pt;}=0D=0Adiv=2ESection1=0D=0A	{page:=
Section1;}=0D=0A-->=0D=0A</style>=0D=0A=0D=0A</head>=0D=0A=0D=0A<body lang=
=3DEN-US link=3Dblue vlink=3Dpurple>=0D=0A=0D=0A<div class=3DSection1>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DNL s=
tyle=3D'font-size:10=2E0pt'>To=0D=0Aall,<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span lang=3DNL styl=
e=3D'font-size:10=2E0pt'><o:p>&nbsp;</o:p></span></font></p>=0D=0A=0D=0A<p =
class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'>Is it=0D=0Anormal DM behavior that we are (temporary) losing paths =
from &#8216;unaffected&#8217;=0D=0ALUN&#8217;s when we unmap a SAN LUN from=
 the storage side=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMso=
Normal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>We=0D=
=0Aare using an IBM SVC (4=2E2=2E1) and RH AS 4=2E6=2E We are using the mul=
tipath=2Econf=0D=0Afile supplied by IBM for the SVC=2E<o:p></o:p></span></f=
ont></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10=2E0pt'><o:p>&nbsp;</o:p></span></font></p>=0D=0A=0D=
=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-siz=
e:10=2E0pt'>It&#8217;s=0D=0Anormal that you loose the paths of the LUN whic=
h you unmap (4 paths in our=0D=0Acase), but why we are also losing paths fr=
om &#8216;unaffected&#8217; LUN&#8217;s=2E<o:p></o:p></span></font></p>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'fo=
nt-size:10=2E0pt'>Unmapping=0D=0Aa LUN is not a normal storage admin action=
 but could happen accidentally=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<=
p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'>We=0D=0Aalso see the same behavior when we give a new LUN to the Li=
nux server=2E The=0D=0Aminute we map the LUN, paths from other LUN&#8217;s =
are temporarily disappearing=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p =
class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'><o:p>&nbsp;</o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal=
><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>We=0D=0Atri=
ed several settings/HBA firmware etc=2E but can not eliminate this behavior=
 of=0D=0ADM=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal=
><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'><o:p>&nbsp;=
</o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fac=
e=3DArial><span style=3D'font-size:10=2E0pt'><o:p>&nbsp;</o:p></span></font=
></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span sty=
le=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 65=
:176: tur checker reports path is down<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: checker faile=
d path 65:176 in map=0D=0A360050768018180a4f8000000000001d2<o:p></o:p></spa=
n></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><=
span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multip=
athd: 360050768018180a4f8000000000001d2: remaining=0D=0Aactive paths: 3<o:p=
></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fa=
ce=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1=
108ju kernel: device-mapper: dm-multipath: Failing path 65:176=2E<o:p></o:p=
></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DA=
rial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju =
multipathd: 65:192: tur checker reports path is down<o:p></o:p></span></fon=
t></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span st=
yle=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: c=
hecker failed path 65:192 in map=0D=0A360050768018180a4f8000000000001d3<o:p=
></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fa=
ce=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1=
108ju multipathd: 360050768018180a4f8000000000001d3: remaining=0D=0Aactive =
paths: 3<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font=
 size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 =
13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing path 65:192=
=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=
=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36=
:54 kl1108ju multipathd: 65:208: tur checker reports path is down<o:p></o:p=
></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DA=
rial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju =
multipathd: checker failed path 65:208 in map=0D=0A360050768018180a4f800000=
000000354<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><fon=
t size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2=
 13:36:54 kl1108ju multipathd: 360050768018180a4f800000000000354: remaining=
=0D=0Aactive paths: 3<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMs=
oNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&=
nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing=
 path 65:208=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNorma=
l><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=
=0D=0A2 13:36:54 kl1108ju multipathd: 65:240: tur checker reports path is d=
own<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=
=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36=
:54 kl1108ju multipathd: checker failed path 65:240 in map=0D=0A36005076801=
8180a4f8000000000001d1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DM=
soNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul=
&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failin=
g path 65:240=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNorm=
al><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=
=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d1: re=
maining=0D=0Aactive paths: 3<o:p></o:p></span></font></p>=0D=0A=0D=0A<p cla=
ss=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0p=
t'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 67:0: tur checker reports=
 path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal>=
<font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=
=0A2 13:36:54 kl1108ju multipathd: checker failed path 67:0 in map=0D=0A360=
050768018180a4f8000000000001d0<o:p></o:p></span></font></p>=0D=0A=0D=0A<p c=
lass=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E=
0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath=
: Failing path 67:0=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DM=
soNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul=
&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001=
d0: remaining=0D=0Aactive paths: 3<o:p></o:p></span></font></p>=0D=0A=0D=0A=
<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 67:32: tur checker =
reports path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMso=
Normal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&n=
bsp;=0D=0A2 13:36:54 kl1108ju multipathd: checker failed path 67:32 in map=
=0D=0A360050768018180a4f8000000000001ce<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm=
-multipath: Failing path 67:32=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<=
p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f80=
00000000001ce: remaining=0D=0Aactive paths: 3<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapp=
er: dm-multipath: Failing path 67:48=2E<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 67:48: tur ch=
ecker reports path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'=
>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Fa=
iling path 67:64=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoN=
ormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nb=
sp;=0D=0A2 13:36:54 kl1108ju multipathd: checker failed path 67:48 in map=
=0D=0A360050768018180a4f8000000000001d2<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm=
-multipath: Failing path 67:80=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<=
p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f80=
00000000001d2: remaining=0D=0Aactive paths: 2<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapp=
er: dm-multipath: Failing path 67:96=2E<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 67:64: tur ch=
ecker reports path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'=
>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Fa=
iling path 67:112=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMso=
Normal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&n=
bsp;=0D=0A2 13:36:54 kl1108ju multipathd: checker failed path 67:64 in map=
=0D=0A360050768018180a4f8000000000001d3<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm=
-multipath: Failing path 67:128=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A=
<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f8=
000000000001d3: remaining=0D=0Aactive paths: 2<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapp=
er: dm-multipath: Failing path 67:160=2E<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 67:80: tur ch=
ecker reports path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'=
>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Fa=
iling path 67:176=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMso=
Normal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&n=
bsp;=0D=0A2 13:36:54 kl1108ju multipathd: checker failed path 67:80 in map=
=0D=0A360050768018180a4f800000000000354<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm=
-multipath: Failing path 67:192=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A=
<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f8=
00000000000354: remaining=0D=0Aactive paths: 2<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapp=
er: dm-multipath: Failing path 67:208=2E<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 67:96: tur ch=
ecker reports path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'=
>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Fa=
iling path 67:224=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMso=
Normal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&n=
bsp;=0D=0A2 13:36:54 kl1108ju multipathd: checker failed path 67:96 in map=
=0D=0A360050768018180a4f8000000000001d4<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm=
-multipath: Failing path 67:240=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A=
<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f8=
000000000001d4: remaining=0D=0Aactive paths: 3<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapp=
er: dm-multipath: Failing path 65:0=2E<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 67:112: tur c=
hecker reports path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p clas=
s=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt=
'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: F=
ailing path 65:32=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMso=
Normal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&n=
bsp;=0D=0A2 13:36:54 kl1108ju multipathd: checker failed path 67:112 in map=
=0D=0A360050768018180a4f8000000000001d1<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm=
-multipath: Failing path 65:48=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<=
p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f80=
00000000001d1: remaining=0D=0Aactive paths: 2<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapp=
er: dm-multipath: Failing path 65:64=2E<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 67:128: tur c=
hecker reports path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p clas=
s=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt=
'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: F=
ailing path 65:80=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMso=
Normal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&n=
bsp;=0D=0A2 13:36:54 kl1108ju multipathd: checker failed path 67:128 in map=
=0D=0A360050768018180a4f8000000000001d0<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm=
-multipath: Failing path 65:96=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<=
p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f80=
00000000001d0: remaining=0D=0Aactive paths: 2<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapp=
er: dm-multipath: Failing path 65:112=2E<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 67:160: tur c=
hecker reports path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p clas=
s=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt=
'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: F=
ailing path 65:128=2E<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMs=
oNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&=
nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: checker failed path 67:160 in ma=
p=0D=0A360050768018180a4f8000000000001ce<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 3600507680181=
80a4f8000000000001ce: remaining=0D=0Aactive paths: 2<o:p></o:p></span></fon=
t></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span st=
yle=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 6=
7:176: tur checker reports path is down<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: checker faile=
d path 67:176 in map=0D=0A360050768018180a4f8000000000001d2<o:p></o:p></spa=
n></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><=
span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multip=
athd: 360050768018180a4f8000000000001d2: remaining=0D=0Aactive paths: 1<o:p=
></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fa=
ce=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1=
108ju multipathd: 67:192: tur checker reports path is down<o:p></o:p></span=
></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><s=
pan style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipa=
thd: checker failed path 67:192 in map=0D=0A360050768018180a4f8000000000001=
d3<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=
=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36=
:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3: remaining=0D=0A=
active paths: 1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNorma=
l><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=
=0D=0A2 13:36:54 kl1108ju multipathd: 67:208: tur checker reports path is d=
own<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=
=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36=
:54 kl1108ju multipathd: checker failed path 67:208 in map=0D=0A36005076801=
8180a4f800000000000354<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DM=
soNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul=
&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000003=
54: remaining=0D=0Aactive paths: 1<o:p></o:p></span></font></p>=0D=0A=0D=0A=
<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:1=
0=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 67:224: tur checker=
 reports path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMs=
oNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&=
nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: checker failed path 67:224 in ma=
p 360050768018180a4f8000000000001d4<o:p></o:p></span></font></p>=0D=0A=0D=
=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-siz=
e:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a=
4f8000000000001d4: remaining=0D=0Aactive paths: 2<o:p></o:p></span></font><=
/p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=
=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 67:2=
40: tur checker reports path is down<o:p></o:p></span></font></p>=0D=0A=0D=
=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-siz=
e:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: checker failed p=
ath 67:240 in map=0D=0A360050768018180a4f8000000000001d1<o:p></o:p></span><=
/font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><spa=
n style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipath=
d: 360050768018180a4f8000000000001d1: remaining=0D=0Aactive paths: 1<o:p></=
o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=
=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl110=
8ju multipathd: 65:0: tur checker reports path is down<o:p></o:p></span></f=
ont></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd:=
 checker failed path 65:0 in map=0D=0A360050768018180a4f8000000000001d0<o:p=
></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fa=
ce=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1=
108ju multipathd: 360050768018180a4f8000000000001d0: remaining=0D=0Aactive =
paths: 1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font=
 size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 =
13:36:54 kl1108ju multipathd: 65:32: tur checker reports path is down<o:p><=
/o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=
=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl110=
8ju multipathd: checker failed path 65:32 in map=0D=0A360050768018180a4f800=
0000000001ce<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><=
font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=
=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001ce: remai=
ning=0D=0Aactive paths: 1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'=
>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 65:48: tur checker reports =
path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><=
font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=
=0A2 13:36:54 kl1108ju multipathd: checker failed path 65:48 in map=0D=0A36=
0050768018180a4f8000000000001d2<o:p></o:p></span></font></p>=0D=0A=0D=0A<p =
class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f80=
00000000001d2: Entering=0D=0Arecovery mode: max_retries=3D5<o:p></o:p></spa=
n></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><=
span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multip=
athd: 360050768018180a4f8000000000001d2: remaining=0D=0Aactive paths: 0<o:p=
></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fa=
ce=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1=
108ju multipathd: 65:64: tur checker reports path is down<o:p></o:p></span>=
</font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><sp=
an style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipat=
hd: checker failed path 65:64 in map=0D=0A360050768018180a4f8000000000001d3=
<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D=
2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54=
 kl1108ju multipathd: 360050768018180a4f8000000000001d3: Entering=0D=0Areco=
very mode: max_retries=3D5<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'=
>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f800000000=
0001d3: remaining=0D=0Aactive paths: 0<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 65:80: tur ch=
ecker reports path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'=
>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: checker failed path 65:80 i=
n map=0D=0A360050768018180a4f800000000000354<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 3600507=
68018180a4f800000000000354: Entering=0D=0Arecovery mode: max_retries=3D5<o:=
p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 f=
ace=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl=
1108ju multipathd: 360050768018180a4f800000000000354: remaining=0D=0Aactive=
 paths: 0<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><fon=
t size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2=
 13:36:54 kl1108ju multipathd: 65:96: tur checker reports path is down<o:p>=
</o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fac=
e=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl11=
08ju multipathd: checker failed path 65:96 in map=0D=0A360050768018180a4f80=
00000000001d4<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal>=
<font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=
=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d4: remai=
ning=0D=0Aactive paths: 1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'=
>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 65:112: tur checker reports=
 path is down<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal>=
<font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=
=0A2 13:36:54 kl1108ju multipathd: checker failed path 65:112 in map=0D=0A3=
60050768018180a4f8000000000001d1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p=
 class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f80=
00000000001d1: Entering=0D=0Arecovery mode: max_retries=3D5<o:p></o:p></spa=
n></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><=
span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multip=
athd: 360050768018180a4f8000000000001d1: remaining=0D=0Aactive paths: 0<o:p=
></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fa=
ce=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1=
108ju multipathd: 65:128: tur checker reports path is down<o:p></o:p></span=
></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><s=
pan style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipa=
thd: checker failed path 65:128 in map=0D=0A360050768018180a4f8000000000001=
d0<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=
=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36=
:54 kl1108ju multipathd: 360050768018180a4f8000000000001d0: Entering=0D=0Ar=
ecovery mode: max_retries=3D5<o:p></o:p></span></font></p>=0D=0A=0D=0A<p cl=
ass=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0=
pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f800000=
0000001d0: remaining=0D=0Aactive paths: 0<o:p></o:p></span></font></p>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'fo=
nt-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 3600507680=
18180a4f8000000000001d2: Entering=0D=0Arecovery mode: max_retries=3D5<o:p><=
/o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=
=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl110=
8ju multipathd: 360050768018180a4f8000000000001d2: Entering=0D=0Arecovery m=
ode: max_retries=3D5<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMso=
Normal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&n=
bsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3=
: Entering=0D=0Arecovery mode: max_retries=3D5<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 3600507=
68018180a4f8000000000001d3: Entering=0D=0Arecovery mode: max_retries=3D5<o:=
p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 f=
ace=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl=
1108ju multipathd: 360050768018180a4f800000000000354: Entering=0D=0Arecover=
y mode: max_retries=3D5<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3D=
MsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Ju=
l&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f800000000000=
354: Entering=0D=0Arecovery mode: max_retries=3D5<o:p></o:p></span></font><=
/p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=
=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 3600=
50768018180a4f8000000000001d0: Entering=0D=0Arecovery mode: max_retries=3D5=
<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D=
2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54=
 kl1108ju multipathd: 360050768018180a4f8000000000001d0: Entering=0D=0Areco=
very mode: max_retries=3D5<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'=
>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 360050768018180a4f800000000=
0001d1: Entering=0D=0Arecovery mode: max_retries=3D5<o:p></o:p></span></fon=
t></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span st=
yle=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:36:54 kl1108ju multipathd: 3=
60050768018180a4f8000000000001d1: Entering=0D=0Arecovery mode: max_retries=
=3D5<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font siz=
e=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:3=
6:55 kl1108ju multipathd: 360050768018180a4f8000000000001d0: Entering=0D=0A=
recovery mode: max_retries=3D5<o:p></o:p></span></font></p>=0D=0A=0D=0A<p c=
lass=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E=
0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 65:176: tur checker rep=
orts path is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNorma=
l><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=
=0D=0A2 13:37:24 kl1108ju multipathd: 65:176: reinstated<o:p></o:p></span><=
/font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><spa=
n style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipath=
d: 360050768018180a4f8000000000001d2:=0D=0Aqueue_if_no_path enabled<o:p></o=
:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=
=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl110=
8ju multipathd: 360050768018180a4f8000000000001d2: Recovered to=0D=0Anormal=
 mode<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font si=
ze=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:=
37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d2: remaining=0D=
=0Aactive paths: 1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNo=
rmal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbs=
p;=0D=0A2 13:37:24 kl1108ju multipathd: 65:192: tur checker reports path is=
 up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=
=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37=
:24 kl1108ju multipathd: 65:192: reinstated<o:p></o:p></span></font></p>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'fo=
nt-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 3600507680=
18180a4f8000000000001d3:=0D=0Aqueue_if_no_path enabled<o:p></o:p></span></f=
ont></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span =
style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd:=
 360050768018180a4f8000000000001d3: Recovered to=0D=0Anormal mode<o:p></o:p=
></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DA=
rial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju =
multipathd: 360050768018180a4f8000000000001d3: remaining=0D=0Aactive paths:=
 1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=
=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37=
:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3: switch to=0D=0A=
path group #2<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal>=
<font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=
=0A2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3: switc=
h to=0D=0Apath group #2<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3D=
MsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Ju=
l&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 65:208: tur checker reports pa=
th is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font=
 size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 =
13:37:24 kl1108ju multipathd: 65:208: reinstated<o:p></o:p></span></font></=
p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=
=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 3600=
50768018180a4f800000000000354:=0D=0Aqueue_if_no_path enabled<o:p></o:p></sp=
an></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial>=
<span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multi=
pathd: 360050768018180a4f800000000000354: Recovered to=0D=0Anormal mode<o:p=
></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fa=
ce=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1=
108ju multipathd: 360050768018180a4f800000000000354: remaining=0D=0Aactive =
paths: 1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font=
 size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 =
13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: switch to=
=0D=0Apath group #2<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoN=
ormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nb=
sp;=0D=0A2 13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354:=
 switch to=0D=0Apath group #2<o:p></o:p></span></font></p>=0D=0A=0D=0A<p cl=
ass=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0=
pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 65:240: tur checker repo=
rts path is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal=
><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=
=0D=0A2 13:37:24 kl1108ju multipathd: 65:240: reinstated<o:p></o:p></span><=
/font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><spa=
n style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipath=
d: 360050768018180a4f8000000000001d1: queue_if_no_path=0D=0Aenabled<o:p></o=
:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=
=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl110=
8ju multipathd: 360050768018180a4f8000000000001d1: Recovered to=0D=0Anormal=
 mode<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font si=
ze=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:=
37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: remaining=0D=
=0Aactive paths: 1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNo=
rmal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbs=
p;=0D=0A2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: =
switch to=0D=0Apath group #2<o:p></o:p></span></font></p>=0D=0A=0D=0A<p cla=
ss=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0p=
t'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000=
000001d1: switch to=0D=0Apath group #2<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:0: tur che=
cker reports path is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3D=
MsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Ju=
l&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:0: reinstated<o:p></o:p></s=
pan></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial=
><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju mult=
ipathd: 360050768018180a4f8000000000001d0:=0D=0Aqueue_if_no_path enabled<o:=
p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 f=
ace=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl=
1108ju multipathd: 360050768018180a4f8000000000001d0: Recovered to=0D=0Anor=
mal mode<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font=
 size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 =
13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d0: remaining=
=0D=0Aactive paths: 1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMs=
oNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&=
nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:32: tur checker reports path =
is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font si=
ze=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:=
37:24 kl1108ju multipathd: 67:32: reinstated<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 3600507=
68018180a4f8000000000001ce: remaining=0D=0Aactive paths: 2<o:p></o:p></span=
></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><s=
pan style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipa=
thd: 67:48: tur checker reports path is up<o:p></o:p></span></font></p>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'fo=
nt-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:48: rei=
nstated<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font =
size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 1=
3:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d2: remaining=
=0D=0Aactive paths: 2<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMs=
oNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul =
&nbsp;2=0D=0A13:37:24 kl1108ju multipathd: 67:64: tur checker reports path =
is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font si=
ze=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:=
37:24 kl1108ju multipathd: 67:64: reinstated<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 3600507=
68018180a4f8000000000001d3: remaining=0D=0Aactive paths: 2<o:p></o:p></span=
></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><s=
pan style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipa=
thd: 67:80: tur checker reports path is up<o:p></o:p></span></font></p>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'fo=
nt-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:80: rei=
nstated<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font =
size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 1=
3:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: remaining=
=0D=0Aactive paths: 2<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMs=
oNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&=
nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:96: tur checker reports path =
is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font si=
ze=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:=
37:24 kl1108ju multipathd: 67:96: reinstated<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 3600507=
68018180a4f8000000000001d4: remaining=0D=0Aactive paths: 2<o:p></o:p></span=
></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><s=
pan style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipa=
thd: 67:112: tur checker reports path is up<o:p></o:p></span></font></p>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'fo=
nt-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:112: re=
instated<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font=
 size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 =
13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: remaining=
=0D=0Aactive paths: 2<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMs=
oNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&=
nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:128: tur checker reports path=
 is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font s=
ize=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13=
:37:24 kl1108ju multipathd: 67:128: reinstated<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 3600507=
68018180a4f8000000000001d0: remaining=0D=0Aactive paths: 2<o:p></o:p></span=
></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><s=
pan style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipa=
thd: 67:160: tur checker reports path is up<o:p></o:p></span></font></p>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'fo=
nt-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:160: re=
instated<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font=
 size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 =
13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001ce: remaining=
=0D=0Aactive paths: 3<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMs=
oNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&=
nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:176: tur checker reports path=
 is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font s=
ize=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13=
:37:24 kl1108ju multipathd: 67:176: reinstated<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 3600507=
68018180a4f8000000000001d2: remaining=0D=0Aactive paths: 3<o:p></o:p></span=
></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><s=
pan style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipa=
thd: 67:192: tur checker reports path is up<o:p></o:p></span></font></p>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'fo=
nt-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:192: re=
instated<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font=
 size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 =
13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3: remaining=
=0D=0Aactive paths: 3<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMs=
oNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&=
nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d=
3: switch to=0D=0Apath group #1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p =
class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 360050768018180a4f80=
00000000001d3: switch to=0D=0Apath group #1<o:p></o:p></span></font></p>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'fo=
nt-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:208: tu=
r checker reports path is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p cla=
ss=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0p=
t'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:208: reinstated<o:p></=
o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=
=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl110=
8ju multipathd: 360050768018180a4f800000000000354: remaining=0D=0Aactive pa=
ths: 3<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font s=
ize=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13=
:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: switch to=0D=
=0Apath group #1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNorm=
al><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=
=0D=0A2 13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: sw=
itch to=0D=0Apath group #1<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'=
>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:224: tur checker reports=
 path is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><f=
ont size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=
=0A2 13:37:24 kl1108ju multipathd: 67:224: reinstated<o:p></o:p></span></fo=
nt></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span s=
tyle=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: =
360050768018180a4f8000000000001d4: remaining=0D=0Aactive paths: 3<o:p></o:p=
></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DA=
rial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju =
multipathd: 67:240: tur checker reports path is up<o:p></o:p></span></font>=
</p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span styl=
e=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 67:=
240: reinstated<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNorma=
l><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=
=0D=0A2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: re=
maining=0D=0Aactive paths: 3<o:p></o:p></span></font></p>=0D=0A=0D=0A<p cla=
ss=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0p=
t'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000=
000001d1: switch to=0D=0Apath group #1<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 3600507680181=
80a4f8000000000001d1: switch to=0D=0Apath group #1<o:p></o:p></span></font>=
</p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span styl=
e=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 65:=
0: tur checker reports path is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<=
p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1108ju multipathd: 65:0: reinstated<o:p=
></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fa=
ce=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:24 kl1=
108ju multipathd: 360050768018180a4f8000000000001d0: remaining=0D=0Aactive =
paths: 3<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font=
 size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 =
13:37:25 kl1108ju multipathd: 65:32: tur checker reports path is up<o:p></o=
:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=
=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:25 kl110=
8ju multipathd: 65:32: reinstated<o:p></o:p></span></font></p>=0D=0A=0D=0A<=
p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=
=2E0pt'>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju multipathd: 360050768018180a4f80=
00000000001ce: remaining=0D=0Aactive paths: 4<o:p></o:p></span></font></p>=
=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D=
'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju multipathd: 65:48: =
tur checker reports path is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p c=
lass=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E=
0pt'>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju multipathd: 65:48: reinstated<o:p><=
/o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=
=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:25 kl110=
8ju multipathd: 360050768018180a4f8000000000001d2: remaining=0D=0Aactive pa=
ths: 4<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font s=
ize=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13=
:37:25 kl1108ju multipathd: 65:64: tur checker reports path is up<o:p></o:p=
></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DA=
rial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju =
multipathd: 65:64: reinstated<o:p></o:p></span></font></p>=0D=0A=0D=0A<p cl=
ass=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0=
pt'>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju multipathd: 360050768018180a4f800000=
0000001d3: remaining=0D=0Aactive paths: 4<o:p></o:p></span></font></p>=0D=
=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'fo=
nt-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju multipathd: 65:80: tur=
 checker reports path is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p clas=
s=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt=
'>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju multipathd: 65:80: reinstated<o:p></o:=
p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3D=
Arial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju=
 multipathd: 360050768018180a4f800000000000354: remaining=0D=0Aactive paths=
: 4<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=
=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37=
:25 kl1108ju multipathd: 65:96: tur checker reports path is up<o:p></o:p></=
span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DAria=
l><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju mul=
tipathd: 65:96: reinstated<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'=
>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju multipathd: 360050768018180a4f800000000=
0001d4: remaining=0D=0Aactive paths: 4<o:p></o:p></span></font></p>=0D=0A=
=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-=
size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju multipathd: 65:112: tur c=
hecker reports path is up<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=
=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'=
>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju multipathd: 65:112: reinstated<o:p></o:=
p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3D=
Arial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju=
 multipathd: 360050768018180a4f8000000000001d1: remaining=0D=0Aactive paths=
: 4<o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=
=3D2 face=3DArial><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37=
:25 kl1108ju multipathd: 65:128: tur checker reports path is up<o:p></o:p><=
/span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DAri=
al><span style=3D'font-size:10=2E0pt'>Jul&nbsp;=0D=0A2 13:37:25 kl1108ju mu=
ltipathd: 65:128: reinstated<o:p></o:p></span></font></p>=0D=0A=0D=0A<p cla=
ss=3DMsoNormal><font size=3D2 face=3DArial><span style=3D'font-size:10=2E0p=
t'><o:p>&nbsp;</o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><fon=
t size=3D2 color=3Dnavy face=3DArial><span style=3D'font-size:=0D=0A10=2E0p=
t;color:navy'>&nbsp;</span></font><font size=3D2><span style=3D'font-size:=
=0D=0A10=2E0pt'><o:p></o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNorm=
al><font size=3D2 color=3Dnavy face=3DArial><span lang=3DNL=0D=0Astyle=3D'f=
ont-size:10=2E0pt;color:navy;layout-grid-mode:line'>Kind regards,<o:p></o:p=
></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 color=3D=
navy face=3DArial><span lang=3DNL=0D=0Astyle=3D'font-size:10=2E0pt;color:na=
vy;layout-grid-mode:line'>Chris</span></font><b><font=0D=0Acolor=3Dnavy><sp=
an lang=3DNL style=3D'color:navy;layout-grid-mode:line;font-weight:=0D=0Abo=
ld'>&nbsp;&nbsp; </span></font></b><font size=3D3 face=3D"Times New Roman">=
<span=0D=0Astyle=3D'font-size:12=2E0pt;font-family:"Times New Roman"'><o:p>=
</o:p></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 fac=
e=3DArial><span lang=3DNL style=3D'font-size:11=2E0pt'>&nbsp;<o:p></o:p></s=
pan></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font size=3D2 face=3DArial=
><span lang=3DNL style=3D'font-size:11=2E0pt'>&nbsp;<b><font=0D=0Acolor=3Dn=
avy><span style=3D'color:navy;layout-grid-mode:line;font-weight:bold'><o:p>=
</o:p></span></font></b></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal>=
<b><font size=3D2 color=3Dnavy face=3DArial><span lang=3DNL=0D=0Astyle=3D'f=
ont-size:11=2E0pt;color:navy;layout-grid-mode:line;font-weight:bold'><o:p>&=
nbsp;</o:p></span></font></b></p>=0D=0A=0D=0A<p class=3DMsoNormal><font siz=
e=3D2 face=3DArial><span lang=3DNL style=3D'font-size:11=2E0pt'>&nbsp;<font=
=0D=0Acolor=3Dnavy><span style=3D'color:navy;layout-grid-mode:line'><o:p></=
o:p></span></font></span></font></p>=0D=0A=0D=0A<p class=3DMsoNormal><font =
size=3D2 face=3DArial><span lang=3DNL style=3D'font-size:11=2E0pt'><o:p>&nb=
sp;</o:p></span></font></p>=0D=0A=0D=0A</div>=0D=0A=0D=0A</body>=0D=0A=0D=
=0A</html>=0D=0A=0D=0A*****************************************************=
***************** <br>For information, services and offers, please visit ou=
r web site: http://www=2Eklm=2Ecom=2E This e-mail and any attachment may co=
ntain confidential and privileged material intended for the addressee only=
=2E If you are not the addressee, you are notified that no part of the e-ma=
il or any attachment may be disclosed, copied or distributed, and that any =
other action related to this e-mail or attachment is strictly prohibited, a=
nd may be unlawful=2E If you have received this e-mail by error, please not=
ify the sender immediately by return e-mail, and delete this message=2E =0D=
=0A=0D=0AKoninklijke Luchtvaart Maatschappij NV (KLM), its subsidiaries and=
/or its employees shall not be liable for the incorrect or incomplete trans=
mission of this e-mail or any attachments, nor responsible for any delay in=
 receipt=2E Koninklijke Luchtvaart Maatschappij N=2EV=2E (also known as KLM=
 Royal Dutch Airlines) is registered in Amstelveen, The Netherlands, with r=
egistered number 33014286 *************************************************=
*********************  =0D=0A
------_=_NextPart_001_01C8EBED.4949CC97--


--===============0357655900==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0357655900==--
