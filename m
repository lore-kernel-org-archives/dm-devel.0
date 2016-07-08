From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 0/5] Makefiles housekeeping II
Date: Fri, 8 Jul 2016 15:17:01 +0200
Message-ID: <CABr-GnfOY0EiOTe4LXdYmMdHTpJtaOUpz6bQ4tf_j4sbwkyShw@mail.gmail.com>
References: <1467393452-1032-1-git-send-email-xose.vazquez@gmail.com>
	<CABr-Gnccm_uvdVFkWK2XonVqm_QPTYSxW+TAYBzT4r=NEmfqKQ@mail.gmail.com>
	<9c6414eb-d869-18c1-816e-67847ddbbd00@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6098922262255877239=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9c6414eb-d869-18c1-816e-67847ddbbd00@gmail.com>
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

--===============6098922262255877239==
Content-Type: multipart/alternative; boundary=001a114128ee3a4c7d05371f9ebf

--001a114128ee3a4c7d05371f9ebf
Content-Type: text/plain; charset=UTF-8

I'd rather follow the preference of distributors.

On Fri, Jul 8, 2016 at 3:02 PM, Xose Vazquez Perez <xose.vazquez@gmail.com>
wrote:

> On 07/08/2016 09:16 AM, Christophe Varoqui wrote:
>
> > Merged patches 1, 2 and 3 of this set.
> >
> > I postponed merging the patches adding fullpath links in libs.
> > Are you sure it is best practice to use fullpaths there ?
>
> This is up to you. It works as is.
>
> But in "libmpathpersist/Makefile" is done as in my patch:
> $ git grep '$(LN) $(DESTDIR)$(syslibdir)/$(LIBS)
> $(DESTDIR)$(syslibdir)/$(DEVLIB)'
> libmpathpersist/Makefile:       $(LN) $(DESTDIR)$(syslibdir)/$(LIBS)
> $(DESTDIR)$(syslibdir)/$(DEVLIB)
>
> Let me know your preference.
>

--001a114128ee3a4c7d05371f9ebf
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I&#39;d rather follow the preference of distributors.</div=
><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Fri, Jul 8, 2=
016 at 3:02 PM, Xose Vazquez Perez <span dir=3D"ltr">&lt;<a href=3D"mailto:=
xose.vazquez@gmail.com" target=3D"_blank">xose.vazquez@gmail.com</a>&gt;</s=
pan> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On 07/08/201=
6 09:16 AM, Christophe Varoqui wrote:<br>
<br>
&gt; Merged patches 1, 2 and 3 of this set.<br>
&gt;<br>
&gt; I postponed merging the patches adding fullpath links in libs.<br>
&gt; Are you sure it is best practice to use fullpaths there ?<br>
<br>
</span>This is up to you. It works as is.<br>
<br>
But in &quot;libmpathpersist/Makefile&quot; is done as in my patch:<br>
$ git grep &#39;$(LN) $(DESTDIR)$(syslibdir)/$(LIBS) $(DESTDIR)$(syslibdir)=
/$(DEVLIB)&#39;<br>
libmpathpersist/Makefile:=C2=A0 =C2=A0 =C2=A0 =C2=A0$(LN) $(DESTDIR)$(sysli=
bdir)/$(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)<br>
<br>
Let me know your preference.<br>
</blockquote></div><br></div>

--001a114128ee3a4c7d05371f9ebf--


--===============6098922262255877239==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6098922262255877239==--
