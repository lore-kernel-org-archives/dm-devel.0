From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/3][RESEND] resending find_multipaths patches
Date: Sat, 14 Mar 2015 10:57:55 +0100
Message-ID: <CABr-GneV8rT5F0eLxrvvj1dUOqmwuXcsMeGrTqZTv7OzEcmrPQ@mail.gmail.com>
References: <1426271247-21345-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8721103611207747706=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426271247-21345-1-git-send-email-bmarzins@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8721103611207747706==
Content-Type: multipart/alternative; boundary=20cf30334cb9b4848305113ca681

--20cf30334cb9b4848305113ca681
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ben,

I'm ready to merge this patchset now.
Waiting for Hannes ack.

Regards,
Christophe Varoqui
OpenSVC
Le 13 mars 2015 19:27, "Benjamin Marzinski" <bmarzins@redhat.com> a =C3=A9c=
rit :

> I'm resending my find_multipaths patch, based on the conversation I had
> here. If nothing else, I'd at least like a discussion about why these
> shouldn't go in.
>
> http://www.redhat.com/archives/dm-devel/2014-July/msg00029.html
>
> Just to clarify. find_multipaths is a configurable option that when set t=
o
> 'yes' will make multipath only run on devices have more than one path.
> This
> means that users can mostly leave the blacklist alone, and they will only
> get
> the multipath devices that they want. The only time the blacklist is
> necessary
> is when users actually have multiple paths to a device, but still don't
> want
> multipath set up on it.  It's been around since RHEL6, and it is turned o=
n
> in the default multipath.conf file in RHEL7. The internal default is "off=
".
>
> Hannes, do you still object to these?
>
> Benjamin Marzinski (3):
>   add find_multipaths option
>   libmultipath: only add uninitialized paths in check_path
>   Add find_multipaths to multipath.conf man page
>
>  libmultipath/config.c      |  1 +
>  libmultipath/config.h      |  1 +
>  libmultipath/configure.c   | 11 +++++++++++
>  libmultipath/defaults.h    |  1 +
>  libmultipath/dict.c        |  4 ++++
>  libmultipath/discovery.c   |  2 ++
>  libmultipath/structs.h     |  1 +
>  libmultipath/wwids.c       | 26 ++++++++++++++++++++++++++
>  libmultipath/wwids.h       |  1 +
>  multipath/main.c           | 27 +++++++++++++++++++++++++--
>  multipath/multipath.conf.5 | 22 ++++++++++++++++++++++
>  multipathd/main.c          |  9 +++++++++
>  12 files changed, 104 insertions(+), 2 deletions(-)
>
> --
> 1.8.3.1
>
>

--20cf30334cb9b4848305113ca681
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Ben,</p>
<p dir=3D"ltr">I&#39;m ready to merge this patchset now. <br>
Waiting for Hannes ack.</p>
<p dir=3D"ltr">Regards,<br>
Christophe Varoqui <br>
OpenSVC </p>
<div class=3D"gmail_quote">Le 13 mars 2015 19:27, &quot;Benjamin Marzinski&=
quot; &lt;<a href=3D"mailto:bmarzins@redhat.com">bmarzins@redhat.com</a>&gt=
; a =C3=A9crit :<br type=3D"attribution"><blockquote class=3D"gmail_quote" =
style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">I&#=
39;m resending my find_multipaths patch, based on the conversation I had<br=
>
here. If nothing else, I&#39;d at least like a discussion about why these<b=
r>
shouldn&#39;t go in.<br>
<br>
<a href=3D"http://www.redhat.com/archives/dm-devel/2014-July/msg00029.html"=
 target=3D"_blank">http://www.redhat.com/archives/dm-devel/2014-July/msg000=
29.html</a><br>
<br>
Just to clarify. find_multipaths is a configurable option that when set to<=
br>
&#39;yes&#39; will make multipath only run on devices have more than one pa=
th.=C2=A0 This<br>
means that users can mostly leave the blacklist alone, and they will only g=
et<br>
the multipath devices that they want. The only time the blacklist is necess=
ary<br>
is when users actually have multiple paths to a device, but still don&#39;t=
 want<br>
multipath set up on it.=C2=A0 It&#39;s been around since RHEL6, and it is t=
urned on<br>
in the default multipath.conf file in RHEL7. The internal default is &quot;=
off&quot;.<br>
<br>
Hannes, do you still object to these?<br>
<br>
Benjamin Marzinski (3):<br>
=C2=A0 add find_multipaths option<br>
=C2=A0 libmultipath: only add uninitialized paths in check_path<br>
=C2=A0 Add find_multipaths to multipath.conf man page<br>
<br>
=C2=A0libmultipath/config.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/config.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/configure.c=C2=A0 =C2=A0| 11 +++++++++++<br>
=C2=A0libmultipath/defaults.h=C2=A0 =C2=A0 |=C2=A0 1 +<br>
=C2=A0libmultipath/dict.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 4 ++++<br>
=C2=A0libmultipath/discovery.c=C2=A0 =C2=A0|=C2=A0 2 ++<br>
=C2=A0libmultipath/structs.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 1 +<br>
=C2=A0libmultipath/wwids.c=C2=A0 =C2=A0 =C2=A0 =C2=A0| 26 +++++++++++++++++=
+++++++++<br>
=C2=A0libmultipath/wwids.h=C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 1 +<br>
=C2=A0multipath/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 27 +++++++=
++++++++++++++++++--<br>
=C2=A0multipath/multipath.conf.5 | 22 ++++++++++++++++++++++<br>
=C2=A0multipathd/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 9 +++++++=
++<br>
=C2=A012 files changed, 104 insertions(+), 2 deletions(-)<br>
<br>
--<br>
1.8.3.1<br>
<br>
</blockquote></div>

--20cf30334cb9b4848305113ca681--


--===============8721103611207747706==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8721103611207747706==--
