From: "Ethan John" <ethan.john@gmail.com>
Subject: Re: Designing a new prio_callout
Date: Fri, 10 Aug 2007 08:40:44 -0700
Message-ID: <d61540a40708100840m541e198dg88c12d031febf968@mail.gmail.com>
References: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>
	<46A735E1.4070206@suse.de>
	<d61540a40707290903q359cc7c8g52f07627b4b9fba7@mail.gmail.com>
	<46AD85A5.1060609@suse.de>
	<d61540a40708091055u725fa5e4wa182ac1d778323be@mail.gmail.com>
	<46BC7F14.80302@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0378388099=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46BC7F14.80302@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============0378388099==
Content-Type: multipart/alternative;
	boundary="----=_Part_18593_23965961.1186760444891"

------=_Part_18593_23965961.1186760444891
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hannes, thanks again for your help with this.

I haven't noticed that failback does the right thing, but I'll try it out
again. Could be something we're doing wrong. In any case, there's very
little documentation on all this, and I'm trying to develop some kind of
strategy for our Linux customers to use until we get ALUA implemented.

Being able to set path priorities manually would be ideal, but it seems lik=
e
this is impossible, right?

Here's the situation we have right now. I initiate two connections to one
target, across two sessions with two different IPs, with two LUs. Multipath
looks like this:
mpath45 (20002c9020020001a00151b6b46bb57b0) dm-1 company,iSCSI target
[size=3D15G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D1][active]
 \_ 22:0:0:1 sdc 8:32  [active][ready]
\_ round-robin 0 [prio=3D1][enabled]
 \_ 23:0:0:1 sde 8:64  [active][ready]
mpath44 (20002c9020020001200151b6b46bb57ae) dm-0 company,iSCSI target
[size=3D15G][features=3D0][hwhandler=3D0]
\_ round-robin 0 [prio=3D1][enabled]
 \_ 22:0:0:0 sdb 8:16  [active][ready]
\_ round-robin 0 [prio=3D1][enabled]
 \_ 23:0:0:0 sdd 8:48  [active][ready]

Note that there are only two active sessions:
# iscsiadm -m session
tcp: [20] 10.53.152.22:3260,1 iqn.2001-07.com.company:qaiscsi2:blah1
tcp: [21] 10.53.152.23:3260,2 iqn.2001-07.com.company:qaiscsi2:blah1

So the result is that all activity is routed to the first session that was
initiated. I want to change the priorities of the paths to allow for traffi=
c
to go to the first IP for mpath45 and the second IP for mpath46.

Obviously ALUA is the way to go for this in the future, but we won't have
the resources to implement that, so I'm looking for an interim solution tha=
t
will scale to thousands of clients. Right now, the only thing I can tell
people is to manually initiate connections to certain targets through
certain IP addresses -- basically, doing the load balancing themselves. Is
there a better way?

On 8/10/07, Hannes Reinecke <hare@suse.de> wrote:
>
> Ethan John wrote:
> > Is it possible to manually set the priority of a path after a connectio=
n
> has
> > been established?
> >
> > Since we're doing failover-only (only 1 active path at a time), it woul=
d
> be
> > nice to tell users that they can manually reset priority after a
> failure.
> > For example, in a configuration with two paths, where one is active and
> the
> > other is passive for two differeent volumes, a failure of one path will
> > result in all traffic going through the one remaining path. After the
> second
> > path comes back up, all traffic will still be written to the first path
> > (paths are not rebalanced after a failure).
> >
> Not necessarily. There is the keyword 'failback', which can be set to
> IMMEDIATE, causing all paths to fail back to the original path once it
> comes back.
>
> And as you don't actually need to send any commands for facilitate
> the failover I doubt you'd need to develop your own hardware handler.
>
> The existing tweaks should be enough, I think.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



--=20
Ethan John
http://www.flickr.com/photos/thaen/
(206) 841.4157

