From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [RFC] dm snapshot based asynchronous replication
Date: Thu, 16 Apr 2009 09:02:13 +0200
Message-ID: <20090416070213.GA7566@johann>
References: <137413921.2150341239820262767.JavaMail.root@zimbra16-e3.priv.proxad.net>
	<1046537454.2150461239820304817.JavaMail.root@zimbra16-e3.priv.proxad.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1046537454.2150461239820304817.JavaMail.root@zimbra16-e3.priv.proxad.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 15, 2009 at 08:31:44PM +0200, christophe.varoqui@free.fr wrot=
e:
> > Should I understand there's no way for userspace to extract from the =
device mapper the cow'ed chunk list of a vanilla snapshot ?
>=20
> Replying to myself, I found an instructive post from Lars of the drdb f=
olks : http://markmail.org/message/7qdbp36tohasojuy (thanks for sharing L=
ars)
>=20
> This script is easy enough to morph from its original snapshot revertin=
g purpose to the replication model using the cow device as a changelog I =
described.
>=20
> Thanks for the inputs. I'll keep posting if I something of general inte=
rest comes out of this stuff.

that perl hack was meanwhile ported to C by someone.
posted earlier this year on dm-devel.
also please do not ignore the Zumastor work.

--=20
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD=AE and LINBIT=AE are registered trademarks of LINBIT, Austria.
