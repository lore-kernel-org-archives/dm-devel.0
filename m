From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] multipath: fix multipath -l <devmap> without
	output
Date: Sun, 31 Jul 2016 10:57:44 +0200
Message-ID: <CABr-GncKxQGA-wPnnUvbmiyBek332jAZ3CSc6ZO+XEQw58YaOw@mail.gmail.com>
References: <1469454098-4423-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0287838046599102198=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1469454098-4423-1-git-send-email-mauricfo@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0287838046599102198==
Content-Type: multipart/alternative; boundary=001a1140211e5554ec0538eaadfc

--001a1140211e5554ec0538eaadfc
Content-Type: text/plain; charset=UTF-8

Merged.
Thanks.

On Mon, Jul 25, 2016 at 3:41 PM, Mauricio Faria de Oliveira <
mauricfo@linux.vnet.ibm.com> wrote:

> Currently, the multipath -l <devmap> output is empty, and an error
> is printed to syslog:
>
>     # ./multipath -l mpatha
>     #
>
>     # echo $?
>     1
>
>     # tail /var/log/messages
>     ...
>     ... multipath: mpatha: can't get udev device
>
> That's due to dev_type not being initialized, and incorrectly evaluated.
> So, initialize it to DEV_NONE, which is verified/reset by get_dev_type().
>
> Now there's actual output and no error in syslog:
>
>     # ./multipath -l mpatha
>     mpatha (3600a0b800011e95c000055d855167d1c) dm-0 IBM,1815      FAStT
>     ...
>
>     # echo $?
>     0
>
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
>
> (tested on '2613ce0 Bump version code to 0.6.2')
> ---
>  multipath/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/multipath/main.c b/multipath/main.c
> index 6ccece7..93376a9 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -511,7 +511,7 @@ main (int argc, char *argv[])
>         extern int optind;
>         int r = 1;
>         enum mpath_cmds cmd = CMD_CREATE;
> -       enum devtypes dev_type;
> +       enum devtypes dev_type = DEV_NONE;
>         char *dev = NULL;
>         struct config *conf;
>
> --
> 1.8.3.1
>
>

--001a1140211e5554ec0538eaadfc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.<div>Thanks.</div></div><div class=3D"gmail_extra">=
<br><div class=3D"gmail_quote">On Mon, Jul 25, 2016 at 3:41 PM, Mauricio Fa=
ria de Oliveira <span dir=3D"ltr">&lt;<a href=3D"mailto:mauricfo@linux.vnet=
.ibm.com" target=3D"_blank">mauricfo@linux.vnet.ibm.com</a>&gt;</span> wrot=
e:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex">Currently, the multipath -l &lt;devmap=
&gt; output is empty, and an error<br>
is printed to syslog:<br>
<br>
=C2=A0 =C2=A0 # ./multipath -l mpatha<br>
=C2=A0 =C2=A0 #<br>
<br>
=C2=A0 =C2=A0 # echo $?<br>
=C2=A0 =C2=A0 1<br>
<br>
=C2=A0 =C2=A0 # tail /var/log/messages<br>
=C2=A0 =C2=A0 ...<br>
=C2=A0 =C2=A0 ... multipath: mpatha: can&#39;t get udev device<br>
<br>
That&#39;s due to dev_type not being initialized, and incorrectly evaluated=
.<br>
So, initialize it to DEV_NONE, which is verified/reset by get_dev_type().<b=
r>
<br>
Now there&#39;s actual output and no error in syslog:<br>
<br>
=C2=A0 =C2=A0 # ./multipath -l mpatha<br>
=C2=A0 =C2=A0 mpatha (3600a0b800011e95c000055d855167d1c) dm-0 IBM,1815=C2=
=A0 =C2=A0 =C2=A0 FAStT<br>
=C2=A0 =C2=A0 ...<br>
<br>
=C2=A0 =C2=A0 # echo $?<br>
=C2=A0 =C2=A0 0<br>
<br>
Signed-off-by: Mauricio Faria de Oliveira &lt;<a href=3D"mailto:mauricfo@li=
nux.vnet.ibm.com">mauricfo@linux.vnet.ibm.com</a>&gt;<br>
<br>
(tested on &#39;2613ce0 Bump version code to 0.6.2&#39;)<br>
---<br>
=C2=A0multipath/main.c | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/multipath/main.c b/multipath/main.c<br>
index 6ccece7..93376a9 100644<br>
--- a/multipath/main.c<br>
+++ b/multipath/main.c<br>
@@ -511,7 +511,7 @@ main (int argc, char *argv[])<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 extern int optind;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 int r =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 enum mpath_cmds cmd =3D CMD_CREATE;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0enum devtypes dev_type;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0enum devtypes dev_type =3D DEV_NONE;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 char *dev =3D NULL;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 struct config *conf;<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
1.8.3.1<br>
<br>
</font></span></blockquote></div><br></div>

--001a1140211e5554ec0538eaadfc--


--===============0287838046599102198==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0287838046599102198==--
