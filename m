From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipathd: revert mpp size update if map
	update fails
Date: Fri, 25 Oct 2013 07:44:26 +0200
Message-ID: <CABr-Gnd4Y+t99-hescDK8KGnSSE88CnJpAGjjhAM62xomQE97g@mail.gmail.com>
References: <1382662255-7861-1-git-send-email-michaelc@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6926401909836597701=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1382662255-7861-1-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============6926401909836597701==
Content-Type: multipart/alternative; boundary=047d7bdca5044f790304e98a3e9c

--047d7bdca5044f790304e98a3e9c
Content-Type: text/plain; charset=ISO-8859-1

Oh yes. Applied.
Thanks.


On Fri, Oct 25, 2013 at 2:50 AM, <michaelc@cs.wisc.edu> wrote:

> From: Mike Christie <michaelc@cs.wisc.edu>
>
> If updating the dm device in the kernel fails we cannot leave
> the mpp size updated, because if we correct the problem and
> try to resize later multipathd prevents resizing the device
> of the size has not changed.
>
> I hit this when all paths to a dm-multipath device where not
> yet updated but multipathd resize was run.
>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  multipathd/cli_handlers.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 4b860bb..58a5643 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -567,6 +567,7 @@ int resize_map(struct multipath *mpp, unsigned long
> long size,
>                struct vectors * vecs)
>  {
>         char params[PARAMS_SIZE] = {0};
> +       unsigned long long orig_size = mpp->size;
>
>         mpp->size = size;
>         update_mpp_paths(mpp, vecs->pathvec);
> @@ -575,6 +576,7 @@ int resize_map(struct multipath *mpp, unsigned long
> long size,
>         if (domap(mpp, params) <= 0) {
>                 condlog(0, "%s: failed to resize map : %s", mpp->alias,
>                         strerror(errno));
> +               mpp->size = orig_size;
>                 return 1;
>         }
>         return 0;
> --
> 1.7.1
>
>

--047d7bdca5044f790304e98a3e9c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Oh yes. Applied.<div style>Thanks.</div></div><div class=
=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Fri, Oct 25, 2013 at=
 2:50 AM,  <span dir=3D"ltr">&lt;<a href=3D"mailto:michaelc@cs.wisc.edu" ta=
rget=3D"_blank">michaelc@cs.wisc.edu</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">From: Mike Christie &lt;<a href=3D"mailto:mi=
chaelc@cs.wisc.edu">michaelc@cs.wisc.edu</a>&gt;<br>
<br>
If updating the dm device in the kernel fails we cannot leave<br>
the mpp size updated, because if we correct the problem and<br>
try to resize later multipathd prevents resizing the device<br>
of the size has not changed.<br>
<br>
I hit this when all paths to a dm-multipath device where not<br>
yet updated but multipathd resize was run.<br>
<br>
Signed-off-by: Mike Christie &lt;<a href=3D"mailto:michaelc@cs.wisc.edu">mi=
chaelc@cs.wisc.edu</a>&gt;<br>
---<br>
=A0multipathd/cli_handlers.c | =A0 =A02 ++<br>
=A01 files changed, 2 insertions(+), 0 deletions(-)<br>
<br>
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c<br>
index 4b860bb..58a5643 100644<br>
--- a/multipathd/cli_handlers.c<br>
+++ b/multipathd/cli_handlers.c<br>
@@ -567,6 +567,7 @@ int resize_map(struct multipath *mpp, unsigned long lon=
g size,<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct vectors * vecs)<br>
=A0{<br>
=A0 =A0 =A0 =A0 char params[PARAMS_SIZE] =3D {0};<br>
+ =A0 =A0 =A0 unsigned long long orig_size =3D mpp-&gt;size;<br>
<br>
=A0 =A0 =A0 =A0 mpp-&gt;size =3D size;<br>
=A0 =A0 =A0 =A0 update_mpp_paths(mpp, vecs-&gt;pathvec);<br>
@@ -575,6 +576,7 @@ int resize_map(struct multipath *mpp, unsigned long lon=
g size,<br>
=A0 =A0 =A0 =A0 if (domap(mpp, params) &lt;=3D 0) {<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 condlog(0, &quot;%s: failed to resize map :=
 %s&quot;, mpp-&gt;alias,<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strerror(errno));<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 mpp-&gt;size =3D orig_size;<br>
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;<br>
=A0 =A0 =A0 =A0 }<br>
=A0 =A0 =A0 =A0 return 0;<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
1.7.1<br>
<br>
</font></span></blockquote></div><br></div>

--047d7bdca5044f790304e98a3e9c--


--===============6926401909836597701==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6926401909836597701==--
