From: "Magni Fabrizio" <Fabrizio.Magni@rasnet.it>
Subject: Unable to use multipath with LVM2
Date: Sat, 30 Apr 2005 09:29:21 +0200
Message-ID: <BFCF159FFD14F444B205968F32DBD5BB01700358@MAILEX01.rasgroup.ita.localnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,
I'm new to multipath and I'm having an hard time configuring the one
shipped with my distribution. The version is "multipath v0.3.6".

If I insert aliases in multipath.conf and modify udev.rules I can see
symbolick links wichi can be used in failover or multibus (tested) but
they are not seen by the LVM2 (even modifying the filter in lvm.conf and
specifying "types").

When I try the out-of-the-box configuration I get links in my
/dev/block/by-id but they don't seen usable with multipath (applycation
die).

Any help on how I need to configure the multipath properly to work with
LVM2?

A multipath -v2 shows me the following:

#
# all paths :
#
1IBM_____2105____________70623125 (0 0 0 0) sda [ready ] (8:0) [2105800
]
1IBM_____2105____________70723125 (0 0 0 1) sdb [ready ] (8:16) [2105800
]
1IBM_____2105____________60623125 (0 0 0 2) sdc [ready ] (8:32) [2105800
]
1IBM_____2105____________60723125 (0 0 0 3) sdd [ready ] (8:48) [2105800
]
1IBM_____2105____________50123125 (0 0 0 4) sde [ready ] (8:64) [2105800
]
1IBM_____2105____________40423125 (0 0 0 5) sdf [ready ] (8:80) [2105800
]
1IBM_____2105____________30423125 (0 0 0 6) sdg [ready ] (8:96) [2105800
]
1IBM_____2105____________20423125 (0 0 0 7) sdh [ready ] (8:112)
[2105800         ]
1IBM_____2105____________01723125 (0 0 0 8) sdi [ready ] (8:128)
[2105800         ]
1IBM_____2105____________11423125 (0 0 0 9) sdj [ready ] (8:144)
[2105800         ]
1IBM_____2105____________01823125 (0 0 0 10) sdk [ready ] (8:160)
[2105800         ]
1IBM_____2105____________11523125 (0 0 0 11) sdl [ready ] (8:176)
[2105800         ]
1IBM_____2105____________70623125 (1 0 0 0) sdm [ready ] (8:192)
[2105800         ]
1IBM_____2105____________70723125 (1 0 0 1) sdn [ready ] (8:208)
[2105800         ]
1IBM_____2105____________60623125 (1 0 0 2) sdo [ready ] (8:224)
[2105800         ]
1IBM_____2105____________60723125 (1 0 0 3) sdp [ready ] (8:240)
[2105800         ]
1IBM_____2105____________50123125 (1 0 0 4) sdq [ready ] (65:0) [2105800
]
1IBM_____2105____________40423125 (1 0 0 5) sdr [ready ] (65:16)
[2105800         ]
1IBM_____2105____________30423125 (1 0 0 6) sds [ready ] (65:32)
[2105800         ]
1IBM_____2105____________20423125 (1 0 0 7) sdt [ready ] (65:48)
[2105800         ]
1IBM_____2105____________01723125 (1 0 0 8) sdu [ready ] (65:64)
[2105800         ]
1IBM_____2105____________11423125 (1 0 0 9) sdv [ready ] (65:80)
[2105800         ]
1IBM_____2105____________01823125 (1 0 0 10) sdw [ready ] (65:96)
[2105800         ]
1IBM_____2105____________11523125 (1 0 0 11) sdx [ready ] (65:112)
[2105800         ]
#
# all multipaths :
#
1IBM_____2105____________70623125 [2105800         ]
 \_(0 0 0 0) sda [ready ] (8:0)
 \_(1 0 0 0) sdm [ready ] (8:192)
1IBM_____2105____________70723125 [2105800         ]
 \_(0 0 0 1) sdb [ready ] (8:16)
 \_(1 0 0 1) sdn [ready ] (8:208)
1IBM_____2105____________60623125 [2105800         ]
 \_(0 0 0 2) sdc [ready ] (8:32)
 \_(1 0 0 2) sdo [ready ] (8:224)
1IBM_____2105____________60723125 [2105800         ]
 \_(0 0 0 3) sdd [ready ] (8:48)
 \_(1 0 0 3) sdp [ready ] (8:240)
1IBM_____2105____________50123125 [2105800         ]
 \_(0 0 0 4) sde [ready ] (8:64)
 \_(1 0 0 4) sdq [ready ] (65:0)
1IBM_____2105____________40423125 [2105800         ]
 \_(0 0 0 5) sdf [ready ] (8:80)
 \_(1 0 0 5) sdr [ready ] (65:16)
1IBM_____2105____________30423125 [2105800         ]
 \_(0 0 0 6) sdg [ready ] (8:96)
 \_(1 0 0 6) sds [ready ] (65:32)
1IBM_____2105____________20423125 [2105800         ]
 \_(0 0 0 7) sdh [ready ] (8:112)
 \_(1 0 0 7) sdt [ready ] (65:48)
1IBM_____2105____________01723125 [2105800         ]
 \_(0 0 0 8) sdi [ready ] (8:128)
 \_(1 0 0 8) sdu [ready ] (65:64)
1IBM_____2105____________11423125 [2105800         ]
 \_(0 0 0 9) sdj [ready ] (8:144)
 \_(1 0 0 9) sdv [ready ] (65:80)
