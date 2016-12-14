From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v4 0/3] multipathd: skip spurious event
 message for blacklisted paths
Date: Wed, 14 Dec 2016 19:39:00 +0100
Message-ID: <CABr-GndfXVagGRMT1LHBOpLDx6YcDFzONWULTm9C1qxfdUTwBg@mail.gmail.com>
References: <1481720731-22503-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<20161214155929.GD19659@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7036940874629542454=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161214155929.GD19659@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
List-Id: dm-devel.ids

--===============7036940874629542454==
Content-Type: multipart/alternative; boundary=94eb2c1ab7b88d50180543a2a62f

--94eb2c1ab7b88d50180543a2a62f
Content-Type: text/plain; charset=UTF-8

This set is merged.
Thanks.

On Wed, Dec 14, 2016 at 4:59 PM, Benjamin Marzinski <bmarzins@redhat.com>
wrote:

> ACK for the set.
>
> -Ben
>
> On Wed, Dec 14, 2016 at 11:05:28AM -0200, Mauricio Faria de Oliveira wrote:
> > This patch-set prevents this error message on 'change'
> > uevents of paths that are blacklisted:
> >
> >     sdb: spurious uevent, path not found
> >
> > And in that case, replaces it with this _debug_ message
> > (so it's not logged by default; only when requested):
> >
> >     sdb: spurious uevent, path is blacklisted
> >
> > Patch 1/3 fixes a potential leak observed while doing that.
> > Patch 2/3 minor refactors two blacklist/filter checks into
> >           pathinfo() to clean-up a bit and fix a couple of
> >           bugs (reported by Ben and Hannes)
> > Patch 3/3 finally does what the patch-set is supposed to.
> >
> > Changelog:
> >  - v2: switch approach from using path_discover() to using
> >        alloc_path_with_pathinfo() (Benjamin Marzinski).
> >  - v3: drop calls to udev_device_ref/unref() (Benjamin Marzinski)
> >        move filter_property() into pathinfo() (Benjamin Marzinski)
> >  - v4: move filter_devnode() into pathinfo() (Hannes Reinecke)
> >        ensure equivalency between path_discover() and pathinfo()
> >        for multipathd behavior.
> >
> > Mauricio Faria de Oliveira (3):
> >   libmultipath: prevent memory leak in alloc_path_with_pathinfo() if
> >     pp_ptr is NULL
> >   libmultipath: move filter_property|devnode() from path_discover() into
> >     pathinfo()
> >   multipathd: skip spurious event message for blacklisted paths
> >
> >  libmultipath/blacklist.c |  4 ++++
> >  libmultipath/discovery.c | 23 +++++++++++++++--------
> >  multipathd/main.c        | 17 ++++++++++++++++-
> >  3 files changed, 35 insertions(+), 9 deletions(-)
> >
> > --
> > 1.8.3.1
>

--94eb2c1ab7b88d50180543a2a62f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">This set is merged.<div>Thanks.</div></div><div class=3D"g=
mail_extra"><br><div class=3D"gmail_quote">On Wed, Dec 14, 2016 at 4:59 PM,=
 Benjamin Marzinski <span dir=3D"ltr">&lt;<a href=3D"mailto:bmarzins@redhat=
.com" target=3D"_blank">bmarzins@redhat.com</a>&gt;</span> wrote:<br><block=
quote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc=
 solid;padding-left:1ex">ACK for the set.<br>
<br>
-Ben<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
On Wed, Dec 14, 2016 at 11:05:28AM -0200, Mauricio Faria de Oliveira wrote:=
<br>
&gt; This patch-set prevents this error message on &#39;change&#39;<br>
&gt; uevents of paths that are blacklisted:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0sdb: spurious uevent, path not found<br>
&gt;<br>
&gt; And in that case, replaces it with this _debug_ message<br>
&gt; (so it&#39;s not logged by default; only when requested):<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0sdb: spurious uevent, path is blacklisted<br>
&gt;<br>
&gt; Patch 1/3 fixes a potential leak observed while doing that.<br>
&gt; Patch 2/3 minor refactors two blacklist/filter checks into<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pathinfo() to clean-up a bit a=
nd fix a couple of<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bugs (reported by Ben and Hann=
es)<br>
&gt; Patch 3/3 finally does what the patch-set is supposed to.<br>
&gt;<br>
&gt; Changelog:<br>
&gt;=C2=A0 - v2: switch approach from using path_discover() to using<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 alloc_path_with_pathinfo() (Benjamin Marzin=
ski).<br>
&gt;=C2=A0 - v3: drop calls to udev_device_ref/unref() (Benjamin Marzinski)=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 move filter_property() into pathinfo() (Ben=
jamin Marzinski)<br>
&gt;=C2=A0 - v4: move filter_devnode() into pathinfo() (Hannes Reinecke)<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 ensure equivalency between path_discover() =
and pathinfo()<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 for multipathd behavior.<br>
&gt;<br>
&gt; Mauricio Faria de Oliveira (3):<br>
&gt;=C2=A0 =C2=A0libmultipath: prevent memory leak in alloc_path_with_pathi=
nfo() if<br>
&gt;=C2=A0 =C2=A0 =C2=A0pp_ptr is NULL<br>
&gt;=C2=A0 =C2=A0libmultipath: move filter_property|devnode() from path_dis=
cover() into<br>
&gt;=C2=A0 =C2=A0 =C2=A0pathinfo()<br>
&gt;=C2=A0 =C2=A0multipathd: skip spurious event message for blacklisted pa=
ths<br>
&gt;<br>
&gt;=C2=A0 libmultipath/blacklist.c |=C2=A0 4 ++++<br>
&gt;=C2=A0 libmultipath/discovery.c | 23 +++++++++++++++--------<br>
&gt;=C2=A0 multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 17 ++++++++++++++=
++-<br>
&gt;=C2=A0 3 files changed, 35 insertions(+), 9 deletions(-)<br>
&gt;<br>
&gt; --<br>
&gt; 1.8.3.1<br>
</div></div></blockquote></div><br></div>

--94eb2c1ab7b88d50180543a2a62f--


--===============7036940874629542454==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7036940874629542454==--
