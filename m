From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: multipathd.init
Date: Sun, 10 Apr 2005 21:22:00 +0200
Message-ID: <20050410192200.GM12752@marowsky-bree.de>
References: <20050401204048.GI14307@agk.surrey.redhat.com>
	<1112389744.8118.26.camel@zezette>
	<20050401211902.GL14307@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050401211902.GL14307@agk.surrey.redhat.com>
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

On 2005-04-01T22:19:02, Alasdair G Kergon <agk@redhat.com> wrote:

> On Fri, Apr 01, 2005 at 11:09:04PM +0200, christophe varoqui wrote:
> > Do we really want to do complicated things to close that window ? I
> > would guess not.
> =20
> In other words, if the paths can't survive the window between initrd=20
> running and init scripts completing, the machine doesn't deserve to boo=
t.
>=20
> And if you want the daemon in single-user mode, you can start it by han=
d.
>=20
> Fair point.
>=20
> So is there ever a requirement to run the daemon while /var is read-onl=
y?

We ran into the same problem, and just decided to invoke /sbin/multipath
once during the boot/ sequence, and then start the daemon in the
runlevel itself.

Note that LSB apparently also suggests that no unneeded daemons are
running in single-user mode; but I couldn't find that detailed anywhere
else.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
