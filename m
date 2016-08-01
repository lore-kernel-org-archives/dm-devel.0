From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH 5/5] multipath-tools: hwtable housekeeping
Date: Mon, 1 Aug 2016 09:32:17 +0200
Message-ID: <CABr-GndnvyftJ+JQcv2bXcx27s50n4E2EPL8Fypq=tmtTzMvYQ@mail.gmail.com>
References: <1469233752-11708-1-git-send-email-xose.vazquez@gmail.com>
	<1469233752-11708-5-git-send-email-xose.vazquez@gmail.com>
	<CABr-Gnfo1zGZRJSnd=gBKFFpww2f_GOdMk2t-Gx_rxybD3C=rw@mail.gmail.com>
	<cb83cdfc-e721-7477-8722-716c445f6b55@gmail.com>
	<CABr-GncVdtP5P0+Wu3ed+M22SBpUHhEH7Pd+YWo3=6ZKcA1Kfw@mail.gmail.com>
	<9acac496-da21-c5d0-7797-b0f3f0b95015@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6146419067659016275=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9acac496-da21-c5d0-7797-b0f3f0b95015@suse.de>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

--===============6146419067659016275==
Content-Type: multipart/alternative; boundary=001a114102e4983a950538fd991f

--001a114102e4983a950538fd991f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Done for the revert, and as an incremental patch, the switch to multibus
for the devices w/o a prioritizer set.

Thanks.

On Mon, Aug 1, 2016 at 9:10 AM, Hannes Reinecke <hare@suse.de> wrote:

> On 08/01/2016 08:55 AM, Christophe Varoqui wrote:
>
>> Yes, I'll take care of the revert to "failover" as the default path
>> grouping policy.
>> Indeed, you can postpone your pending patch rebasing to this incoming
>> commit.
>>
>> The website update is done.
>>
>> And while you're at it:
>
> There are some entries which list a grouping policy as 'group_by_prio',
> but don't have prioritizer set. Which it completely pointless.
> They should be switched to 'multibus' instead.
>
> But if the patch is already done I'll be sending a new patch.
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

--001a114102e4983a950538fd991f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Done for the revert, and as an incremental patch, the swit=
ch to multibus for the devices w/o a prioritizer set.<div><br></div><div>Th=
anks.</div></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On Mon, Aug 1, 2016 at 9:10 AM, Hannes Reinecke <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>&gt;</span> wr=
ote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border=
-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On 08/01/2016 08:55=
 AM, Christophe Varoqui wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Yes, I&#39;ll take care of the revert to &quot;failover&quot; as the defaul=
t path<br>
grouping policy.<br>
Indeed, you can postpone your pending patch rebasing to this incoming<br>
commit.<br>
<br>
The website update is done.<br>
<br>
</blockquote></span>
And while you&#39;re at it:<br>
<br>
There are some entries which list a grouping policy as &#39;group_by_prio&#=
39;, but don&#39;t have prioritizer set. Which it completely pointless.<br>
They should be switched to &#39;multibus&#39; instead.<br>
<br>
But if the patch is already done I&#39;ll be sending a new patch.<br>
<br>
Cheers,<br>
<br>
Hannes<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-- <br>
Dr. Hannes Reinecke=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
Teamlead Storage &amp; Networking<br>
<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<a href=3D"tel:%2B49%20911%207=
4053%20688" value=3D"+4991174053688" target=3D"_blank">+49 911 74053 688</a=
><br>
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg<br>
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton<br>
HRB 21284 (AG N=C3=BCrnberg)<br>
</font></span></blockquote></div><br></div>

--001a114102e4983a950538fd991f--


--===============6146419067659016275==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6146419067659016275==--
