From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Re: Need Help
Date: Thu, 17 Jan 2008 11:09:23 -0800
Message-ID: <110b17190801171109g3bbb71b4o651381a57f78a567@mail.gmail.com>
References: <EEBC5C82F965344199BFA3E6047FE13302E8E1@SAUSEXMB2.amd.com>
	<1200596524.7183.76.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1200596524.7183.76.camel@linuxchandra>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

In addition to that, should "dm-" also be under the devnode_blacklilst?

Regards,
Pradipmaya.

On Jan 17, 2008 11:02 AM, Chandra Seetharaman <sekharan@us.ibm.com> wrote:
> On Thu, 2008-01-17 at 12:40 -0600, Nath, Varun wrote:
> > I used the /dev/mapper/mpath# also in the fstab but that did not help.
>
> That is odd.
>
> When the system boots up completely, do you see the multipath devices,
> or you explicitly run the multipath command to make the multipath
> devices show up ?
>
>
> >
> >
> > -----Original Message-----
> > From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> > On Behalf Of Chandra Seetharaman
> > Sent: Thursday, January 17, 2008 12:38 PM
> > To: device-mapper development
> > Subject: Re: [dm-devel] Need Help
> >
> > Without the /etc/fstab, this is my hunch: you are using /dev/mpath
> > in /etc/fstab. Try /dev/mapper instead.
> >
> > On Thu, 2008-01-17 at 08:35 -0600, Nath, Varun wrote:
> > > Hi,
> > >
> > >
> > >
> > > I am trying to configure multipathing on Red hat 4 update 6 64 bit.
> > >
> > >
> > >
> > > Below is the list of RPM I have installed
> > >
> > >
> > >
> > > rpm -qa | grep mapper
> > >
> > > device-mapper-1.02.21-1.el4
> > >
> > > device-mapper-1.02.21-1.el4
> > >
> > > device-mapper-multipath-0.4.5-27.RHEL4
> > >
> > >
> > >
> > > The hardware is Sun x4600 and I am using QLA cards. The system has two
> > > LUNs presented to it of size 10 GB and size 90 GB
> > >
> > >
> > >
> > > There is a problem when I configure file system on it. I am able to
> > > access and mount the file system. But when I add those entries
> > > in /etc/fstab, the system would not recognize those devices.
> > >
> > >
> > >
> > > Below is the output from multipath command
> > >
> > >
> > >
> > > multipath -ll
> > >
> > > mpath5 (3600508b40010541d00009000065d0000)
> > >
> > > [size=90 GB][features="1 queue_if_no_path"][hwhandler="0"]
> > >
> > > \_ round-robin 0 [prio=100][active]
> > >
> > >  \_ 1:0:0:2 sdd 8:48  [active][ready]
> > >
> > >  \_ 2:0:0:2 sdh 8:112 [active][ready]
> > >
> > > \_ round-robin 0 [prio=20][enabled]
> > >
> > >  \_ 1:0:1:2 sdf 8:80  [active][ready]
> > >
> > >  \_ 2:0:1:2 sdj 8:144 [active][ready]
> > >
> > >
> > >
> > > mpath4 (3600508b40010541d00009000065a0000)
> > >
> > > [size=10 GB][features="1 queue_if_no_path"][hwhandler="0"]
> > >
> > > \_ round-robin 0 [prio=100][enabled]
> > >
> > >  \_ 1:0:1:1 sde 8:64  [active][ready]
> > >
> > >  \_ 2:0:1:1 sdi 8:128 [active][ready]
> > >
> > > \_ round-robin 0 [prio=20][enabled]
> > >
> > >  \_ 1:0:0:1 sdc 8:32  [active][ready]
> > >
> > >  \_ 2:0:0:1 sdg 8:96  [active][ready]
> > >
> > >
> > >
> > >
> > >
> > > Also, below is my /etc/multipath.conf
> > >
> > >
> > >
> > > # This is an example configuration file for device mapper multipath.
> > >
> > > # For a complete list of the default configuration values, see
> > >
> > > # /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.defaults
> > >
> > > # For a list of configuration options with descriptions, see
> > >
> > > # /usr/share/doc/device-mapper-
> > > multipath-0.4.5/multipath.conf.annotated
> > >
> > >
> > >
> > >
> > >
> > > # Blacklist all devices by default. Remove this to enable multipathing
> > >
> > > # on the default devices.
> > >
> > > #devnode_blacklist {
> > >
> > > #        devnode "*"
> > >
> > > #}
> > >
> > >
> > >
> > > ## Use user friendly names, instead of using WWIDs as names.
> > >
> > > defaults {
> > >
> > >         user_friendly_names yes
> > >
> > >         selector   "round-robin 0"
> > >
> > > }
> > >
> > >
> > >
> > >
> > >
> > > ## By default, devices with vendor = "IBM" and product = "S/390.*" are
> > >
> > > ## blacklisted. To enable mulitpathing on these devies, uncomment the
> > >
> > > ## following lines.
> > >
> > > #devices {
> > >
> > > #       device {
> > >
> > > #               vendor                  "IBM"
> > >
> > > #               product                 "S/390 DASD ECKD"
> > >
> > > #               path_grouping_policy    multibus
> > >
> > > #               getuid_callout          "/sbin/dasdview -j -f /dev/%n"
> > >
> > > #               path_checker            directio
> > >
> > > #       }
> > >
> > > #}
> > >
> > >
> > >
> > >
> > >
> > > ##
> > >
> > > ## This is a template multipath-tools configuration file
> > >
> > > ## Uncomment the lines relevent to your environment
> > >
> > > ##
> > >
> > > #defaults {
> > >
> > > #       udev_dir                /dev
> > >
> > > #       polling_interval        10
> > >
> > > #       selector                "round-robin 0"
> > >
> > > #       path_grouping_policy    multibus
> > >
> > > #       getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
> > >
> > > #       prio_callout            /bin/true
> > >
> > > #       path_checker            readsector0
> > >
> > > #       rr_min_io               100
> > >
> > > #       rr_weight               priorities
> > >
> > > #       failback                immediate
> > >
> > > #       no_path_retry           fail
> > >
> > > #       user_friendly_name      yes
> > >
> > > #}
> > >
> > > ##
> > >
> > > ## The wwid line in the following blacklist section is shown as an
> > > example
> > >
> > > ## of how to blacklist devices by wwid.  The 3 devnode lines are the
> > >
> > > ## compiled in default blacklist. If you want to blacklist entire
> > > types
> > >
> > > ## of devices, such as all scsi devices, you should use a devnode
> > > line.
> > >
> > > ## However, if you want to blacklist specific devices, you should use
> > >
> > > ## a wwid line.  Since there is no guarantee that a specific device
> > > will
> > >
> > > ## not change names on reboot (from /dev/sda to /dev/sdb for example)
> > >
> > > ## devnode lines are not recommended for blacklisting specific
> > > devices.
> > >
> > > ##
> > >
> > > devnode_blacklist {
> > >
> > >        wwid 3600508e000000000ed7fb52911133c06
> > >
> > >         devnode "^(ram|raw|loop|fd|md|sr|scd|st)[0-9]*"
> > >
> > >         devnode "^hd[a-z]"
> > >
> > > }
> > >
> > > #multipaths {
> > >
> > > #       multipath {
> > >
> > > #               wwid
> > > 3600508b4000156d700012000000b0000
> > >
> > > #               alias                   yellow
> > >
> > > #               path_grouping_policy    multibus
> > >
> > > #               path_checker            readsector0
> > >
> > > #               path_selector           "round-robin 0"
> > >
> > > #               failback                manual
> > >
> > > #               rr_weight               priorities
> > >
> > > #               no_path_retry           5
> > >
> > > #       }
> > >
> > > #       multipath {
> > >
> > > #               wwid                    1DEC_____321816758474
> > >
> > > #               alias                   red
> > >
> > > #       }
> > >
> > > #}
> > >
> > > #devices {
> > >
> > > #       device {
> > >
> > > #               vendor                  "COMPAQ  "
> > >
> > > #               product                 "HSV110 (C)COMPAQ"
> > >
> > > #               path_grouping_policy    multibus
> > >
> > > #               getuid_callout          "/sbin/scsi_id -g -u -
> > > s /block/%n"
> > >
> > > #               path_checker            readsector0
> > >
> > > #               path_selector           "round-robin 0"
> > >
> > > #               hardware_handler        "0"
> > >
> > > #               failback                15
> > >
> > > #               rr_weight               priorities
> > >
> > > #               no_path_retry           queue
> > >
> > > #       }
> > >
> > > #       device {
> > >
> > > #               vendor                  "COMPAQ  "
> > >
> > > #               product                 "MSA1000         "
> > >
> > > #               path_grouping_policy    multibus
> > >
> > > #       }
> > >
> > > #}
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > > Here is the contents of the /dev/mpath/
> > >
> > >
> > >
> > > [root@x mpath]# pwd
> > >
> > > /dev/mpath
> > >
> > > [root@x mpath]# ls -all
> > >
> > > total 0
> > >
> > > drwxr-xr-x   2 root root   80 Jan 16 17:34 .
> > >
> > > drwxr-xr-x  12 root root 5260 Jan 17 08:17 ..
> > >
> > > lrwxrwxrwx   1 root root    7 Jan 16 17:34 mpath4 -> ../dm-8
> > >
> > > lrwxrwxrwx   1 root root    7 Jan 16 17:34 mpath5 -> ../dm-9
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > >
> > > Can anyone please help me with this? I think I am missing some
> > > configuration on the system which is causing this.
> > >
> > >
> > >
> > > Thanks,
> > >
> > >
> > >
> > >
> > >
> > >
> > > --
> > > dm-devel mailing list
> > > dm-devel@redhat.com
> > > https://www.redhat.com/mailman/listinfo/dm-devel
> --
>
> ----------------------------------------------------------------------
>    Chandra Seetharaman               | Be careful what you choose....
>              - sekharan@us.ibm.com   |      .......you may get it.
> ----------------------------------------------------------------------
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
