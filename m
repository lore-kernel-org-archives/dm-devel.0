From: Peter Volkov <peter.volkov@gmail.com>
Subject: Re: multipath-0.5.0 still provides broken udev rules
Date: Mon, 25 Apr 2016 15:10:46 +0300
Message-ID: <CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0652771089079439631=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <571DF852.6030604@redhat.com>
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

--===============0652771089079439631==
Content-Type: multipart/alternative; boundary=047d7b450998306dba05314e1288

--047d7b450998306dba05314e1288
Content-Type: text/plain; charset=UTF-8

On Mon, Apr 25, 2016 at 1:58 PM, Zdenek Kabelac <zkabelac@redhat.com> wrote:

> On 25.4.2016 12:52, Peter Volkov wrote:
>>
>> There is a problem: udev does not create partitions for multipath devices
>> in
>> case I use kpartx.rules provided with multipath sources. I found that udev
>> always go to kpartx_end after following line of rules:
>> ENV{DM_TABLE_STATE}!="LIVE", GOTO="kpartx_end"
>>
>
> Just curious - what would you want to do with inactive table???
>

Actually don't understand what's this table and what's wrong with that.
There is no traces of DM_TABLE_STATE variable in lvm2 sources. Yet there is
such variable in udev rules file that comes with multipath sources:
http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=kpartx/kpartx.rules;h=022361f907e873ac16fc75459b88af34b27576e5;hb=HEAD


> You cannot read/scan such device ?


The problem I have - multipath with udev's help creates /dev/mapper/mpatha
block device but does not create devices for partitions, e.g.
/dev/mapper/mpatha1. I found that this happens due to udev rule mentioned
above. After execution rule on line 10 (*ENV{DM_TABLE_STATE}!="LIVE",
GOTO="kpartx_end"*) udev goes directly to kpartx_end and rule on line 45
(..."/sbin/kpartx -u -p -part /dev/$name") is never executed.


> There is 8 (!!!) years old thread that discusses this problem:
>> https://www.redhat.com/archives/dm-devel/2007-July/msg00095.html
>>
>> So what is the current state? Should we fix udev rules for multipath or
>> should
>> we create better patch for dmsetup.c? Meanwhile I've copied
>> multipath.rules
>> from redhat and partitions are created as they should.
>>
>
>
> What is the exact problem you do have/see ?

Can you describe in some single repeatable steps a reproducer ?
>

Install udev rules file from mutlipath tools and see that partitions are
not created.


> Which distro are you talking about  (Fedora ? Debian ??)
>

That's Gentoo. But I think any distro that uses whatever upstream prepares
have this problem.


> Have you opened any bugzilla anywhere ?
>

Not yet. I'd like to understand what needs to be done first.

--
Peter.

--047d7b450998306dba05314e1288
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On M=
on, Apr 25, 2016 at 1:58 PM, Zdenek Kabelac <span dir=3D"ltr">&lt;<a href=
=3D"mailto:zkabelac@redhat.com" target=3D"_blank">zkabelac@redhat.com</a>&g=
t;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);borde=
r-left-style:solid;padding-left:1ex"><span class=3D"">On 25.4.2016 12:52, P=
eter Volkov wrote:<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px=
 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-=
left-style:solid;padding-left:1ex">
There is a problem: udev does not create partitions for multipath devices i=
n<br>
case I use kpartx.rules provided with multipath sources. I found that udev<=
br>
always go to kpartx_end after following line of rules:<br>
ENV{DM_TABLE_STATE}!=3D&quot;LIVE&quot;, GOTO=3D&quot;kpartx_end&quot;<br>
</blockquote>
</span><br>
Just curious - what would you want to do with inactive table???<br></blockq=
uote><div><div><br class=3D"">Actually don&#39;t understand what&#39;s this=
 table and what&#39;s wrong with that. There is no traces of DM_TABLE_STATE=
 variable in lvm2 sources. Yet there is such variable in udev rules file th=
at comes with multipath sources:</div><div><a href=3D"http://git.opensvc.co=
m/gitweb.cgi?p=3Dmultipath-tools/.git;a=3Dblob;f=3Dkpartx/kpartx.rules;h=3D=
022361f907e873ac16fc75459b88af34b27576e5;hb=3DHEAD">http://git.opensvc.com/=
gitweb.cgi?p=3Dmultipath-tools/.git;a=3Dblob;f=3Dkpartx/kpartx.rules;h=3D02=
2361f907e873ac16fc75459b88af34b27576e5;hb=3DHEAD</a></div></div><div>=C2=A0=
</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;b=
order-left-width:1px;border-left-color:rgb(204,204,204);border-left-style:s=
olid;padding-left:1ex">
You cannot read/scan such device ?</blockquote><div><br></div><div>The prob=
lem I have - multipath with udev&#39;s help creates /dev/mapper/mpatha bloc=
k device but does not create devices for partitions, e.g. /dev/mapper/mpath=
a1. I found that this happens due to udev rule mentioned above. After execu=
tion rule on line 10 (<i>ENV{DM_TABLE_STATE}!=3D&quot;LIVE&quot;, GOTO=3D&q=
uot;kpartx_end&quot;</i>) udev goes directly to=C2=A0kpartx_end and rule on=
 line 45 (...<span style=3D"color:rgb(105,105,105);font-family:monospace,mo=
nospace;white-space:pre">&quot;/sbin/kpartx=C2=A0-u=C2=A0-p=C2=A0-part=C2=
=A0/dev/$name&quot;)</span>=C2=A0is never executed.</div><div>=C2=A0</div><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;pa=
dding-left:1ex"><span class=3D""><blockquote class=3D"gmail_quote" style=3D=
"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,2=
04,204);border-left-style:solid;padding-left:1ex">
There is 8 (!!!) years old thread that discusses this problem:<br>
<a href=3D"https://www.redhat.com/archives/dm-devel/2007-July/msg00095.html=
" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/archives/dm-d=
evel/2007-July/msg00095.html</a><br>
<br>
So what is the current state? Should we fix udev rules for multipath or sho=
uld<br>
we create better patch for dmsetup.c? Meanwhile I&#39;ve copied multipath.r=
ules<br>
from redhat and partitions are created as they should.<br>
</blockquote>
<br>
<br></span>
What is the exact problem you do have/see ?</blockquote><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;bo=
rder-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">
Can you describe in some single repeatable steps a reproducer ?<br></blockq=
uote><div><br></div><div>Install udev rules file from mutlipath tools and s=
ee that partitions are not created.</div><div>=C2=A0</div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;bo=
rder-left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">
Which distro are you talking about=C2=A0 (Fedora ? Debian ??)<br></blockquo=
te><div><br></div><div>That&#39;s Gentoo. But I think any distro that uses =
whatever upstream prepares have this problem.</div><div>=C2=A0</div><blockq=
uote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-wi=
dth:1px;border-left-color:rgb(204,204,204);border-left-style:solid;padding-=
left:1ex">
Have you opened any bugzilla anywhere ?<br></blockquote><div><br></div><div=
>Not yet. I&#39;d like to understand what needs to be done first.</div><div=
><br></div><div>--</div><div>Peter.</div></div></div></div>

--047d7b450998306dba05314e1288--


--===============0652771089079439631==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0652771089079439631==--
