From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 2/7] multipathd: fix check_path errors with
 removed map
Date: Fri, 19 Jun 2020 20:09:27 +0000
Message-ID: <bfb3d1b613a5346fe57bfedac6b2b631f791c854.camel@suse.com>
References: <1592439867-18427-1-git-send-email-bmarzins@redhat.com>
	<1592439867-18427-3-git-send-email-bmarzins@redhat.com>
	<f09ec3b6537a7b7ac1ae26433e43846176f1dd48.camel@suse.com>
	<20200618231711.GM5894@octiron.msp.redhat.com>
	<6f9284eeec0dda69e8e4dd4b2858f02d3c31fb8b.camel@suse.com>
	<20200619165236.GP5894@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200619165236.GP5894@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <1D6385902A382E4B8B7EC24BC88DB210@eurprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2020-06-19 at 11:52 -0500, Benjamin Marzinski wrote:
> On Fri, Jun 19, 2020 at 01:42:47PM +0000, Martin Wilck wrote:
> > On Thu, 2020-06-18 at 18:17 -0500, Benjamin Marzinski wrote:
> > > On Thu, Jun 18, 2020 at 07:34:38PM +0000, Martin Wilck wrote:
> > > >=20
> > > > It would be more elegant if we could distinguish different
> > > > failure
> > > > modes from update_multipath_strings() directly, without having
> > > > to
> > > > call
> > > > do_dm_get_info() again.
> > >=20
> > > Seems reasonable. I'll take a look at that.
> >=20
> > Yet another idea: I just discussed this with Hannes, and he pointed
> > out
> > that right below this code, we have
> >=20
> > =09/* if update_multipath_strings orphaned the path, quit early */
> > =09if (!pp->mpp)
> > =09=09return 0;
> >=20
> > ... which could have the same effect, if pp->mpp was reloaded.
> > Probably
> > that doesn't happen because the pp->mpp dereference is cached in a
> > register, but we could simply add a READ_ONCE there.
>=20
> When update_multipath_strings() calls update_multipath_table() it
> will
> fail because the table no longer exists.  If we differentiate between
> a dm error and not finding the map, we can exit early without having
> to
> call do_dm_get_info() again. But right now, if the map is gone, but
> we
> haven't got the uevent removing it, then nothing will clear pp->mpp.=20

You're right. Let's "differentiate", then :-)

> If
> we did get the uevent, then it must have grabbed the vecs lock. That
> better have caused a memory barrier, which will guarantee that
> check_path() sees the updated value.

It could hardly have grabbed the lock while check_path() was running.
Anyway, this wasn't the right suggestion then, and "differentiating" is
better anyway. Sorry for the confusion.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
