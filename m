From: Hannes Reinecke <hare@suse.de>
Subject: Re: Differentiating between dm devices
Date: Thu, 24 Mar 2011 08:23:45 +0100
Message-ID: <4D8AF181.4050004@suse.de>
References: <4D8A2E53.10401@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D8A2E53.10401@cfl.rr.com>
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
Cc: Phillip Susi <psusi@cfl.rr.com>
List-Id: dm-devel.ids

On 03/23/2011 06:30 PM, Phillip Susi wrote:
> There are different classes of dm devices that different utilities may
> or may not care about.  Some are intended to represent whole disks (
> dmraid ) that can be partitioned.  Some ARE partitions and should
> contain filesystems.  Still others are used only internally by the tools
> ( -real, -cow for lvm, and raid10 subvolumes for dmraid ).  I can not
> find any good way to differentiate between these types.
> =

And indeed you are right, there is none.

> One way of fixing this is to add a new attribute to the device where the
> tools creating them can specify a hint about what they are and how they
> should be used.  Another way is to embed that information in the UUID.
> For instance, logical volumes have UUIDs that start with "LVM-" and
> dmraid disks start with "DMRAID-".  Perhaps dmraid partitions could have
> their uuids changed to "DMRAIDP-" and internal devices changed to
> "DMRAIDI-" and "LVMI-" for dmraid and lvm respectively.
> =

That is the approach I've been following for SUSE.
The UUID is assumed to be of this syntax:

<type>-<identifier>

where <type> is defined by the program creating the mapping.
EG 'mpath' for multipath, 'partX' (where 'X' is the partition
number) for kpartx etc.

Not that these prefixes are registered in any way; would be nice
to have them registered / documented somewhere.
Cool would be to have them build into the module :-)

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
