From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [RFC] [PATCH] add serial keyword to the weightedpath
	prioritizer
Date: Mon, 1 Aug 2016 10:42:13 +0200
Message-ID: <CABr-GnfBwx6Fb1D7-2L0RiUP_ujOP8ZpH2WM0kyQR8f42424Pg@mail.gmail.com>
References: <CABr-Gndh4LLgd=T00GdtwNVrFgL7Te91BwjZ0Dh4uYyDi3c9bA@mail.gmail.com>
	<d9c1d17d-83c2-3e68-166c-78f44c5dd21d@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3702401710936434243=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <d9c1d17d-83c2-3e68-166c-78f44c5dd21d@suse.de>
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

--===============3702401710936434243==
Content-Type: multipart/alternative; boundary=001a11402e64ab3f1d0538fe93cd

--001a11402e64ab3f1d0538fe93cd
Content-Type: text/plain; charset=UTF-8

On Mon, Aug 1, 2016 at 9:49 AM, Hannes Reinecke <hare@suse.de> wrote:

> On 07/31/2016 09:26 PM, Christophe Varoqui wrote:
>
>> Ben, Hannes,
>>
>> Can you review this patch, adding a new 'serial' keyword to the
>> weightedpath prioritizer.
>>
>> I compile-tested it only, as I have no testing environment at hand at
>> the moment.
>>
>> I commited it in a separate 'weightedpath-serial' branch for now.
>>
>>
>> http://git.opensvc.com/?p=multipath-tools/.git;a=commitdiff;h=4dd16d99281104fc3504ad73626894a5c3702fb3
>>
>> Thanks,
>> Christophe Varoqui
>> OpenSVC
>>
>> Well.
> In general, sure, fine, I don't have any issues with that.
> If the customer wants to diddle with his array that way...
>
> The more general problem I'm seeing is that our current two-layered
> priority setup (path groups with distinct priorities and paths within them)
> might not be leading to issues with larger and more complex scenarios.
>
> ATM we already have the problem that clustered scenarios like this:
>
> Storage node 1(active):
>   Path 1 (optimal):
>     LUN 1, LUN2
>   Path 2 (non-optimal):
>     LUN 1, LUN2
>
> Storage node 2(passive):
>   Path 1(optimal):
>      LUN 1, LUN2
>   Path 2(non-optimal):
>      LUN 1, LUN2
>
> can not be represented properly with multipath tools.
> We are forced to either
> a) set 'storage node 2' to 'failed', which would kill
>    any cluster instance accessing only 'storage node 2'
> or
> b) map all priorities from 'storage node 2' to '0',
>    thereby losing all priority information
>
> Things become even more convoluted if both storage nodes are in fact
> accessible, or if someone would be using different transports.
>
> Would something like "prio alua+weightedpath" produce correct priorities
for the path grouping ? where priorities reported by alua would be added to
those reported by weighted path. That syntax extension would reduce the
need to develop more complex prioritizers.

The prio_args to prio mapping, wouldn't be nice though.

Concerning transports, we can also extend the weightedpath prioritizer, and
if the multi-prioritizer setup is implemented we could even weight on
serial+transport with a "prio weighedpath+weightedpath" setup.

--001a11402e64ab3f1d0538fe93cd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Mon, Aug 1, 2016 at 9:49 AM, Hannes Reinecke <span dir=3D"ltr">&lt;<=
a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</a>&gt;</span=
> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex"><span>On 07/31/2016 09:26 PM, Ch=
ristophe Varoqui wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Ben, Hannes,<br>
<br>
Can you review this patch, adding a new &#39;serial&#39; keyword to the<br>
weightedpath prioritizer.<br>
<br>
I compile-tested it only, as I have no testing environment at hand at<br>
the moment.<br>
<br>
I commited it in a separate &#39;weightedpath-serial&#39; branch for now.<b=
r>
<br>
<a href=3D"http://git.opensvc.com/?p=3Dmultipath-tools/.git;a=3Dcommitdiff;=
h=3D4dd16d99281104fc3504ad73626894a5c3702fb3" rel=3D"noreferrer" target=3D"=
_blank">http://git.opensvc.com/?p=3Dmultipath-tools/.git;a=3Dcommitdiff;h=
=3D4dd16d99281104fc3504ad73626894a5c3702fb3</a><br>
<br>
Thanks,<br>
Christophe Varoqui<br>
OpenSVC<br>
<br>
</blockquote></span>
Well.<br>
In general, sure, fine, I don&#39;t have any issues with that.<br>
If the customer wants to diddle with his array that way...<br>
<br>
The more general problem I&#39;m seeing is that our current two-layered pri=
ority setup (path groups with distinct priorities and paths within them) mi=
ght not be leading to issues with larger and more complex scenarios.<br>
<br>
ATM we already have the problem that clustered scenarios like this:<br>
<br>
Storage node 1(active):<br>
=C2=A0 Path 1 (optimal):<br>
=C2=A0 =C2=A0 LUN 1, LUN2<br>
=C2=A0 Path 2 (non-optimal):<br>
=C2=A0 =C2=A0 LUN 1, LUN2<br>
<br>
Storage node 2(passive):<br>
=C2=A0 Path 1(optimal):<br>
=C2=A0 =C2=A0 =C2=A0LUN 1, LUN2<br>
=C2=A0 Path 2(non-optimal):<br>
=C2=A0 =C2=A0 =C2=A0LUN 1, LUN2<br>
<br>
can not be represented properly with multipath tools.<br>
We are forced to either<br>
a) set &#39;storage node 2&#39; to &#39;failed&#39;, which would kill<br>
=C2=A0 =C2=A0any cluster instance accessing only &#39;storage node 2&#39;<b=
r>
or<br>
b) map all priorities from &#39;storage node 2&#39; to &#39;0&#39;,<br>
=C2=A0 =C2=A0thereby losing all priority information<br>
<br>
Things become even more convoluted if both storage nodes are in fact access=
ible, or if someone would be using different transports.<br>
<br></blockquote><div>Would something like &quot;prio alua+weightedpath&quo=
t; produce correct priorities for the path grouping ? where priorities repo=
rted by alua would be added to those reported by weighted path. That syntax=
 extension would reduce the need to develop more complex prioritizers.</div=
><div><br></div><div>The prio_args to prio mapping, wouldn&#39;t be nice th=
ough.</div><div><br></div><div>Concerning transports, we can also extend th=
e weightedpath prioritizer, and if the multi-prioritizer setup is implement=
ed we could even weight on serial+transport with a &quot;prio weighedpath+w=
eightedpath&quot; setup.</div><div><br></div></div></div></div>

--001a11402e64ab3f1d0538fe93cd--


--===============3702401710936434243==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3702401710936434243==--
