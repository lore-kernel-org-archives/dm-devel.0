From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: PATCH 0/4] multipath-tools: Ceph rbd support v2
Date: Wed, 10 Aug 2016 09:55:46 +0200
Message-ID: <CABr-GndTq8hUNw8w_ES773R2LqpitkZm+=8JTfhJVktwuuSwfg@mail.gmail.com>
References: <1470657710-28081-1-git-send-email-mchristi@redhat.com>
	<CABr-Gnf1vfGOMGcP8YF2tFMy5Z2Buwp7H9iXfCzuDC-S+FE7AA@mail.gmail.com>
	<57AA2060.20708@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7796044625170819902=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <57AA2060.20708@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <mchristi@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7796044625170819902==
Content-Type: multipart/alternative; boundary=001a114109ce29beaf0539b2fa0d

--001a114109ce29beaf0539b2fa0d
Content-Type: text/plain; charset=UTF-8

Distributors will surely want to build all checkers to have the docs and
hwtable in sync with the shipped checkers, and cover the widest range of
setups.

I'd rather drop this patch or, if it proves to be a problem, merge a
variant with the rbd checker build by default and not-buildable by explicit
define.

But thanks,
Christophe


On Tue, Aug 9, 2016 at 8:26 PM, Mike Christie <mchristi@redhat.com> wrote:

> On 08/09/2016 10:36 AM, Christophe Varoqui wrote:
> > Merged.
> >
>
> Thanks.
>
> > I think it is worth advertizing here that the build now requires rados.h.
> >
>
> Sorry about adding the silly dependency. How about the attached patch to
> make the rbd checker only be built if the user requests it. In the
> documentation for my use, I will describe how to build it. This way
> majority of users will not be bothered.
>
>
> > Thanks.
> >
> > On Mon, Aug 8, 2016 at 2:01 PM, Mike Christie <mchristi@redhat.com>
> wrote:
> >
> >> The following patches made over Christophe's tree today,
> >> add Ceph rbd support for handling blacklisted devices.
> >>
> >>
> >> This is not general support for rbd and multipath. There is
> >> no boot/root support and it does not support features like
> >> multibus. My use is for HA configurations, specifically for exporting
> >> rbd images through multiple LIO instances. In this case, we have one
> >> rbd instance that has the ceph rbd exclusive lock and it can send
> >> WRITE requests. If that host becomes unreachable, then another host
> >> will grab the lock, and blacklist the original host to prevent it from
> >> sending stale IO (when blacklisted IO will be failed by the OSD).
> >>
> >> To recover from that type of scenario, this patchset adds a repair()
> >> callout to the checker. If the path is in the PATH_DOWN state this
> >> callout can be used to fix it up. For my case, I am remapping
> >> the device to flush stale IO and cleanup the old lock,
> >> and then unblacklisting the path, so it can be used again.
> >>
> >> Changes since v1:
> >> - Drop ID_UID use and implemented sysfs getuid support.
> >> - Drop settings that were defaults and follow template.
> >> - Fix ceph auth/user.
> >>
> >>
> >
> >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> >
>
>

--001a114109ce29beaf0539b2fa0d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Distributors will surely want to build all checkers to hav=
e the docs and hwtable in sync with the shipped checkers, and cover the wid=
est range of setups.<div><br></div><div>I&#39;d rather drop this patch or, =
if it proves to be a problem,=C2=A0merge a variant with the rbd checker bui=
ld by default and not-buildable by explicit define.</div><div><br></div><di=
v>But thanks,</div><div>Christophe</div><div><br></div></div><div class=3D"=
gmail_extra"><br><div class=3D"gmail_quote">On Tue, Aug 9, 2016 at 8:26 PM,=
 Mike Christie <span dir=3D"ltr">&lt;<a href=3D"mailto:mchristi@redhat.com"=
 target=3D"_blank">mchristi@redhat.com</a>&gt;</span> wrote:<br><blockquote=
 class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex">On 08/09/2016 10:36 AM, Christophe Varoqui wrote:<br>
&gt; Merged.<br>
&gt;<br>
<br>
Thanks.<br>
<span class=3D""><br>
&gt; I think it is worth advertizing here that the build now requires rados=
.h.<br>
&gt;<br>
<br>
</span>Sorry about adding the silly dependency. How about the attached patc=
h to<br>
make the rbd checker only be built if the user requests it. In the<br>
documentation for my use, I will describe how to build it. This way<br>
majority of users will not be bothered.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
&gt; Thanks.<br>
&gt;<br>
&gt; On Mon, Aug 8, 2016 at 2:01 PM, Mike Christie &lt;<a href=3D"mailto:mc=
hristi@redhat.com">mchristi@redhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt;&gt; The following patches made over Christophe&#39;s tree today,<br>
&gt;&gt; add Ceph rbd support for handling blacklisted devices.<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; This is not general support for rbd and multipath. There is<br>
&gt;&gt; no boot/root support and it does not support features like<br>
&gt;&gt; multibus. My use is for HA configurations, specifically for export=
ing<br>
&gt;&gt; rbd images through multiple LIO instances. In this case, we have o=
ne<br>
&gt;&gt; rbd instance that has the ceph rbd exclusive lock and it can send<=
br>
&gt;&gt; WRITE requests. If that host becomes unreachable, then another hos=
t<br>
&gt;&gt; will grab the lock, and blacklist the original host to prevent it =
from<br>
&gt;&gt; sending stale IO (when blacklisted IO will be failed by the OSD).<=
br>
&gt;&gt;<br>
&gt;&gt; To recover from that type of scenario, this patchset adds a repair=
()<br>
&gt;&gt; callout to the checker. If the path is in the PATH_DOWN state this=
<br>
&gt;&gt; callout can be used to fix it up. For my case, I am remapping<br>
&gt;&gt; the device to flush stale IO and cleanup the old lock,<br>
&gt;&gt; and then unblacklisting the path, so it can be used again.<br>
&gt;&gt;<br>
&gt;&gt; Changes since v1:<br>
&gt;&gt; - Drop ID_UID use and implemented sysfs getuid support.<br>
&gt;&gt; - Drop settings that were defaults and follow template.<br>
&gt;&gt; - Fix ceph auth/user.<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
</div></div><span class=3D"HOEnZb"><font color=3D"#888888">&gt; --<br>
&gt; dm-devel mailing list<br>
&gt; <a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"no=
referrer" target=3D"_blank">https://www.redhat.com/<wbr>mailman/listinfo/dm=
-devel</a><br>
&gt;<br>
<br>
</font></span></blockquote></div><br></div>

--001a114109ce29beaf0539b2fa0d--


--===============7796044625170819902==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7796044625170819902==--
