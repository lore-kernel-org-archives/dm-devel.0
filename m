From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: RH 4 and HSG80
Date: Wed, 1 Aug 2007 17:39:08 +0200
Message-ID: <OFD9DA3C9D.6E99EABB-ONC125732A.005472D4-C125732A.0055D34C@de.ibm.com>
References: <46B09E83.9010503@interactivebrokers.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46B09E83.9010503@interactivebrokers.com>
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

I have no access to HSGs but maybe this generic statements (plus some=20
wisdom from hwtable.c) helps:

First, you are actually forcing multipath-tools to use all paths by=20
stating "multibus" in you multipath section.
Everything you put there will replace the defaults and the device=20
sections. Just be minimalistic there. In the
latest multipath-tools code there actually is a configuration for=20
"DEC"/"HSG80". From this, does the following
multipath-conf help you?

defaults {
        rr_min_io                       64
        user_friendly_names     yes
}

multipaths {
        multipath {
                wwid    360001fe1000d85f000039341397602d2
                alias   disk1
        }
        multipath {
                wwid    360001fe1000d85f0000393413976024b
                alias   disk2
        }
}

devices {
        device {
                vendor                  "DEC"
                product                 "HSG80"
                path_grouping_policy    group_by_prio
                prio_callout            "/sbin/mpath_prio_hp_sw /dev/%n"
                hardware_handler                "1 hp_sw"
                path_checker            hp_sw
                no_path_retry           5
        }
        device {
                vendor                  "DEC"
                product                 "HSG80    (C) DEC"
                path_grouping_policy    group_by_prio
                prio_callout            "/sbin/mpath_prio_hp_sw /dev/%n"
                hardware_handler                "1 hp_sw"
                path_checker            hp_sw
                no_path_retry           5
        }
}


Mit freundlichem Gru=DF / Regards,
Stefan Bader

SW Linux on zSeries Development
Stefan.Bader@de.ibm.com

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Martin Jetter
Gesch=E4ftsf=FChrung: Herbert Kircher
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
-------------------------------------------------------------------------=
---------
  When all other means of communication fail, try words.

dm-devel-bounces@redhat.com wrote on 01.08.2007 16:53:55:

> I trying to setup multipathing with HSG80s on a Redhat 4 update 5 host.=
=20
> I have it mostly working, the problem I'm having is that the 2 disks=20
> I've created on the HSGs only go through one controller. I set the=20
> preferred path for each disk to use a different controller but dm alway=
s=20

> sets them to go through just one. I also can't find a way to move a dis=
k=20

> to the other controller, I thought multipathd -k switch would work but=20
> it doesn't. Does anyone have RedHat4 and HSG80s working properly with=20
> multipathing? Here is my multipath.conf file and multipath -ll output:
>=20
> defaults {
>         user_friendly_names yes
> }
>=20
> defaults {
>         udev_dir                /dev
>         polling_interval        10
>         selector                "round-robin 0"
>         path_grouping_policy    multibus
>         getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>         prio_callout            /bin/true
>         path_checker            readsector0
>         rr_min_io               100
>         rr_weight               priorities
>         failback                immediate
>         no_path_retry           fail
>         user_friendly_name      yes
>         features                "1 queue_if_no_path"
> }
> devnode_blacklist {
>         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
>         devnode "^hd[a-z]"
>         devnode "^cciss!c[0-9]d[0-9]*"
> }
>=20
> multipaths {
>         multipath {
>                 wwid 360001fe1000d85f000039341397602d2
>                 alias                   disk1
>                 path_grouping_policy    multibus
>                 path_checker            readsector0
>                 path_selector           "round-robin 0"
>                 failback                manual
>                 rr_weight               priorities
>                 no_path_retry           5
>         }
>         multipath {
>                 wwid 360001fe1000d85f0000393413976024b
>                 alias                   disk2
>                 path_grouping_policy    multibus
>                 path_checker            readsector0
>                 path_selector           "round-robin 0"
>                 failback                manual
>                 rr_weight               priorities
>                 no_path_retry           5
>         }
> }
> devices {
>         device {
>                 vendor                  DEC
>                 product                 HSG80
>                 path_grouping_policy    group_by_serial
>                 getuid_callout          "/sbin/scsi_id -g -u -s=20
/block/%n"
>                 path_checker            hp_sw
>                 features                "1 queue_if_no_path"
>         }
>         device {
>                 vendor                  DEC
>                 product                 "HSG80    (C) DEC"
>                 path_grouping_policy    group_by_serial
>                 getuid_callout          "/sbin/scsi_id -g -u -s=20
/block/%n"
>                 path_checker            hp_sw
>                 features                "1 queue_if_no_path"
>         }
> }
>=20
> [root@lin380g5-ib etc]# multipath -ll
> disk2 (360001fe1000d85f0000393413976024b)
> [size=3D339 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]
> \_ round-robin 0 [active]
>  \_ 0:0:4:11 sdb 8:16  [active][ready]
>  \_ 0:0:5:11 sdd 8:48  [active][ghost]
>  \_ 1:0:4:11 sdf 8:80  [active][ready]
>  \_ 1:0:5:11 sdh 8:112 [active][ghost]
>=20
> disk1 (360001fe1000d85f000039341397602d2)
> [size=3D67 GB][features=3D"1 queue_if_no_path"][hwhandler=3D"0"]
> \_ round-robin 0 [active]
>  \_ 0:0:4:20 sda 8:0   [active][ready]
>  \_ 0:0:5:20 sdc 8:32  [active][ghost]
>  \_ 1:0:4:20 sde 8:64  [active][ready]
>  \_ 1:0:5:20 sdg 8:96  [active][ghost]
>=20
>=20
> Thanks
>=20
> --=20
> Eric Ritchie
> Interactive Brokers LLC
>=20
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
