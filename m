From: Oliver Rojo <orojo.horus@gmail.com>
Subject: Re: multipathing in debian lenny with sychronized data
 between 2 servers
Date: Mon, 6 Dec 2010 11:13:47 -0800
Message-ID: <AANLkTing+Kw2g9WMjM7EL4zSpM4kqzZXV0xkcg1fmq94@mail.gmail.com>
References: <AANLkTik9tVk9sY-YyC+uAOTnMOuBw8DU3sozE2o=DKk1@mail.gmail.com>
	<1291662074.1518.5.camel@Nokia-N900-42-11>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7016850230669793642=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1291662074.1518.5.camel@Nokia-N900-42-11>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7016850230669793642==
Content-Type: multipart/alternative; boundary=00221597575aff8a010496c2affc

--00221597575aff8a010496c2affc
Content-Type: text/plain; charset=ISO-8859-1

Yes I've tested without multipathing.

On Server A, it shows /dev/dm-0 as the fs to mount and /dev/dm-3 on Server
B.

Mounting it on /data and writing files into Server A, all those files
written are not reflecting on Server B and vice versa. Do I need to use GFS2
on this scenario?

On Mon, Dec 6, 2010 at 11:01 AM, Christophe Varoqui <
christophe.varoqui@gmail.com> wrote:

>
> > I'm having issues right now using HP Storageworks P2000 G3 MSA with Dual
> > Fiber Channel connected on each host (2 Servers). I've already configure
> > multipathing and mounted my multipath alias (/dev/mapper/data to /data)
> > but everytime I put some data inside /data/ on Server 1, it doesn't
> > reflect on Server2 and vice versa. Is there any tweak on this?
> >
> have you tested that without multipathing ?
>
> I understand you use a filesystem there ... A clustered fs like ocfs2 or
> gfs2 would be necessary to synchronize your caches. If you are not using one
> of those, the fs should be mounted on a single node at a time.
>
> Regards,
> cvaroqui,
> opensvc
>

--00221597575aff8a010496c2affc
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Yes I&#39;ve tested without multipathing. <br><br>On Server A, it shows /de=
v/dm-0 as the fs to mount and /dev/dm-3 on Server B. <br><br>Mounting it on=
 /data and writing files into Server A, all those files written are not ref=
lecting on Server B and vice versa. Do I need to use GFS2 on this scenario?=
<br>
<br><div class=3D"gmail_quote">On Mon, Dec 6, 2010 at 11:01 AM, Christophe =
Varoqui <span dir=3D"ltr">&lt;<a href=3D"mailto:christophe.varoqui@gmail.co=
m">christophe.varoqui@gmail.com</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); margin=
: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">


   =20
   =20
   =20
<div>
<p></p><div><div></div><div class=3D"h5">
<br>&gt; I&#39;m having issues right now using HP Storageworks P2000 G3 MSA=
 with Dual
<br>&gt; Fiber Channel connected on each host (2 Servers). I&#39;ve already=
 configure
<br>&gt; multipathing and mounted my multipath alias (/dev/mapper/data to /=
data)
<br>&gt; but everytime I put some data inside /data/ on Server 1, it doesn&=
#39;t
<br>&gt; reflect on Server2 and vice versa. Is there any tweak on this?
<br>&gt;=20
<br></div></div>have you tested that without multipathing ?
<br>
<br>I understand you use a filesystem there ... A clustered fs like ocfs2 o=
r gfs2 would be necessary to synchronize your caches. If you are not using =
one of those, the fs should be mounted on a single node at a time.
<br>
<br>Regards,
<br>cvaroqui,
<br>opensvc
</div>

</blockquote></div><br>

--00221597575aff8a010496c2affc--


--===============7016850230669793642==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7016850230669793642==--
