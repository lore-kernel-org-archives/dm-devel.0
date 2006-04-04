From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: creating partition mappings with different delimiters
Date: Tue, 04 Apr 2006 09:31:20 -0400
Message-ID: <1144157480.3111.54.camel@gator.sc.steeleye.com>
References: <1144081162.3111.32.camel@gator.sc.steeleye.com>
	<1144097506.3111.81.camel@gator.sc.steeleye.com>
	<44319246.6040008@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44319246.6040008@free.fr>
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

On Mon, 2006-04-03 at 23:23 +0200, Christophe Varoqui wrote:
> Eddie Williams a =C3=A9crit :
> > I see it is kpartx that is defaulting to the 'p' as the delimiter (in
> > the set_delimiter function) when the uuid ends with a digit and no
> > delimiter when the uuid ends with a character.
> >
> > Wouldn't it be better to always use the same delimiter by default?  A=
s
> > it stands now one will not be able to determine that a node is a
> > partition versus a full device by just looking at the name.=20
> >
> >  =20
> This behaviour mimics the kernel partition naming policies : /dev/sd?=20
> partitions have no separator, while /dev/cciss/c0d0 have one, for examp=
le.

Yes and no.  Yes, for /dev/sd nodes it never adds a separator and
for /dev/cciss it always adds one.  But "no" in the sense that I can not
think of any examples prior to this where sometimes it does and
sometimes it doesn't (add a separator) for the same device type.

The key item here is that it was consistent.  For each device you knew
what to expect.  That made for a nice easy regular expression to figure
out what kind of device you were dealing with.

For the case of "uuid" nodes I do not see a way to use a regular
expression to determine what kind of node you are dealing with.  If you
have a node that ends with something like "c1" you can not tell if that
is partition 1 or the full device.

Yes, there are tools available to figure out if a node is a partition or
the full disk.  I have to admit to being lazy and like the ease at being
able at a glance to tell what the node represents.  The same work I do
not want to have to do as a human I also do not want to have to add to
my programs.  I often find being lazy makes for good programming.
Accomplishing a task with minimal work is always best (and even better
if you find someone else has done the work for you).

>=20
> kpartx once meant to be a true alternative to in-kernel partition=20
> handling, thus cared about that naming compatibility.
>=20
> I'm inclined to leave it that way, if not only to discourage people to=20
> partition multipathed devices :)

I can understand that, I was a bit disappointed when I found that kpartx
existed.  I was not expecting to support partitions on multipath
devices.  The cat is out of the bag now and I doubt it will go back in.
Partitions are here to stay.

I started to suggest that I could add a way, perhaps in multipath.conf,
to define a default separator.  That way someone could override the
default behavior fairly easily.  I am not sure making this change now is
worth it though.  I will just accept that I probably need to run
'dmsetup info' on a node to figure out if it is a partition or disk.

Thanks

Eddie

=20
