From: "Caushik, Ramesh" <ramesh.caushik@intel.com>
Subject: RE: path priority group and path state
Date: Tue, 15 Feb 2005 09:59:52 -0800
Message-ID: <EA4DC661A6353747A2E5C0DE8792DDDE07CA9912@orsmsx404.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Given that some of the problems I am noticing in my testing relates to
mismatch between the path state recorded by the driver and the daemon, I
thought I will chime in with my questions / observations.
  =20
My setup consists of a dual port qla2312 controller connected to a JBOD
through a FC switch thus creating 2 paths A & B to the drive. I have all
the paths in one PG using round-robin selector and "queue if no path"
set. I run a bonnie++ transfer to the mounted drive, and then pull out
the path A connection. When the transfer switches to path B I reinsert A
and then after a little while pull out B and repeat this a few times.
Sometimes the transfer just hangs and the log messages indicate the
driver is queueing the i/o (both paths are marked faulty). This is what
seems to happen. When the cable on path  A is pulled out the controller
receives a "LOOP DOWN" on that port and ALSO a "LIP RESET" on path B.
This causes i/o on both paths to return SCSI error and so both paths are
set faulty (some of the in-flight i/o on path B fails as a result of the
LIP RESET). However when the daemon checker loop wakes up and tests the
path (via checkfn) path B returns OK, and since the daemon will
reconfigure the paths only if newstate !=3D oldstate it does not
reconfigure the path. As a result, we end up with a situation where the
driver marks path B as faulty due to i/o error in the path, and waits
for the daemon to reconfigure the path, while the daemon does not
reconfigure path B because the checkfn does not detect a state change.
First of all please tell me if this analyses is correct. If it is then
my suggestion is for the daemon checker loop to reinstate the path
anytime the there is a mismatch between the path state in the driver and
that returned by the checkfn, and not just based on the newstate !=3D
oldstate check. I am in the process of coding this up to see if it will
fix the problem. Meanwhile I would much appreciate any comments or
suggestions on this. Thanks,

Ramesh.

       =20
-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Christophe Varoqui
Sent: Monday, February 14, 2005 2:29 PM
To: device-mapper development
Subject: Re: [dm-devel] path priority group and path state

goggin, edward wrote:

>On Sat, 12 Feb 2005 11:23:50 +0100 Christophe Varoqui wrote:
> =20
>
>>>The multipath utility is relying on having at least one block
>>>read/write I/O be serviced through a multipath mapped
>>>device in order to show one of the path priority groups in
>>>an active state.  While I can see the semantic correctness
>>>in this claim since the priority group is not yet initialized,
>>>is this what is intended?=20
>>>
>>>     =20
>>>
>>In fact, the multipath tool shares the same checker with the daemon.
>>
>>It is intended the tool doesn't rely on the path status the=20
>>daemon could=20
>>provide, because, the check interval being what it is, we=20
>>can't assume=20
>>the daemon path status are an accurate representation of the current=20
>>reality. The tool being in charge to load new maps, I fear it=20
>>could load=20
>>erroneous ones if relying on outdated info.
>>
>>Maybe I'm paranoid, but I'm still convinced it's a safe bet to do so.
>>   =20
>>
>
>I see your approach -- wanting to avoid failing paths which previously
>failed a path test but are now in an active state.  Would the
inaccuracy
>be due to delays in the invocation of multipath from multipathd in the
>event of a failed path test? =20
>
0) multipath can be triggered upon checker events, yes, but also
1) on map events (paths failed by DM upon IO)
2) by hotplug/udev, upon device add/remove
3) by administrator

In any of these scenarii the daemon can have invalid path state info :

0) Say paths A, B, C form the multipath M. The daemon checker loop kicks

in, A is checked and shows a transition. multipath is executed for M=20
before B and C are re-checked. If their actual status have changed too,=20
and multipath asks the daemon about paths states, the daemon will answer

with the previous/obsolete states so the tool will factor a wrong map.

1) A path failed by the DM will show up as such in the map status=20
string, but it doesn't trigger an immediate checker loop run. So the=20
tool kicks in while the daemon holds obsolete path states : the tools=20
can't resonnably ask the daemon about path states there.

