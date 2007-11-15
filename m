From: "Kevin Foote" <kevin.foote@gmail.com>
Subject: Re: DM-Multipath path failure questions..
Date: Wed, 14 Nov 2007 23:55:10 -0500
Message-ID: <5fb0f77b0711142055y1bdb4f9dkde59c0c12be132d6@mail.gmail.com>
References: <20071114000743.3b2d36a5.vaio@nolatency.com>
	<5fb0f77b0711141026w327195f3rd9a7a4d1ec9ba716@mail.gmail.com>
	<20071114173906.17029cdc.vaio@nolatency.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2004023263=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071114173906.17029cdc.vaio@nolatency.com>
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

--===============2004023263==
Content-Type: multipart/alternative;
	boundary="----=_Part_4730_32218119.1195102510895"

------=_Part_4730_32218119.1195102510895
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

As far as I know you should be able to do the same as with a SAN. you can
have multiple block-dev entries (to handle your aggregated IO) per path
group. Some one on the list please correct me if Im wrong.. So in my
previous example things would expand like this to handle your aggregated IO
to the device.

media-oracle (30690a018a0b3d369dd4f04191c4090f9)
[size=8 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 2:0:8:0 sdj 8:144 [active][ready]            }
 \_ another dev here                                    } These all make up
path group one
 \_ another dev here                                    }
\_ round-robin 0 [enabled]
 \_ 3:0:8:0 sdr 65:16 [active][ready]           }
 \_ another dev here                                   }
 \_ another dev here                                   } These all make up
path group two
 \_ another dev here                                   }

Our ISCSI net is very isolated and built with failover so unless we loose
two switches at once there should be no hick-up. Sorry cant fill in any more
on that end.

On a side note.. can we go of list Id like to hear more about your
Equallogic issue. Ive got some wierd nonsense filling up my OS logs and
Equallogic can't figure it out either.

-- 
:wq!
kevin.foote

