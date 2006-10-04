From: Edward Goggin <egoggin@emc.com>
Subject: RE: 1st of 2 patches for dm_emc.c and dm-multipath
	hardware handler interface
Date: Wed, 4 Oct 2006 16:13:54 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D1413@CORPUSMX40A.corp.emc.com>
References: <4501A68F.8050708@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4501A68F.8050708@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: michaelc@cs.wisc.edu
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Friday, September 08, 2006 1:21 PM, Mike Christie wrote
>=20
> Edward Goggin wrote:
> > +
> > +	rq->buffer =3D rq->data =3D h->buffer;
> > +	rq->data_len =3D len;
> > +	rq->bio =3D rq->biotail =3D NULL;
> > =20
>=20
> I think I only suggested that you use the block layer map functions in
> the previous review. Now I will say, use them and fix the core code to
> not allocate memory or use a mempool since it will also fix the path
> testers at the same time :) The reason is that the scsi layer=20
> is trying
> to make every thing run with scatterlists. In 2.6.18, every place is
> converted (they should be at least), so you should not be=20
> adding another
> place where we send down a data buffer like this.
>=20

Mike, sorry for the long delay.

I certainly can (and have tried already before submitting the patch
as is) change the code to call blk_rq_map_kern instead of using the
code sequence you have identified above.  As you cite, I was trying
to avoid memory/mempool allocation (for a bio) while servicing the io.

As far as fixing the code to not allocate memory or use a mempool,
let me know if the description below is what you have in mind?

A slightly modified version of __bio_map_kern
(and modified versions of its callers like blk_rq_map_kern)
which would accept a ptr to bio as a parameter instead of
allocating one.  Any kernel resident code like a dm-multipath
hardware handler could obtain a bio beforehand from a distinct
bio_set (bio mempool).  In the dm-multipath hardware handler
case, a single bio_set could be associated with each target
path (struct path).

Solving this for the path testing code path is more complicated
since the code path is more generic and involves ios initiated
from user space.  We could move the path testing to within a
device mapper ioctl interface which makes it easier to obtain
the bio from the path's bio_set and call a  slightly modified
version of bkl_rq_map_user, bio_map_user, and __bio_map_user_iov.
