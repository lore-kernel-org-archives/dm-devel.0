From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 6/8] libmpathcmd: Do not install header file
	as executable
Date: Fri, 3 Jun 2016 08:42:40 +0200
Message-ID: <CABr-Gnc-ZjJJQbPjFQ49csRfmEhh3Xg_r_KbJx9m8UuXLa_PVw@mail.gmail.com>
References: <1464936038-709-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4103912191165289419=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1464936038-709-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.com>
List-Id: dm-devel.ids

--===============4103912191165289419==
Content-Type: multipart/alternative; boundary=001a1142100a7b364805345a073a

--001a1142100a7b364805345a073a
Content-Type: text/plain; charset=UTF-8

Merged.

On Fri, Jun 3, 2016 at 8:40 AM, Hannes Reinecke <hare@suse.de> wrote:

> Our build system complained that the mpath_cmd.h header file is
> installed as executable.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  libmpathcmd/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile
> index 0304ecc..6fca165 100644
> --- a/libmpathcmd/Makefile
> +++ b/libmpathcmd/Makefile
> @@ -19,7 +19,7 @@ install: $(LIBS)
>         $(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
>         ln -sf $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
>         $(INSTALL_PROGRAM) -d $(DESTDIR)$(incdir)
> -       $(INSTALL_PROGRAM) -m 755 mpath_cmd.h $(DESTDIR)$(incdir)
> +       $(INSTALL_PROGRAM) -m 644 mpath_cmd.h $(DESTDIR)$(incdir)
>
>  uninstall:
>         rm -f $(DESTDIR)$(syslibdir)/$(LIBS)
> --
> 2.6.6
>
>

--001a1142100a7b364805345a073a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Merged.</div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Fri, Jun 3, 2016 at 8:40 AM, Hannes Reinecke <span dir=3D"l=
tr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>&=
gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 =
0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Our build system compla=
ined that the mpath_cmd.h header file is<br>
installed as executable.<br>
<br>
Signed-off-by: Hannes Reinecke &lt;<a href=3D"mailto:hare@suse.com">hare@su=
se.com</a>&gt;<br>
---<br>
=C2=A0libmpathcmd/Makefile | 2 +-<br>
=C2=A01 file changed, 1 insertion(+), 1 deletion(-)<br>
<br>
diff --git a/libmpathcmd/Makefile b/libmpathcmd/Makefile<br>
index 0304ecc..6fca165 100644<br>
--- a/libmpathcmd/Makefile<br>
+++ b/libmpathcmd/Makefile<br>
@@ -19,7 +19,7 @@ install: $(LIBS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(s=
yslibdir)/$(LIBS)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ln -sf $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 $(INSTALL_PROGRAM) -d $(DESTDIR)$(incdir)<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 755 mpath_cmd.h $(DESTDIR=
)$(incdir)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0$(INSTALL_PROGRAM) -m 644 mpath_cmd.h $(DESTDIR=
)$(incdir)<br>
<br>
=C2=A0uninstall:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 rm -f $(DESTDIR)$(syslibdir)/$(LIBS)<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
2.6.6<br>
<br>
</font></span></blockquote></div><br></div>

--001a1142100a7b364805345a073a--


--===============4103912191165289419==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4103912191165289419==--
