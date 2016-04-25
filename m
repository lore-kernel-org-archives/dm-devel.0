From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: multipath-0.5.0 still provides broken udev rules
Date: Mon, 25 Apr 2016 14:56:35 +0200
Message-ID: <CABr-GnfxOKz8gxDju20Hx3T9Tn74Zz9FhjF1dBk8weEBJMOmLg@mail.gmail.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
	<CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
	<571E0E7A.4050703@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3290065776286608515=="
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
Cc: device-mapper development <dm-devel@redhat.com>, Peter Volkov <peter.volkov@gmail.com>
List-Id: dm-devel.ids

--===============3290065776286608515==
Content-Type: multipart/alternative; boundary=001a113fa5bce9a82e05314eb41f

--001a113fa5bce9a82e05314eb41f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

Those example udev rules are indeed unmaintained and should be removed not
to confuse distributors.

Distributors can't be asked to agree on a common udev ruleset. Ben, Hannes,
Xos=C3=A9, Peter are you ok with my deleting the udev rules example ?

Best regards,


On Mon, Apr 25, 2016 at 2:32 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote=
:

> On 25.4.2016 14:10, Peter Volkov wrote:
>
>> On Mon, Apr 25, 2016 at 1:58 PM, Zdenek Kabelac <zkabelac@redhat.com
>> <mailto:zkabelac@redhat.com>> wrote:
>>
>>     On 25.4.2016 12:52, Peter Volkov wrote:
>>
>>         There is a problem: udev does not create partitions for multipat=
h
>>         devices in
>>         case I use kpartx.rules provided with multipath sources. I found
>> that udev
>>         always go to kpartx_end after following line of rules:
>>         ENV{DM_TABLE_STATE}!=3D"LIVE", GOTO=3D"kpartx_end"
>>
>>
>>     Just curious - what would you want to do with inactive table???
>>
>>
>> Actually don't understand what's this table and what's wrong with that.
>> There
>> is no traces of DM_TABLE_STATE variable in lvm2 sources. Yet there is su=
ch
>> variable in udev rules file that comes with multipath sources:
>>
>> http://git.opensvc.com/gitweb.cgi?p=3Dmultipath-tools/.git;a=3Dblob;f=3D=
kpartx/kpartx.rules;h=3D022361f907e873ac16fc75459b88af34b27576e5;hb=3DHEAD
>>
>
>
> So you would need to figure out which rules would have set  DM_TABLE_STAT=
E
> before ?  (I assume such have never existed...)
>
> In Fedora/RHEL  these  kpartx.rules are not packaged as they are likely
> some 'ancient' rules - IMHO  most of that file is useless on today's
> distros.
> (Unsure about dm-wwn logic???)
>
> So it's rather question for upstream kpartx maintainer why these rules
> are not maintained in any way.
>
> Vars like DM_TABLE_STATE are simply not created by dm rules.
>
> kpartx rules comes from year 2007, while dm rules started to be maintaine=
d
> in 2009 - that may explain few things as well...
>
> That's Gentoo. But I think any distro that uses whatever upstream prepare=
s
>> have this problem.
>>
>>     Have you opened any bugzilla anywhere ?
>>
>>
>> Not yet. I'd like to understand what needs to be done first.
>>
>>
> Likely Gentoo should not install obsoleted udev rules file.
>
> Regards
>
> Zdenek
>
> PS: I could be wrong here - since I've nothing in common with multipath,
> so in such case - feel free to correct me....
>
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a113fa5bce9a82e05314eb41f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,</div><div><br></div>Those example udev rules are =
indeed unmaintained and should be removed not to confuse distributors.<div>=
<br></div><div>Distributors can&#39;t be asked to agree on a common udev ru=
leset. Ben, Hannes, Xos=C3=A9, Peter are you ok with my deleting the udev r=
ules example ?</div><div><br></div><div>Best regards,</div><div><br></div><=
/div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Apr =
25, 2016 at 2:32 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=3D"mailto=
:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&gt;</span> =
wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On 25.4.2016 14:1=
0, Peter Volkov wrote:<br>
</span><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-=
left:1px #ccc solid;padding-left:1ex"><span class=3D"">
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
<br>
=C2=A0 =C2=A0 Just curious - what would you want to do with inactive table?=
??<br>
<br>
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
TATE before ?=C2=A0 (I assume such have never existed...)<br>
<br>
In Fedora/RHEL=C2=A0 these=C2=A0 kpartx.rules are not packaged as they are =
likely some &#39;ancient&#39; rules - IMHO=C2=A0 most of that file is usele=
ss on today&#39;s distros.<br>
(Unsure about dm-wwn logic???)<br>
<br>
So it&#39;s rather question for upstream kpartx maintainer why these rules<=
br>
are not maintained in any way.<br>
<br>
Vars like DM_TABLE_STATE are simply not created by dm rules.<br>
<br>
kpartx rules comes from year 2007, while dm rules started to be maintained =
in 2009 - that may explain few things as well...<span class=3D""><br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
That&#39;s Gentoo. But I think any distro that uses whatever upstream prepa=
res<br>
have this problem.<br>
<br>
=C2=A0 =C2=A0 Have you opened any bugzilla anywhere ?<br>
<br>
<br>
Not yet. I&#39;d like to understand what needs to be done first.<br>
<br>
</blockquote>
<br></span>
Likely Gentoo should not install obsoleted udev rules file.<br>
<br>
Regards<span class=3D"HOEnZb"><font color=3D"#888888"><br>
<br>
Zdenek<br>
</font></span><br>
PS: I could be wrong here - since I&#39;ve nothing in common with multipath=
,<br>
so in such case - feel free to correct me....<div class=3D"HOEnZb"><div cla=
ss=3D"h5"><br>
<br>
<br>
--<br>
dm-devel mailing list<br>
<a href=3D"mailto:dm-devel@redhat.com" target=3D"_blank">dm-devel@redhat.co=
m</a><br>
<a href=3D"https://www.redhat.com/mailman/listinfo/dm-devel" rel=3D"norefer=
rer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/dm-devel</a>=
<br>
</div></div></blockquote></div><br></div>

--001a113fa5bce9a82e05314eb41f--


--===============3290065776286608515==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3290065776286608515==--