On 11/14/07, Michael Vallaly <vaio@nolatency.com> wrote:
>
> Kevin,
>
> Correct me if im wrong, but I if I changed the path_grouping_policy to
> "failover" I lose the ability to aggregate IO traffic across multiple active
> paths at once. Unfortunately in our situation the performance hit would be
> undesirable.
>
> With your setup do your backend block device names ever change? Say if you
> had an extended network outage and had to manually reconnect to the SAN?
>
> -Mike
>
> On Wed, 14 Nov 2007 13:26:32 -0500
> "Kevin Foote" <kevin.foote@gmail.com> wrote:
>
> > Mike,
> > If you are going for failover things should look like this..
> > We go to an Equallogic PS box as well .. through a QLA4052 HBA
> >
> > You need to change this line in your /etc/multipath.conf file to
> > reflect what you want multipathd to do.
> > >         path_grouping_policy    multibus
> > should read ...
> >          path_grouping_policy    failover
> >
> > In turn your maps will look like this ..  (multipath -ll)
> > media-oracle (30690a018a0b3d369dd4f04191c4090f9)
> > [size=8 GB][features="0"][hwhandler="0"]
> > \_ round-robin 0 [active]
> >   \_ 2:0:8:0 sdj 8:144 [active][ready]
> > \_ round-robin 0 [enabled]
> >   \_ 3:0:8:0 sdr 65:16 [active][ready]
> >
> > and dmsetup table <dev>
> > #> dmsetup table /dev/mapper/media-oracle
> > 0 16803840 multipath 0 0 2 1 round-robin 0 1 1 8:144 100 round-robin 0
> > 1 1 65:16 100
> >
> > will show a multipath failover setup
> >
> >
> > --
> > :wq!
> > kevin.foote
> >
> > On Nov 14, 2007 1:07 AM, Michael Vallaly <vaio@nolatency.com> wrote:
> > >
> > > Hello,
> > >
> > > I am currently using the dm-multipather (multipath-tools) to allow
> high-availability / increased capacity to our Equallogic iSCSI SAN. I was
> wondering if anyone had come across a way to re-instantiate a failed path /
> paths from a multipath target, when the backend device (iscsi initiator)
> goes away.
> > >
> > > All goes well until we have a lengthy network hiccup or
> non-recoverable iSCSI error in which case the multipather seems to get
> wedged. The path seems to get stuck in a [active][faulty] state and the
> backend block device (sdX) actually gets removed from the system. I have
> tried reconnecting the iSCSI session, after this happens, and get a new
> (different IE: sdg vs. sdf) backend block level device, but the multipather
> never picks it up / never resumes IO operations, and I generally have then
> to power cycle the box.
> > >
> > > We have anywhere from 2 to 4 iSCSI sessions open per multipath target,
> but even one path failing seems to cause the whole multipath to die. I am
> hoping there is a way to continue on after a path failure, rather than the
> power cycle. I have tried multipath-tools 0.4.6/0.4.7/0.4.8, and almost
> every permutation of the configuration I can think of. Maybe I am missing
> something quite obvious.
> > >
> > > Working Multipather
> > > <snip>
> > > mpath89 (36090a0281051367df57194d2a37392d5) dm-4 EQLOGIC ,100E-00
> > > [size=300G][features=1 queue_if_no_path][hwhandler=0]
> > > \_ round-robin 0 [prio=2][active]
> > >  \_ 5:0:0:0  sdf 8:80  [active][ready]
> > >  \_ 6:0:0:0  sdg 8:96  [active][ready]
> > > </snip>
> > >
> > > Wedged Multipather (when a iSCSI session terminates) (All IO queues
> indefinitely)
> > > <snip>
> > > mpath94 (36090a0180087e6045673743d3c01401c) dm-10 ,
> > > [size=600G][features=1 queue_if_no_path][hwhandler=0]
> > > \_ round-robin 0 [prio=0][enabled]
> > >  \_ #:#:#:#  -   #:#   [active][faulty]
> > > </snip>
> > >
> > > Our multipath.conf looks like this:
> > > <snip>
> > > defaults {
> > >         udev_dir                /dev
> > >         polling_interval        10
> > >         selector                "round-robin 0"
> > >         path_grouping_policy    multibus
> > >         getuid_callout          "/lib/udev/scsi_id -g -u -s /block/%n"
> > >         #prio_callout            /bin/true
> > >         #path_checker            readsector0
> > >         path_checker            directio
> > >         rr_min_io               100
> > >         rr_weight               priorities
> > >         failback                immediate
> > >         no_path_retry           fail
> > >         #user_friendly_names     no
> > >         user_friendly_names     yes
> > > }
> > >
> > > blacklist {
> > >         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|sda)[0-9]*"
> > >         devnode "^hd[a-z][[0-9]*]"
> > >         devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
> > > }
> > >
> > >
> > > devices {
> > >         device {
> > >                 vendor                  "EQLOGIC"
> > >                 product                 "100E-00"
> > >                 path_grouping_policy    multibus
> > >                 getuid_callout          "/lib/udev/scsi_id -g -u -s
> /block/%n"
> > >                 #path_checker            directio
> > >                 path_checker            readsector0
> > >                 path_selector           "round-robin 0"
> > >                 ##hardware_handler        "0"
> > >                 failback                immediate
> > >                 rr_weight               priorities
> > >                 no_path_retry           queue
> > >                 #no_path_retry           fail
> > >                 rr_min_io               100
> > >                 product_blacklist       LUN_Z
> > >         }
> > > }
> > >
> > > </snip>
> > >
> > > Thanks for your help.
> > >
> > > - Mike Vallaly
> > >
> > >
> > >
> > >
> > >
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://www.redhat.com/mailman/listinfo/dm-devel
> > >
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

------=_Part_4730_32218119.1195102510895
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

