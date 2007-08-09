From: "Ethan John" <ethan.john@gmail.com>
Subject: Re: Designing a new prio_callout
Date: Thu, 9 Aug 2007 10:55:50 -0700
Message-ID: <d61540a40708091055u725fa5e4wa182ac1d778323be@mail.gmail.com>
References: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>
	<46A735E1.4070206@suse.de>
	<d61540a40707290903q359cc7c8g52f07627b4b9fba7@mail.gmail.com>
	<46AD85A5.1060609@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1155424526=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46AD85A5.1060609@suse.de>
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

--===============1155424526==
Content-Type: multipart/alternative;
	boundary="----=_Part_9282_16000655.1186682150449"

------=_Part_9282_16000655.1186682150449
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Is it possible to manually set the priority of a path after a connection ha=
s
been established?

Since we're doing failover-only (only 1 active path at a time), it would be
nice to tell users that they can manually reset priority after a failure.
For example, in a configuration with two paths, where one is active and the
other is passive for two differeent volumes, a failure of one path will
result in all traffic going through the one remaining path. After the secon=
d
path comes back up, all traffic will still be written to the first path
(paths are not rebalanced after a failure).

At this point, we're looking for a decent solution for customers that
doesn't involve ALUA, since we won't have resources to implement that for
this first version of our target. Ideally, we'd like to be able to set the
priority for paths automatically through one of the mpath_prio_* scripts.
Even allowing a user to set these priorities manually would be better than
advising them to use mpath_prio_random as the "easy configuration" solution=
.

We're not looking to develop our own method of load balancing or failover.
We want to work within the MPIO world, but it's a little difficult given
that we don't support active/active configurations.

Thanks so much for you help so far!

On 7/29/07, Hannes Reinecke <hare@suse.de> wrote:
>
> Ethan John wrote:
> > Thanks for the heads-up about ALUA. We're looking into it.
> >
> > What is the purpose of the custom mpio_prio_* applications that ship
> > with open-iscsi if not to handle multipathing?
> >
> It is. mpath_prio_* are the priority callouts for multipathing.
> They determine the layout of the multipath map.
> Theory is that mpath_prio_* will return the priority for a
> given path in relation to the entire multipath layout.
>
> If used with 'group_by_prio' all paths with the same
> priority will be grouped into one multipath group, and
> the group with the highest priority will become active.
>
> When all paths in a group fail, the group with the next
> highest priority will become active. Additionally some
> failover command (as determined by the hardware handler)
> may be send to the target.
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

------=_Part_9282_16000655.1186682150449
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Is it possible to manually set the priority of a path after a connection ha=
s been established?<br><br>Since we&#39;re doing failover-only (only 1 acti=
ve path at a time), it would be nice to tell users that they can manually r=
eset priority after a failure. For example, in a configuration with two pat=
hs, where one is active and the other is passive for two differeent volumes=
, a failure of one path will result in all traffic going through the one re=
maining path. After the second path comes back up, all traffic will still b=
e written to the first path (paths are not rebalanced after a failure).
<br><br>At this point, we&#39;re looking for a decent solution for customer=
s that doesn&#39;t involve ALUA, since we won&#39;t have resources to imple=
ment that for this first version of our target. Ideally, we&#39;d like to b=
e able to set the priority for paths automatically through one of the mpath=
_prio_* scripts. Even allowing a user to set these priorities manually woul=
d be better than advising them to use mpath_prio_random as the &quot;easy c=
onfiguration&quot; solution.
<br><br>We&#39;re not looking to develop our own method of load balancing o=
r failover. We want to work within the MPIO world, but it&#39;s a little di=
fficult given that we don&#39;t support active/active configurations.<br>
<br>Thanks so much for you help so far!<br><br><div><span class=3D"gmail_qu=
ote">On 7/29/07, <b class=3D"gmail_sendername">Hannes Reinecke</b> &lt;<a h=
ref=3D"mailto:hare@suse.de">hare@suse.de</a>&gt; wrote:</span><blockquote c=
lass=3D"gmail_quote" style=3D"border-left: 1px solid rgb(204, 204, 204); ma=
rgin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Ethan John wrote:<br>&gt; Thanks for the heads-up about ALUA. We&#39;re loo=
king into it.<br>&gt;<br>&gt; What is the purpose of the custom mpio_prio_*=
 applications that ship<br>&gt; with open-iscsi if not to handle multipathi=
ng?
<br>&gt;<br>It is. mpath_prio_* are the priority callouts for multipathing.=
<br>They determine the layout of the multipath map.<br>Theory is that mpath=
_prio_* will return the priority for a<br>given path in relation to the ent=
ire multipath layout.
<br><br>If used with &#39;group_by_prio&#39; all paths with the same<br>pri=
ority will be grouped into one multipath group, and<br>the group with the h=
ighest priority will become active.<br><br>When all paths in a group fail, =
the group with the next
<br>highest priority will become active. Additionally some<br>failover comm=
and (as determined by the hardware handler)<br>may be send to the target.<b=
r><br>Cheers,<br><br>Hannes<br>--<br>Dr. Hannes Reinecke&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; zSeries &amp; Storage
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

------=_Part_9282_16000655.1186682150449--


--===============1155424526==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1155424526==--
