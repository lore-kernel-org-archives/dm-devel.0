From: Christopher Weis <ccweis@gmail.com>
Subject: Re: RE: dm-devel Digest, Vol 18, Issue 2
Date: Tue, 2 Aug 2005 22:01:14 -0500
Message-ID: <d6dcfcc90508022001702e46c9@mail.gmail.com>
References: <C2EEB4E538D3DC48BF57F391F422779321AB99@SRMANNING.eng.emc.com>
	<1123014429.20148.3.camel@zezette>
	<d6dcfcc90508021449d4de066@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2112412839=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d6dcfcc90508021449d4de066@mail.gmail.com>
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

--===============2112412839==
Content-Type: multipart/alternative;
	boundary="----=_Part_149_5273884.1123038074398"

------=_Part_149_5273884.1123038074398
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 8/2/05, Christopher Weis <ccweis@gmail.com> wrote:
>=20
> On 8/2/05, christophe varoqui <christophe.varoqui@free.fr> wrote:
> >=20
> > On mar, 2005-08-02 at 15:07 -0400, goggin, edward wrote:
> > > On Tue, 02 Aug 2005 09:37:14 -0500
> > > "Christopher C. Weis" <ccweis@gmail.com> wrote
> > >
> > > > I have a multipath SAN environment with storage controllers that ar=
e=20
> >=20
> > > > active/active. However, the controllers are not active/active at th=
e
> > > > LUN-level without a performance penalty, meaning if two
> > > > servers want to
> > > > see the same LUN (as in a clustered filesystem environment), they=
=20
> > both=20
> > > > need to be using the same controller. I'm trying to figure
> > > > out a way to
> > > > statically "order" the paths so that I can copy a config to all of=
=20
> > the
> > > > nodes using the CFS.=20
> > > >
> > > > >From what I've read, in a single-server environment with=20
> > controllers
> > > > such as the ones I'm dealing with, the path_grouping_policy should=
=20
> > be
> > > > set to "group_by_serial", which should work fine, but in a clustere=
d=20
> >=20
> > > > environment, I need to be sure that the path ordering is the same.
> > > >
> > > > Are there any path_selectors, other than round-robin, that might
> > > > accomplish this? Any other ideas?
> > > >
> > >
> > > One was is to configure each multipath to have two groups with one=20
> > group
> > > having a higher priority than the other based on whether the path=20
> > accesses
> > > the fast path controller. The assignment of the highest priority path=
=20
> > group=20
> > > is non deterministic when using the "group_by_serial" path grouping=
=20
> > policy.
> > >
> > > Seems like you want to use the "group_by_priority" path grouping=20
> > policy and
> > > create and get_priority executable which when invoked will return a 1=
=20
> > for=20
> > > fast path and 0 for slow path. See the code for mpath_prio_emc, the
> > > get_priority executable for the EMC CLARiiON array in
> > > multipath-tools/path_priority/pp_emc/pp_emc.c.
> > >
> > Yes, also note "group_by_priority" path grouping policy may be overkill=
=20
> > for the context. PG produced by "group_by_serial" can be sorted with an
> > adequate prioritizer too.
> >=20
> >=20
> >=20
> Does this mean that "group_by_serial" utilizes a "default_prio_callout"=
=20
> program/script as well, or is there another callout (or something totally=
=20
> different that I'm missing)?


I've verified that by writing my own "default_prio_callout" script I can=20
achieve what I want with both the "group_by_priority" and "failover"=20
policies. Once I get done testing/tweaking the script, I'll post it in case=
=20
anyone else wants it.

I can't seem to make group_by_serial work, although I'm not sure I=20
understand this policy very well. It sounds like it's supposed to make all=
=20
paths that go to a particular controller (serial?) be in the same priority=
=20
group. For me, it's no different than multibus. Probably my=20
misunderstanding, so I'm open to any suggestions...

Thanks for all the help everyone.

~Chris

------=_Part_149_5273884.1123038074398
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 8/2/05, <b class=3D"gmail_sendername">Christopher Weis</b> &lt;<a href=
=3D"mailto:ccweis@gmail.com">ccweis@gmail.com</a>&gt; wrote:<div><span clas=
s=3D"gmail_quote"></span><blockquote class=3D"gmail_quote" style=3D"border-=
left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left=
: 1ex;">
<div><span class=3D"e" id=3D"q_105792b5aaa743c4_0">On 8/2/05, <b class=3D"g=
mail_sendername">christophe varoqui</b> &lt;<a href=3D"mailto:christophe.va=
roqui@free.fr" target=3D"_blank" onclick=3D"return top.js.OpenExtLink(windo=
w,event,this)">
christophe.varoqui@free.fr</a>&gt; wrote:<div><span class=3D"gmail_quote"><=
/span><blockquote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb=
(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
On mar, 2005-08-02 at 15:07 -0400, goggin, edward wrote:<br>&gt; On Tue, 02=
 Aug 2005 09:37:14 -0500<br>&gt; &quot;Christopher C. Weis&quot; &lt;<a hre=
f=3D"mailto:ccweis@gmail.com" target=3D"_blank" onclick=3D"return top.js.Op=
enExtLink(window,event,this)">
ccweis@gmail.com</a>&gt; wrote<br>&gt;<br>&gt; &gt; I have a multipath SAN =
environment with storage controllers that are
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
</blockquote></div><br></span></div>Does this mean that &quot;group_by_seri=
al&quot; utilizes a &quot;default_prio_callout&quot;
program/script as well, or is there another callout (or something
totally different that I'm missing)?</blockquote><div><br>
I've verified that by writing my own &quot;default_prio_callout&quot; scrip=
t I
can achieve what I want with both the &quot;group_by_priority&quot; and
&quot;failover&quot; policies.&nbsp; Once I get done testing/tweaking the s=
cript,
I'll post it in case anyone else wants it.<br>
<br>
I can't seem to make group_by_serial work, although I'm not sure I
understand this policy very well.&nbsp; It sounds like it's supposed to
make all paths that go to a particular controller (serial?) be in the
same priority group.&nbsp; For me, it's no different than
multibus.&nbsp; Probably my misunderstanding, so I'm open to any
suggestions...<br>
<br>
Thanks for all the help everyone.<br>
<br>
~Chris<br>
</div></div>

------=_Part_149_5273884.1123038074398--


--===============2112412839==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2112412839==--
