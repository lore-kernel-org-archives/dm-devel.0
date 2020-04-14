From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHv3 00/11] dm-zoned: metadata version 2
Date: Tue, 14 Apr 2020 11:13:43 -0400
Message-ID: <20200414151342.GA24238@redhat.com>
References: <20200409064527.82992-1-hare@suse.de>
	<4052464c-cf93-3e22-3050-58183b9ae564@oracle.com>
	<72e25c3e-818b-93a3-1468-5a5fcd256469@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <72e25c3e-818b-93a3-1468-5a5fcd256469@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Bob Liu <bob.liu@oracle.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Apr 14 2020 at  2:38am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 4/11/20 2:30 PM, Bob Liu wrote:
> >On 4/9/20 2:45 PM, Hannes Reinecke wrote:
> >>Hi all,
> >>
> >>this patchset adds a new metadata version 2, which brings the following
> >>improvements:
> >>- UUIDs and labels: Adding three more fields to the metadata containing
> >>   the dm-zoned device UUID and label, and the device UUID. This allows
> >>   for an unique identification of the devices, so that several dm-zone=
d
> >>   sets can coexist and have a persistent identification.
> >>- Extend random zones by an additional regular disk device: A regular
> >>   block device can be added together with the zoned block device, prov=
iding
> >>   additional (emulated) random write zones. With this it's possible to
> >>   handle sequential zones only devices; also there will be a speed-up =
if
> >>   the regular block device resides on a fast medium. The regular block=
 device
> >>   is placed logically in front of the zoned block device, so that meta=
data
> >>   and mapping tables reside on the regular block device, not the zoned=
 device.
> >>- Tertiary superblock support: In addition to the two existing sets of =
metadata
> >>   another, tertiary, superblock is written to the first block of the z=
oned
> >>   block device. This superblock is for identification only; the genera=
tion
> >>   number is set to '0' and the block itself it never updated. The addi=
tional
> >>   metadate like bitmap tables etc are not copied.
> >>
> >>To handle this, some changes to the original handling are introduced:
> >>- Zones are now equidistant. Originally, runt zones were ignored, and
> >>   not counted when sizing the mapping tables. With the dual device set=
up
> >>   runt zones might occur at the end of the regular block device, makin=
g
> >>   direct translation between zone number and sector/block number compl=
ex.
> >>   For metadata version 2 all zones are considered to be of the same si=
ze,
> >>   and runt zones are simply marked as 'offline' to have them ignored w=
hen
> >>   allocating a new zone.
> >>- The block number in the superblock is now the global number, and refe=
rs to
> >>   the location of the superblock relative to the resulting device-mapp=
er
> >>   device. Which means that the tertiary superblock contains absolute b=
lock
> >>   addresses, which needs to be translated to the relative device addre=
sses
> >>   to find the referenced block.
> >>
> >>There is an accompanying patchset for dm-zoned-tools for writing and ch=
ecking
> >>this new metadata.
> >>
> >>As usual, comments and reviews are welcome.
> >>
> >>Changes to v2:
> >>- Kill dmz_id()
> >>- Include reviews from Damien
> >>- Sanitize uuid handling as suggested by John Dorminy
> >>
> >
> >This series looks good to me, feel free to add my
> >Reviewed-by: Bob Liu <bob.liu@oracle.com>
> >
> >By the way, have you completed the patches for regular device support?
> >I was considering rebase my previous patches to this series but not sure=
 is it still necessary.

Bob, not trying to be overly critical but if you couldn't answer your
question how did you feel comfortable providing your Reviewed-by to this
patchset?  That Reviewed-by _must_ mean something.

Mike


> I have combined both patchsets, this one now also included regular
> device support. So no need to resend from your side.
>=20
> Cheers,
>=20
> Hannes
> --=20
> Dr. Hannes Reinecke            Teamlead Storage & Networking
> hare@suse.de                               +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> HRB 36809 (AG N=FCrnberg), Gesch=E4ftsf=FChrer: Felix Imend=F6rffer
>=20
