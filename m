From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: vplex and multipath-tools
Date: Thu, 11 Aug 2016 08:57:56 +0200
Message-ID: <CABr-GndXpJvBXwqK5CViQKTgzAXvzDnv-j=19CeskswMAUi70w@mail.gmail.com>
References: <884c0b71-917f-a6bb-03ca-cd5c0848c1fb@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1604816430041039483=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <884c0b71-917f-a6bb-03ca-cd5c0848c1fb@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: stupid-test@emc.com, device-mapper development <dm-devel@redhat.com>, Edward Goggin <egoggin@emc.com>
List-Id: dm-devel.ids

--===============1604816430041039483==
Content-Type: multipart/alternative; boundary=001a1142be9a2498f80539c64964

--001a1142be9a2498f80539c64964
Content-Type: text/plain; charset=UTF-8

Thank you for this information.

Anyway, the "static path weight by serial" patch I merged solve the "not
easy to deploy site-wise" issue I raised ... in this particular vplex
topology.

For reference, more complex topologies would need new features Hannes and I
discussed earlier on the mailing-list (prioritizer stacking for example).

Regards,
Christophe

On Wed, Aug 10, 2016 at 10:36 PM, Xose Vazquez Perez <xose.vazquez@gmail.com
> wrote:

> Christophe Varoqui wrote:
>
> > Hi Ed,
> >
> > does EMC have a specific prioritizer to select the local head in a vplex
> > cross-connect setup ?
> >
> > If not, would it be useful to develop one ? ... or does a particular
> setup
> > in multipath.conf suffices (not resorting to the weightedpath
> prioritizer,
> > which is not easy to deploy site-wise) ?
> >
> > If you are no longer the appropriate person to answer, please route me
> ...
>
> I believe he no longer works at EMC since long time ago.
>
> There are no recent traces at any ml: https://marc.info/?w=2&r=1&s=+
> Edward+Goggin&q=a
>
>
> EMC MTA server does not send back an unknown user message.
>

--001a1142be9a2498f80539c64964
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thank you for this information.<div><br></div><div>Anyway,=
 the &quot;static path weight by serial&quot; patch I merged solve the &quo=
t;not easy to deploy site-wise&quot; issue I raised ... in this particular =
vplex topology.</div><div><br></div><div>For reference, more complex topolo=
gies would need new features Hannes and I discussed earlier on the mailing-=
list (prioritizer stacking for example).</div><div><br></div><div>Regards,<=
/div><div>Christophe</div></div><div class=3D"gmail_extra"><br><div class=
=3D"gmail_quote">On Wed, Aug 10, 2016 at 10:36 PM, Xose Vazquez Perez <span=
 dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_blank=
">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex">Christophe Varoqui wrote:<br>
<br>
&gt; Hi Ed,<br>
&gt;<br>
&gt; does EMC have a specific prioritizer to select the local head in a vpl=
ex<br>
&gt; cross-connect setup ?<br>
&gt;<br>
&gt; If not, would it be useful to develop one ? ... or does a particular s=
etup<br>
&gt; in multipath.conf suffices (not resorting to the weightedpath prioriti=
zer,<br>
&gt; which is not easy to deploy site-wise) ?<br>
&gt;<br>
&gt; If you are no longer the appropriate person to answer, please route me=
 ...<br>
<br>
I believe he no longer works at EMC since long time ago.<br>
<br>
There are no recent traces at any ml: <a href=3D"https://marc.info/?w=3D2&a=
mp;r=3D1&amp;s=3D+Edward+Goggin&amp;q=3Da" rel=3D"noreferrer" target=3D"_bl=
ank">https://marc.info/?w=3D2&amp;r=3D1&amp;s=3D+<wbr>Edward+Goggin&amp;q=
=3Da</a><br>
<br>
<br>
EMC MTA server does not send back an unknown user message.<br>
</blockquote></div><br></div>

--001a1142be9a2498f80539c64964--


--===============1604816430041039483==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1604816430041039483==--
