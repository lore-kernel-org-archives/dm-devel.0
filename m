From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: multipathing flip flopping on Sun 6140
Date: Mon, 6 Aug 2007 12:01:45 -0500
Message-ID: <20070806170145.GU24772@ether.msp.redhat.com>
References: <66F461DD7EDEEF4AA928FCC80B425B52AFCB41@c2kp01mail.cucbc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <66F461DD7EDEEF4AA928FCC80B425B52AFCB41@c2kp01mail.cucbc.com>
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

On Tue, Jul 31, 2007 at 02:41:45PM -0700, James Fillman wrote:
> I'm having a major problem with my multipathing on my RHEL5 servers.
> 
> Here's the problem:
> 
> The paths to my SAN volume keep flip flopping between the two
> controllers. Sometimes I see the path with the lowest priority set as
> the 'active' path with the higher priority path set to 'enabled'.
> Sometimes I see both paths set to 'enabled'. dmesg is contantly
> outputting path error's and the SAN keep reporting error's about the
> volume is not being managed by its preferred controller.
> 
> I had multipathing working great on our STK D280 SAN with brocade
> switches but we've recently upgraded to the STK 6140 SAN with qlogic
> 5200 switches.

I've never played with this storage myself, but I'm almost sure that
the 6140 needs RDAC support, which will not be available until RHEL 5.1

Once RHEL 5.1 is available, try this configuration.

devices {

        device {
           vendor  "SUN"
           product "CSM200_R"
           product_blacklist "Universal Xport"
           path_checker rdac
           path_grouping_policy group_by_prio
           prio_callout         "/sbin/mpath_prio_tpc /dev/%n"
           failback             immediate

        }

}

Hope this helps.

-Ben
 
> Here's my setup:
> 
> - RHEL5-64bit server
> - stock qla2xxx hba driver
> - device-mapper-multipath
> - Single Qlogic QLE2460 HBA
> - Sun's 6140 SAN
> - Qlogic 5200 switch
> 
> My server has a single HBA connected to the switch which then connects
> to each controller.
> 
> I've learned that for this hardware configuration, multipathing needs
> AVT enabled so the fibre channel switch port for my server has its
> 'Host' type set to 'Sun with Veritas DMP'. My multipathing config is
> using 'group_by_prio' for the path grouping policy.
> 
> Here's my multipath.conf:
> 
> blacklist
> {
>          devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|sda)[0-9]*"
> }
> 
> defaults
> {
>         udev_dir                /dev
>         polling_interval        10
>         selector                "round-robin 0"
>         path_grouping_policy    group_by_prio
>         getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>         prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
>         path_checker            tur
>         rr_min_io               100
>         rr_weight               priorities
>         failback                manual
>         no_path_retry           fail
>         user_friendly_name      yes
> }
> 
> devnode_blacklist
> {
>         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|sda)[0-9]*"
>         devnode "^hd[a-z][0-9]*"
>         devnode "^cciss!c[0-9]d[0-9]*"
> }
> devices
> {
>         device
>         {
>                 vendor                  "SUN"
>                 product                 "CSM200_R"    # the 6140 reports
> that it's a CSM200_R
>                 path_grouping_policy    group_by_prio
>                 path_checker            tur
>                 prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
>                 getuid_callout          "/sbin/scsi_id -g -u -s
> /block/%n"
>         }
> }
> 
> Here's some different output from the multipath command showing the
> different states of my paths:
> 
> [root@plxp02log etc]# multipath -v2 -ll
> mdi_logging (3600a0b800029a482000005d34695182b) dm-8 SUN,CSM200_R
> [size=100G][features=0][hwhandler=0]
> \_ round-robin 0 [prio=3][enabled]
>  \_ 1:0:0:1 sdc 8:32  [active][ready]
> \_ round-robin 0 [prio=0][enabled]
>  \_ 1:0:1:1 sdf 8:80  [active][ready]
> 
> mdi_logging (3600a0b800029a482000005d34695182b) dm-8 SUN,CSM200_R
> [size=100G][features=0][hwhandler=0]
> \_ round-robin 0 [prio=3][enabled]
>  \_ 1:0:1:1 sdf 8:80  [active][ready]
> \_ round-robin 0 [prio=0][active]
>  \_ 1:0:0:1 sdc 8:32  [active][ready]
> 
> dmesg output looks like this:
> device-mapper: multipath: Failing path 8:32.
> device-mapper: multipath: Failing path 8:80.
> 
> It looks like the path checker keeps failing and/or the priority of each
> path keeps switching.
> 
> I don't know much anything about configuring san's or fibre channel
> switches. I've only started learning the in's and out's of setting up
> multipathing and so I don't really know how to troubleshoot this
> problem. Is my multipathing config correct for this hardware?
> 
> Like I said before, it was working great on a D280 with a brocade
> switch. I don't have access to the SAN gear and my SAN guy is pointing
> the finger at my server config.
> 
> If someone could validate my config, tell what I'm doing right and what
> I'm doing wrong, I'd be forever grateful. I've not found much info
> online pertaining to this hardware config.
> 
> thanks,
> James Fillman
> 
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
