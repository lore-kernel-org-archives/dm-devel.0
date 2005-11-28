From: "goggin, edward" <egoggin@emc.com>
Subject: proposed changes to multipath-tools
Date: Mon, 28 Nov 2005 11:06:14 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321AE45@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Christophe and I have re-designed the multipath-tools package to enable
multipathd(8) to be self sufficient without multipath(8).

Design Change :
===============
multipathd(8) now configures paths/devices directly in response to
uevent or UNIX domain socket driven path addition/removal and mapped
device addition/removal/rename external events without requiring
a hotplug invocation of multipath(8) or any other executable/shell
to accomplish these tasks.

Rationale :
===========
This design approach is more efficient than the previous one
involving hotplug invocation of multipath since 

(1) it does not involve fork&exec

(2) it does not require that a host's entire multipath path state be
    reconstructed upon the occurrence of each event

(3) this design approach will eventually lead to the elimination of
    the file based path cache currently used by multipath(8) to
    improve the response time of frequent path management invocations

(4) since this design approach consolidates multipath state management,
    synchronization of updates to the multipath configuration become
    more easily achievable

(5) multipathd(8) is now able to respond effectively to the hotplug
    removal (restoration) of failed (reactivated) paths to SCSI
    logical units initiated by the common SCSI transport classes
    (fiber channel, iSCSI) introduced at or about the 2.6.13 kernel

Consequences for users and packagers :
======================================
As part of this effort, a significant amount of code previously
private to either the multipath(8) or multipathd(8) executables
has been moved to libmultipath where it is easily sharable between
both executables.  Although multipath(8) will continue to be
capable of setting up the multipath configuration (particularly
during early boot), its use to perform multipath configuration
duties beyond early boot is no longer required.

While these changes will likely be first introduced in version
0.4.7 of multipath-tools, at least the functionality for multipathd(8)
to be responsive to the externally initiated renaming of a multipath
mapped device is dependent on a kernel patch which is likely
destined for 2.6.15.

Also, please remember that while the invocation of multipath(8) via
hotplug is no longer necessary (or desirable at this point), the
hotplug invocation of kpartx(8) is desirable.  To affect this, please
do not remove the multipath udev rules file at
/etc/udev/rules.d/multipath.rules, but instead simply comment out
the invocation of multipath(8) upon the occurrence of a hotplug add
event for a target device.

Near-term plans :
=================
Continue enhancing multipath-tools to

(1) broaden the capability to selectively update the components of
    a multipath map

(2) enhance the capabilities of the multipathd(8) client interface.

An improvement in the first category is the configuration support for
adding/removing/changing any component of a multipath map, particularly
adding/removing a single path or path group, to a multipath map without
having to reload a new map and changing multipathd to take advantage
of this new support.  Much of this work will require commensurate
kernel changes to the multipath target driver.  An improvement in
the second category is the enhancement of both the "list paths" and
"list maps" multipathd(8) client commands to have "at least" the
capability of a "multipath -l" display.

Longer-term plans :
===================
Adapt multipath-tools to utilize whatever new device mapper event
mechanism and/or configuration passing mechanism gets implemented
with the goal of having multipathd be capable of 

(1) selectively updating either the contents or status of any
component of a multipath map

(2) being alerted via a kernel generated event whenever either any
component of the map is changed or the status of any map component
changes.
