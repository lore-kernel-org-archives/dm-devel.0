From: Hannes Reinecke <hare@suse.de>
Subject: Re: multibus / failover and EMC CX600
Date: Thu, 18 Oct 2007 09:12:44 +0200
Message-ID: <20071018071244.GB22562@pentland.suse.de>
References: <066001c810cc$cd9f6f90$0a00a8c0@ALDI2>
	<20071018061907.GA22562@pentland.suse.de>
	<06cf01c81153$eca36c70$0a00a8c0@ALDI2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <06cf01c81153$eca36c70$0a00a8c0@ALDI2>
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

On Thu, Oct 18, 2007 at 08:55:52AM +0200, Gerald Nowitzky wrote:
> Hannes,
>=20
> so is this behavior by design? In this case, patching in the scsi subsy=
stem won't
> help to much, will it?
>
No, not really.
=20
> Manually updating the multipath information - well, yes, that will work=
 I guess,
> but in the end that should work without manual intervention. Thus, I'd =
need to have
> a job checking the multipath table if there are stale devices, and, if =
there are,
> rerun multipath to get them out. Not exactly smooth, is it?
>
Why, we do have interns for this kind of work :-)

No, really: Normally this should be done by multipathd / udev. With the m=
ainline
multipathd it reads from the kernel netlink socket and will get a uevent =
if
a device is removed. And it should update the tables accordingly.

There have been problems with device-mapper itself (older versions requir=
ed to
flush all outstanding I/O before the table could be modified), but that s=
hould
be resolved by now.

So maybe have multipathd running in verbose mode (ie -v 6 or somesuch) an=
d see
what's going on. Especially why it isn't updating the device-mapper table=
s.

BTW, which distribution are you running? multipath & udev seem to be a tr=
icky
area for most.

Not ours, of course :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
