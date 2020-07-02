From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 2/3] libmutipath: don't close fd on
 dm_lib_release
Date: Thu, 2 Jul 2020 15:06:32 -0500
Message-ID: <20200702200632.GH11089@octiron.msp.redhat.com>
References: <1585083834-14237-1-git-send-email-bmarzins@redhat.com>
	<1585083834-14237-2-git-send-email-bmarzins@redhat.com>
	<ebfcb22b005314635b77e4820e205971d708d07d.camel@suse.com>
	<20200325205255.GB17313@octiron.msp.redhat.com>
	<20200325220045.GC17313@octiron.msp.redhat.com>
	<4eaae3bfe0c383d23a839483e88ec093883f4e5a.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4eaae3bfe0c383d23a839483e88ec093883f4e5a.camel@suse.com>
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
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 02, 2020 at 11:52:21AM +0000, Martin Wilck wrote:
> On Wed, 2020-03-25 at 17:00 -0500, Benjamin Marzinski wrote:
> > On Wed, Mar 25, 2020 at 03:52:55PM -0500, Benjamin Marzinski wrote:
> > > On Wed, Mar 25, 2020 at 03:16:50PM +0000, Martin Wilck wrote:
> > > > On Tue, 2020-03-24 at 16:03 -0500, Benjamin Marzinski wrote:
> > > >=20
> > > > AFAICS, this function has been in libdm since 1.02.111. We
> > > > support
> > > > 1.02.89 (if all features enabled, otherwise even older). Perhaps
> > > > we
> > > > should make this function call conditional on the libdm verson?
> > > >=20
> > > > But perhaps more importantly, why do we still need to call
> > > > dm_lib_release()? AFAICS it's only needed for systems that have
> > > > no udev
> > > > support for creating device nodes (to call update_devs() via
> > > > dm_lib_release()), and we don't support that anymore anyway, do
> > > > we?=20
> > > >=20
> > > > Since 26c4bb0, we're always setting the
> > > > DM_UDEV_DISABLE_LIBRARY_FALLBACK flag, and the cookie, too
> > > > (we aren't setting it for DM_DEVICE_RELOAD, but it isn't needed
> > > > for
> > > > that, either, since no device nodes need to be created or
> > > > removed); so
> > > > dm_lib_release() should really have no effect.
> > > >=20
> > > > Regards
> > > > Martin
> > >=20
> > > Good call. I'll redo this patch.
> >=20
> > Actually, I've changed my mind. Calling dm_lib_release() lets us
> > release
> > the memory that device-mapper uses to store all the node ops that it
> > was saving up.  Without calling dm_lib_release(), AFAICS, that memory
> > keeps growing until the daemon exits.
>=20
> Sorry for coming back to this so late. I've just stared at the libdm
> code again.=20
>=20
> We always set DM_UDEV_DISABLE_LIBRARY_FALLBACK. In the standard CREATE
> and REMOVE cases, libdm doesn't stack any operations if this flag is
> set. The only exceptions are=20
>=20
>  a) RESUME operations with DM_ADD_NODE_ON_RESUME set. This happens
> implicity when we create new maps
>  b) RENAME operations
>=20
> In both cases, we call dm_udev_wait() after the libdm operation, which
> calls update_devs() and should thus have the same effect as
> dm_lib_release(). IOW, I still believe we don't need to call
> dm_lib_release() any more.

Sure. But can we leave this patch as is, and remove those calls in a
different patch?

-Ben
=20
> Regards,
> Martin
>=20
> --=20
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE  Software Solutions Germany GmbH
> HRB 36809, AG N=FCrnberg GF: Felix
> Imend=F6rffer
>=20
