From: "goggin, edward" <egoggin@emc.com>
Subject: Re: path priority group and path state
Date: Tue, 22 Feb 2005 17:59:08 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321A7C4@SRMANNING.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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

On Mon, 14 Feb 2005 23:28:55 +0100, Christophe Varoqui wrote

...

> >As much as is reasonably possible, I would like to always know which
> >path priority group will be used by the next I/O -- even when none of
> >the priority groups have been initialized and therefore all of them
> >have an "enabled" path priority group state.  Looks like "first" will
> >tell me that, but it is not updated on "multipath -l".
>
>  
>
>Not updated ? Can you elaborate ?
>To me, this info is fetched in the map table string upon each exec ...

I'm sorry for the confusion.  I wasn't very clear at all.

When the active path group of an active/passive array is changed
external to multipath (either a SAN utility or multipath running
on a different node in a multi-node cluster), sometimes the wrong
path group is shown to be "active" and sometimes both multipath
priority groups are shown as "enabled".  I think the former
condition occurs between the time the active path group is changed
externally and the time of the first block I/O to the multipath
mapped device.  I think the latter condition occurs between the
time multipath changes the active group back to the highest priority
path group and the first block I/O to the multipath mapped device.

I think that the former condition could be addressed by validating
with the storage array that the highest priority path group is
actually the current active path group whenever path health is
checked.  Yet, if they are different, it is not always clear that
the right thing to do is to trespass back to the highest priority
group. 

I think the latter condition could be addressed by always initializing
a multipath path group immediately whenever the path group is either
initially setup or changed instead of waiting for the first block i/o. 


> There can be room for improvement in responsiveness anyway. 
> Caching the 
> uids for example, but there you loose on uid changes 
> detection, lacking 
> an event-driven detection for that.
> If you have suggestion, please post them.
> 

My suggestion is based on (1) periodic testing of physical paths not
logical ones, (2) immediately placing all logical paths associated
with failed physical components into a bypassed state whether the
failure was detected by i/o failure or path test, (3) prioritizing
the testing of bypassed paths, and (4) failing logical paths which
fail path tests.  For SCSI, a physical path would be defined as a
unique combination of initiator and target.  These components would
need to be identified and associated with all of the logical paths
(LU specific) which utilize the component.

A similar approach can also be taken to improve the responsiveness to
the restoration of physical path components.

> >I'm just wondering if multipathd could invoke multipath to fail paths
> >from user space in addition to reinstating them?  Seems like both
> >multipathd/main.c:checkerloop() and 
> multipath/main.c:/reinstate_paths()
> >will only initiate a kernel path state transition from 
> PSTATE_FAILED to
> >PSTATE_ACTIVE but not the other way around.  The state 
> transition from
> >PSTATE_ACTIVE to PSTATE_FAILED requires a failed I/O since this state
> >is initiated only from the kernel code itself in the event of an I/O
> >failure on a multipath target device.
> >
> >One could expand this approach to proactively fail (and immediately
> >schedule for testing) all paths associated with common bus components
> >(for SCSI, initiator and/or target).  The goal being not 
> only to avoid
> >failing I/O for all but all-paths-down use cases, but to also avoid
> >long time-out driven delays and high path testing overhead for large
> >SANs in the process of doing so.
> >
> >  
> >
> It is commonly accepted those timouts are set to 0 in multipathed SAN.
> Have you experienced real problems here, or is it just a theory ?
>
 
Qlogic FC HBA people have long warned EMC PowerPath multipath developers
NOT to mess around with the timeout values of their SCSI commands.  As
a result we have been burdoned with 30-60 second SCSI command timeout
values for SCSI commands sent to multipathed devices in a SAN.
My understanding was that they needed this time in order to deal
convincingly with target-side FC disconnect failures.  Things may
certainly have changed to allow getting rid of this huge timeout,
though this is far from certain to me.

> I particularly fear the "proactively fail all paths associated to a 
> component", as this may lead to dramatic errors like : "I'm 
> so smart, I 
> failed all paths for this multipath, now the FS is remounted 
> read-only 
> but wait, in fact you can use this path as it is up after all"
>

One can deal with that concern by not actually failing these paths, but
putting them into a "bypassed" state whereby (1) they are skipped (similar
to how bypassed path groups are skipped) in all cases unless there are no
other path choices (instead of failing the i/o) and (2) each of these paths
are immediately scheduled for testing ahead of all others.  But since this
testing is done in user space, we would still need the capability to fail
these paths from user space once their failed state is verified through
path testing.  I am still not understanding your logic behind not wanting
to do that.
