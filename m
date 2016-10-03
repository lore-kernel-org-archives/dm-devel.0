From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 3/4] multipath-tools: change default failback
 from manual to undefined
Date: Mon, 3 Oct 2016 14:19:34 +0200
Message-ID: <CABr-GnfcT+iuu=UGSdyCfOX704SqMSyW18LSxj4bJMjJ5mFwcg@mail.gmail.com>
References: <1471543096-11441-1-git-send-email-xose.vazquez@gmail.com>
	<1471543096-11441-3-git-send-email-xose.vazquez@gmail.com>
	<CABr-Gnf0TqViwJ2a83GFqbbAWH351v+sKTbus4qeEZs3KTNyFg@mail.gmail.com>
	<39888100-7ca5-024c-3e49-7d4b438d5515@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5866307018356720034=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <39888100-7ca5-024c-3e49-7d4b438d5515@suse.de>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============5866307018356720034==
Content-Type: multipart/alternative; boundary=001a11408126034067053df4f5e7

--001a11408126034067053df4f5e7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Patch pushed.

On Mon, Oct 3, 2016 at 1:56 PM, Hannes Reinecke <hare@suse.de> wrote:

> On 10/03/2016 01:29 PM, Christophe Varoqui wrote:
> > Wouldn't it be nicer to keep manual as the default and remove all
> > FAILBACK_UNDEF from the hwtable ?
> >
> > In the current code base, FAILBACK_UNDEF causes need_switch_pathgroup()
> > to refresh each path prio and mpp->bestpg, and return to the caller it
> > should switch pathgroup. But the caller (check_path()) won't switch
> anyway.
> >
> > As I read it FAILBACK_UNDEF never fails back automatically, like
> > FAILBACK_MANUAL, but causes unecessary work.
> >
> > Hannes, Ben, do you confirm I read correctly ? Would you ack to removal
> > of FAILBACK_UNDEF from the hwtable ?
> >
> Yes, please.
> FAILBACK_UNDEF always was kinda pointless, as and we're now using
> defaults more aggressively I'm all for dropping FAILBACK_UNDEF and use
> FAILBACK_MANUAL as the default.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)
>

--001a11408126034067053df4f5e7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Patch pushed.</div><div class=3D"gmail_extra"><br><div cla=
ss=3D"gmail_quote">On Mon, Oct 3, 2016 at 1:56 PM, Hannes Reinecke <span di=
r=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.d=
e</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margi=
n:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">=
On 10/03/2016 01:29 PM, Christophe Varoqui wrote:<br>
&gt; Wouldn&#39;t it be nicer to keep manual as the default and remove all<=
br>
&gt; FAILBACK_UNDEF from the hwtable ?<br>
&gt;<br>
&gt; In the current code base, FAILBACK_UNDEF causes need_switch_pathgroup(=
)<br>
&gt; to refresh each path prio and mpp-&gt;bestpg, and return to the caller=
 it<br>
&gt; should switch pathgroup. But the caller (check_path()) won&#39;t switc=
h anyway.<br>
&gt;<br>
&gt; As I read it FAILBACK_UNDEF never fails back automatically, like<br>
&gt; FAILBACK_MANUAL, but causes unecessary work.<br>
&gt;<br>
&gt; Hannes, Ben, do you confirm I read correctly ? Would you ack to remova=
l<br>
&gt; of FAILBACK_UNDEF from the hwtable ?<br>
&gt;<br>
</span>Yes, please.<br>
FAILBACK_UNDEF always was kinda pointless, as and we&#39;re now using<br>
defaults more aggressively I&#39;m all for dropping FAILBACK_UNDEF and use<=
br>
FAILBACK_MANUAL as the default.<br>
<br>
Cheers,<br>
<br>
Hannes<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dr. Hannes Reinecke=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0zSeries &amp; Storage<br>
<a href=3D"mailto:hare@suse.de">hare@suse.de</a>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"=
tel:%2B49%20911%2074053%20688" value=3D"+4991174053688">+49 911 74053 688</=
a><br>
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg<br>
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg)<br=
>
</font></span></blockquote></div><br></div>

--001a11408126034067053df4f5e7--


--===============5866307018356720034==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5866307018356720034==--
