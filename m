From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: multipath-tools merges
Date: Tue, 3 Mar 2020 00:35:29 +0100
Message-ID: <CABr-GnckSFPe5aRMQgRqUR2Lg9q5nomX00pL9JKOk-qoGAweMw@mail.gmail.com>
References: <CABr-Gne_oOns4W0A4Ny4t4xRPbU3qdtS5Z6BSt7wQ0N7cRqDeQ@mail.gmail.com>
	<3f8ae4512f68c5ba0cce93e5da27bb812dd8107e.camel@suse.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6821510070975462820=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3f8ae4512f68c5ba0cce93e5da27bb812dd8107e.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <Martin.Wilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6821510070975462820==
Content-Type: multipart/alternative; boundary="000000000000241c54059fe7a5dd"

--000000000000241c54059fe7a5dd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Martin,

Thanks for pointing these missing patches.
They are now merged.

Best,
Christophe.

On Mon, Mar 2, 2020 at 10:51 PM Martin Wilck <Martin.Wilck@suse.com> wrote:

> Hi Christophe,
>
> On Mon, 2020-03-02 at 11:19 +0100, Christophe Varoqui wrote:
> > Hi ben, Martin,
> >
> > I finally catched up with your changes from october till now.
> > Please review I did not mess up the merges, then i'll commit a
> > version bump.
>
> This is great, thanks a lot!
> I admit that I was starting to get nervous :-)
>
> It seems that you missed the following patches from me, reviewed by
> Ben:
>
>  * My "Drop nr_active, and some more fixes" series from 11/19
>    - "multipathd: move set_no_path_retry() back to libmultipath"
>       Review:
> https://www.redhat.com/archives/dm-devel/2019-November/msg00099.html
>    - libmultipath: dict.c: rename duplicate set_no_path_retry()
>       Review:
> https://www.redhat.com/archives/dm-devel/2019-November/msg00100.html
>    - libmultipath: drop mpp->nr_active field
>       Review:
> https://www.redhat.com/archives/dm-devel/2019-December/msg00037.html
>    - libmultipath: fix (max_)polling_interval setting logic
>      Review:
> https://www.redhat.com/archives/dm-devel/2019-November/msg00101.html
>    - libmultipath: fix ALUA autodetection when paths are down
>      Review:
> https://www.redhat.com/archives/dm-devel/2019-November/msg00107.html
>
>  * libmultipath: fix compilation with -fno-common
>    Review:
> https://www.redhat.com/archives/dm-devel/2020-January/msg00118.html
>  * libmultipath: fix files read from config_dir (from Enzo):
>    Review (by me):
> https://www.redhat.com/archives/dm-devel/2020-February/msg00058.html
>
> Furthermore, as I indicated before, I'd like to propose a minor change on
> top of Ben's
> last series before you tag a new version. No C code changes, just build
> logic for
> unit tests, and a README. I'll post it ASAP.
>
> Regards
> Martin
>
> --
> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE
> Software Solutions Germany GmbH
> HRB 36809 (AG N=C3=BCrnberg) GF: Felix
> Imend=C3=B6rffer
>
>