1IBM_____2105____________01823125 [2105800         ]
 \_(0 0 0 10) sdk [ready ] (8:160)
 \_(1 0 0 10) sdw [ready ] (65:96)
1IBM_____2105____________11523125 [2105800         ]
 \_(0 0 0 11) sdl [ready ] (8:176)
 \_(1 0 0 11) sdx [ready ] (65:112)
#
# device maps :
#
create:1IBM_____2105____________70623125:0 78125056 multipath 2
round-robin 1 0 8:192 round-robin 1 0 8:0
create:1IBM_____2105____________70723125:0 78125056 multipath 2
round-robin 1 0 8:208 round-robin 1 0 8:16
create:1IBM_____2105____________60623125:0 78125056 multipath 2
round-robin 1 0 8:224 round-robin 1 0 8:32
create:1IBM_____2105____________60723125:0 78125056 multipath 2
round-robin 1 0 8:240 round-robin 1 0 8:48
create:1IBM_____2105____________50123125:0 78125056 multipath 2
round-robin 1 0 65:0 round-robin 1 0 8:64
create:1IBM_____2105____________40423125:0 78125056 multipath 2
round-robin 1 0 65:16 round-robin 1 0 8:80
create:1IBM_____2105____________30423125:0 78125056 multipath 2
round-robin 1 0 65:32 round-robin 1 0 8:96
create:1IBM_____2105____________20423125:0 78125056 multipath 2
round-robin 1 0 65:48 round-robin 1 0 8:112
create:1IBM_____2105____________01723125:0 78125056 multipath 2
round-robin 1 0 65:64 round-robin 1 0 8:128
create:1IBM_____2105____________11423125:0 78125056 multipath 2
round-robin 1 0 65:80 round-robin 1 0 8:144
create:1IBM_____2105____________01823125:0 78125056 multipath 2
round-robin 1 0 65:96 round-robin 1 0 8:160
create:1IBM_____2105____________11523125:0 78125056 multipath 2
round-robin 1 0 65:112 round-robin 1 0 8:176

and under /dev/disk/by-id/

total 8
drwxr-xr-x  2 root root 4096 Apr 29 11:56 .
drwxr-xr-x  4 root root 4096 Apr 29 11:56 ..
lrwxrwxrwx  1 root root    9 Apr 29 11:56 1IBM_2105_01723125 ->
../../sdi
lrwxrwxrwx  1 root root   10 Apr 29 11:56 1IBM_2105_01723125p1 ->
../../sdi1
lrwxrwxrwx  1 root root    9 Apr 29 11:56 1IBM_2105_01823125 ->
../../sdk
lrwxrwxrwx  1 root root   10 Apr 29 11:56 1IBM_2105_01823125p1 ->
../../sdk1
lrwxrwxrwx  1 root root    9 Apr 29 11:56 1IBM_2105_11423125 ->
../../sdj
lrwxrwxrwx  1 root root   10 Apr 29 11:56 1IBM_2105_11423125p1 ->
../../sdj1
lrwxrwxrwx  1 root root    9 Apr 29 11:56 1IBM_2105_11523125 ->
../../sdl
lrwxrwxrwx  1 root root   10 Apr 29 11:56 1IBM_2105_11523125p1 ->
../../sdl1
lrwxrwxrwx  1 root root    9 Apr 29 11:56 1IBM_2105_20423125 ->
../../sdh
lrwxrwxrwx  1 root root   10 Apr 29 11:56 1IBM_2105_20423125p1 ->
../../sdh1
lrwxrwxrwx  1 root root    9 Apr 29 11:56 1IBM_2105_30423125 ->
../../sdg
lrwxrwxrwx  1 root root   10 Apr 29 11:56 1IBM_2105_30423125p1 ->
../../sdg1
lrwxrwxrwx  1 root root    9 Apr 29 11:56 1IBM_2105_40423125 ->
../../sdf
lrwxrwxrwx  1 root root   10 Apr 29 11:56 1IBM_2105_40423125p1 ->
../../sdf1
lrwxrwxrwx  1 root root    9 Apr 29 11:56 1IBM_2105_50123125 ->
../../sde
lrwxrwxrwx  1 root root   10 Apr 29 11:56 1IBM_2105_50123125p1 ->
../../sde1
lrwxrwxrwx  1 root root    9 Apr 29 11:56 1IBM_2105_60623125 ->
../../sdc
lrwxrwxrwx  1 root root   10 Apr 29 11:56 1IBM_2105_60623125p1 ->
../../sdc1
lrwxrwxrwx  1 root root    9 Apr 29 11:56 1IBM_2105_60723125 ->
../../sdd
lrwxrwxrwx  1 root root   10 Apr 29 11:56 1IBM_2105_60723125p1 ->
../../sdd1
lrwxrwxrwx  1 root root    9 Apr 29 11:56 1IBM_2105_70623125 ->
../../sda
lrwxrwxrwx  1 root root   10 Apr 29 11:56 1IBM_2105_70623125p1 ->
../../sda1
lrwxrwxrwx  1 root root    9 Apr 29 11:56 1IBM_2105_70723125 ->
../../sdb
lrwxrwxrwx  1 root root   10 Apr 29 11:56 1IBM_2105_70723125p1 ->
../../sdb1

What devices should the LVM scan to use multipathed PVs?

Any hint?


Thank you
Fabrizio
