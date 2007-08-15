From: "Ethan John" <ethan.john@gmail.com>
Subject: Re: Designing a new prio_callout
Date: Wed, 15 Aug 2007 08:57:09 -0700
Message-ID: <d61540a40708150857v3182b221sa0c91d0cf90fd162@mail.gmail.com>
References: <d61540a40706211442w1ef3bacflddd44f74c8883a3f@mail.gmail.com>
	<46A735E1.4070206@suse.de>
	<d61540a40707290903q359cc7c8g52f07627b4b9fba7@mail.gmail.com>
	<46AD85A5.1060609@suse.de>
	<d61540a40708091055u725fa5e4wa182ac1d778323be@mail.gmail.com>
	<46BC7F14.80302@suse.de>
	<d61540a40708100840m541e198dg88c12d031febf968@mail.gmail.com>
	<d61540a40708141005n4eb06cebx14559f055b0df3d6@mail.gmail.com>
	<5201e28f0708150145s42ff46a5t8dab865931cb09d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1270379425=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5201e28f0708150145s42ff46a5t8dab865931cb09d@mail.gmail.com>
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

--===============1270379425==
Content-Type: multipart/alternative;
	boundary="----=_Part_52492_5493373.1187193429158"

------=_Part_52492_5493373.1187193429158
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Definitely, that would be ideal -- having code on our end that tracked who
was writing to which path. It's a matter of development effort at this
point, and so I'm exploring other options.

You can imagine our system as a number of different machines -- each with
separate network addresses -- that all provide access to the same LUs. Let's
say you have a single target on our system called "mytarget." Users could
log into that target via any one of a number of network addresses (even via
DNS name, I suppose).

So the response from SendTargets is along the lines of:
10.53.152.22:3260,1 iqn.2001-07.com.company:qaiscsi2:mytarget
10.53.152.23:3260,2 iqn.2001-07.com.company:qaiscsi2:mytarget

So they might initiate two logins to two separate IPs:
iscsiadm -m node --portal 10.53.152.22 --target
iqn.2001-07.com.company:qaiscsi2:mytarget --login;
iscsiadm -m node --portal 10.53.152.23 --target
iqn.2001-07.com.company:qaiscsi2:mytarget --login;

Now what happens? If mytarget has multiple LUs associated with it, the
multipath output will look like it did below if failover is being used --
two paths for each of two devices. The problem for us is that by default,
multipath just uses the first path that it sees. Which means that for every
device in mytarget, all data will be read and written across just the first
path -- 10.53.151.22, in this case.

We need a way to load balance connections across all available connections.

There are several ways that I can see to do this. Ideally, we would
implement ALUA on our end and advise people to use mpath_prio_alua as their
callout. But this has a development cost. We could also implement a custom
system as your suggest, but this also has a development cost.

If we could advise users to manually set priorities on the client side, that
would be acceptable, but this is impossible with the current version of
multipath.

As such, the best we can do is to set path priorities randomly, using
mpath_prio_random. This is fine, but there is a significant cost in terms of
resource usage on our system when the active path changes frequently,
especially in cases where users have thousands of clients connected to our
system, and paths are switching constantly. Thus we need to limit the number
of times the active path switches, which the rr_min_io settings seems to do
quite nicely.

Not sure if that makes any more sense? I'm trying to be thorough for the
sake of the next guy. The information on the web is pretty minimal about all
this, and it's been a painful experience getting up to speed.


On a related note, I've read the reports of people experiencing higher
levels of performance with lower settings of rr_min_io, but it seems to me
that as rr_min_io gets smaller, the system becomes less like active/passive
MPIO and more like active/active MPIO, so users experiencing this
performance improvement would be better off using group_by_serial, so that
all paths are excitable simultaneously.

