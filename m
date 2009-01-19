From: Hannes Reinecke <hare@suse.de>
Subject: Re: Could device-mapper offer multi-tier storage?
Date: Mon, 19 Jan 2009 17:01:06 +0100
Message-ID: <4974A3C2.3090509@suse.de>
References: <496E4063.5070502@nrel.colostate.edu>
	<D8A2BC50-9F46-4355-AF48-C83BC091F590@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D8A2BC50-9F46-4355-AF48-C83BC091F590@redhat.com>
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

Hi Jon et al,

Jonathan Brassow wrote:
> I wonder how much Heinz's replicator code could work with this...
>=20
> Heinz et al have a "remote replicator" target that 'logs' requests to a=
=20
> local device and then pushes them to remote devices.  I could imagine=20
> the log device being the fast device, and the remote devices being the=20
> slow devices.
>=20
> So, I'm not sure how much overlap there is here, but it's something to=20
> think about.
>=20
Well, maybe. Not so sure if device-mapper is the correct place to impleme=
nt
something like this.

What you get if you use a device-mapper device as the 'middle' tier in
this scenario is that this device will contain only random blocks,
ie those actually accessed/modified/whatever.
Only the underlying device will contain the full information about
all blocks, and as such only the underlying device can be mounted
and provides a meaningful filesystem.
Any middle tier devices will contain a somewhat random update of
several blocks, which cannot be interpreted at all.

This makes error checking _really_ hard, as the middle tier devices
can't be consistency checked at all; we have to hope the blocks on
there make sense to the underlying device.

No, this scenario could be more efficiently handled on the filesystem
level, as we then have an implicit consistency check as you're restricted
to move _files_ to a different storage; but that's okay as the filesystem=
s
in on each device themselves will be consistent.

Would be a grand application for union mount if and when it comes around.
And probably btrfs already has it built-in, I wouldn't wonder.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
