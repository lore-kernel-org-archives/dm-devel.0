From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Status of resizing/growing dm-multipath devices on the
	fly
Date: Fri, 5 Sep 2008 11:12:32 +0300
Message-ID: <20080905081232.GM13941@edu.joroinen.fi>
References: <20080806125355.GM3771@edu.joroinen.fi>
	<BF003E91ABCA429FA851667CB3486F7F@pitagora.it>
	<20080806143751.GO3771@edu.joroinen.fi>
	<20080806193602.GA9941@linux.vnet.ibm.com>
	<1218056296.14886.29.camel@bluto.andrew>
	<20080811103619.GA3771@edu.joroinen.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080811103619.GA3771@edu.joroinen.fi>
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
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
List-Id: dm-devel.ids

On Mon, Aug 11, 2008 at 01:36:19PM +0300, Pasi K=E4rkk=E4inen wrote:
> On Wed, Aug 06, 2008 at 02:58:16PM -0600, Andrew Patterson wrote:
> > On Wed, 2008-08-06 at 12:36 -0700, Mike Anderson wrote:
> > > Pasi K?rkk?inen <pasik@iki.fi> wrote:
> > > > On Wed, Aug 06, 2008 at 03:48:12PM +0200, Domenico Viggiani wrote=
:
> > > > > * Pasi K=E4rkk=E4inen wrote:
> > > > > >=20
> > > > > > Is it possible to resize (grow) dm-multipath devices on the=20
> > > > > > fly nowadays?
> > > > > >=20
> > > > > > I googled and found some discussions about the subject, but=20
> > > > > > the conclusion seemed to be it's not possible.. that was a=20
> > > > > > while ago, so I was wondering if this has been fixed/implemen=
ted..
> > > > > >=20
> > > > > > Using LVM and adding another new LUN/PV is not an option=20
> > > > > > always.. it's a lot easier to manage the whole thing if it's=20
> > > > > > possible to resize/grow existing LUNs on the fly.
> > > > >=20
> > > > > Nowadays all disk-arrays make online LUN extension a breeze but
> > > > > unfortunately it seems that dm-multipath is still not able to s=
ee new size
> > > > > without downtime:
> > > > >  http://www.redhat.com/archives/dm-devel/2007-August/msg00205.h=
tml
> > > > > Look also at this recent thread on RHEL5 mailing-list where you=
 can find
> > > > > also a post from a Red Hat representative:
> > > > >  http://www.redhat.com/archives/rhelv5-list/2008-July/msg00267.=
html
> > > > >=20
> > > > > Sure, you can just add a new LUN, pvcreate and vgextend but it =
is not a
> > > > > viable solution because it causes LUN proliferation.
> > > > >=20
> > > > > Sincerely, I'm still subscribed to this mailing-list only to se=
e if someone
> > > > > solve this SHAME!
> > > > > It's a feature that Linux really needs.
> > > > >=20
> > > > > Hope someone pick this cry of pain!
> > > > >=20
> > > >=20
> > > > Thanks for the reply.
> > > >=20
> > > > Does someone know what's the actual problem in this? meaning why =
it hasn't
> > > > been done yet..=20
> > >=20
> > > It has to do with the block layer not using the new size value whil=
e there
> > > are openers.
> > >=20
> > > Andrew submitted a patch series (url below) a while ago to try and =
address
> > > this issue, but I do not know the status. I added Andrew to the cc.
> > >=20
> > > http://thread.gmane.org/gmane.linux.scsi/41623
> > >=20
> >=20
> > The above patchset works with SCSI devices. I have tested it with sin=
gle
> > SCSI devices under dm/LVM, i.e., a PV is on a single SCSI LUN with on=
ly
> > one path to it. It has not yet been accepted upstream due to not gett=
ing
> > sign-off from Al Viro. I plan on resubmitting soon to add cciss suppo=
rt.
> > Hopefully Al will getting around to reviewing it sometime this centur=
y.
> > I have heard rumors that Al has some all-encompassing solution for th=
is
> > problem but hasn't got around to implementing it.  I'll test my new
> > patches with multi-path while I am at it.
> >=20
>=20
> Was there some problems/issues with the patchset? Or just lack of time =
from
> Al..=20
>=20

I noticed these patches were accepted for 2.6.28:
http://www.gossamer-threads.com/lists/linux/kernel/967628

Now how about online resizing dm-multipath devices.. ? We want that aswel=
l! :)

-- Pasi
