From: "Romanowski, John (OFT)" <John.Romanowski@oft.state.ny.us>
Subject: RE: Losing paths
Date: Tue, 22 Jul 2008 10:44:17 -0400
Message-ID: <1D80D4F6D179BD4D869FE807A5BF833602D8B683@EXCNYSM0A1AN.nysemail.nyenet>
References: <E6D1DDD48426A44EB25DF27F5AAE7A6505B96797@KL1010XG.cs.ad.klmcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Class: urn:content-classes:message
In-Reply-To: <E6D1DDD48426A44EB25DF27F5AAE7A6505B96797@KL1010XG.cs.ad.klmcorp.net>
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

Hi,
We had similar problem last year using sles9 and SVC 4.2.0.2,  as you des=
cribe: adding/deleting a LUN causes brief path failures for the host's re=
maining, unaffected LUNs.

We were using tur checker and it turned out that while adding/deleting a =
LUN (and some other admin tasks) the SVC does not respond well to test-un=
it-ready tur requests; but it responds perfectly well to normal read comm=
ands. I opened IBM PMR 43118 on that if you want to ask the SVC folks abo=
ut it. =20

Workaround for us was to use readsector0 instead of  tur as multipath pat=
h checker.=20
=20
Recent post here (see July 8, 2008)  said multipath-tools is deprecating =
readsector0, and to use directio as path checker, but directio was said t=
o be much slower than tur, implying tur was better replacement than direc=
tio for readsector0.=20

Not sure what deprecating readsector0 means for us SVC users. =20

regards,
John



--------------------------------------------------------
This e-mail, including any attachments, may be confidential, privileged o=
r otherwise legally protected. It is intended only for the addressee. If =
you received this e-mail in error or from someone who was not authorized =
to send it to you, do not disseminate, copy or otherwise use this e-mail =
or its attachments.  Please notify the sender immediately by reply e-mail=
 and delete the e-mail from your system.


________________________________________

From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On=
 Behalf Of Vardaris, C - SPLXM
Sent: Tuesday, July 22, 2008 7:23 AM
To: dm-devel@redhat.com
Subject: [dm-devel] Losing paths

To all,

Is it normal DM behavior that we are (temporary) losing paths from 'unaff=
ected' LUN's when we unmap a SAN LUN from the storage side.
We are using an IBM SVC (4.2.1) and RH AS 4.6. We are using the multipath=
.conf file supplied by IBM for the SVC.

It's normal that you loose the paths of the LUN which you unmap (4 paths =
in our case), but why we are also losing paths from 'unaffected' LUN's.
Unmapping a LUN is not a normal storage admin action but could happen acc=
identally.
We also see the same behavior when we give a new LUN to the Linux server.=
 The minute we map the LUN, paths from other LUN's are temporarily disapp=
earing.

We tried several settings/HBA firmware etc. but can not eliminate this be=
havior of DM.