------=_Part_18593_23965961.1186760444891
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hannes, thanks again for your help with this.<br>&nbsp;<br>I haven&#39;t no=
ticed that failback does the right thing, but I&#39;ll try it out again. Co=
uld be something we&#39;re doing wrong. In any case, there&#39;s very littl=
e documentation on all this, and I&#39;m trying to develop some kind of str=
ategy for our Linux customers to use until we get ALUA implemented.
<br><br>Being able to set path priorities manually would be ideal, but it s=
eems like this is impossible, right?<br><br>Here&#39;s the situation we hav=
e right now. I initiate two connections to one target, across two sessions =
with two different IPs, with two LUs. Multipath looks like this:
<br>mpath45 (20002c9020020001a00151b6b46bb57b0) dm-1 company,iSCSI target<b=
r>[size=3D15G][features=3D0][hwhandler=3D0]<br>\_ round-robin 0 [prio=3D1][=
active]<br>&nbsp;\_ 22:0:0:1 sdc 8:32&nbsp; [active][ready]<br>\_ round-rob=
in 0 [prio=3D1][enabled]
<br>&nbsp;\_ 23:0:0:1 sde 8:64&nbsp; [active][ready]<br>mpath44 (20002c9020=
020001200151b6b46bb57ae) dm-0 company,iSCSI target<br>[size=3D15G][features=
=3D0][hwhandler=3D0]<br>\_ round-robin 0 [prio=3D1][enabled]<br>&nbsp;\_ 22=
:0:0:0 sdb 8:16&nbsp; [active][ready]
<br>\_ round-robin 0 [prio=3D1][enabled]<br>&nbsp;\_ 23:0:0:0 sdd 8:48&nbsp=
; [active][ready]<br><br>Note that there are only two active sessions:<br>#=
 iscsiadm -m session<br>tcp: [20] <a href=3D"http://10.53.152.22:3260">10.5=
3.152.22:3260
</a>,1 iqn.2001-07.com.company:qaiscsi2:blah1<br>tcp: [21] <a href=3D"http:=
//10.53.152.23:3260">10.53.152.23:3260</a>,2 iqn.2001-07.com.company:qaiscs=
i2:blah1<br><br>So the result is that all activity is routed to the first s=
ession that was initiated. I want to change the priorities of the paths to =
allow for traffic to go to the first IP for mpath45 and the second IP for m=
path46.
<br><br>Obviously ALUA is the way to go for this in the future, but we won&=
#39;t have the resources to implement that, so I&#39;m looking for an inter=
im solution that will scale to thousands of clients. Right now, the only th=
ing I can tell people is to manually initiate connections to certain target=
s through certain IP addresses -- basically, doing the load balancing thems=
elves. Is there a better way?
<br><br><div><span class=3D"gmail_quote">On 8/10/07, <b class=3D"gmail_send=
ername">Hannes Reinecke</b> &lt;<a href=3D"mailto:hare@suse.de">hare@suse.d=
e</a>&gt; wrote:</span><blockquote class=3D"gmail_quote" style=3D"border-le=
ft: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: =
1ex;">
Ethan John wrote:<br>&gt; Is it possible to manually set the priority of a =
path after a connection has<br>&gt; been established?<br>&gt;<br>&gt; Since=
 we&#39;re doing failover-only (only 1 active path at a time), it would be
<br>&gt; nice to tell users that they can manually reset priority after a f=
ailure.<br>&gt; For example, in a configuration with two paths, where one i=
s active and the<br>&gt; other is passive for two differeent volumes, a fai=
lure of one path will
<br>&gt; result in all traffic going through the one remaining path. After =
the second<br>&gt; path comes back up, all traffic will still be written to=
 the first path<br>&gt; (paths are not rebalanced after a failure).<br>
&gt;<br>Not necessarily. There is the keyword &#39;failback&#39;, which can=
 be set to<br>IMMEDIATE, causing all paths to fail back to the original pat=
h once it<br>comes back.<br><br>And as you don&#39;t actually need to send =
any commands for facilitate
<br>the failover I doubt you&#39;d need to develop your own hardware handle=
r.<br><br>The existing tweaks should be enough, I think.<br><br>Cheers,<br>=
<br>Hannes<br>--<br>Dr. Hannes Reinecke&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; zS=
eries &amp; Storage
<br><a href=3D"mailto:hare@suse.de">hare@suse.de</a>&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;+49 911 74053 688=
<br>SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg<br>GF: Markus=
 Rex, HRB 16746 (AG N=FCrnberg)<br><br>--<br>dm-devel mailing list
<br><a href=3D"mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><a hr=
ef=3D"https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.=
com/mailman/listinfo/dm-devel</a><br></blockquote></div><br><br clear=3D"al=
l">
<br>-- <br>Ethan John<br><a href=3D"http://www.flickr.com/photos/thaen/">ht=
tp://www.flickr.com/photos/thaen/</a><br>(206) 841.4157

------=_Part_18593_23965961.1186760444891--


--===============0378388099==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0378388099==--
