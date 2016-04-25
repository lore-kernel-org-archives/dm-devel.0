From: Peter Volkov <peter.volkov@gmail.com>
Subject: Re: multipath-0.5.0 still provides broken udev rules
Date: Mon, 25 Apr 2016 15:52:02 +0300
Message-ID: <CAE+k_g+n6XmGvCen8ZuMtr5ULQa2zD9PyyphupmyM4PpTdEK4w@mail.gmail.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
	<CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
	<571E0E7A.4050703@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5113312450388053332=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <571E0E7A.4050703@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============5113312450388053332==
Content-Type: multipart/alternative; boundary=001a11444e1ac5d7ab05314ea551

--001a11444e1ac5d7ab05314ea551
Content-Type: text/plain; charset=UTF-8

On Mon, Apr 25, 2016 at 3:32 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:

> On 25.4.2016 14:10, Peter Volkov wrote:
>
>> On Mon, Apr 25, 2016 at 1:58 PM, Zdenek Kabelac <zkabelac@redhat.com
>> <mailto:zkabelac@redhat.com>> wrote:
>>
>>     On 25.4.2016 12:52, Peter Volkov wrote:
>>
>>         There is a problem: udev does not create partitions for multipath
>>         devices in
>>         case I use kpartx.rules provided with multipath sources. I found
>> that udev
>>         always go to kpartx_end after following line of rules:
>>         ENV{DM_TABLE_STATE}!="LIVE", GOTO="kpartx_end"
>>
>> Actually don't understand what's this table and what's wrong with that.
>> There
>> is no traces of DM_TABLE_STATE variable in lvm2 sources. Yet there is such
>> variable in udev rules file that comes with multipath sources:
>>
>> http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=kpartx/kpartx.rules;h=022361f907e873ac16fc75459b88af34b27576e5;hb=HEAD
>>
>
>
> So you would need to figure out which rules would have set  DM_TABLE_STATE
> before ?  (I assume such have never existed...)
>

There was a patch suggested for dmsetup:
https://www.redhat.com/archives/dm-devel/2007-July/msg00095.html

So it's rather question for upstream kpartx maintainer why these rules
> are not maintained in any way.
>

Yup,  that's why I'm here.

kpartx rules comes from year 2007, while dm rules started to be maintained
> in 2009 - that may explain few things as well...


Then your suggestion is to fix udev rules that comes with multipath. Ok.

That's Gentoo. But I think any distro that uses whatever upstream prepares
>> have this problem.
>>
>

> Likely Gentoo should not install obsoleted udev rules file.
>

That's true. Yet I'm not talking about Gentoo here, but about config file
that comes with multipath sources and according to multipath homepage this
mailing list is a right place for such discussions. Please, correct me if
I'm wrong.

--
Peter.

--001a11444e1ac5d7ab05314ea551
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On M=
on, Apr 25, 2016 at 3:32 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=
=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);borde=
r-left-style:solid;padding-left:1ex"><span class=3D"">On 25.4.2016 14:10, P=
eter Volkov wrote:<br>
</span><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;=
border-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:=
solid;padding-left:1ex"><span class=3D"">
On Mon, Apr 25, 2016 at 1:58 PM, Zdenek Kabelac &lt;<a href=3D"mailto:zkabe=
lac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a><br></span><span c=
lass=3D"">
&lt;mailto:<a href=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabela=
c@redhat.com</a>&gt;&gt; wrote:<br>
<br>
=C2=A0 =C2=A0 On 25.4.2016 12:52, Peter Volkov wrote:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 There is a problem: udev does not create partit=
ions for multipath<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 devices in<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 case I use kpartx.rules provided with multipath=
 sources. I found that udev<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 always go to kpartx_end after following line of=
 rules:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ENV{DM_TABLE_STATE}!=3D&quot;LIVE&quot;, GOTO=
=3D&quot;kpartx_end&quot;<br>
<br>
Actually don&#39;t understand what&#39;s this table and what&#39;s wrong wi=
th that. There<br>
is no traces of DM_TABLE_STATE variable in lvm2 sources. Yet there is such<=
br>
variable in udev rules file that comes with multipath sources:<br>
<a href=3D"http://git.opensvc.com/gitweb.cgi?p=3Dmultipath-tools/.git;a=3Db=
lob;f=3Dkpartx/kpartx.rules;h=3D022361f907e873ac16fc75459b88af34b27576e5;hb=
=3DHEAD" rel=3D"noreferrer" target=3D"_blank">http://git.opensvc.com/gitweb=
.cgi?p=3Dmultipath-tools/.git;a=3Dblob;f=3Dkpartx/kpartx.rules;h=3D022361f9=
07e873ac16fc75459b88af34b27576e5;hb=3DHEAD</a><br>
</span></blockquote>
<br>
<br>
So you would need to figure out which rules would have set=C2=A0 DM_TABLE_S=
TATE before ?=C2=A0 (I assume such have never existed...)<br></blockquote><=
div><br></div><div>There was a patch suggested for dmsetup:=C2=A0<a href=3D=
"https://www.redhat.com/archives/dm-devel/2007-July/msg00095.html" target=
=3D"_blank" style=3D"font-family:&#39;Times New Roman&#39;;font-size:medium=
">https://www.redhat.com/archives/dm-devel/2007-July/msg00095.html</a></div=
><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0=
px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-le=
ft-style:solid;padding-left:1ex">
So it&#39;s rather question for upstream kpartx maintainer why these rules<=
br>
are not maintained in any way.<br></blockquote><div><br></div><div>Yup, =C2=
=A0that&#39;s why I&#39;m here.</div><div><br></div><blockquote class=3D"gm=
ail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-l=
eft-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">
kpartx rules comes from year 2007, while dm rules started to be maintained =
in 2009 - that may explain few things as well...</blockquote><div><br></div=
><div>Then your suggestion is to fix udev rules that comes with multipath. =
Ok.</div><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0=
px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);b=
order-left-style:solid;padding-left:1ex"><span class=3D"">
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">
That&#39;s Gentoo. But I think any distro that uses whatever upstream prepa=
res<br>
have this problem.<br></blockquote></span></blockquote><div>=C2=A0</div><bl=
ockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-lef=
t-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;padd=
ing-left:1ex"><span class=3D""><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204=
,204);border-left-style:solid;padding-left:1ex"></blockquote></span>
Likely Gentoo should not install obsoleted udev rules file.<br></blockquote=
><div><br></div><div>That&#39;s true. Yet I&#39;m not talking about Gentoo =
here, but about config file that comes with multipath sources and according=
 to multipath homepage this mailing list is a right place for such discussi=
ons. Please, correct me if I&#39;m wrong.</div><div><br></div><div>--</div>=
<div>Peter.</div></div></div></div>

--001a11444e1ac5d7ab05314ea551--


--===============5113312450388053332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5113312450388053332==--
