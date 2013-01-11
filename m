From: Hannes Reinecke <hare@suse.de>
Subject: Re: Priozier for remote port on fibre channel devices
Date: Fri, 11 Jan 2013 08:22:24 +0100
Message-ID: <50EFBDB0.5010004@suse.de>
References: <OF21470796.D356BC7E-ONC1257AF0.0022D29F-C1257AF0.00278317@continental-corporation.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF21470796.D356BC7E-ONC1257AF0.0022D29F-C1257AF0.00278317@continental-corporation.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 01/11/2013 08:11 AM, =

Andreas.Bleischwitz@continental-corporation.com wrote:
> Hello List,
>
> I'm currently facing a problem with a storage virtualization device
> which is located in two different datacenters and shows up as
> another path to a configured SAN-LUN.
> The virtualization device is from EMC=B2 and is called V-PLEX.
>
> So I have something like this:
>
>          DC A
> Host ---VPLEX-DC A---LUN storage A
>    |     |
> ..|...........|...................
>    |     DC B  |
>    ------VPLEX-DC B---LUN storage B
>
> The VPLEX device itself is for storage based mirroring and
> synchronizes write access to storage A to storage B and the other
> way around.
>
> My problem is, that the virtual LUN I get from the VPLEX does not
> have any prioritization given by dm-multipath and looks like this:
>
> mpath3 (36000144000000010e06d8f12ec30dfef) dm-9 EMC,Invista
> [size=3D5.0G][features=3D1 queue_if_no_path][hwhandler=3D0][rw]
> \_ round-robin 0 [prio=3D1][active]
>   \_ 5:0:1:2 sdad 65:208 [active][ready]
>   \_ 5:0:4:2 sdak 66:64  [active][ready]
>   \_ 5:0:5:2 sdap 66:144 [active][ready]
>   \_ 4:0:0:2 sdc  8:32   [active][ready]
>   \_ 4:0:1:2 sdh  8:112  [active][ready]
>   \_ 4:0:4:2 sdo  8:224  [active][ready]
>   \_ 4:0:5:2 sdt  65:48  [active][ready]
>   \_ 5:0:0:2 sdy  65:128 [active][ready]
>
> That way, write access is made round-robin and access to the
> "remote-devices" - device located in the other DC - creating
> duplicate traffic through the
> SAN switches as the access has to be routed to the remote VPLEX-B
> and it will write to the local VPLEX-A.
>
> I wanted to solve this problem by giving priorities to a path by its
> remote-port - which is different for each connection to a SAN
> device. Unfortunately
> there currently doesn't exist any priorizer and I have to write one
> on my own.
> To make the definition flexible, I would like to have a file with a
> list of port-wwns associated with a priority.
>
> For versions shipped with RHEL5 this could be a simple shell script
> which simply looks up the sysfs file structures of a given device.
> For RHEL6 this has to be
> a binary library. So writing a binary version will make more sense
> than maintaining two different solutions.
>

Well, at least on SLES we're shipping a prioritizer named =

'weightedpath' which does exactly this.

However, chances are that the VPLEX is supporting ALUA, so you might =

want to use the 'alua' prioritizer here.

What is the output of 'sg_inq /dev/sdc' ?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
