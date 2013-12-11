From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: Added missing variable
	declaration
Date: Wed, 11 Dec 2013 06:45:51 +0100
Message-ID: <CABr-GndB_j3m3kw3_sM-4RHRjA_C5zoOoACJ72qS-Rmu+eKZgA@mail.gmail.com>
References: <CAACFEQBRAk=W4ymRuvCYGxuF4K_wZdBw9HH0VgnhU3ThOAa-3A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3677232149969863278=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAACFEQBRAk=W4ymRuvCYGxuF4K_wZdBw9HH0VgnhU3ThOAa-3A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

--===============3677232149969863278==
Content-Type: multipart/alternative; boundary=001a11c3ad4cebabae04ed3bbd4f

--001a11c3ad4cebabae04ed3bbd4f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Applied,
Thanks.

Christophe Varoqui
www.opensvc.com


On Mon, Dec 9, 2013 at 9:37 PM, Mateusz P=C3=B3=C5=82rola
<mateusz.polrola@gmail.com>wrote:

> Declaration of envp variable in child function is missing
>
> ---
>  multipathd/main.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 7c0e313..2d6aac8 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1609,6 +1609,7 @@ child (void * param)
>   struct multipath * mpp;
>   int i;
>   int rc, pid_rc;
> + char *envp;
>
>   mlockall(MCL_CURRENT | MCL_FUTURE);
>   sem_init(&exit_sem, 0, 0);
> --
> 1.8.4.2
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11c3ad4cebabae04ed3bbd4f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Applied,<div>Thanks.</div><div><br></div><div>Christophe V=
aroqui</div><div><a href=3D"http://www.opensvc.com">www.opensvc.com</a></di=
v></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Mo=
n, Dec 9, 2013 at 9:37 PM, Mateusz P=C3=B3=C5=82rola <span dir=3D"ltr">&lt;=
<a href=3D"mailto:mateusz.polrola@gmail.com" target=3D"_blank">mateusz.polr=
ola@gmail.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div><div><div>Declaration =
of envp variable in child function is missing</div><div><br></div><div>---<=
/div>
<div>=C2=A0multipathd/main.c | 1 +</div><div>=C2=A01 file changed, 1 insert=
ion(+)</div><div><br></div><div>diff --git a/multipathd/main.c b/multipathd=
/main.c</div>
<div>index 7c0e313..2d6aac8 100644</div><div>--- a/multipathd/main.c</div><=
div>+++ b/multipathd/main.c</div><div>@@ -1609,6 +1609,7 @@ child (void * p=
aram)</div><div>=C2=A0<span style=3D"white-space:pre-wrap">	</span>struct m=
ultipath * mpp;</div>

<div>=C2=A0<span style=3D"white-space:pre-wrap">	</span>int i;</div><div>=
=C2=A0<span style=3D"white-space:pre-wrap">	</span>int rc, pid_rc;</div><di=
v>+<span style=3D"white-space:pre-wrap">	</span>char *envp;</div><div>=C2=
=A0</div>
<div>=C2=A0<span style=3D"white-space:pre-wrap">	</span>mlockall(MCL_CURREN=
T | MCL_FUTURE);</div><div>=C2=A0<span style=3D"white-space:pre-wrap">	</sp=
an>sem_init(&amp;exit_sem, 0, 0);</div><span class=3D"HOEnZb"><font color=
=3D"#888888"><div>
--=C2=A0</div><div>1.8.4.2</div></font></span></div>
</div><div><br></div></div>
<br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" target=3D"_bla=
nk">https://www.redhat.com/mailman/listinfo/dm-devel</a><br></blockquote></=
div><br></div>

--001a11c3ad4cebabae04ed3bbd4f--


--===============3677232149969863278==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3677232149969863278==--
