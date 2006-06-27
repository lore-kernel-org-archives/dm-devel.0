From: "Kevin Foote" <kevin.foote@gmail.com>
Subject: Re: RHEL 4.3 to Sun 6320 storage
Date: Tue, 27 Jun 2006 08:42:49 -0400
Message-ID: <5fb0f77b0606270542w1ddb5a69q6d9ea939bf98fb83@mail.gmail.com>
References: <1151402657.4766.13.camel@x41ade>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0395215186=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1151402657.4766.13.camel@x41ade>
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

--===============0395215186==
Content-Type: multipart/alternative;
	boundary="----=_Part_63138_25783920.1151412169830"

------=_Part_63138_25783920.1151412169830
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Andrew
I'm not a pro at dm-multipath but if you are looking for failover dont you
want your  path_grouping_policy line to be

    default_path_grouping_policy    failover

that way your multipath -ll output would look something like

archives (30690a018a0e3a3178c46f4510900307f)
[size=16 GB][features="0"][hwhandler="0"]
\_ round-robin 0 [active]
 \_ 2:0:1:0  sdc 8:32   [active][ready]
\_ round-robin 0 [enabled]
 \_ 3:0:1:0  sdo 8:224  [active][ready]

hope some of that made sense..

-- 
:wq!
kevin.foote