--000000000000241c54059fe7a5dd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Martin,</div><div><br></div>Thanks for pointing th=
ese missing patches.<div>They are now merged.</div><div><br></div><div>Best=
,</div><div>Christophe.</div></div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr" class=3D"gmail_attr">On Mon, Mar 2, 2020 at 10:51 PM Martin Wilck =
&lt;<a href=3D"mailto:Martin.Wilck@suse.com">Martin.Wilck@suse.com</a>&gt; =
wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0=
px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hi Christ=
ophe,<br>
<br>
On Mon, 2020-03-02 at 11:19 +0100, Christophe Varoqui wrote:<br>
&gt; Hi ben, Martin,<br>
&gt; <br>
&gt; I finally catched up with your changes from october till now.<br>
&gt; Please review I did not mess up the merges, then i&#39;ll commit a<br>
&gt; version bump.<br>
<br>
This is great, thanks a lot!<br>
I admit that I was starting to get nervous :-)<br>
<br>
It seems that you missed the following patches from me, reviewed by<br>
Ben:<br>
<br>
=C2=A0* My &quot;Drop nr_active, and some more fixes&quot; series from 11/1=
9<br>
=C2=A0 =C2=A0- &quot;multipathd: move set_no_path_retry() back to libmultip=
ath&quot;<br>
=C2=A0 =C2=A0 =C2=A0 Review: <a href=3D"https://www.redhat.com/archives/dm-=
devel/2019-November/msg00099.html" rel=3D"noreferrer" target=3D"_blank">htt=
ps://www.redhat.com/archives/dm-devel/2019-November/msg00099.html</a><br>
=C2=A0 =C2=A0- libmultipath: dict.c: rename duplicate set_no_path_retry()<b=
r>
=C2=A0 =C2=A0 =C2=A0 Review: <a href=3D"https://www.redhat.com/archives/dm-=
devel/2019-November/msg00100.html" rel=3D"noreferrer" target=3D"_blank">htt=
ps://www.redhat.com/archives/dm-devel/2019-November/msg00100.html</a><br>
=C2=A0 =C2=A0- libmultipath: drop mpp-&gt;nr_active field<br>
=C2=A0 =C2=A0 =C2=A0 Review: <a href=3D"https://www.redhat.com/archives/dm-=
devel/2019-December/msg00037.html" rel=3D"noreferrer" target=3D"_blank">htt=
ps://www.redhat.com/archives/dm-devel/2019-December/msg00037.html</a><br>
=C2=A0 =C2=A0- libmultipath: fix (max_)polling_interval setting logic<br>
=C2=A0 =C2=A0 =C2=A0Review: <a href=3D"https://www.redhat.com/archives/dm-d=
evel/2019-November/msg00101.html" rel=3D"noreferrer" target=3D"_blank">http=
s://www.redhat.com/archives/dm-devel/2019-November/msg00101.html</a><br>
=C2=A0 =C2=A0- libmultipath: fix ALUA autodetection when paths are down<br>
=C2=A0 =C2=A0 =C2=A0Review: <a href=3D"https://www.redhat.com/archives/dm-d=
evel/2019-November/msg00107.html" rel=3D"noreferrer" target=3D"_blank">http=
s://www.redhat.com/archives/dm-devel/2019-November/msg00107.html</a><br>
<br>
=C2=A0* libmultipath: fix compilation with -fno-common<br>
=C2=A0 =C2=A0Review: <a href=3D"https://www.redhat.com/archives/dm-devel/20=
20-January/msg00118.html" rel=3D"noreferrer" target=3D"_blank">https://www.=
redhat.com/archives/dm-devel/2020-January/msg00118.html</a><br>
=C2=A0* libmultipath: fix files read from config_dir (from Enzo):<br>
=C2=A0 =C2=A0Review (by me): <a href=3D"https://www.redhat.com/archives/dm-=
devel/2020-February/msg00058.html" rel=3D"noreferrer" target=3D"_blank">htt=
ps://www.redhat.com/archives/dm-devel/2020-February/msg00058.html</a><br>
<br>
Furthermore, as I indicated before, I&#39;d like to propose a minor change =
on top of Ben&#39;s<br>
last series before you tag a new version. No C code changes, just build log=
ic for<br>
unit tests, and a README. I&#39;ll post it ASAP.<br>
<br>
Regards<br>
Martin<br>
<br>
-- <br>
Dr. Martin Wilck &lt;<a href=3D"mailto:mwilck@suse.com" target=3D"_blank">m=
wilck@suse.com</a>&gt;, Tel. +49 (0)911 74053 2107<br>
SUSE<br>
Software Solutions Germany GmbH <br>
HRB 36809 (AG N=C3=BCrnberg) GF: Felix<br>
Imend=C3=B6rffer<br>
<br>
</blockquote></div>

--000000000000241c54059fe7a5dd--

--===============6821510070975462820==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6821510070975462820==--
