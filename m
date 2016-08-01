From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [RFC] [PATCH] add serial keyword to the weightedpath
	prioritizer
Date: Mon, 1 Aug 2016 14:25:06 +0200
Message-ID: <CABr-Gnd6zGeHgo5ka1LjQ5xB2WtZVCW_-=fH8UYZR_qppfog8Q@mail.gmail.com>
References: <CABr-Gndh4LLgd=T00GdtwNVrFgL7Te91BwjZ0Dh4uYyDi3c9bA@mail.gmail.com>
	<d9c1d17d-83c2-3e68-166c-78f44c5dd21d@suse.de>
	<CABr-GnfBwx6Fb1D7-2L0RiUP_ujOP8ZpH2WM0kyQR8f42424Pg@mail.gmail.com>
	<135275ad-ad45-7be3-d23c-6dc0dfb9d833@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4673123857389224494=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <135275ad-ad45-7be3-d23c-6dc0dfb9d833@suse.de>
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

--===============4673123857389224494==
Content-Type: multipart/alternative; boundary=001a1140211ece3e27053901b0da

--001a1140211ece3e27053901b0da
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Or we could honor arythmetic expressions like "5*alua+weightedpath", giving
users more control about preferences (and more opportunities to step on
their toes, sure).

Another idea, less invasive if possible, but less versatile :

- Merge the alua prioritizer into the weightedpath prioritizer, given the
optimized/non-optimized and other ALUA states are available in the path
struct and have their snprint_path_* function and %wildcard.

- Then weightedpath prio_args can be extended to support additive
priorities, like "alua <optimized state>:<... state> 10 serial foo 20"


On Mon, Aug 1, 2016 at 1:40 PM, Hannes Reinecke <hare@suse.de> wrote:

> On 08/01/2016 10:42 AM, Christophe Varoqui wrote:
>
>>
>>
>> On Mon, Aug 1, 2016 at 9:49 AM, Hannes Reinecke <hare@suse.de
>> <mailto:hare@suse.de>> wrote:
>>
>>     On 07/31/2016 09:26 PM, Christophe Varoqui wrote:
>>
>>         Ben, Hannes,
>>
>>         Can you review this patch, adding a new 'serial' keyword to the
>>         weightedpath prioritizer.
>>
>>         I compile-tested it only, as I have no testing environment at
>>         hand at
>>         the moment.
>>
>>         I commited it in a separate 'weightedpath-serial' branch for now=
.
>>
>>
>> http://git.opensvc.com/?p=3Dmultipath-tools/.git;a=3Dcommitdiff;h=3D4dd1=
6d99281104fc3504ad73626894a5c3702fb3
>>
>>         Thanks,
>>         Christophe Varoqui
>>         OpenSVC
>>
>>     Well.
>>     In general, sure, fine, I don't have any issues with that.
>>     If the customer wants to diddle with his array that way...
>>
>>     The more general problem I'm seeing is that our current two-layered
>>     priority setup (path groups with distinct priorities and paths
>>     within them) might not be leading to issues with larger and more
>>     complex scenarios.
>>
>>     ATM we already have the problem that clustered scenarios like this:
>>
>>     Storage node 1(active):
>>       Path 1 (optimal):
>>         LUN 1, LUN2
>>       Path 2 (non-optimal):
>>         LUN 1, LUN2
>>
>>     Storage node 2(passive):
>>       Path 1(optimal):
>>          LUN 1, LUN2
>>       Path 2(non-optimal):
>>          LUN 1, LUN2
>>
>>     can not be represented properly with multipath tools.
>>     We are forced to either
>>     a) set 'storage node 2' to 'failed', which would kill
>>        any cluster instance accessing only 'storage node 2'
>>     or
>>     b) map all priorities from 'storage node 2' to '0',
>>        thereby losing all priority information
>>
>>     Things become even more convoluted if both storage nodes are in fact
>>     accessible, or if someone would be using different transports.
>>
>> Would something like "prio alua+weightedpath" produce correct priorities
>> for the path grouping ? where priorities reported by alua would be added
>> to those reported by weighted path. That syntax extension would reduce
>> the need to develop more complex prioritizers.
>>
>> Hmm.
> Allowing stacked prioritizers is a nice idea.
> But then we need to impose some preference here; if we do not set any
> restrictions on the value of the prioritizers we end up with a jumble of
> (essentially unreadable) priorities.
> EG if your weightedpath returns values of '5' or '0' they'll be readily
> obscured by alua information, which uses '5' for the non-optimized path.
>
> So if we were to got that route we need to restrict the values of the
> prioritizers to eg 256, and shift the stacked prioritizer values ontop of
> each other.
> EG with a stacked 'prio_alua+weightedpath' we should end up with a
> priority of 0xAAWW.
> With that we can allow up to 4 levels of stacking (or 8 if we extend that
> to 64 bits), and still keep source-level compability with the original co=
de.
> We could even reduce the permissive values for the prioritzers even more;
> 16 is enough even for ALUA, and that would leave us with enough room of
> 1024 possible stacking levels :-)
>
> But in general I like the idea.
>
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