On 8/15/07, Stefan Bader <Stefan.Bader@de.ibm.com> wrote:
>
> Hi Ethan,
>
> I might not understand the problem completely but I do not understand
> the benefit of changing rr_min_io. As far as I can see from your
> multipath output, both of the devices consist of two path groups with
> one path. This means, as long as there is no path failure I/O will
> never be sent to the inactive group.
> I guess the only thing you need is a script that might find out from a
> given scsi device (like sdc) whether this would be the preferred path
> and then print a number that represents the priority (the lower, the
> higher). Then use this as priority callout and group by priority with
> failback set to immediate.
>
> Regards,
> Stefan
>
> 2007/8/14, Ethan John <ethan.john@gmail.com>:
> > For the record, setting rr_min_io to something extremely large (we're
> using
> > 2 billion now, since I'm assuming it's a C integer) solves the immediate
> > problem that we're having (overhead in path switching causing poor
>
> > > mpath45 (20002c9020020001a00151b6b46bb57b0) dm-1
> > company,iSCSI target
> > > [size=15G][features=0][hwhandler=0]
> > > \_ round-robin 0 [prio=1][active]
> > >  \_ 22:0:0:1 sdc 8:32  [active][ready]
> > > \_ round-robin 0 [prio=1][enabled]
> > >  \_ 23:0:0:1 sde 8:64  [active][ready]
> > > mpath44 (20002c9020020001200151b6b46bb57ae) dm-0
> > company,iSCSI target
> > > [size=15G][features=0][hwhandler=0]
> > > \_ round-robin 0 [prio=1][enabled]
> > >  \_ 22:0:0:0 sdb 8:16  [active][ready]
> > > \_ round-robin 0 [prio=1][enabled]
> > >  \_ 23:0:0:0 sdd 8:48  [active][ready]
> > >
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>



-- 
Ethan John
http://www.flickr.com/photos/thaen/
(206) 841.4157

------=_Part_52492_5493373.1187193429158
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Definitely, that would be ideal -- having code on our end that tracked who was writing to which path. It&#39;s a matter of development effort at this point, and so I&#39;m exploring other options.<br><br>You can imagine our system as a number of different machines -- each with separate network addresses -- that all provide access to the same LUs. Let&#39;s say you have a single target on our system called &quot;mytarget.&quot; Users could log into that target via any one of a number of network addresses (even via DNS name, I suppose). 
<br><br>So the response from SendTargets is along the lines of:<br><a href="http://10.53.152.22:3260">10.53.152.22:3260</a>,1 iqn.2001-07.com.company:qaiscsi2:mytarget<br><a href="http://10.53.152.23:3260">10.53.152.23:3260
</a>,2 iqn.2001-07.com.company:qaiscsi2:mytarget<br><br>So they might initiate two logins to two separate IPs:<br>iscsiadm -m node --portal <a href="http://10.53.152.22">10.53.152.22</a> --target iqn.2001-07.com.company:qaiscsi2:mytarget
 --login;<br>iscsiadm -m node --portal <a href="http://10.53.152.23">10.53.152.23</a> --target iqn.2001-07.com.company:qaiscsi2:mytarget --login;<br><br>Now what happens? If mytarget has multiple LUs associated with it, the multipath output will look like it did below if failover is being used -- two paths for each of two devices. The problem for us is that by default, multipath just uses the first path that it sees. Which means that for every device in mytarget, all data will be read and written across just the first path -- 
