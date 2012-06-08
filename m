From: Hannes Reinecke <hare@suse.de>
Subject: Re: different LUN numbers under the same dm device
Date: Fri, 08 Jun 2012 08:37:52 +0200
Message-ID: <4FD19DC0.2030705@suse.de>
References: <8DCD6D08-35CE-48CC-AC54-7436265C32CB@purestorage.com>
	<20120606203507.GC16432@redhat.com>
	<A1C07741-D139-45F5-A877-A5E5DC792AD3@purestorage.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <A1C07741-D139-45F5-A877-A5E5DC792AD3@purestorage.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Brian Bunker <brian@purestorage.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 06/06/2012 10:59 PM, Brian Bunker wrote:
> Mike,
> =

> The devices for LUN 12 are failed and correspond to LUN's not currently s=
hared
> to the initiator at all. They were at one point and were likely
used by dm-11
> for its underlying paths. The inquiry data of those LUN's when the
problem happened was like this:
> =

> [root@r13init32 ~]# sg_inq /dev/sde
> standard INQUIRY: [qualifier indicates no connected LU]
>   PQual=3D1  Device_type=3D31  RMB=3D0  version=3D0x06  [SPC-4]
>   [AERC=3D0]  [TrmTsk=3D0]  NormACA=3D0  HiSUP=3D0  Resp_data_format=3D2
>   SCCS=3D0  ACC=3D0  TPGS=3D0  3PC=3D0  Protect=3D0  BQue=3D0
>   EncServ=3D0  MultiP=3D1 (VS=3D0)  [MChngr=3D0]  [ACKREQQ=3D0]  Addr16=
=3D0
>   [RelAdr=3D0]  WBus16=3D0  Sync=3D0  Linked=3D0  [TranDis=3D0]  CmdQue=
=3D1
>   [SPI: Clocking=3D0x0  QAS=3D0  IUS=3D0]
>     length=3D96 (0x60)   Peripheral device type: no physical device on th=
is lu
>  Vendor identification: PURE    =

>  Product identification: FlashArray      =

>  Product revision level: 100 =

> =

> There is no NAA number, page code 0x83 or LUN serial number available, pa=
ge code 0x80
> since there is no LUN 12 attached as a disk device at the time
multipath -ll was run.
> Different LUN's from our array would ever have the same NAA value,
what I think you are calling UUID.
> =

Yep. Hmm. So the devices are unmapped from the storage, but still
visible from the initiator?
Have you run 'rescan-scsi-bus.sh -r' here?
That should clean up these devices.

> The sequence is something like share a LUN from the array with two paths =
to
> the initiator, a dm device gets created presumably like this at
first (except
> that the status would be active and ready and not failed and faulty:
> =

>   3624a93700a14254d729923840001000b dm-11 PURE,FlashArray
>   size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
>    `-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
>    |- 1:0:0:12 sde  8:64   failed faulty running
>    |- 0:0:0:12 sdd  8:48   failed faulty running
> =

> Then that LUN 12 is taken away from the initiator and the dm device dm-11=
 is
> reused later by LUN 10 when it is shared to the initiator, but the
LUN 12
> devices still remain as part of the dm device. Then I would expect:
> =

>  3624a93700a14254d729923840001000b dm-11 PURE,FlashArray
>  size=3D500G features=3D'0' hwhandler=3D'0' wp=3Drw
>  `-+- policy=3D'round-robin 0' prio=3D1 status=3Dactive
>    |- 0:0:0:10 sdar 66:176 active ready  running
>    !- 1:0:0:10 sdba 67:64  active ready  running
> =


Yeah, but still: it means that at one point LUN 12 had the same NAA
value than LUN 10, correct?
It _might_ happen that multipath created a dm-device for LUN12, set
them to 'faulty' during unsharing, and then added the then-new LUN10
to the same device, given that the NAA number is identical.

So the point still stands: LUN10 must have had the same NAA value
than LUN12 now has.
So unless the original LUN10 referred to the same storage entity as
LUN12 now does, this is a definite no-no.
And if it does, we're pretty much in the clear, as then LUN10 would
now refer to a stale device (with status 'failed faulty'), and
should be cleared up with 'rescan-scsi-bus.sh -r'.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
