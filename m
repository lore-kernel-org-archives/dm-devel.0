From: "Ethan John" <ethan.john@gmail.com>
Subject: Re: Designing a new prio_callout
Date: Mon, 27 Aug 2007 08:50:19 -0700
Message-ID: <d61540a40708270850v6a097dddo55d2879344fa24b@mail.gmail.com>
References: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>
	<46A735E1.4070206@suse.de>
	<d61540a40707290903q359cc7c8g52f07627b4b9fba7@mail.gmail.com>
	<46AD85A5.1060609@suse.de>
	<d61540a40708091055u725fa5e4wa182ac1d778323be@mail.gmail.com>
	<46BC7F14.80302@suse.de>
	<d61540a40708100840m541e198dg88c12d031febf968@mail.gmail.com>
	<d61540a40708141005n4eb06cebx14559f055b0df3d6@mail.gmail.com>
	<46D2E929.4080905@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0935045495=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46D2E929.4080905@suse.de>
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

--===============0935045495==
Content-Type: multipart/alternative;
	boundary="----=_Part_44468_26309426.1188229819704"

------=_Part_44468_26309426.1188229819704
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Thanks again, Hannes. We really appreciate your time on this.

Stefan's suggestion will be a great option for round-robin failover for our
first release. We'll try to figure out a way to do that. It also sounds lik=
e
using the ALUA callout is going to be the best long-term solution, which
answers the original question that I posed.

As for putting failover paths on a different subnet, that will be up to the
user to manage. We won't prevent that sort of thing, and network
configurations are extremely flexible on our systems. Subnet also doesn't
necessarily effect physical network paths with our system.

Again, thanks so much for your help!

On 8/27/07, Hannes Reinecke <hare@suse.de> wrote:
>
> Ethan John wrote:
> > For the record, setting rr_min_io to something extremely large (we're
> using
> > 2 billion now, since I'm assuming it's a C integer) solves the immediat=
e
> > problem that we're having (overhead in path switching causing poor
> > performance). Telling people to use mpath_prio_random is still less tha=
n
> > ideal for any small number of iSCSI targets, but it a better short-term
> > solution for us than nothing.
> >
> In setting rr_min_io to something extremely large you effectively
> disable the round-robin scheduler in multipathing.
> That's okay for the failover scenario you have (as you only have
> one path per group), but whenever you have more than one path
> in a group that wouldn't work anymore.
>
> > On 8/10/07, Ethan John <ethan.john@gmail.com> wrote:
> >> Hannes, thanks again for your help with this.
> >>
> >> I haven't noticed that failback does the right thing, but I'll try it
> out
> >> again. Could be something we're doing wrong. In any case, there's very
> >> little documentation on all this, and I'm trying to develop some kind
> of
> >> strategy for our Linux customers to use until we get ALUA implemented.
> >>
> >> Being able to set path priorities manually would be ideal, but it seem=
s
> >> like this is impossible, right?
> >>
> >> Here's the situation we have right now. I initiate two connections to
> one
> >> target, across two sessions with two different IPs, with two LUs.
> Multipath
> >> looks like this:
> >> mpath45 (20002c9020020001a00151b6b46bb57b0) dm-1 company,iSCSI target
> >> [size=3D15G][features=3D0][hwhandler=3D0]
> >> \_ round-robin 0 [prio=3D1][active]
> >>  \_ 22:0:0:1 sdc 8:32  [active][ready]
> >> \_ round-robin 0 [prio=3D1][enabled]
> >>  \_ 23:0:0:1 sde 8:64  [active][ready]
> >> mpath44 (20002c9020020001200151b6b46bb57ae) dm-0 company,iSCSI target
> >> [size=3D15G][features=3D0][hwhandler=3D0]
> >> \_ round-robin 0 [prio=3D1][enabled]
> >>  \_ 22:0:0:0 sdb 8:16  [active][ready]
> >> \_ round-robin 0 [prio=3D1][enabled]
> >>  \_ 23:0:0:0 sdd 8:48  [active][ready]
> >>
> >> Note that there are only two active sessions:
> >> # iscsiadm -m session
> >> tcp: [20] 10.53.152.22:3260 ,1 iqn.2001-07.com.company:qaiscsi2:blah1
> >> tcp: [21] 10.53.152.23:3260,2 iqn.2001-07.com.company:qaiscsi2:blah1
> >>
> >> So the result is that all activity is routed to the first session that
> was
> >> initiated. I want to change the priorities of the paths to allow for
> traffic
> >> to go to the first IP for mpath45 and the second IP for mpath46.
> >>
> That's a matter of the IP routing. Having both target on the same (sub-)
> net
> doesn't work very well with multipathing. Please setup your system with
> each iSCSI Target port in a different subnet eg
>
> 10.53.152.22:3260,1 iqn.2001-07.com.company:qaiscsi2:blah1
> 10.53.153.22:3260,2 iqn.2001-07.com.company:qaiscsi2:blah1
>
> then you'll have one iSCSI target port per subnet and you can actually
> do failover etc.
>
> >> Obviously ALUA is the way to go for this in the future, but we won't
> have
> >> the resources to implement that, so I'm looking for an interim solutio=
n
> that
> >> will scale to thousands of clients. Right now, the only thing I can
> tell
> >> people is to manually initiate connections to certain targets through
> >> certain IP addresses -- basically, doing the load balancing themselves=
.
> Is
> >> there a better way?
> >>
> No, not really. But I'm not a network guru. You may want to ask on
> the open-iscsi mailing list.
>
> And you can get all information you need via sysfs, so it should
> be possible to create a script like Stefan Bader suggested.
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