<a href="http://10.53.151.22">10.53.151.22</a>, in this case. <br><br>We need a way to load balance connections across all available connections. <br><br>There are several ways that I can see to do this. Ideally, we would implement ALUA on our end and advise people to use mpath_prio_alua as their callout. But this has a development cost. We could also implement a custom system as your suggest, but this also has a development cost.
<br><br>If we could advise users to manually set priorities on the client side, that would be acceptable, but this is impossible with the current version of multipath.<br><br>As such, the best we can do is to set path priorities randomly, using mpath_prio_random. This is fine, but there is a significant cost in terms of resource usage on our system when the active path changes frequently, especially in cases where users have thousands of clients connected to our system, and paths are switching constantly. Thus we need to limit the number of times the active path switches, which the rr_min_io settings seems to do quite nicely.
<br><br>Not sure if that makes any more sense? I&#39;m trying to be thorough for the sake of the next guy. The information on the web is pretty minimal about all this, and it&#39;s been a painful experience getting up to speed.
<br><br><br>On a related note, I&#39;ve read the reports of people experiencing higher levels of performance with lower settings of rr_min_io, but it seems to me that as rr_min_io gets smaller, the system becomes less like active/passive MPIO and more like active/active MPIO, so users experiencing this performance improvement would be better off using group_by_serial, so that all paths are excitable simultaneously.
<br><br><div><span class="gmail_quote">On 8/15/07, <b class="gmail_sendername">Stefan Bader</b> &lt;<a href="mailto:Stefan.Bader@de.ibm.com">Stefan.Bader@de.ibm.com</a>&gt; wrote:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi Ethan,<br><br>I might not understand the problem completely but I do not understand<br>the benefit of changing rr_min_io. As far as I can see from your<br>multipath output, both of the devices consist of two path groups with
<br>one path. This means, as long as there is no path failure I/O will<br>never be sent to the inactive group.<br>I guess the only thing you need is a script that might find out from a<br>given scsi device (like sdc) whether this would be the preferred path
<br>and then print a number that represents the priority (the lower, the<br>higher). Then use this as priority callout and group by priority with<br>failback set to immediate.<br><br>Regards,<br>Stefan<br><br>2007/8/14, Ethan John &lt;
<a href="mailto:ethan.john@gmail.com">ethan.john@gmail.com</a>&gt;:<br>&gt; For the record, setting rr_min_io to something extremely large (we&#39;re using<br>&gt; 2 billion now, since I&#39;m assuming it&#39;s a C integer) solves the immediate
<br>&gt; problem that we&#39;re having (overhead in path switching causing poor<br><br>&gt; &gt; mpath45 (20002c9020020001a00151b6b46bb57b0) dm-1<br>&gt; company,iSCSI target<br>&gt; &gt; [size=15G][features=0][hwhandler=0]
<br>&gt; &gt; \_ round-robin 0 [prio=1][active]<br>&gt; &gt;&nbsp;&nbsp;\_ 22:0:0:1 sdc 8:32&nbsp;&nbsp;[active][ready]<br>&gt; &gt; \_ round-robin 0 [prio=1][enabled]<br>&gt; &gt;&nbsp;&nbsp;\_ 23:0:0:1 sde 8:64&nbsp;&nbsp;[active][ready]<br>&gt; &gt; mpath44 (20002c9020020001200151b6b46bb57ae) dm-0
<br>&gt; company,iSCSI target<br>&gt; &gt; [size=15G][features=0][hwhandler=0]<br>&gt; &gt; \_ round-robin 0 [prio=1][enabled]<br>&gt; &gt;&nbsp;&nbsp;\_ 22:0:0:0 sdb 8:16&nbsp;&nbsp;[active][ready]<br>&gt; &gt; \_ round-robin 0 [prio=1][enabled]
<br>&gt; &gt;&nbsp;&nbsp;\_ 23:0:0:0 sdd 8:48&nbsp;&nbsp;[active][ready]<br>&gt; &gt;<br><br>--<br>dm-devel mailing list<br><a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><a href="https://www.redhat.com/mailman/listinfo/dm-devel">
https://www.redhat.com/mailman/listinfo/dm-devel</a><br></blockquote></div><br><br clear="all"><br>-- <br>Ethan John<br><a href="http://www.flickr.com/photos/thaen/">http://www.flickr.com/photos/thaen/</a><br>(206) 841.4157


------=_Part_52492_5493373.1187193429158--


--===============1270379425==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1270379425==--