Jul  2 13:36:54 kl1108ju multipathd: 65:176: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 65:176 in map 36=
0050768018180a4f8000000000001d2
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d2: r=
emaining active paths: 3
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 65:176.
Jul  2 13:36:54 kl1108ju multipathd: 65:192: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 65:192 in map 36=
0050768018180a4f8000000000001d3
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3: r=
emaining active paths: 3
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 65:192.
Jul  2 13:36:54 kl1108ju multipathd: 65:208: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 65:208 in map 36=
0050768018180a4f800000000000354
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f800000000000354: r=
emaining active paths: 3
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 65:208.
Jul  2 13:36:54 kl1108ju multipathd: 65:240: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 65:240 in map 36=
0050768018180a4f8000000000001d1
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 65:240.
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d1: r=
emaining active paths: 3
Jul  2 13:36:54 kl1108ju multipathd: 67:0: tur checker reports path is do=
wn
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:0 in map 3600=
50768018180a4f8000000000001d0
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:0.
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d0: r=
emaining active paths: 3
Jul  2 13:36:54 kl1108ju multipathd: 67:32: tur checker reports path is d=
own
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:32 in map 360=
050768018180a4f8000000000001ce
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:32.
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001ce: r=
emaining active paths: 3
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:48.
Jul  2 13:36:54 kl1108ju multipathd: 67:48: tur checker reports path is d=
own
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:64.
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:48 in map 360=
050768018180a4f8000000000001d2
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:80.
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d2: r=
emaining active paths: 2
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:96.
Jul  2 13:36:54 kl1108ju multipathd: 67:64: tur checker reports path is d=
own
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:112.
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:64 in map 360=
050768018180a4f8000000000001d3
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:128.
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3: r=
emaining active paths: 2
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:160.
Jul  2 13:36:54 kl1108ju multipathd: 67:80: tur checker reports path is d=
own
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:176.
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:80 in map 360=
050768018180a4f800000000000354
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:192.
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f800000000000354: r=
emaining active paths: 2
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:208.
Jul  2 13:36:54 kl1108ju multipathd: 67:96: tur checker reports path is d=
own
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:224.
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:96 in map 360=
050768018180a4f8000000000001d4
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 67:240.
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d4: r=
emaining active paths: 3
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 65:0.
Jul  2 13:36:54 kl1108ju multipathd: 67:112: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 65:32.
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:112 in map 36=
0050768018180a4f8000000000001d1
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 65:48.
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d1: r=
emaining active paths: 2
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 65:64.
Jul  2 13:36:54 kl1108ju multipathd: 67:128: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 65:80.
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:128 in map 36=
0050768018180a4f8000000000001d0
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 65:96.
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d0: r=
emaining active paths: 2
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 65:112.
Jul  2 13:36:54 kl1108ju multipathd: 67:160: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju kernel: device-mapper: dm-multipath: Failing pat=
h 65:128.
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:160 in map 36=
0050768018180a4f8000000000001ce
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001ce: r=
emaining active paths: 2
Jul  2 13:36:54 kl1108ju multipathd: 67:176: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:176 in map 36=
0050768018180a4f8000000000001d2
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d2: r=
emaining active paths: 1
Jul  2 13:36:54 kl1108ju multipathd: 67:192: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:192 in map 36=
0050768018180a4f8000000000001d3
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3: r=
emaining active paths: 1
Jul  2 13:36:54 kl1108ju multipathd: 67:208: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:208 in map 36=
0050768018180a4f800000000000354
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f800000000000354: r=
emaining active paths: 1
Jul  2 13:36:54 kl1108ju multipathd: 67:224: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:224 in map 36=
0050768018180a4f8000000000001d4
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d4: r=
emaining active paths: 2
Jul  2 13:36:54 kl1108ju multipathd: 67:240: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 67:240 in map 36=
0050768018180a4f8000000000001d1
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d1: r=
emaining active paths: 1
Jul  2 13:36:54 kl1108ju multipathd: 65:0: tur checker reports path is do=
wn
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 65:0 in map 3600=
50768018180a4f8000000000001d0
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d0: r=
emaining active paths: 1
Jul  2 13:36:54 kl1108ju multipathd: 65:32: tur checker reports path is d=
own
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 65:32 in map 360=
050768018180a4f8000000000001ce
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001ce: r=
emaining active paths: 1
Jul  2 13:36:54 kl1108ju multipathd: 65:48: tur checker reports path is d=
own
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 65:48 in map 360=
050768018180a4f8000000000001d2
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d2: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d2: r=
emaining active paths: 0
Jul  2 13:36:54 kl1108ju multipathd: 65:64: tur checker reports path is d=
own
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 65:64 in map 360=
050768018180a4f8000000000001d3
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3: r=
emaining active paths: 0
Jul  2 13:36:54 kl1108ju multipathd: 65:80: tur checker reports path is d=
own
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 65:80 in map 360=
050768018180a4f800000000000354
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f800000000000354: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f800000000000354: r=
emaining active paths: 0
Jul  2 13:36:54 kl1108ju multipathd: 65:96: tur checker reports path is d=
own
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 65:96 in map 360=
050768018180a4f8000000000001d4
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d4: r=
emaining active paths: 1
Jul  2 13:36:54 kl1108ju multipathd: 65:112: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 65:112 in map 36=
0050768018180a4f8000000000001d1
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d1: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d1: r=
emaining active paths: 0
Jul  2 13:36:54 kl1108ju multipathd: 65:128: tur checker reports path is =
down
Jul  2 13:36:54 kl1108ju multipathd: checker failed path 65:128 in map 36=
0050768018180a4f8000000000001d0
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d0: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d0: r=
emaining active paths: 0
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d2: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d2: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d3: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f800000000000354: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f800000000000354: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d0: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d0: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d1: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:54 kl1108ju multipathd: 360050768018180a4f8000000000001d1: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:36:55 kl1108ju multipathd: 360050768018180a4f8000000000001d0: E=
ntering recovery mode: max_retries=3D5
Jul  2 13:37:24 kl1108ju multipathd: 65:176: tur checker reports path is =
up
Jul  2 13:37:24 kl1108ju multipathd: 65:176: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d2: q=
ueue_if_no_path enabled
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d2: R=
ecovered to normal mode
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d2: r=
emaining active paths: 1
Jul  2 13:37:24 kl1108ju multipathd: 65:192: tur checker reports path is =
up
Jul  2 13:37:24 kl1108ju multipathd: 65:192: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3: q=
ueue_if_no_path enabled
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3: R=
ecovered to normal mode
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3: r=
emaining active paths: 1
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3: s=
witch to path group #2
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3: s=
witch to path group #2
Jul  2 13:37:24 kl1108ju multipathd: 65:208: tur checker reports path is =
up
Jul  2 13:37:24 kl1108ju multipathd: 65:208: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: q=
ueue_if_no_path enabled
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: R=
ecovered to normal mode
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: r=
emaining active paths: 1
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: s=
witch to path group #2
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: s=
witch to path group #2
Jul  2 13:37:24 kl1108ju multipathd: 65:240: tur checker reports path is =
up
Jul  2 13:37:24 kl1108ju multipathd: 65:240: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: q=
ueue_if_no_path enabled
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: R=
ecovered to normal mode
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: r=
emaining active paths: 1
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: s=
witch to path group #2
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: s=
witch to path group #2
Jul  2 13:37:24 kl1108ju multipathd: 67:0: tur checker reports path is up
Jul  2 13:37:24 kl1108ju multipathd: 67:0: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d0: q=
ueue_if_no_path enabled
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d0: R=
ecovered to normal mode
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d0: r=
emaining active paths: 1
Jul  2 13:37:24 kl1108ju multipathd: 67:32: tur checker reports path is u=
p
Jul  2 13:37:24 kl1108ju multipathd: 67:32: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001ce: r=
emaining active paths: 2
Jul  2 13:37:24 kl1108ju multipathd: 67:48: tur checker reports path is u=
p
Jul  2 13:37:24 kl1108ju multipathd: 67:48: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d2: r=
emaining active paths: 2
Jul  2 13:37:24 kl1108ju multipathd: 67:64: tur checker reports path is u=
p
Jul  2 13:37:24 kl1108ju multipathd: 67:64: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3: r=
emaining active paths: 2
Jul  2 13:37:24 kl1108ju multipathd: 67:80: tur checker reports path is u=
p
Jul  2 13:37:24 kl1108ju multipathd: 67:80: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: r=
emaining active paths: 2
Jul  2 13:37:24 kl1108ju multipathd: 67:96: tur checker reports path is u=
p
Jul  2 13:37:24 kl1108ju multipathd: 67:96: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d4: r=
emaining active paths: 2
Jul  2 13:37:24 kl1108ju multipathd: 67:112: tur checker reports path is =
up
Jul  2 13:37:24 kl1108ju multipathd: 67:112: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: r=
emaining active paths: 2
Jul  2 13:37:24 kl1108ju multipathd: 67:128: tur checker reports path is =
up
Jul  2 13:37:24 kl1108ju multipathd: 67:128: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d0: r=
emaining active paths: 2
Jul  2 13:37:24 kl1108ju multipathd: 67:160: tur checker reports path is =
up
Jul  2 13:37:24 kl1108ju multipathd: 67:160: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001ce: r=
emaining active paths: 3
Jul  2 13:37:24 kl1108ju multipathd: 67:176: tur checker reports path is =
up
Jul  2 13:37:24 kl1108ju multipathd: 67:176: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d2: r=
emaining active paths: 3
Jul  2 13:37:24 kl1108ju multipathd: 67:192: tur checker reports path is =
up
Jul  2 13:37:24 kl1108ju multipathd: 67:192: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3: r=
emaining active paths: 3
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3: s=
witch to path group #1
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d3: s=
witch to path group #1
Jul  2 13:37:24 kl1108ju multipathd: 67:208: tur checker reports path is =
up
Jul  2 13:37:24 kl1108ju multipathd: 67:208: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: r=
emaining active paths: 3
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: s=
witch to path group #1
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f800000000000354: s=
witch to path group #1
Jul  2 13:37:24 kl1108ju multipathd: 67:224: tur checker reports path is =
up
Jul  2 13:37:24 kl1108ju multipathd: 67:224: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d4: r=
emaining active paths: 3
Jul  2 13:37:24 kl1108ju multipathd: 67:240: tur checker reports path is =
up
Jul  2 13:37:24 kl1108ju multipathd: 67:240: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: r=
emaining active paths: 3
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: s=
witch to path group #1
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d1: s=
witch to path group #1
Jul  2 13:37:24 kl1108ju multipathd: 65:0: tur checker reports path is up
Jul  2 13:37:24 kl1108ju multipathd: 65:0: reinstated
Jul  2 13:37:24 kl1108ju multipathd: 360050768018180a4f8000000000001d0: r=
emaining active paths: 3
Jul  2 13:37:25 kl1108ju multipathd: 65:32: tur checker reports path is u=
p
Jul  2 13:37:25 kl1108ju multipathd: 65:32: reinstated
Jul  2 13:37:25 kl1108ju multipathd: 360050768018180a4f8000000000001ce: r=
emaining active paths: 4
Jul  2 13:37:25 kl1108ju multipathd: 65:48: tur checker reports path is u=
p
Jul  2 13:37:25 kl1108ju multipathd: 65:48: reinstated
Jul  2 13:37:25 kl1108ju multipathd: 360050768018180a4f8000000000001d2: r=
emaining active paths: 4
Jul  2 13:37:25 kl1108ju multipathd: 65:64: tur checker reports path is u=
p
Jul  2 13:37:25 kl1108ju multipathd: 65:64: reinstated
Jul  2 13:37:25 kl1108ju multipathd: 360050768018180a4f8000000000001d3: r=
emaining active paths: 4
Jul  2 13:37:25 kl1108ju multipathd: 65:80: tur checker reports path is u=
p
Jul  2 13:37:25 kl1108ju multipathd: 65:80: reinstated
Jul  2 13:37:25 kl1108ju multipathd: 360050768018180a4f800000000000354: r=
emaining active paths: 4
Jul  2 13:37:25 kl1108ju multipathd: 65:96: tur checker reports path is u=
p
Jul  2 13:37:25 kl1108ju multipathd: 65:96: reinstated
Jul  2 13:37:25 kl1108ju multipathd: 360050768018180a4f8000000000001d4: r=
emaining active paths: 4
Jul  2 13:37:25 kl1108ju multipathd: 65:112: tur checker reports path is =
up
Jul  2 13:37:25 kl1108ju multipathd: 65:112: reinstated
Jul  2 13:37:25 kl1108ju multipathd: 360050768018180a4f8000000000001d1: r=
emaining active paths: 4
Jul  2 13:37:25 kl1108ju multipathd: 65:128: tur checker reports path is =
up
Jul  2 13:37:25 kl1108ju multipathd: 65:128: reinstated

=20
Kind regards,
Chris
