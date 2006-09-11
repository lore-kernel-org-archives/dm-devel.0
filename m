From: Edward Goggin <egoggin@emc.com>
Subject: RE: Re: 1st of 2 patches for dm_emc.c and dm-multipath
	hardware handler interface
Date: Mon, 11 Sep 2006 13:34:12 -0400
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D13B7@CORPUSMX40A.corp.emc.com>
References: <4501AF96.9030502@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <4501AF96.9030502@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: michaelc@cs.wisc.edu, dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Friday, September 08, 2006 2:00 PM, Mike Christie wrote
>=20
> Mike Christie wrote:
> > Edward Goggin wrote:
> >> +
> >> +	rq->buffer =3D rq->data =3D h->buffer;
> >> +	rq->data_len =3D len;
> >> +	rq->bio =3D rq->biotail =3D NULL;
> >> =20
> >=20
> > I think I only suggested that you use the block layer map=20
> functions in
> > the previous review. Now I will say, use them and fix the=20
> core code to
> > not allocate memory or use a mempool since it will also fix the path
> > testers at the same time :) The reason is that the scsi=20
> layer is trying
> > to make every thing run with scatterlists. In 2.6.18, every place is
> > converted (they should be at least), so you should not be=20
> adding another
> > place where we send down a data buffer like this.
> >=20
>=20
> And if we are going to continue to do some scsi processing in dm I
> already did some helpers you could base yourself off of here
>=20
> http://www.cs.wisc.edu/~michaelc/block/dm/v4/

I was first trying to submit these changes to the upstream code
(I chose 2.6.18-rc4) since I this is what I thought you had
suggested that I do when we talked about it briefly at the dm bof
session at OLS.

Should I not be taking this tack?

>=20
>=20
> In dm_scsi_end_rq, you could handle errors like transient transport
> failures for all hw handlers at one tine.
>=20
> http://www.cs.wisc.edu/~michaelc/block/dm/v4/02-dm-scsi-helpers.patch

Again, doesn't this imply a change from what we already agreed upon?
That is fine, I just need to know.

>=20
> And in fact a lot of your patch has already been done with this patch
>=20
> http://www.cs.wisc.edu/~michaelc/block/dm/v4/03-emc.patch a year ago.

I certainly read your patch set at that time it was sent since this is
how I learned about the availability of the blk_execute_rq_nowait
interface.  Yet, I certainly didn't mean to plagiarize any of your
code.  I apologize if I have inadvertently done so.  I definitely
remember having a difficult time getting the io initiated by dm-emc.c
to work at all with my changes.  Turns out I was trying to DMA from
kernel static sections (as is your code).  Yet, I don't remember
looking back at your patch set for inspiration to solve the problem.

The primary intention of my patch is to (1) allow dm-emc.c to
distinguish between dm and non-dm initiated multipath path group
switch events, (2) provide a dm-multipath hw-handler status callback
for dm-emc.c, and (3) provide a somewhat more informative error
logging capability for the dm-multipath hw-handler interface.

I was also intent on having the possibly multiple ios initiated by
dm-emc.c not involve allocating memory for request or bio structures
from mempools or otherwise.  Doing so is proving especially difficult.

>=20
> We really need to change how dm-multipath development works IMHO.
> Alasdair is just too overworked. It is not fair to him to have so much
> work piled on top of him and not fair to the community to=20
> have problems
> like this sit around for so long.
>=20
> The basics of the hw handler framework were done when I did=20
> my pg group
> callouts that improved on Joe's idea to put everything in the path
> selectors. It took a year after that to get hw handlers,=20
> which made some
> of the same architectural mistakes as well as odd coding=20
> choices that I
> made, in the kernel. And now for another year we have been sitting on
> these type of bugs and problems where we need some of the hw handler
> functionality in the scsi layer as well as dm layer.
>=20
> With Alasdair having to maintain every driver that dm handles=20
> and those
> drivers increasing in complexity the work load is too large for one
> person and this makes coordination with other subsystems impossible.
> This is a large problem, when for something like dm-multipath it needs
> help from the block layer, and low levels like scsi.
>=20
> We really need a system like in the scsi layer where there are driver
> maintainers and then one core maintainer of the subsystem. The core
> maintainer has final (well ok community has final say I guess) say but
> trusts the low level driver maintainers to some extent. The low level
> driver maintainers still have to post patches for review to the
> community and maintainer but the core maintainer does not have to do a
> line by line review of the dm target module and learn all the lower
> level details of the sub-subsytem/lld/dm target module/transport/spec
> unless it affects dm core or it is a suspicious patch.
>=20
> Just my 2 cents.

Good ideas.  This approach should scale more effectively.

>=20