--001a1140211ece3e27053901b0da
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Or we could honor arythmetic expressions like &quot;5*alua=
+weightedpath&quot;, giving users more control about preferences (and more =
opportunities to step on their toes, sure).<div><br></div><div>Another idea=
, less invasive if possible, but less versatile :</div><div><br></div><div>=
- Merge the alua prioritizer into the weightedpath prioritizer, given the o=
ptimized/non-optimized and other ALUA states are available in the path stru=
ct and have their snprint_path_* function and %wildcard.</div><div><br></di=
v><div>- Then weightedpath prio_args can be extended to support additive pr=
iorities, like &quot;alua &lt;optimized state&gt;:&lt;... state&gt; 10 seri=
al foo 20&quot;</div><div><br></div></div><div class=3D"gmail_extra"><br><d=
iv class=3D"gmail_quote">On Mon, Aug 1, 2016 at 1:40 PM, Hannes Reinecke <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@=
suse.de</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=
=3D"">On 08/01/2016 10:42 AM, Christophe Varoqui wrote:<br>
</span><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-=
left:1px #ccc solid;padding-left:1ex"><span class=3D"">
<br>
<br>
On Mon, Aug 1, 2016 at 9:49 AM, Hannes Reinecke &lt;<a href=3D"mailto:hare@=
suse.de" target=3D"_blank">hare@suse.de</a><br></span><div><div class=3D"h5=
">
&lt;mailto:<a href=3D"mailto:hare@suse.de" target=3D"_blank">hare@suse.de</=
a>&gt;&gt; wrote:<br>
<br>
=C2=A0 =C2=A0 On 07/31/2016 09:26 PM, Christophe Varoqui wrote:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Ben, Hannes,<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Can you review this patch, adding a new &#39;se=
rial&#39; keyword to the<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 weightedpath prioritizer.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 I compile-tested it only, as I have no testing =
environment at<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 hand at<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 the moment.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 I commited it in a separate &#39;weightedpath-s=
erial&#39; branch for now.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"http://git.opensvc.com/?p=3Dmultipat=
h-tools/.git;a=3Dcommitdiff;h=3D4dd16d99281104fc3504ad73626894a5c3702fb3" r=
el=3D"noreferrer" target=3D"_blank">http://git.opensvc.com/?p=3Dmultipath-t=
ools/.git;a=3Dcommitdiff;h=3D4dd16d99281104fc3504ad73626894a5c3702fb3</a><b=
r>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Thanks,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Christophe Varoqui<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 OpenSVC<br>
<br>
=C2=A0 =C2=A0 Well.<br>
=C2=A0 =C2=A0 In general, sure, fine, I don&#39;t have any issues with that=
.<br>
=C2=A0 =C2=A0 If the customer wants to diddle with his array that way...<br=
>
<br>
=C2=A0 =C2=A0 The more general problem I&#39;m seeing is that our current t=
wo-layered<br>
=C2=A0 =C2=A0 priority setup (path groups with distinct priorities and path=
s<br>
=C2=A0 =C2=A0 within them) might not be leading to issues with larger and m=
ore<br>
=C2=A0 =C2=A0 complex scenarios.<br>
<br>
=C2=A0 =C2=A0 ATM we already have the problem that clustered scenarios like=
 this:<br>
<br>
=C2=A0 =C2=A0 Storage node 1(active):<br>
=C2=A0 =C2=A0 =C2=A0 Path 1 (optimal):<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 LUN 1, LUN2<br>
=C2=A0 =C2=A0 =C2=A0 Path 2 (non-optimal):<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 LUN 1, LUN2<br>
<br>
=C2=A0 =C2=A0 Storage node 2(passive):<br>
=C2=A0 =C2=A0 =C2=A0 Path 1(optimal):<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LUN 1, LUN2<br>
=C2=A0 =C2=A0 =C2=A0 Path 2(non-optimal):<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LUN 1, LUN2<br>
<br>
=C2=A0 =C2=A0 can not be represented properly with multipath tools.<br>
=C2=A0 =C2=A0 We are forced to either<br>
=C2=A0 =C2=A0 a) set &#39;storage node 2&#39; to &#39;failed&#39;, which wo=
uld kill<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0any cluster instance accessing only &#39;storage=
 node 2&#39;<br>
=C2=A0 =C2=A0 or<br>
=C2=A0 =C2=A0 b) map all priorities from &#39;storage node 2&#39; to &#39;0=
&#39;,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0thereby losing all priority information<br>
<br>
=C2=A0 =C2=A0 Things become even more convoluted if both storage nodes are =
in fact<br>
=C2=A0 =C2=A0 accessible, or if someone would be using different transports=
.<br>
<br>
Would something like &quot;prio alua+weightedpath&quot; produce correct pri=
orities<br>
for the path grouping ? where priorities reported by alua would be added<br=
>
to those reported by weighted path. That syntax extension would reduce<br>
the need to develop more complex prioritizers.<br>
<br>
</div></div></blockquote>
Hmm.<br>
Allowing stacked prioritizers is a nice idea.<br>
But then we need to impose some preference here; if we do not set any restr=
ictions on the value of the prioritizers we end up with a jumble of (essent=
ially unreadable) priorities.<br>
EG if your weightedpath returns values of &#39;5&#39; or &#39;0&#39; they&#=
39;ll be readily obscured by alua information, which uses &#39;5&#39; for t=
he non-optimized path.<br>
<br>
So if we were to got that route we need to restrict the values of the prior=
itizers to eg 256, and shift the stacked prioritizer values ontop of each o=
ther.<br>
EG with a stacked &#39;prio_alua+weightedpath&#39; we should end up with a =
priority of 0xAAWW.<br>
With that we can allow up to 4 levels of stacking (or 8 if we extend that t=
o 64 bits), and still keep source-level compability with the original code.=
<br>
We could even reduce the permissive values for the prioritzers even more; 1=
6 is enough even for ALUA, and that would leave us with enough room of 1024=
 possible stacking levels :-)<br>
<br>
But in general I like the idea.<div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
Cheers,<br>
<br>
Hannes<br>
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
</div></div></blockquote></div><br></div>

--001a1140211ece3e27053901b0da--


--===============4673123857389224494==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4673123857389224494==--
