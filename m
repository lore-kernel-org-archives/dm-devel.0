From: "Sunil Joshi" <mail2joshi@gmail.com>
Subject: Re: RHEL5 and RDAC/Multipath
Date: Mon, 24 Sep 2007 22:04:40 +0530
Message-ID: <778391c50709240934x11d6436cs5f5f6f4a56b8751f@mail.gmail.com>
References: <200709241439.12426.npf-mlists@eurotux.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1560471131=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200709241439.12426.npf-mlists@eurotux.com>
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

--===============1560471131==
Content-Type: multipart/alternative;
	boundary="----=_Part_20574_6919146.1190651680900"

------=_Part_20574_6919146.1190651680900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Could you try using in your default settings

 no_path_retry           queue




Regards
Sunil Joshi


On 9/24/07, Nuno Fernandes <npf-mlists@eurotux.com> wrote:
>
> Hi,
>
> We've bought and IBM BladecenterH and IBM DS4700 storage.
> We are using Redhat Enterprise Linux 5 and we are trying to put multipath
> working.
>
> RHEL5 we are using uses 2.6.18-8.1.3.el5xen. We've ported rdac patch
> (
> http://kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.21/dm-mpath-rdac.patch
> )
> to RHEL5 kernel. We've also updated multipath-tools to support
> mpath_prio_rdac.
>
> Our multipath.conf is:
>
> devnode_blacklist {
>   devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>   devnode "^hd[a-z]"
>   devnode "^cciss!c[0-9]d[0-9]*"
>   #USB 4G Flash drive inside HS21
>   devnode "sda"
> }
>
> defaults {
>   multipath_tool "/sbin/multipath -v0"
>   udev_dir /dev
>   polling_interval 5
>   default_selector "round-robin 0"
>   default_getuid_callout "/sbin/scsi_id -g -u -s /block/%n"
>   #default_prio_callout "/bin/true"
>   failback immediate
>   path_checker rdac
>   hardware_handler "1 rdac"
>   prio_callout "/sbin/mpath_prio_tpc /dev/%n"
>   path_grouping_policy group_by_prio
> }
>
> multipaths {
>   multipath {
>   wwid 3600a0b8000320bea0000048f46e52137
>   alias client_data
>   }
> }
>
> When we start multipath -v2 it creates multipath devices. I can see 2
> active
> paths (active controler) and 2 ghost paths (standby controler).
> When i unplug 2 active fibre that connect the fabric to DS4700, multipath
> reports I/O errors and doesn't failover the controler.
>
> Any ideas?
>
> Thanks for any help
> Nuno Fernandes
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

------=_Part_20574_6919146.1190651680900
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Could you try using in your default settings<br><pre> no_path_retry           queue</pre><br><br><br>Regards<br>Sunil Joshi<br><br><br><div><span class="gmail_quote">On 9/24/07, <b class="gmail_sendername">Nuno Fernandes</b>
 &lt;<a href="mailto:npf-mlists@eurotux.com">npf-mlists@eurotux.com</a>&gt; wrote:</span><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">Hi,
<br><br>We&#39;ve bought and IBM BladecenterH and IBM DS4700 storage.<br>We are using Redhat Enterprise Linux 5 and we are trying to put multipath<br>working.<br><br>RHEL5 we are using uses 2.6.18-8.1.3.el5xen. We&#39;ve ported rdac patch
<br>(<a href="http://kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.21/dm-mpath-rdac.patch">http://kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.21/dm-mpath-rdac.patch</a>)<br>to RHEL5 kernel. We&#39;ve also updated multipath-tools to support
<br>mpath_prio_rdac.<br><br>Our multipath.conf is:<br><br>devnode_blacklist {<br>&nbsp;&nbsp;devnode &quot;^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*&quot;<br>&nbsp;&nbsp;devnode &quot;^hd[a-z]&quot;<br>&nbsp;&nbsp;devnode &quot;^cciss!c[0-9]d[0-9]*&quot;
<br>&nbsp;&nbsp;#USB 4G Flash drive inside HS21<br>&nbsp;&nbsp;devnode &quot;sda&quot;<br>}<br><br>defaults {<br>&nbsp;&nbsp;multipath_tool &quot;/sbin/multipath -v0&quot;<br>&nbsp;&nbsp;udev_dir /dev<br>&nbsp;&nbsp;polling_interval 5<br>&nbsp;&nbsp;default_selector &quot;round-robin 0&quot;
<br>&nbsp;&nbsp;default_getuid_callout &quot;/sbin/scsi_id -g -u -s /block/%n&quot;<br>&nbsp;&nbsp;#default_prio_callout &quot;/bin/true&quot;<br>&nbsp;&nbsp;failback immediate<br>&nbsp;&nbsp;path_checker rdac<br>&nbsp;&nbsp;hardware_handler &quot;1 rdac&quot;<br>&nbsp;&nbsp;prio_callout &quot;/sbin/mpath_prio_tpc /dev/%n&quot;
<br>&nbsp;&nbsp;path_grouping_policy group_by_prio<br>}<br><br>multipaths {<br>&nbsp;&nbsp;multipath {<br>&nbsp;&nbsp;wwid 3600a0b8000320bea0000048f46e52137<br>&nbsp;&nbsp;alias client_data<br>&nbsp;&nbsp;}<br>}<br><br>When we start multipath -v2 it creates multipath devices. I can see 2 active
<br>paths (active controler) and 2 ghost paths (standby controler).<br>When i unplug 2 active fibre that connect the fabric to DS4700, multipath<br>reports I/O errors and doesn&#39;t failover the controler.<br><br>Any ideas?
<br><br>Thanks for any help<br>Nuno Fernandes<br><br>--<br>dm-devel mailing list<br><a href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a><br><a href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel
</a><br></blockquote></div><br>

------=_Part_20574_6919146.1190651680900--


--===============1560471131==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1560471131==--