As far as I know you should be able to do the same as with a SAN. you
can have multiple block-dev entries (to handle your aggregated IO) per
path group. Some one on the list please correct me if Im wrong.. So in
my previous example things would expand like this to handle your
aggregated IO to the device. <br>
<br>
media-oracle (30690a018a0b3d369dd4f04191c4090f9)<br>[size=8 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_
round-robin 0
[active]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp; <br> &nbsp;\_ 2:0:8:0 sdj 8:144 [active][ready]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; }&nbsp;&nbsp;&nbsp; <br>&nbsp;\_
another dev
here&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
} These all make up path group one <br>
&nbsp;\_ another dev
here&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
}<br>
\_ round-robin 0 [enabled]<br> &nbsp;\_ 3:0:8:0 sdr 65:16 [active][ready]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } <br>
&nbsp;\_ another dev
here&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
}<br>
&nbsp;\_ another dev
here&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
} These all make up path group two<br>
&nbsp;\_ another dev
here&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
}<br>
<br>
Our ISCSI net is very isolated and built with failover so unless we
loose two switches at once there should be no hick-up. Sorry cant fill
in any more on that end.<br>
<br>
On a side note.. can we go of list Id like to hear more about your
Equallogic issue. Ive got some wierd nonsense filling up my OS logs and
Equallogic can&#39;t figure it out either. <br><br>
-- <br>
:wq!<br>
kevin.foote<br>
<br><div><span class="gmail_quote">On 11/14/07, <b class="gmail_sendername">Michael Vallaly</b> &lt;<a href="mailto:vaio@nolatency.com">vaio@nolatency.com</a>&gt; wrote:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Kevin,<br><br>Correct
me if im wrong, but I if I changed the path_grouping_policy to
&quot;failover&quot; I lose the ability to aggregate IO traffic across multiple
active paths at once. Unfortunately in our situation the performance
hit would be undesirable.<br><br>With your setup do your backend block
device names ever change? Say if you had an extended network outage and
had to manually reconnect to the SAN?<br><br>-Mike<br><br>On Wed, 14 Nov 2007 13:26:32 -0500<br>&quot;Kevin Foote&quot; &lt;<a href="mailto:kevin.foote@gmail.com">kevin.foote@gmail.com</a>&gt; wrote:<br><br>&gt; Mike,<br>
&gt; If you are going for failover things should look like this..<br>&gt; We go to an Equallogic PS box as well .. through a QLA4052 HBA<br>&gt;<br>&gt; You need to change this line in your /etc/multipath.conf file to<br>
&gt; reflect what you want multipathd to do.<br>&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grouping_policy&nbsp;&nbsp;&nbsp;&nbsp;multibus<br>&gt; should read ...<br>&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;path_grouping_policy&nbsp;&nbsp;&nbsp;&nbsp;failover<br>&gt;<br>&gt; In turn your maps will look like this ..&nbsp;&nbsp;(multipath -ll)
<br>&gt; media-oracle (30690a018a0b3d369dd4f04191c4090f9)<br>&gt; [size=8 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>&gt; \_ round-robin 0 [active]<br>&gt;&nbsp;&nbsp; \_ 2:0:8:0 sdj 8:144 [active][ready]<br>&gt; \_ round-robin 0 [enabled]
<br>&gt;&nbsp;&nbsp; \_ 3:0:8:0 sdr 65:16 [active][ready]<br>&gt;<br>&gt; and dmsetup table &lt;dev&gt;<br>&gt; #&gt; dmsetup table /dev/mapper/media-oracle<br>&gt; 0 16803840 multipath 0 0 2 1 round-robin 0 1 1 8:144 100 round-robin 0
<br>&gt; 1 1 65:16 100<br>&gt;<br>&gt; will show a multipath failover setup<br>&gt;<br>&gt;<br>&gt; --<br>&gt; :wq!<br>&gt; kevin.foote<br>&gt;<br>&gt; On Nov 14, 2007 1:07 AM, Michael Vallaly &lt;<a href="mailto:vaio@nolatency.com">
vaio@nolatency.com</a>&gt; wrote:<br>&gt; &gt;<br>&gt; &gt; Hello,<br>&gt; &gt;<br>&gt;
&gt; I am currently using the dm-multipather (multipath-tools) to allow
high-availability / increased capacity to our Equallogic iSCSI SAN. I
was wondering if anyone had come across a way to re-instantiate a
failed path / paths from a multipath target, when the backend device
(iscsi initiator) goes away.<br>&gt; &gt;<br>&gt; &gt; All goes well
until we have a lengthy network hiccup or non-recoverable iSCSI error
in which case the multipather seems to get wedged. The path seems to
get stuck in a [active][faulty] state and the backend block device
(sdX) actually gets removed from the system. I have tried reconnecting
the iSCSI session, after this happens, and get a new (different IE: sdg
vs. sdf) backend block level device, but the multipather never picks it
up / never resumes IO operations, and I generally have then to power
cycle the box.<br>&gt; &gt;<br>&gt; &gt; We have anywhere from 2 to 4
iSCSI sessions open per multipath target, but even one path failing
seems to cause the whole multipath to die. I am hoping there is a way
to continue on after a path failure, rather than the power cycle. I
have tried multipath-tools 0.4.6/0.4.7/0.4.8, and almost every
permutation of the configuration I can think of. Maybe I am missing
something quite obvious.<br>&gt; &gt;<br>&gt; &gt; Working Multipather<br>&gt; &gt; &lt;snip&gt;<br>&gt; &gt; mpath89 (36090a0281051367df57194d2a37392d5) dm-4 EQLOGIC ,100E-00<br>&gt; &gt; [size=300G][features=1 queue_if_no_path][hwhandler=0]
<br>&gt; &gt; \_ round-robin 0 [prio=2][active]<br>&gt; &gt;&nbsp;&nbsp;\_ 5:0:0:0&nbsp;&nbsp;sdf 8:80&nbsp;&nbsp;[active][ready]<br>&gt; &gt;&nbsp;&nbsp;\_ 6:0:0:0&nbsp;&nbsp;sdg 8:96&nbsp;&nbsp;[active][ready]<br>&gt; &gt; &lt;/snip&gt;<br>&gt; &gt;<br>&gt; &gt; Wedged Multipather (when a iSCSI session terminates) (All IO queues indefinitely)
<br>&gt; &gt; &lt;snip&gt;<br>&gt; &gt; mpath94 (36090a0180087e6045673743d3c01401c) dm-10 ,<br>&gt; &gt; [size=600G][features=1 queue_if_no_path][hwhandler=0]<br>&gt; &gt; \_ round-robin 0 [prio=0][enabled]<br>&gt; &gt;&nbsp;&nbsp;\_ #:#:#:#&nbsp;&nbsp;-&nbsp;&nbsp; #:#&nbsp;&nbsp; [active][faulty]
<br>&gt; &gt; &lt;/snip&gt;<br>&gt; &gt;<br>&gt; &gt; Our multipath.conf looks like this:<br>&gt; &gt; &lt;snip&gt;<br>&gt; &gt; defaults {<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
udev_dir&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/dev<br>&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; polling_interval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;round-robin
0&quot;<br>&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; path_grouping_policy&nbsp;&nbsp;&nbsp;&nbsp;multibus<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;/lib/udev/scsi_id
-g -u -s /block/%n&quot;<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
#prio_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/bin/true<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
#path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;readsector0<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;directio<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
rr_min_io&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
100<br>&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
rr_weight&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
priorities<br>&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;immediate<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
fail<br>&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; #user_friendly_names&nbsp;&nbsp;&nbsp;&nbsp; no<br>&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; user_friendly_names&nbsp;&nbsp;&nbsp;&nbsp; yes<br>&gt; &gt; }<br>&gt; &gt;<br>&gt; &gt; blacklist {<br>&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode &quot;^(ram|raw|loop|fd|md|dm-|sr|scd|st|sda)[0-9]*&quot;
<br>&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode &quot;^hd[a-z][[0-9]*]&quot;<br>&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; devnode &quot;^cciss!c[0-9]d[0-9]*[p[0-9]*]&quot;<br>&gt; &gt; }<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt; devices {<br>&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; device {
<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
vendor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;EQLOGIC&quot;<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
product&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;100E-00&quot;<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
path_grouping_policy&nbsp;&nbsp;&nbsp;&nbsp;multibus<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
getuid_callout&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;/lib/udev/scsi_id
-g -u -s /block/%n&quot;<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
#path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;directio<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;readsector0<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
path_selector&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&quot;round-robin 0&quot;<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
##hardware_handler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&quot;0&quot;<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
failback&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;immediate<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
rr_weight&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
priorities<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
queue<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
#no_path_retry&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
fail<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
rr_min_io&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
100<br>&gt;
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
product_blacklist&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LUN_Z<br>&gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br>&gt; &gt; }<br>&gt; &gt;<br>&gt; &gt; &lt;/snip&gt;<br>&gt; &gt;<br>&gt; &gt; Thanks for your help.<br>&gt; &gt;<br>&gt; &gt; - Mike Vallaly<br>&gt; &gt;<br>&gt; &gt;
<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt;<br>&gt; &gt; --<br>&gt; &gt; dm-devel mailing list<br>&gt; &gt; <a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>&gt; &gt; <a href="https://www.redhat.com/mailman/listinfo/dm-devel">
https://www.redhat.com/mailman/listinfo/dm-devel</a><br>&gt; &gt;<br>&gt;<br>&gt; --<br>&gt; dm-devel mailing list<br>&gt; <a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br>&gt; <a href="https://www.redhat.com/mailman/listinfo/dm-devel">
https://www.redhat.com/mailman/listinfo/dm-devel</a><br><br><br>--<br>dm-devel mailing list<br><a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel
</a><br></blockquote></div><br><br>


------=_Part_4730_32218119.1195102510895--


--===============2004023263==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============2004023263==--
