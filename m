From: "goggin, edward" <egoggin@emc.com>
Subject: RE: Adding/removing multi-pathed disk partitions
Date: Mon, 31 Jan 2005 09:05:57 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A733@SRMANNING.eng.emc.com>
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

> Some assumptions are not that clear to me, so let me confront them to
> your knowledge :
> 

I changed the meaningless subject line I used two days ago into
something meaningful.

> 1) A Logical Unit can change its H/B/T/L mapping.
> 1.1) H/B/T through LUN masking reconfiguration
> 1.2) L through a logical unit reconfiguration

I think there are lots of ways to change the association
between a kernel's SCSI mid-layer's scsi_device data
structure and the SCSI logical unit to which it corresponds
in an FC SAN, amongst them (1) switch zoning, (2) storage
system LUN masking, (2) storage System LUN re-configuration,
and (4) inadvertent re-cabling errors at initiators, switches,
or targets.

> 2) These topology changes can happen between two checks of 
> the affected path

Absoltuely.

> 3) No path failure is seen by the device mapper during the topology
> reconfiguration

This is my understanding, assuming no I/Os are directed to the unit
during this period of time.

> 4) Not failing or isolating the changed path from its 
> previous multipath
> map will lead to unrecoverable data corruption at the first submitted
> write IO routed through this path

I belive this to be true.

> 5) HBA drivers see the LU remapping events
>

The SCSI mid-layer should be seeing a UNIT_ATTENTION sense key
for all I/O directed to a SCSI logical unit with a "new" identity
before the UNIT_ATTENTION check condition is cleared.

> If all these assertions are legitimate, it might not be 
> enough to check
> uid changes at pathcheck interval.
>

I agree with all the assertions above.

Because the consequences of the problem are so severe, I was
advocating that the multipathing software detect this condition
if it can do so with reasonable means, even though the potential
for the problem cannot be fully elminated using these techniques.

I now agree with your suggestion below, that the problem is better
addressed at the SCSI mid-layer. 

> It would seem safer to let the HBA driver error the first IO 
> submitted to a 
> changed LU *and* send an event (maybe through a transport 
> class kobj) for
> userspace to reconfigure the maps.
>

I like your idea better.  You are attempting to solve the problem
at a lower level where it can more likely be fully addressed.

Looks like the SCSI mid-layer may be already doing __most__ of the
"right thing" - but (1) the right thing isn't happening for EMC CLARiion
or Symmetrix logical units (maybe other storage also) because they are
not being treated as "removable" units by the mid-layer and (2) there
Does not seem to be any refresh of the cached inquiry data
(vendor/model/rev) in the mid-layer's scsi_device data structure.
Not clear to me if these storage systems should be setting the RMB
bit of the standard inquiry reply (which CLARiion and Symmetrix are
not doing) or if the linux SCSI mid-layer should just be treating all
SAN storage units as removable units, independent of the state of this bit.

The SCSI mid-layer (scsi_io_completion()) detects a SCSI sense key of
UNIT_ATTENTION after most any attempt to access the SCSI logical unit
With the "new" identity for the first time.  As long as the logical unit
is viewed as "removable" media, the most of right thing happens, namely,
the I/O in question is failed and the device is marked to prevent any
further I/O.  Apparently calling check_disk_change() from the next
sd_open() will at least clear the changed field of the scsi_device,
thereby allowing I/O to the device.  But, the cached inquiry fields
are not updated (possibly via scsi_probe_lun()) to reflect the
possibly new device identity.

> Please comment abundantly.
> 
> regards,
> cvaroqui


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
