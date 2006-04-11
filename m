From: =?ISO-8859-1?Q?Roger_H=E5kansson?= <hson@ludd.luth.se>
Subject: Problems with multipathing
Date: Tue, 11 Apr 2006 20:10:54 +0200
Message-ID: <443BF12E.50900@ludd.luth.se>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

I'm trying to setup a couple of machines running CentOS 4.3 x86_64 using
disk from a SAN, but I can't get the multipathing to work properly.

The machines (three in total) all have two Emulex LP10000-M2 and thus
are using the lpfc-driver.

When I boot the machines the paths seem to be multipathed somewhat, if i
put a "multipath"-tag in /etc/multipath.conf with a specific alias
(yellow,red) for each wwid, those paths are mapped under /dev/mapper and
/dev/mpath.

But multipath -ll doesn't show what I expect (basically no mappings) and
if I do a multipath -F I can't get the mappings back without a reboot.

If I do a 'multipath -v3' directly after boot, this is what I get:
#
# all paths in cache :
#
3600d0230000000000b0191489a946601  1:0:2:0 sdb 8:16  [active][ready] IFT
    /
3600d0230000000000b0191489a946600  1:0:3:0 sdc 8:32  [active][ready] IFT
    /
3600d0230000000000b0191489a946601  2:0:2:0 sdd 8:48  [active][ready] IFT
    /
3600d0230000000000b0191489a946600  2:0:3:0 sde 8:64  [active][ready] IFT
    /
*blacklist*
===== path info sdb (mask 0x1f) =====
bus = 1
dev_t = 8:16
size = 204800000
vendor = IFT
product = A16F-R2221
rev = 347B
h:b:t:l = 1:0:2:0
tgt_node_name = 0x200000d0231b0191
serial = 0B0191489A946601
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
uid = 3600d0230000000000b0191489a946601 (cache)
===== path info sdc (mask 0x1f) =====
bus = 1
dev_t = 8:32
size = 409600000
vendor = IFT
product = A16F-R2221
rev = 347B
h:b:t:l = 1:0:3:0
tgt_node_name = 0x200000d0230b0191
serial = 0B0191489A946600
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
uid = 3600d0230000000000b0191489a946600 (cache)
===== path info sdd (mask 0x1f) =====
bus = 1
dev_t = 8:48
size = 204800000
vendor = IFT
product = A16F-R2221
rev = 347B
h:b:t:l = 2:0:2:0
tgt_node_name = 0x200000d0231b0191
serial = 0B0191489A946601
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
uid = 3600d0230000000000b0191489a946601 (cache)
===== path info sde (mask 0x1f) =====
bus = 1
dev_t = 8:64
size = 409600000
vendor = IFT
product = A16F-R2221
rev = 347B
h:b:t:l = 2:0:3:0
tgt_node_name = 0x200000d0230b0191
serial = 0B0191489A946600
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
uid = 3600d0230000000000b0191489a946600 (cache)
path sdf not found in pathvec

===== path info sdf (mask 0x1f) =====
bus = 1
dev_t = 8:80
sr0 blacklisted


After a 'multipath -F;multipath', 'multipath -v3' gives me this:
#
# all paths in cache :
#
3600d0230000000000b0191489a946601  1:0:2:0 sdb 8:16  [ready] IFT
/A16F-R22
3600d0230000000000b0191489a946600  1:0:3:0 sdc 8:32  [ready] IFT
/A16F-R22
3600d0230000000000b0191489a946601  2:0:2:0 sdd 8:48  [ready] IFT
/A16F-R22
3600d0230000000000b0191489a946600  2:0:3:0 sde 8:64  [ready] IFT
/A16F-R22
*blacklist*
===== path info sdb (mask 0x1f) =====
bus = 1
dev_t = 8:16
size = 204800000
vendor = IFT
product = A16F-R2221
rev = 347B
h:b:t:l = 1:0:2:0
tgt_node_name = 0x200000d0231b0191
serial = 0B0191489A946601
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
uid = 3600d0230000000000b0191489a946601 (cache)
===== path info sdc (mask 0x1f) =====
bus = 1
dev_t = 8:32
size = 409600000
vendor = IFT
product = A16F-R2221
rev = 347B
h:b:t:l = 1:0:3:0
tgt_node_name = 0x200000d0230b0191
serial = 0B0191489A946600
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
uid = 3600d0230000000000b0191489a946600 (cache)
===== path info sdd (mask 0x1f) =====
bus = 1
dev_t = 8:48
size = 204800000
vendor = IFT
product = A16F-R2221
rev = 347B
h:b:t:l = 2:0:2:0
tgt_node_name = 0x200000d0231b0191
serial = 0B0191489A946601
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
uid = 3600d0230000000000b0191489a946601 (cache)
===== path info sde (mask 0x1f) =====
bus = 1
dev_t = 8:64
size = 409600000
vendor = IFT
product = A16F-R2221
rev = 347B
h:b:t:l = 2:0:3:0
tgt_node_name = 0x200000d0230b0191
serial = 0B0191489A946600
path checker = readsector0 (internal default)
state = 2
getprio = /bin/true (internal default)
prio = 0
uid = 3600d0230000000000b0191489a946600 (cache)
path sdf not found in pathvec

===== path info sdf (mask 0x1f) =====
bus = 1
dev_t = 8:80
sr0 blacklisted


Running multipathd with -v4 doesn't give me any relevant output.


Anyone got a clue how to solve this problem?
