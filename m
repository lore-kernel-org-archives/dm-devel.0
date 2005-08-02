From: Christopher Weis <ccweis@gmail.com>
Subject: Re: RE: dm-devel Digest, Vol 18, Issue 2
Date: Tue, 2 Aug 2005 16:49:08 -0500
Message-ID: <d6dcfcc90508021449d4de066@mail.gmail.com>
References: <C2EEB4E538D3DC48BF57F391F422779321AB99@SRMANNING.eng.emc.com>
	<1123014429.20148.3.camel@zezette>
Reply-To: Christopher Weis <ccweis@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0737662036=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1123014429.20148.3.camel@zezette>
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

--===============0737662036==
Content-Type: multipart/alternative;
	boundary="----=_Part_7289_3147098.1123019348799"

------=_Part_7289_3147098.1123019348799
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 8/2/05, christophe varoqui <christophe.varoqui@free.fr> wrote:
>=20
> On mar, 2005-08-02 at 15:07 -0400, goggin, edward wrote:
> > On Tue, 02 Aug 2005 09:37:14 -0500
> > "Christopher C. Weis" <ccweis@gmail.com> wrote
> >
> > > I have a multipath SAN environment with storage controllers that are
> > > active/active. However, the controllers are not active/active at the
> > > LUN-level without a performance penalty, meaning if two
> > > servers want to
> > > see the same LUN (as in a clustered filesystem environment), they bot=
h
> > > need to be using the same controller. I'm trying to figure
> > > out a way to
> > > statically "order" the paths so that I can copy a config to all of th=
e
> > > nodes using the CFS.
> > >
> > > >From what I've read, in a single-server environment with controllers
> > > such as the ones I'm dealing with, the path_grouping_policy should be
> > > set to "group_by_serial", which should work fine, but in a clustered
> > > environment, I need to be sure that the path ordering is the same.
> > >
> > > Are there any path_selectors, other than round-robin, that might
> > > accomplish this? Any other ideas?
> > >
> >
> > One was is to configure each multipath to have two groups with one grou=
p
> > having a higher priority than the other based on whether the path=20
> accesses
> > the fast path controller. The assignment of the highest priority path=
=20
> group
> > is non deterministic when using the "group_by_serial" path grouping=20
> policy.
> >
> > Seems like you want to use the "group_by_priority" path grouping policy=
=20
> and
> > create and get_priority executable which when invoked will return a 1=
=20
> for
> > fast path and 0 for slow path. See the code for mpath_prio_emc, the
> > get_priority executable for the EMC CLARiiON array in
> > multipath-tools/path_priority/pp_emc/pp_emc.c.
> >
> Yes, also note "group_by_priority" path grouping policy may be overkill
> for the context. PG produced by "group_by_serial" can be sorted with an
> adequate prioritizer too.
>=20
>=20
>=20
Does this mean that "group_by_serial" utilizes a "default_prio_callout"=20
program/script as well, or is there another callout (or something totally=
=20
different that I'm missing)?

Thx.

~Chris

------=_Part_7289_3147098.1123019348799
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 8/2/05, <b class=3D"gmail_sendername">christophe varoqui</b> &lt;<a href=
=3D"mailto:christophe.varoqui@free.fr">christophe.varoqui@free.fr</a>&gt; w=
rote:<div><span class=3D"gmail_quote"></span><blockquote class=3D"gmail_quo=
te" style=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt=
 0.8ex; padding-left: 1ex;">
On mar, 2005-08-02 at 15:07 -0400, goggin, edward wrote:<br>&gt; On Tue, 02=
 Aug 2005 09:37:14 -0500<br>&gt; &quot;Christopher C. Weis&quot; &lt;<a hre=
f=3D"mailto:ccweis@gmail.com">ccweis@gmail.com</a>&gt; wrote<br>&gt;<br>&gt=
; &gt; I have a multipath SAN environment with storage controllers that are
<br>&gt; &gt; active/active.&nbsp;&nbsp;However, the controllers are not ac=
tive/active at the<br>&gt; &gt; LUN-level without a performance penalty, me=
aning if two<br>&gt; &gt; servers want to<br>&gt; &gt; see the same LUN (as=
 in a clustered filesystem environment), they both
<br>&gt; &gt; need to be using the same controller.&nbsp;&nbsp;I'm trying t=
o figure<br>&gt; &gt; out a way to<br>&gt; &gt; statically &quot;order&quot=
; the paths so that I can copy a config to all of the<br>&gt; &gt; nodes us=
ing the CFS.
<br>&gt; &gt;<br>&gt; &gt; &gt;From what I've read, in a single-server envi=
ronment with controllers<br>&gt; &gt; such as the ones I'm dealing with, th=
e path_grouping_policy should be<br>&gt; &gt; set to &quot;group_by_serial&=
quot;, which should work fine, but in a clustered
<br>&gt; &gt; environment, I need to be sure that the path ordering is the =
same.<br>&gt; &gt;<br>&gt; &gt; Are there any path_selectors, other than ro=
und-robin, that might<br>&gt; &gt; accomplish this?&nbsp;&nbsp;Any other id=
eas?<br>
&gt; &gt;<br>&gt;<br>&gt; One was is to configure each multipath to have tw=
o groups with one group<br>&gt; having a higher priority than the other bas=
ed on whether the path accesses<br>&gt; the fast path controller.&nbsp;&nbs=
p;The assignment of the highest priority path group
<br>&gt; is non deterministic when using the &quot;group_by_serial&quot; pa=
th grouping policy.<br>&gt;<br>&gt; Seems like you want to use the &quot;gr=
oup_by_priority&quot; path grouping policy and<br>&gt; create and get_prior=
ity executable which when invoked will return a 1 for
<br>&gt; fast path and 0 for slow path.&nbsp;&nbsp;See the code for mpath_p=
rio_emc, the<br>&gt; get_priority executable for the EMC CLARiiON array in<=
br>&gt; multipath-tools/path_priority/pp_emc/pp_emc.c.<br>&gt;<br>Yes, also=
 note &quot;group_by_priority&quot; path grouping policy may be overkill
<br>for the context. PG produced by &quot;group_by_serial&quot; can be sort=
ed with an<br>adequate prioritizer too.<br><br><br>
</blockquote></div><br>Does this mean that &quot;group_by_serial&quot; util=
izes a &quot;default_prio_callout&quot;
program/script as well, or is there another callout (or something
totally different that I'm missing)?<br clear=3D"all"><br>
Thx.<br>
<br>
~Chris<br>

------=_Part_7289_3147098.1123019348799--


--===============0737662036==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0737662036==--
