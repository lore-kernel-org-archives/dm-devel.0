From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 5/7] Move the declaration of
 mpath_mx_alloc_len to a header file
Date: Fri, 19 May 2017 18:39:59 +0000
Message-ID: <1495219197.2581.1.camel@sandisk.com>
References: <20170517154309.17787-1-bart.vanassche@sandisk.com>
	<20170517154309.17787-6-bart.vanassche@sandisk.com>
	<20170518200615.GS22856@octiron.msp.redhat.com>
	<1495139768.2511.7.camel@sandisk.com>
	<20170518210051.GT22856@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170518210051.GT22856@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <0D567B8C0B80C14283581FE90F1D3242@namprd04.prod.outlook.com>
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

On Thu, 2017-05-18 at 16:00 -0500, Benjamin Marzinski wrote:
> On Thu, May 18, 2017 at 08:36:10PM +0000, Bart Van Assche wrote:
> > On Thu, 2017-05-18 at 15:06 -0500, Benjamin Marzinski wrote:
> > > On Wed, May 17, 2017 at 08:43:07AM -0700, Bart Van Assche wrote:
> > > > This allows the compiler to verify consistency of declaration and
> > > > definition.
> > > > Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> > > > ---
> > > >  libmpathpersist/mpath_persist.h | 3 +++
> > > >  mpathpersist/main.c             | 1 -
> > > >  multipathd/main.c               | 2 --
> > > >  3 files changed, 3 insertions(+), 3 deletions(-)
> > > > =

> > > > diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpat=
h_persist.h
> > > > index 79de5b5b..3faa8c9e 100644
> > > > --- a/libmpathpersist/mpath_persist.h
> > > > +++ b/libmpathpersist/mpath_persist.h
> > > > @@ -81,6 +81,9 @@ extern "C" {
> > > >  =

> > > >  =

> > > >  =

> > > > +extern unsigned int mpath_mx_alloc_len;
> > > > +
> > > > +
> > > >  =

> > > >  struct prin_readdescr
> > > >  {
> > > > diff --git a/mpathpersist/main.c b/mpathpersist/main.c
> > > > index 2e0aba3c..9de52b98 100644
> > > > --- a/mpathpersist/main.c
> > > > +++ b/mpathpersist/main.c
> > > > @@ -40,7 +40,6 @@ void mpath_print_transport_id(struct prin_fulldes=
cr *fdesc);
> > > >  int construct_transportid(const char * inp, struct transportid tra=
nsid[], int num_transportids);
> > > >  =

> > > >  int logsink;
> > > > -unsigned int mpath_mx_alloc_len;
> > > >  struct config *multipath_conf;
> > > >  =

> > > >  struct config *get_multipath_config(void)
> > > > diff --git a/multipathd/main.c b/multipathd/main.c
> > > > index b167cb4c..81c76cab 100644
> > > > --- a/multipathd/main.c
> > > > +++ b/multipathd/main.c
> > > > @@ -104,8 +104,6 @@ struct mpath_event_param
> > > >  	struct multipath *mpp;
> > > >  };
> > > >  =

> > > > -unsigned int mpath_mx_alloc_len;
> > > > -
> > > >  int logsink;
> > > >  int verbosity;
> > > >  int bindings_read_only; =

> > > =

> > > I get why you did this, but I'm not totally happy with where the exte=
rn
> > > declaration is.=A0=A0libmpathpersist is actually a public library, un=
like
> > > libmultipath, and mpath_persist.h is that header for that library.=A0=
=A0As
> > > such, I'd rather not add things to it that users aren't supposed to m=
ess
> > > with.=A0=A0So, is your intention to let users set the max alloc lengt=
h. If
> > > so, we should probably give them a function, or at the very least some
> > > comments telling them what this variable does. If we only want the
> > > mpathpersist program to be able to change this, then we probably
> > > should probably put the declaration in a different header file, perha=
ps
> > > mpath_pr_ioctl.c. Now that I'm looking at this, I see that this option
> > > (-l) isn't even documented in the mpathpersist manpage. So right now
> > > this seems likely a completely unused feature. I guess since it exist=
s,
> > > I'd lean towards actually documenting it and putting it in the
> > > libmpathpersist API in a more useful way.
> > =

> > (changed top-posting into bottom-posting)
> > =

> > Hello Ben,
> > =

> > It was not my intention to make the mpath_mx_alloc_len variable accessi=
ble
> > to users of the libmpathpersist library. From what I can see in
> > libmpathpersist/Makefile the only public header file of the libmpathper=
sist
> > library is mpath_persist.h. Would you agree to move that declaration in=
to
> > mpathpr.h?
> =

> Sure

Hello Ben,

When I tried to implement what I proposed I noticed that there is already a=
 user
of the libmpathpersist library that modifies the mpath_mx_alloc_len variabl=
e,
namely the mpathpersist executable. So what I proposed is not possible beca=
use it
would break the=A0build of the mpathpersist executable.

Bart.
