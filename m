From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 2/5] libmultipath: change reservation_key to
	a uint64_t
Date: Fri, 8 Sep 2017 17:55:03 -0500
Message-ID: <20170908225503.GG3145@octiron.msp.redhat.com>
References: <1504896354-28181-1-git-send-email-bmarzins@redhat.com>
	<1504896354-28181-3-git-send-email-bmarzins@redhat.com>
	<1504904957.4585.26.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1504904957.4585.26.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 08, 2017 at 11:09:17PM +0200, Martin Wilck wrote:
> On Fri, 2017-09-08 at 13:45 -0500, Benjamin Marzinski wrote:
> > The reservation key is currently being stored as any array of 8
> > unsigned
> > chars.  This is exactly the same in-memory representation as a big
> > endian 64 bit integer. However, the code for dealing with a big
> > endian
> > 64 bit integer is much simpler, so switch to use that instead.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmpathpersist/mpath_persist.c | 23 +++++++----------------
> >  libmultipath/byteorder.h        | 36
> > ++++++++++++++++++++++++++++++++++++
> >  libmultipath/config.c           |  3 ---
> >  libmultipath/config.h           |  6 ++++--
> >  libmultipath/dict.c             | 31 ++++---------------------------
> >  libmultipath/propsel.c          |  6 +++---
> >  libmultipath/structs.h          |  5 ++++-
> >  multipathd/main.c               | 23 +++++------------------
> >  8 files changed, 63 insertions(+), 70 deletions(-)
> >  create mode 100644 libmultipath/byteorder.h
> > =

> >  =

> >  	char * prio_name;
> >  	char * prio_args;
> > -	unsigned char * reservation_key;
> > +	uint64_t  reservation_key; /* stored in big-endian format */
> =

> I would prefer if you could encapsulate this into a type that can't be
> implicitly converted to an int, such as
> =

> struct res_key {
> 	uint64_t _v;
> } reservation_key;
> =

> together with macros like
> =

> #define reskey_to_uint64(r) be64_to_cpu((r)->_v)
> #define set_reskey_from_uint64(r, x) do { (r)->_v =3D (x); } while (0)
> =

> Using be64_to_cpu is all too easily forgotten, which leads to nasty
> bugs.

That's a good idea. I'll resend with a structure instead of a straight
uint64_t.

-Ben

> =

> Apart from that, ack.
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
