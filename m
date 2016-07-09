From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/6] Delete attributes with default values
Date: Sat, 9 Jul 2016 10:17:05 +0200
Message-ID: <CABr-GncP-rzeXogT1EFZTtFrre2UUSV6i-AJ27GZ3mTvcxx-7Q@mail.gmail.com>
References: <1468022328-5905-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8316871660372430581=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468022328-5905-1-git-send-email-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============8316871660372430581==
Content-Type: multipart/alternative; boundary=001a1141084075170105372f8ba4

--001a1141084075170105372f8ba4
Content-Type: text/plain; charset=UTF-8

I'll wait for comments from distribution maintainers on this patchset.

Because, though we have already deleted the checker_name settings when
equal to the default value, it should be clear that with this patchset
changing a default may cause re-certification for all impacted devices.
This can be viewed as a problem for distributors.

Hannes, Ben, do you ack this patchset ? If not, what do we do the
checker_name settings, that I understood Hannes wanted to switch to TUR
anyway.


On Sat, Jul 9, 2016 at 1:58 AM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> Xose Vazquez Perez (6):
>   multipath-tools: delete attributes with DEFAULT_* values in hwtable.c
>   multipath-tools: delete prio_args attribute when it is equal to default
> value
>   multipath-tools: delete no_path_retry attribute when it is equal to
> default value
>   multipath-tools: delete minio_rq attribute when it is equal to default
> value
>   multipath-tools: delete fast_io_fail attribute when it is equal to
> default value
>   multipath-tools: delete pgpolicy attribute when it is equal to default
> value
>
>  libmultipath/hwtable.c | 226
> -------------------------------------------------
>  1 file changed, 226 deletions(-)
>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
>
> --
> 2.7.4
>
>

--001a1141084075170105372f8ba4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I&#39;ll wait for comments from distribution maintainers o=
n this patchset.<div><br></div><div>Because, though we have already deleted=
 the checker_name settings when equal to the default value, it should be cl=
ear that with this patchset changing a default may cause re-certification f=
or all impacted devices. This can be viewed as a problem for distributors.<=
/div><div><br></div><div>Hannes, Ben, do you ack this patchset ? If not, wh=
at do we do the checker_name settings, that I understood Hannes wanted to s=
witch to TUR anyway.</div><div><br></div></div><div class=3D"gmail_extra"><=
br><div class=3D"gmail_quote">On Sat, Jul 9, 2016 at 1:58 AM, Xose Vazquez =
Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:xose.vazquez@gmail.com" targe=
t=3D"_blank">xose.vazquez@gmail.com</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex">Xose Vazquez Perez (6):<br>
=C2=A0 multipath-tools: delete attributes with DEFAULT_* values in hwtable.=
c<br>
=C2=A0 multipath-tools: delete prio_args attribute when it is equal to defa=
ult value<br>
=C2=A0 multipath-tools: delete no_path_retry attribute when it is equal to =
default value<br>
=C2=A0 multipath-tools: delete minio_rq attribute when it is equal to defau=
lt value<br>
=C2=A0 multipath-tools: delete fast_io_fail attribute when it is equal to d=
efault value<br>
=C2=A0 multipath-tools: delete pgpolicy attribute when it is equal to defau=
lt value<br>
<br>
=C2=A0libmultipath/hwtable.c | 226 ----------------------------------------=
---------<br>
=C2=A01 file changed, 226 deletions(-)<br>
<br>
Cc: Christophe Varoqui &lt;<a href=3D"mailto:christophe.varoqui@opensvc.com=
">christophe.varoqui@opensvc.com</a>&gt;<br>
Cc: device-mapper development &lt;<a href=3D"mailto:dm-devel@redhat.com">dm=
-devel@redhat.com</a>&gt;<br>
Signed-off-by: Xose Vazquez Perez &lt;<a href=3D"mailto:xose.vazquez@gmail.=
com">xose.vazquez@gmail.com</a>&gt;<br>
<br>
--<br>
2.7.4<br>
<br>
</blockquote></div><br></div>

--001a1141084075170105372f8ba4--


--===============8316871660372430581==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8316871660372430581==--
