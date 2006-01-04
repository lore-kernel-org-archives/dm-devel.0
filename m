From: Dieter Zuleger <dzuleger@web.de>
Subject: Mixed Mode Raid!
Date: Wed, 04 Jan 2006 20:37:16 +0100
Message-ID: <302809469@web.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
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

Hi,
Silicon Image=B4s Raid-Controller like the 3132 or 3114 support a certain=
 mixed-mode raid, like
Intels matrix raid of the ich6 oer ich7. For example, I use two Maxtor 6V=
300F0 on a Silicon Image 3132 pcie-raid-card. With Silicons sataraid5-too=
l within windows xp I created on the first 160Gb of each disk a raid0-arr=
ay and on the remaining 120Gb of each disk a raid1-array. I can use it wi=
th windows but dmraid-1.0.0.rc9 discovers only the first raid array.
dmraid -s -vvv
WARN: locking /var/lock/dmraid/.lock
NOTICE: skipping removable device /dev/hdd
NOTICE: skipping removable device /dev/hdc
NOTICE: skipping removable device /dev/hda
NOTICE: /dev/sda: hpt37x discovering
NOTICE: /dev/sda: hpt45x discovering
NOTICE: /dev/sda: isw    discovering
NOTICE: /dev/sda: lsi    discovering
NOTICE: /dev/sda: nvidia discovering
NOTICE: /dev/sda: pdc    discovering
NOTICE: /dev/sda: sil    discovering
NOTICE: /dev/sda: via    discovering
NOTICE: /dev/sdb: hpt37x discovering
NOTICE: /dev/sdb: hpt45x discovering
NOTICE: /dev/sdb: isw    discovering
NOTICE: /dev/sdb: lsi    discovering
NOTICE: /dev/sdb: nvidia discovering
NOTICE: /dev/sdb: pdc    discovering
NOTICE: /dev/sdb: sil    discovering
NOTICE: /dev/sdb: via    discovering
NOTICE: /dev/sdc: hpt37x discovering
NOTICE: /dev/sdc: hpt45x discovering
NOTICE: /dev/sdc: isw    discovering
NOTICE: /dev/sdc: lsi    discovering
NOTICE: /dev/sdc: nvidia discovering
NOTICE: /dev/sdc: pdc    discovering
NOTICE: /dev/sdc: sil    discovering
NOTICE: sil: areas 1,2,3,4[4] are valid
NOTICE: /dev/sdc: sil metadata discovered
NOTICE: /dev/sdc: via    discovering
NOTICE: /dev/sdd: hpt37x discovering
NOTICE: /dev/sdd: hpt45x discovering
NOTICE: /dev/sdd: isw    discovering
NOTICE: /dev/sdd: lsi    discovering
NOTICE: /dev/sdd: nvidia discovering
NOTICE: /dev/sdd: pdc    discovering
NOTICE: /dev/sdd: sil    discovering
NOTICE: sil: areas 1,2,3,4[4] are valid
NOTICE: /dev/sdd: sil metadata discovered
NOTICE: /dev/sdd: via    discovering
NOTICE: added /dev/sdc to RAID set "sil_afbieacedhaj"
NOTICE: added /dev/sdd to RAID set "sil_afbieacedhaj"
*** Active Set
name   : sil_afbieacedhaj
size   : 671088640
stride : 128
type   : stripe
status : ok
subsets: 0
devs   : 2
spares : 0
WARN: unlocking /var/lock/dmraid/.lock

I think its a nice feature. Any clues to make it discover?
______________________________________________________________
Verschicken Sie romantische, coole und witzige Bilder per SMS!
Jetzt bei WEB.DE FreeMail: http://f.web.de/?mc=3D021193