On 6/27/06, Andrew Elwell <andrewe@epcc.ed.ac.uk> wrote:
>
> Hi folks,
>
> I'm trying to set up access to our SAN, 5 cabinets of 6320 storage, from
> CentOS 4.3 using dm-multipath and two Emulex lpfc cards.
>
>
> So far I can see the correct arrays through the zoning and have setup
> multipath.conf as below:
>
> defaults {
>         user_friendly_names     yes
>         polling_interval        1
>         path_checker            tur
>         path_grouping_policy    group_by_serial
> }
> devnode_blacklist {
>         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>         devnode "^hd[a-z]"
>         devnode "^sd[a-b]"
>         # sda and sdb are internal 3ware raid and sata system disk
>         devnode "^cciss!c[0-9]d[0-9]*"
> }
> multipaths {
>         multipath {
>                 wwid     360003baccb976000426f26d30004c45a
>                 alias    cab2a01t0
>         }
>         multipath {
>                 wwid    360003baccb976000426f27a00006ae93
>                 alias   cab2a01t1
>         }
>         ... snip more multipath definitions....
> }
>
> multipath -ll shows..
>
>
> cab2a01t2 (360003baccb976000426f289000049adb)
> [size=1638 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [active]
> \_ 3:0:0:2 sde 8:64  [failed][faulty]
> \_ 4:0:0:2 sdj 8:144 [active][ready]
>
> cab2a01t1 (360003baccb976000426f27a00006ae93)
> [size=1638 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [active]
> \_ 3:0:0:1 sdd 8:48  [active][ready]
> \_ 4:0:0:1 sdi 8:128 [active][ready]
>
> cab2a01t0 (360003baccb976000426f26d30004c45a)
> [size=1638 GB][features="0"][hwhandler="0"]
> \_ round-robin 0 [active]
> \_ 3:0:0:0 sdc 8:32  [active][ready]
> \_ 4:0:0:0 sdh 8:112 [active][ready]
>
>
>
> but the error log is filling up with
> kernel: Device sde not ready.
> kernel: end_request: I/O error, dev sde, sector 2181037632
> multipathd: 8:64: mark as failed
> multipathd: cab2a01t2: remaining active paths: 1
> multipathd: 8:64: tur checker reports path is up
> multipathd: 8:64: reinstated
> multipathd: cab2a01t2: remaining active paths: 2
> kernel: Device sde not ready.
> kernel: end_request: I/O error, dev sde, sector 3187670215
> kernel: device-mapper: dm-multipath: Failing path 8:64.
>
> etc. I guess I should be using something other than the default for
> prio_callout, but what?
>
> Please can someone give me hints on the correct incantation for
> path_checker, path_grouping_policy, prio_callout
>
> Many thanks
>
> Andrew
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

------=_Part_63138_25783920.1151412169830
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Andrew <br>
I'm not a pro at dm-multipath but if you are looking for failover dont you want your&nbsp; path_grouping_policy line to be <br>
<br>
&nbsp;&nbsp;&nbsp; default_path_grouping_policy&nbsp;&nbsp;&nbsp; failover<br>
<br>
that way your multipath -ll output would look something like <br>
<br>
archives (30690a018a0e3a3178c46f4510900307f)<br>
[size=16 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>
\_ round-robin 0 [active]<br>
&nbsp;\_ 2:0:1:0&nbsp; sdc 8:32&nbsp;&nbsp; [active][ready]<br>
\_ round-robin 0 [enabled]<br>
&nbsp;\_ 3:0:1:0&nbsp; sdo 8:224&nbsp; [active][ready]<br>
<br>
hope some of that made sense.. <br>
<br>
-- <br>
:wq!<br>
kevin.foote<br>
<br><div><span class="gmail_quote">On 6/27/06, <b class="gmail_sendername">Andrew Elwell</b> &lt;<a href="mailto:andrewe@epcc.ed.ac.uk">andrewe@epcc.ed.ac.uk</a>&gt; wrote:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Hi folks,<br><br>I'm trying to set up access to our SAN, 5 cabinets of 6320 storage, from<br>CentOS 4.3 using dm-multipath and two Emulex lpfc cards.<br><br><br>So far I can see the correct arrays through the zoning and have setup
<br>multipath.conf as below:<br><br>defaults {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;user_friendly_names&nbsp;&nbsp;&nbsp;&nbsp; yes<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;polling_interval&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;path_checker&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;tur<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;path_grouping_policy&nbsp;&nbsp;&nbsp;&nbsp;group_by_serial<br>}<br>
devnode_blacklist {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;^hd[a-z]&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;^sd[a-b]&quot;<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;# sda and sdb are internal 3ware raid and sata system disk
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;devnode &quot;^cciss!c[0-9]d[0-9]*&quot;<br>}<br>multipaths {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;multipath {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wwid&nbsp;&nbsp;&nbsp;&nbsp;
360003baccb976000426f26d30004c45a<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alias&nbsp;&nbsp;&nbsp;&nbsp;cab2a01t0<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;multipath {<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wwid&nbsp;&nbsp;&nbsp;&nbsp;360003baccb976000426f27a00006ae93<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;alias&nbsp;&nbsp; cab2a01t1<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;... snip more multipath definitions....<br>}<br><br>multipath -ll shows..<br><br><br>cab2a01t2 (360003baccb976000426f289000049adb)<br>[size=1638 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [active]
<br> \_ 3:0:0:2 sde 8:64&nbsp;&nbsp;[failed][faulty]<br> \_ 4:0:0:2 sdj 8:144 [active][ready]<br><br>cab2a01t1 (360003baccb976000426f27a00006ae93)<br>[size=1638 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [active]
<br> \_ 3:0:0:1 sdd 8:48&nbsp;&nbsp;[active][ready]<br> \_ 4:0:0:1 sdi 8:128 [active][ready]<br><br>cab2a01t0 (360003baccb976000426f26d30004c45a)<br>[size=1638 GB][features=&quot;0&quot;][hwhandler=&quot;0&quot;]<br>\_ round-robin 0 [active]
<br> \_ 3:0:0:0 sdc 8:32&nbsp;&nbsp;[active][ready]<br> \_ 4:0:0:0 sdh 8:112 [active][ready]<br><br><br><br>but the error log is filling up with<br> kernel: Device sde not ready.<br> kernel: end_request: I/O error, dev sde, sector 2181037632
<br> multipathd: 8:64: mark as failed<br> multipathd: cab2a01t2: remaining active paths: 1<br> multipathd: 8:64: tur checker reports path is up<br> multipathd: 8:64: reinstated<br> multipathd: cab2a01t2: remaining active paths: 2
<br> kernel: Device sde not ready.<br> kernel: end_request: I/O error, dev sde, sector 3187670215<br> kernel: device-mapper: dm-multipath: Failing path 8:64.<br><br>etc. I guess I should be using something other than the default for
<br>prio_callout, but what?<br><br>Please can someone give me hints on the correct incantation for<br>path_checker, path_grouping_policy, prio_callout<br><br>Many thanks<br><br>Andrew<br><br>--<br>dm-devel mailing list<br>
<a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a><br></blockquote></div><br><br clear="all"><br>



------=_Part_63138_25783920.1151412169830--


--===============0395215186==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0395215186==--
