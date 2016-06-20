From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 00/39] multipath: coverity fixes
Date: Mon, 20 Jun 2016 09:32:13 +0200
Message-ID: <CABr-Gncmmn70=pwsu_+E9a0T2YXtLi9fj=_TX4UAtc-kkRDfTA@mail.gmail.com>
References: <1466070465-1021-1-git-send-email-hare@suse.de>
	<57679699.4050300@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7363845117744652549=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <57679699.4050300@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============7363845117744652549==
Content-Type: multipart/alternative; boundary=001a1140d2befed74f0535b0b3f7

--001a1140d2befed74f0535b0b3f7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I pulled the coverity branch today.
Thanks.

On Mon, Jun 20, 2016 at 9:09 AM, Hannes Reinecke <hare@suse.de> wrote:

> On 06/16/2016 11:47 AM, Hannes Reinecke wrote:
> > Hi all,
> >
> > here's a bunch of fixes from a recent coverity run.
> > Nothing critical, mostly memory leaks and possible
> > buffer overflows. And the usual missing return value
> > check.
> >
> > As usual, comments and reviews are welcome.
> >
> Ping?
> I've got another patchset (converting config accesses to RCU)
> which sort of relies on this one...
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
>

--001a1140d2befed74f0535b0b3f7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I pulled the coverity branch today.<div>Thanks.</div></div=
><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Jun 20, =
2016 at 9:09 AM, Hannes Reinecke <span dir=3D"ltr">&lt;<a href=3D"mailto:ha=
re@suse.de" target=3D"_blank">hare@suse.de</a>&gt;</span> wrote:<br><blockq=
uote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc =
solid;padding-left:1ex"><span class=3D"">On 06/16/2016 11:47 AM, Hannes Rei=
necke wrote:<br>
&gt; Hi all,<br>
&gt;<br>
&gt; here&#39;s a bunch of fixes from a recent coverity run.<br>
&gt; Nothing critical, mostly memory leaks and possible<br>
&gt; buffer overflows. And the usual missing return value<br>
&gt; check.<br>
&gt;<br>
&gt; As usual, comments and reviews are welcome.<br>
&gt;<br>
</span>Ping?<br>
I&#39;ve got another patchset (converting config accesses to RCU)<br>
which sort of relies on this one...<br>
<br>
Cheers,<br>
<br>
Hannes<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dr. Hannes Reinecke=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
Teamlead Storage &amp; Networking<br>
<a href=3D"mailto:hare@suse.de">hare@suse.de</a>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"tel:%2B49%20911%2074053%20688" value=3D"=
+4991174053688">+49 911 74053 688</a><br>
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg<br>
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton<br>
HRB 21284 (AG N=C3=BCrnberg)<br>
</font></span></blockquote></div><br></div>

--001a1140d2befed74f0535b0b3f7--


--===============7363845117744652549==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7363845117744652549==--