------=_Part_44468_26309426.1188229819704
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Thanks again, Hannes. We really appreciate your time on this.<br><br>Stefan=
&#39;s suggestion will be a great option for round-robin failover for our f=
irst release. We&#39;ll try to figure out a way to do that. It also sounds =
like using the ALUA callout is going to be the best long-term solution, whi=
ch answers the original question that I posed.
<br><br>As for putting failover paths on a different subnet, that will be u=
p to the user to manage. We won&#39;t prevent that sort of thing, and netwo=
rk configurations are extremely flexible on our systems. Subnet also doesn&=
#39;t necessarily effect physical network paths with our system.
<br><br>Again, thanks so much for your help!<br><br><div><span class=3D"gma=
il_quote">On 8/27/07, <b class=3D"gmail_sendername">Hannes Reinecke</b> &lt=
;<a href=3D"mailto:hare@suse.de">hare@suse.de</a>&gt; wrote:</span><blockqu=
ote class=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204=
); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Ethan John wrote:<br>&gt; For the record, setting rr_min_io to something ex=
tremely large (we&#39;re using<br>&gt; 2 billion now, since I&#39;m assumin=
g it&#39;s a C integer) solves the immediate<br>&gt; problem that we&#39;re=
 having (overhead in path switching causing poor
<br>&gt; performance). Telling people to use mpath_prio_random is still les=
s than<br>&gt; ideal for any small number of iSCSI targets, but it a better=
 short-term<br>&gt; solution for us than nothing.<br>&gt;<br>In setting rr_=
min_io to something extremely large you effectively
<br>disable the round-robin scheduler in multipathing.<br>That&#39;s okay f=
or the failover scenario you have (as you only have<br>one path per group),=
 but whenever you have more than one path<br>in a group that wouldn&#39;t w=
ork anymore.
<br><br>&gt; On 8/10/07, Ethan John &lt;<a href=3D"mailto:ethan.john@gmail.=
com">ethan.john@gmail.com</a>&gt; wrote:<br>&gt;&gt; Hannes, thanks again f=
or your help with this.<br>&gt;&gt;<br>&gt;&gt; I haven&#39;t noticed that =
failback does the right thing, but I&#39;ll try it out
<br>&gt;&gt; again. Could be something we&#39;re doing wrong. In any case, =
there&#39;s very<br>&gt;&gt; little documentation on all this, and I&#39;m =
trying to develop some kind of<br>&gt;&gt; strategy for our Linux customers=
 to use until we get ALUA implemented.
<br>&gt;&gt;<br>&gt;&gt; Being able to set path priorities manually would b=
e ideal, but it seems<br>&gt;&gt; like this is impossible, right?<br>&gt;&g=
t;<br>&gt;&gt; Here&#39;s the situation we have right now. I initiate two c=
onnections to one
<br>&gt;&gt; target, across two sessions with two different IPs, with two L=
Us. Multipath<br>&gt;&gt; looks like this:<br>&gt;&gt; mpath45 (20002c90200=
20001a00151b6b46bb57b0) dm-1 company,iSCSI target<br>&gt;&gt; [size=3D15G][=
features=3D0][hwhandler=3D0]
<br>&gt;&gt; \_ round-robin 0 [prio=3D1][active]<br>&gt;&gt;&nbsp;&nbsp;\_ =
22:0:0:1 sdc 8:32&nbsp;&nbsp;[active][ready]<br>&gt;&gt; \_ round-robin 0 [=
prio=3D1][enabled]<br>&gt;&gt;&nbsp;&nbsp;\_ 23:0:0:1 sde 8:64&nbsp;&nbsp;[=
active][ready]<br>&gt;&gt; mpath44 (20002c9020020001200151b6b46bb57ae) dm-0=
 company,iSCSI target
<br>&gt;&gt; [size=3D15G][features=3D0][hwhandler=3D0]<br>&gt;&gt; \_ round=
-robin 0 [prio=3D1][enabled]<br>&gt;&gt;&nbsp;&nbsp;\_ 22:0:0:0 sdb 8:16&nb=
sp;&nbsp;[active][ready]<br>&gt;&gt; \_ round-robin 0 [prio=3D1][enabled]<b=
r>&gt;&gt;&nbsp;&nbsp;\_ 23:0:0:0 sdd 8:48&nbsp;&nbsp;[active][ready]
<br>&gt;&gt;<br>&gt;&gt; Note that there are only two active sessions:<br>&=
gt;&gt; # iscsiadm -m session<br>&gt;&gt; tcp: [20] <a href=3D"http://10.53=
.152.22:3260">10.53.152.22:3260</a> ,1 iqn.2001-07.com.company:qaiscsi2:bla=
h1
<br>&gt;&gt; tcp: [21] <a href=3D"http://10.53.152.23:3260">10.53.152.23:32=
60</a>,2 iqn.2001-07.com.company:qaiscsi2:blah1<br>&gt;&gt;<br>&gt;&gt; So =
the result is that all activity is routed to the first session that was<br>
&gt;&gt; initiated. I want to change the priorities of the paths to allow f=
or traffic<br>&gt;&gt; to go to the first IP for mpath45 and the second IP =
for mpath46.<br>&gt;&gt;<br>That&#39;s a matter of the IP routing. Having b=
oth target on the same (sub-) net
<br>doesn&#39;t work very well with multipathing. Please setup your system =
with<br>each iSCSI Target port in a different subnet eg<br><br><a href=3D"h=
ttp://10.53.152.22:3260">10.53.152.22:3260</a>,1 iqn.2001-07.com.company:qa=
iscsi2:blah1
<br><a href=3D"http://10.53.153.22:3260">10.53.153.22:3260</a>,2 iqn.2001-0=
7.com.company:qaiscsi2:blah1<br><br>then you&#39;ll have one iSCSI target p=
ort per subnet and you can actually<br>do failover etc.<br><br>&gt;&gt; Obv=
iously ALUA is the way to go for this in the future, but we won&#39;t have
<br>&gt;&gt; the resources to implement that, so I&#39;m looking for an int=
erim solution that<br>&gt;&gt; will scale to thousands of clients. Right no=
w, the only thing I can tell<br>&gt;&gt; people is to manually initiate con=
nections to certain targets through
<br>&gt;&gt; certain IP addresses -- basically, doing the load balancing th=
emselves. Is<br>&gt;&gt; there a better way?<br>&gt;&gt;<br>No, not really.=
 But I&#39;m not a network guru. You may want to ask on<br>the open-iscsi m=
ailing list.
<br><br>And you can get all information you need via sysfs, so it should<br=
>be possible to create a script like Stefan Bader suggested.<br><br>Cheers,=
<br><br>Hannes<br>--<br>Dr. Hannes Reinecke&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; zSeries &amp; Storage
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

------=_Part_44468_26309426.1188229819704--


--===============0935045495==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0935045495==--
