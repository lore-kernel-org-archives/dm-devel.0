From: Martin Wilck <martin.wilck@suse.com>
Subject: Re: [PATCH 1/3] multipath: add libmpathvalid library
Date: Fri, 18 Sep 2020 07:51:47 +0000
Message-ID: <4b65fb0cf70f139f2fa06b61c2a092038038a170.camel@suse.com>
References: <1600206312-6497-1-git-send-email-bmarzins@redhat.com>
	<1600206312-6497-2-git-send-email-bmarzins@redhat.com>
	<940b5f7e1202f27a55f58417314c45e441679535.camel@suse.com>
	<20200917235242.GT11108@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200917235242.GT11108@octiron.msp.redhat.com>
Content-ID: <A509AA48A9405A4FBCB90690A2F92764@eurprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Language: en-US
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-09-17 at 18:52 -0500, Benjamin Marzinski wrote:
> On Wed, Sep 16, 2020 at 02:18:49PM +0000, Martin Wilck wrote:
> > On Tue, 2020-09-15 at 16:45 -0500, Benjamin Marzinski wrote:
> > >=20
> > > +struct config;
> > > +extern struct config *mpathvalid_conf;
> >=20
> > What do you need this for?
>=20
> This isn't really necessary. Library users are expected to define
> methods like
>=20
> struct config *get_multipath_config(void)
> {
>         return mpathvalid_conf;
> }
>=20
> void put_multipath_config(__attribute__((unused))void *conf)
> {
>         /* Noop */
> }
>=20
> It would be possible to have mpathvalid_init() return
>=20
> struct config *
>=20
> and mpathvalid_exit() take that pointer. That would allow the caller
> to
> name their config pointer whatever they liked.  However the only
> thing
> that the caller can effect is the verbosity, so there's never really
> any
> point to have more than one config pointer.
>=20
> If you have objections, I can switch this to make the library use a
> user provided config pointer, instead of declaring one itself.

No, I'd rather not. I was mainly wondering why you export the pointer.
I believe that libmultipath's way to require the application to define
certain symbols is suboptimal, and I'd like to get rid of it (see my
other patch set). I can see that (as far as libmultipath is concerned)
this comes too late for sid, but I wouldn't want to repeat that design
decision again.

So, I guess exporting the pointer is just fine. Applications can still
define a symbol by the same name, overriding libmpathvalid's. It might
get problematic if sid will support runtime reconfiguration, like
multipathd. In that case it'd be better if you let the application
override get_multpath_config().

Martin

>=20
> -Ben
>=20
> =20
> > This looks good to me. It would be even better with a few unit
> > tests...
> >=20
> > Anyway, I've been working on a patch set to spare callers to define
> > the symbols {get,put}_multipath_config, udev, and logsink (we've
> > been
> > discussing that in the past). I'm going to submit it soon. I think
> > you
> > might be interested in that for this new library.
> >=20
> > Regards
> > Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer
