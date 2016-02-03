From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Fix loopback file with kpartx -av
Date: Wed, 3 Feb 2016 09:27:23 +0100
Message-ID: <CABr-Gnd-jTopvz_k0B5RK7Soui5-vw5tyUZJ4P4H7NAS005Xwg@mail.gmail.com>
References: <1453297965-32278-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<CABr-GnfeNpQPcuoRSLHTA5q8E3OF8as1zOTY7SP=bwMwtC=MFQ@mail.gmail.com>
	<56B121AF.6090100@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6912207586195045335=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56B121AF.6090100@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============6912207586195045335==
Content-Type: multipart/alternative; boundary=047d7b3a84c4305dc7052ad96324

--047d7b3a84c4305dc7052ad96324
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Commited,
Thanks.

On Tue, Feb 2, 2016 at 10:37 PM, Mathieu Trudel-Lapierre <
mathieu.trudel-lapierre@canonical.com> wrote:

> Le 2016-01-20 09:53, Christophe Varoqui a =C3=A9crit :
> > Applied,
> > thanks.
> >
>
> This patch apparently breaks the use of loopback-mounted files if you
> try to use them directly with kpartx -av.
>
> For instance:
> qemu-img create foo.img 20M
> sgdisk -n 1 foo.img
> kpartx -av foo.img
>
>
> Fails with the following error:
> device-mapper: reload ioctl on loop0p1 failed: No such device
> create/reload failed on loop0p1
> add map loop0p1 (0:0): 0 4192256 linear 0:0 2048
>
>
> This can be fixed by stat()'ing the loop device again after picking it:
>
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -322,6 +322,11 @@ main(int argc, char **argv){
>                         loopcreated =3D 1;
>                 }
>                 device =3D loopdev;
> +
> +               if (stat(device, &buf)) {
> +                       printf("failed to stat() %s\n", device);
> +                       exit (1);
> +               }
>         }
>
>         off =3D find_devname_offset(device);
>
>
>
>
> --
> Mathieu Trudel-Lapierre <mathieu.trudel-lapierre@canonical.com>
> Freenode: cyphermox, Jabber: mathieu.tl@gmail.com
> 4096R/65B58DA1 818A D123 0992 275B 23C2  CF89 C67B B4D6 65B5 8DA1
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--047d7b3a84c4305dc7052ad96324
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Commited,<div>Thanks.</div></div><div class=3D"gmail_extra=
"><br><div class=3D"gmail_quote">On Tue, Feb 2, 2016 at 10:37 PM, Mathieu T=
rudel-Lapierre <span dir=3D"ltr">&lt;<a href=3D"mailto:mathieu.trudel-lapie=
rre@canonical.com" target=3D"_blank">mathieu.trudel-lapierre@canonical.com<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Le 2016-01-20 09:53=
, Christophe Varoqui a =C3=A9crit :<br>
&gt; Applied,<br>
&gt; thanks.<br>
&gt;<br>
<br>
This patch apparently breaks the use of loopback-mounted files if you<br>
try to use them directly with kpartx -av.<br>
<br>
For instance:<br>
qemu-img create foo.img 20M<br>
sgdisk -n 1 foo.img<br>
kpartx -av foo.img<br>
<br>
<br>
Fails with the following error:<br>
device-mapper: reload ioctl on loop0p1 failed: No such device<br>
create/reload failed on loop0p1<br>
add map loop0p1 (0:0): 0 4192256 linear 0:0 2048<br>
<br>
<br>
This can be fixed by stat()&#39;ing the loop device again after picking it:=
<br>
<br>
--- a/kpartx/kpartx.c<br>
+++ b/kpartx/kpartx.c<br>
@@ -322,6 +322,11 @@ main(int argc, char **argv){<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 loopcreated =3D 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 device =3D loopdev;=
<br>
+<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (stat(device, &a=
mp;buf)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0printf(&quot;failed to stat() %s\n&quot;, device);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0exit (1);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 off =3D find_devname_offset(device);<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
<br>
<br>
--<br>
Mathieu Trudel-Lapierre &lt;<a href=3D"mailto:mathieu.trudel-lapierre@canon=
ical.com">mathieu.trudel-lapierre@canonical.com</a>&gt;<br>
Freenode: cyphermox, Jabber: <a href=3D"mailto:mathieu.tl@gmail.com">mathie=
u.tl@gmail.com</a><br>
4096R/65B58DA1 818A D123 0992 275B 23C2=C2=A0 CF89 C67B B4D6 65B5 8DA1<br>
<br>
</font></span><br>--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br></blockquote></div><br></div>

--047d7b3a84c4305dc7052ad96324--


--===============6912207586195045335==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6912207586195045335==--
