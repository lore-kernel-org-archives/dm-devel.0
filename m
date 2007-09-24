From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: RHEL5 and RDAC/Multipath
Date: Mon, 24 Sep 2007 11:30:31 -0700
Message-ID: <1190658631.1933.137.camel@linuxchandra>
References: <200709241439.12426.npf-mlists@eurotux.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Hi Nuno,

I would suggest you to move the rdac specific configuration information
to device section and retry.

Are you running the multipathd command ?

Here is how my rdac configuration looks in multipath.conf
--------------------------
devices {
        device {
                vendor                  "IBM"
                product                 "1815"
                hardware_handler        "1 rdac"
                path_checker            rdac
                failback                immediate
                path_grouping_policy    group_by_prio
                prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
        }
}
-----------------------------
Let me know how it goes,

chandra
On Mon, 2007-09-24 at 14:39 +0100, Nuno Fernandes wrote:
> Hi,
> 
> We've bought and IBM BladecenterH and IBM DS4700 storage.
> We are using Redhat Enterprise Linux 5 and we are trying to put multipath 
> working.
> 
> RHEL5 we are using uses 2.6.18-8.1.3.el5xen. We've ported rdac patch 
> (http://kernel.org/pub/linux/kernel/people/agk/patches/2.6/2.6.21/dm-mpath-rdac.patch) 
> to RHEL5 kernel. We've also updated multipath-tools to support 
> mpath_prio_rdac.
> 
> Our multipath.conf is:
> 
> devnode_blacklist {
>         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>         devnode "^hd[a-z]"
>         devnode "^cciss!c[0-9]d[0-9]*"
>         #USB 4G Flash drive inside HS21
>         devnode "sda" 
> }
> 
> defaults {
>         multipath_tool  "/sbin/multipath -v0"
>         udev_dir        /dev
>         polling_interval 5
>         default_selector        "round-robin 0"
>         default_getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
>         #default_prio_callout    "/bin/true"
>         failback                immediate
>         path_checker            rdac
>         hardware_handler        "1 rdac"
>         prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
>         path_grouping_policy    group_by_prio
> }
> 
> multipaths {
>         multipath {
>                 wwid                    3600a0b8000320bea0000048f46e52137
>                 alias                   client_data
>         }
> }
> 
> When we start multipath -v2 it creates multipath devices. I can see 2 active 
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
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
