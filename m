From: "Nath, Varun" <varun.nath@amd.com>
Subject: RE: Need Help
Date: Thu, 17 Jan 2008 12:40:15 -0600
Message-ID: <EEBC5C82F965344199BFA3E6047FE13302E8E1@SAUSEXMB2.amd.com>
References: <1200595061.7183.60.camel@linuxchandra>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1200595061.7183.60.camel@linuxchandra>
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

I used the /dev/mapper/mpath# also in the fstab but that did not help.=20

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
On Behalf Of Chandra Seetharaman
Sent: Thursday, January 17, 2008 12:38 PM
To: device-mapper development
Subject: Re: [dm-devel] Need Help

Without the /etc/fstab, this is my hunch: you are using /dev/mpath
in /etc/fstab. Try /dev/mapper instead.

On Thu, 2008-01-17 at 08:35 -0600, Nath, Varun wrote:
> Hi,
>=20
> =20
>=20
> I am trying to configure multipathing on Red hat 4 update 6 64 bit.
>=20
> =20
>=20
> Below is the list of RPM I have installed
>=20
> =20
>=20
> rpm -qa | grep mapper
>=20
> device-mapper-1.02.21-1.el4
>=20
> device-mapper-1.02.21-1.el4
>=20
> device-mapper-multipath-0.4.5-27.RHEL4
>=20
> =20
>=20
> The hardware is Sun x4600 and I am using QLA cards. The system has two
> LUNs presented to it of size 10 GB and size 90 GB
>=20
> =20
>=20
> There is a problem when I configure file system on it. I am able to
> access and mount the file system. But when I add those entries
> in /etc/fstab, the system would not recognize those devices.=20
>=20
> =20
>=20
> Below is the output from multipath command
>=20
> =20
>=20
> multipath -ll
>=20
> mpath5 (3600508b40010541d00009000065d0000)
>=20
> [size=3D90 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]
>=20
> \_ round-robin 0 [prio=3D100][active]
>=20
>  \_ 1:0:0:2 sdd 8:48  [active][ready]
>=20
>  \_ 2:0:0:2 sdh 8:112 [active][ready]
>=20
> \_ round-robin 0 [prio=3D20][enabled]
>=20
>  \_ 1:0:1:2 sdf 8:80  [active][ready]
>=20
>  \_ 2:0:1:2 sdj 8:144 [active][ready]
>=20
> =20
>=20
> mpath4 (3600508b40010541d00009000065a0000)
>=20
> [size=3D10 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]
>=20
> \_ round-robin 0 [prio=3D100][enabled]
>=20
>  \_ 1:0:1:1 sde 8:64  [active][ready]
>=20
>  \_ 2:0:1:1 sdi 8:128 [active][ready]
>=20
> \_ round-robin 0 [prio=3D20][enabled]
>=20
>  \_ 1:0:0:1 sdc 8:32  [active][ready]
>=20
>  \_ 2:0:0:1 sdg 8:96  [active][ready]
>=20
> =20
>=20
> =20
>=20
> Also, below is my /etc/multipath.conf
>=20
> =20
>=20
> # This is an example configuration file for device mapper multipath.
>=20
> # For a complete list of the default configuration values, see
>=20
> # /usr/share/doc/device-mapper-multipath-0.4.5/multipath.conf.defaults
>=20
> # For a list of configuration options with descriptions, see
>=20
> # /usr/share/doc/device-mapper-
> multipath-0.4.5/multipath.conf.annotated
>=20
> =20
>=20
> =20
>=20
> # Blacklist all devices by default. Remove this to enable multipathing
>=20
> # on the default devices.
>=20
> #devnode_blacklist {
>=20
> #        devnode "*"
>=20
> #}
>=20
> =20
>=20
> ## Use user friendly names, instead of using WWIDs as names.
>=20
> defaults {
>=20
>         user_friendly_names yes
>=20
>         selector   "round-robin 0"
>=20
> }
>=20
> =20
>=20
> =20
>=20
> ## By default, devices with vendor =3D "IBM" and product =3D "S/390.*" =
are
>=20
> ## blacklisted. To enable mulitpathing on these devies, uncomment the
>=20
> ## following lines.
>=20
> #devices {
>=20
> #       device {
>=20
> #               vendor                  "IBM"
>=20
> #               product                 "S/390 DASD ECKD"
>=20
> #               path_grouping_policy    multibus
>=20
> #               getuid_callout          "/sbin/dasdview -j -f /dev/%n"
>=20
> #               path_checker            directio
>=20
> #       }
>=20
> #}
>=20
> =20
>=20
> =20
>=20
> ##
>=20
> ## This is a template multipath-tools configuration file
>=20
> ## Uncomment the lines relevent to your environment
>=20
> ##
>=20
> #defaults {
>=20
> #       udev_dir                /dev
>=20
> #       polling_interval        10
>=20
> #       selector                "round-robin 0"
>=20
> #       path_grouping_policy    multibus
>=20
> #       getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>=20
> #       prio_callout            /bin/true
>=20
> #       path_checker            readsector0
>=20
> #       rr_min_io               100
>=20
> #       rr_weight               priorities
>=20
> #       failback                immediate
>=20
> #       no_path_retry           fail
>=20
> #       user_friendly_name      yes
>=20
> #}
>=20
> ##
>=20
> ## The wwid line in the following blacklist section is shown as an
> example
>=20
> ## of how to blacklist devices by wwid.  The 3 devnode lines are the
>=20
> ## compiled in default blacklist. If you want to blacklist entire
> types
>=20
> ## of devices, such as all scsi devices, you should use a devnode
> line.
>=20
> ## However, if you want to blacklist specific devices, you should use
>=20
> ## a wwid line.  Since there is no guarantee that a specific device
> will
>=20
> ## not change names on reboot (from /dev/sda to /dev/sdb for example)
>=20
> ## devnode lines are not recommended for blacklisting specific
> devices.
>=20
> ##
>=20
> devnode_blacklist {
>=20
>        wwid 3600508e000000000ed7fb52911133c06
>=20
>         devnode "^(ram|raw|loop|fd|md|sr|scd|st)[0-9]*"
>=20
>         devnode "^hd[a-z]"
>=20
> }
>=20
> #multipaths {
>=20
> #       multipath {
>=20
> #               wwid
> 3600508b4000156d700012000000b0000
>=20
> #               alias                   yellow
>=20
> #               path_grouping_policy    multibus
>=20
> #               path_checker            readsector0
>=20
> #               path_selector           "round-robin 0"
>=20
> #               failback                manual
>=20
> #               rr_weight               priorities
>=20
> #               no_path_retry           5
>=20
> #       }
>=20
> #       multipath {
>=20
> #               wwid                    1DEC_____321816758474
>=20
> #               alias                   red
>=20
> #       }
>=20
> #}
>=20
> #devices {
>=20
> #       device {
>=20
> #               vendor                  "COMPAQ  "
>=20
> #               product                 "HSV110 (C)COMPAQ"
>=20
> #               path_grouping_policy    multibus
>=20
> #               getuid_callout          "/sbin/scsi_id -g -u -
> s /block/%n"
>=20
> #               path_checker            readsector0
>=20
> #               path_selector           "round-robin 0"
>=20
> #               hardware_handler        "0"
>=20
> #               failback                15
>=20
> #               rr_weight               priorities
>=20
> #               no_path_retry           queue
>=20
> #       }
>=20
> #       device {
>=20
> #               vendor                  "COMPAQ  "
>=20
> #               product                 "MSA1000         "
>=20
> #               path_grouping_policy    multibus
>=20
> #       }
>=20
> #}
>=20
> =20
>=20
> =20
>=20
> =20
>=20
> =20
>=20
> Here is the contents of the /dev/mpath/
>=20
> =20
>=20
> [root@x mpath]# pwd
>=20
> /dev/mpath
>=20
> [root@x mpath]# ls -all
>=20
> total 0
>=20
> drwxr-xr-x   2 root root   80 Jan 16 17:34 .
>=20
> drwxr-xr-x  12 root root 5260 Jan 17 08:17 ..
>=20
> lrwxrwxrwx   1 root root    7 Jan 16 17:34 mpath4 -> ../dm-8
>=20
> lrwxrwxrwx   1 root root    7 Jan 16 17:34 mpath5 -> ../dm-9
>=20
> =20
>=20
> =20
>=20
> =20
>=20
> =20
>=20
> Can anyone please help me with this? I think I am missing some
> configuration on the system which is causing this.=20
>=20
> =20
>=20
> Thanks,
>=20
> =20
>=20
> =20
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
--=20

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