2) a device just added has no checker, no way the tool can ask for its=20
state there. The tool execution finishes by a signal sent to the daemon,

which rediscover paths and instantiate a new checker for the new path.

3) last but not least, if the admin take the pain to run the tool=20
himself, he's certainly out of trust for the daemon :)

There can be room for improvement in responsiveness anyway. Caching the=20
uids for example, but there you loose on uid changes detection, lacking=20
an event-driven detection for that.
If you have suggestion, please post them.

>Wouldn't multipath repeat the path test as
>part of discovering the SAN?  Wont there always be a non-zero time
delay
>between detecting a path failure (whether that be from a failed I/O in
>the kernel or a failed path test in user space) and actually updating
the
>multipath kernel state to reflect that failure where sometime during
that
>time period the path could actually be used again (it was physically
>restored) but it wont be after its path status is updated to failed?
>
>I see the real cost of not failing paths from path testing results but
>instead waiting for actual failed I/Os as a lack of responsiveness to
>path failures.
>
> =20
>
We can't fail paths in the secondary path group of an=20
assymetric-controler-driven multipathed LU, because I need those path=20
ready to take IO in case of a PG switch. That is, if you don't want to=20
impose the need of a hardware handler module for every assymetric=20
controlers out there.

>>>Why show both the single priority
>>>group of an active-active storage system using a multibus
>>>path grouping policy and the non-active priority group of an
>>>active-passive storage system using a priority path grouping
>>>policy both as "enabled" when the actual readiness of each
>>>differs quite significantly?
>>>=20
>>>
>>>     =20
>>>
>>We don't have so many choices there. The device mapper declares 3 PG=20
>>states : active, enabled, disabled.
>>How would you map these states upon the 2 scenarii you mention ?
>>
>>   =20
>>
>
>As much as is reasonably possible, I would like to always know which
>path priority group will be used by the next I/O -- even when none of
>the priority groups have been initialized and therefore all of them
>have an "enabled" path priority group state.  Looks like "first" will
>tell me that, but it is not updated on "multipath -l".
>
> =20
>
Not updated ? Can you elaborate ?
To me, this info is fetched in the map table string upon each exec ...

>>>Also, multipath will not set a path to a failed state until the
>>>first block read/write I/O to that path fails.  This approach
>>>can be misleading while monitoring path health via
>>>"multipath -l".  Why not have multipath(8) fail paths known to
>>>fail path testing?  Waiting instead for block I/O requests to
>>>fail lessens the responsiveness of the product to path failures.
>>>Also, the failed paths of enabled, but non-active path priority
>>>groups will not have their path state updated for possibly a
>>>very long time -- and this seems very misleading.
>>>
>>>=20
>>>
>>>     =20
>>>
>>Maybe I'm overseeing something, but to my knowledge=20
>>"multipath -l" gets=20
>>the paths status from devinfo.c, which in turn switches to=20
>>pp->checkfn()=20
>>... ie the same checker the daemon uses.
>>   =20
>>
>
>I'm just wondering if multipathd could invoke multipath to fail paths
>from user space in addition to reinstating them?  Seems like both
>multipathd/main.c:checkerloop() and multipath/main.c:/reinstate_paths()
>will only initiate a kernel path state transition from PSTATE_FAILED to
>PSTATE_ACTIVE but not the other way around.  The state transition from
>PSTATE_ACTIVE to PSTATE_FAILED requires a failed I/O since this state
>is initiated only from the kernel code itself in the event of an I/O
>failure on a multipath target device.
>
>One could expand this approach to proactively fail (and immediately
>schedule for testing) all paths associated with common bus components
>(for SCSI, initiator and/or target).  The goal being not only to avoid
>failing I/O for all but all-paths-down use cases, but to also avoid
>long time-out driven delays and high path testing overhead for large
>SANs in the process of doing so.
>
> =20
>
It is commonly accepted those timouts are set to 0 in multipathed SAN.
Have you experienced real problems here, or is it just a theory ?

I particularly fear the "proactively fail all paths associated to a=20
component", as this may lead to dramatic errors like : "I'm so smart, I=20
failed all paths for this multipath, now the FS is remounted read-only=20
but wait, in fact you can use this path as it is up after all"

Regards,
cvaroqui

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
