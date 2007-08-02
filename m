From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.4.8
Date: Fri, 03 Aug 2007 00:27:05 +0200
Message-ID: <1186093625.20108.69.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

Hello,

here goes multipath-tools-0.4.8.

Well, a year after the last release, let's see what changed in the
multipath tools package.

Changes that may require your altering your config file :

* seed cciss multipathing support for recent MSA hardware : warning, the
cciss blacklist is not hardcoded anymore. Proliant owners should add it
to your config file if you don't want surprises.
* pp_sgi renamed to pp_rdac : no behaviour change otherwise
* Add "^dcssblk[0-9]*" to default blacklist
* Directio is now the default checker
* Move id callouts to standardized /lib/udev
* Adopt Suse udev rules
* Add path group timeout handling (pg_timeout keyword)
* Add blacklist exceptions
* Almost every vendor updated the internal defaults for their hardware
("show config" cli command is your friend)
* We support matching by SCSI revision now, in addition to Vendor and
Product. No rev specified means all rev matches.
* Blacklist entries and other strings in the config file are true
regular expressions, not shell expansion syntax

Features :

* prio: add a prioritizer for HP storageworks arrays
* prio: add a prioritizer for HDS modular arrays
* checkers: asynchronous checker framework. Directio is the first and
only user. Means no more checking loop blocking (while holding lock the
cli tries to acquire for example).
* checkers: EMC checker support for ALUA EMC arrays
* checkers: add RDAC path checker
* lib: pick up existing alias (if any) from current dm config
* cli: add syntax auto-completion
* cli: new command, show blacklist
* doc: More man pages
* kpartx: handling for SUN partition tables
* kpartx: c-slice handling for BSD partition tables
* kpartx: handling for extended partitions
* kpartx: accept /dev/dm-* as arg

Fixes :

* checkers: add a timeout to SG_IO ioctls
* checkers: read buffer size bumped to 4096 bytes (Infiniband)
* checkers: handling CLARiiON I/O to inactive snapshot logical units
* lib: support newer kernels sysfs layout (remove libsysfs dependency)
* lib: we keep stale paths in multipaths in case they get back online,
but multipathd had trouble dealing with device name change in this
situation : fixed
* lib: listen events from udev socket instead of netlink : proper
serialization allows to remove wait_for_devnode_appearance() hacks
* lib: fix user_friendly_names race leading to a mpathX being served
multiple times
* lib: fix bug limiting to <8 paths luns
* lib: don't discard paths with large uuid
* lib: don't segfault when no config file
* kpartx: large file support
* kpartx: fix partition calculations of DASD partitions
* prio: fix ALUA for minor >256

Developers changes :

* checkers: Checkers attached to different paths of a same multipath can
share information through a context pointer in "struct multipath"
* lib: use DM uuid "mpath-" prefix
* kpartx: use DM uuid "part%d-" prefix


As usual, doc and download at :
http://christophe.varoqui.free.fr/

Archive mirror at ftp://sources.redhat.com/pub/dm/multipath-tools/

Regards,
cvaroqui
