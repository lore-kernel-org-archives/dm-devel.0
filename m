From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/4] make tur the default path checker
Date: Fri, 8 Jul 2016 08:52:31 +0200
Message-ID: <CABr-GneaU4xMj2pRTNi3X+qeo4Hm5D-DJCFL7oHq=BDFfP725w@mail.gmail.com>
References: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4100377774575570578=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466689340-5590-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: Matthias Rudolph <matthias.rudolph@hds.com>, Yacine Kheddache <yacine@alyseo.com>, device-mapper development <dm-devel@redhat.com>, "Brian King,
	IBM" <brking@linux.vnet.ibm.com>, Srinivasan Ramani <srinivas.ramani@oracle.com>, Sean Stewart <sean.stewart@netapp.com>, Shyam Sundar <g.shyamsundar@yahoo.co.in>, "Bart Brooks,
	Pivot3" <bartb@pivot3.com>, "Edward Goggin, EMC" <egoggin@emc.com>
List-Id: dm-devel.ids

--===============4100377774575570578==
Content-Type: multipart/alternative; boundary=001a11410840333a9405371a3f95

--001a11410840333a9405371a3f95
Content-Type: text/plain; charset=UTF-8

Patches 1 and 2 are merged.
I commited a patch to delete DIRECTIO and TUR checker_name settings to
replace patch 3 and 4.

Thanks.

On Thu, Jun 23, 2016 at 3:42 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Based on previous Hannes's work.
> He says:
> "For years I've been telling our customers to use the 'tur' checker
> as the current default 'directio' will cause spurious path failures
> under high load."
>
> Xose Vazquez Perez (4):
>   multipath-tools: change the default path checker from directio to tur
>   multipath-tools: update path checker info in multipath.conf.5
>   multipath-tools: replace TUR with DEFAULT_CHECKER in hwtable
>   multipath-tools: replace DIRECTIO with DEFAULT_CHECKER in hwtable
>
>  libmultipath/checkers.h    |   2 +-
>  libmultipath/hwtable.c     | 100
> ++++++++++++++++++++++-----------------------
>  multipath/multipath.conf.5 |   8 ++--
>  3 files changed, 56 insertions(+), 54 deletions(-)
>
> Cc: Shyam Sundar <g.shyamsundar@yahoo.co.in>
> Cc: Edward Goggin, EMC <egoggin@emc.com>
> Cc: Matthias Rudolph <matthias.rudolph@hds.com>
> Cc: Brian King, IBM <brking@linux.vnet.ibm.com>
> Cc: Yacine Kheddache <yacine@alyseo.com>
> Cc: Srinivasan Ramani <srinivas.ramani@oracle.com>
> Cc: Bart Brooks, Pivot3 <bartb@pivot3.com>
> Cc: Martin George <marting@netapp.com>
> Cc: Sean Stewart <sean.stewart@netapp.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> --
> 2.5.5
>
>

--001a11410840333a9405371a3f95
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Patches 1 and 2 are merged.<div>I commited a patch to dele=
te DIRECTIO and TUR checker_name settings to replace patch 3 and 4.</div><d=
iv><br></div><div>Thanks.</div></div><div class=3D"gmail_extra"><br><div cl=
ass=3D"gmail_quote">On Thu, Jun 23, 2016 at 3:42 PM, Xose Vazquez Perez <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" target=3D"_bla=
nk">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gm=
ail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-le=
ft:1ex">Based on previous Hannes&#39;s work.<br>
He says:<br>
&quot;For years I&#39;ve been telling our customers to use the &#39;tur&#39=
; checker<br>
as the current default &#39;directio&#39; will cause spurious path failures=
<br>
under high load.&quot;<br>
<br>
Xose Vazquez Perez (4):<br>
=C2=A0 multipath-tools: change the default path checker from directio to tu=
r<br>
=C2=A0 multipath-tools: update path checker info in multipath.conf.5<br>
=C2=A0 multipath-tools: replace TUR with DEFAULT_CHECKER in hwtable<br>
=C2=A0 multipath-tools: replace DIRECTIO with DEFAULT_CHECKER in hwtable<br=
>
<br>
=C2=A0libmultipath/checkers.h=C2=A0 =C2=A0 |=C2=A0 =C2=A02 +-<br>
=C2=A0libmultipath/hwtable.c=C2=A0 =C2=A0 =C2=A0| 100 +++++++++++++++++++++=
+-----------------------<br>
=C2=A0multipath/multipath.conf.5 |=C2=A0 =C2=A08 ++--<br>
=C2=A03 files changed, 56 insertions(+), 54 deletions(-)<br>
<br>
Cc: Shyam Sundar &lt;<a href=3D"mailto:g.shyamsundar@yahoo.co.in">g.shyamsu=
ndar@yahoo.co.in</a>&gt;<br>
Cc: Edward Goggin, EMC &lt;<a href=3D"mailto:egoggin@emc.com">egoggin@emc.c=
om</a>&gt;<br>
Cc: Matthias Rudolph &lt;<a href=3D"mailto:matthias.rudolph@hds.com">matthi=
as.rudolph@hds.com</a>&gt;<br>
Cc: Brian King, IBM &lt;<a href=3D"mailto:brking@linux.vnet.ibm.com">brking=
@linux.vnet.ibm.com</a>&gt;<br>
Cc: Yacine Kheddache &lt;<a href=3D"mailto:yacine@alyseo.com">yacine@alyseo=
.com</a>&gt;<br>
Cc: Srinivasan Ramani &lt;<a href=3D"mailto:srinivas.ramani@oracle.com">sri=
nivas.ramani@oracle.com</a>&gt;<br>
Cc: Bart Brooks, Pivot3 &lt;<a href=3D"mailto:bartb@pivot3.com">bartb@pivot=
3.com</a>&gt;<br>
Cc: Martin George &lt;<a href=3D"mailto:marting@netapp.com">marting@netapp.=
com</a>&gt;<br>
Cc: Sean Stewart &lt;<a href=3D"mailto:sean.stewart@netapp.com">sean.stewar=
t@netapp.com</a>&gt;<br>
Cc: Benjamin Marzinski &lt;<a href=3D"mailto:bmarzins@redhat.com">bmarzins@=
redhat.com</a>&gt;<br>
Cc: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.de">hare@suse.de</a>&gt=
;<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.5.5<br>
<br>
</font></span></blockquote></div><br></div>

--001a11410840333a9405371a3f95--


--===============4100377774575570578==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4100377774575570578==--
