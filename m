From: Hannes Reinecke <hare@suse.de>
Subject: Re: path priorities on Sun's 6140
Date: Mon, 17 Sep 2007 08:21:50 +0200
Message-ID: <46EE1CFE.9070807@suse.de>
References: <66F461DD7EDEEF4AA928FCC80B425B520468B7@c2kp01mail.cucbc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <66F461DD7EDEEF4AA928FCC80B425B520468B7@c2kp01mail.cucbc.com>
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

James Fillman wrote:
> I'm running RHEL5 with QLogic HBA's and a Sun 6140 SAN. The host type
> I'm using for my servers is 'Solaris (with DMP)'. This turns AVT mode
> one. For some reason, the two controllers are returning the same
> priority value to my priority call out program (mpath_prio_tpc).
>=20
> Can anyone briefly explain what the mpath_prio_tpc utility does and
> where these priority values come from?
>=20
> The output of multipath -v2 -ll is:
>=20
> [root@vlxq02md cluster]# multipath -v2 -ll
> mdi_logging (3600a0b800029f8e80000064d46e565e7) dm-9 SUN,CSM200_R
> [size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 1:0:0:2 sdd 8:48  [active][ready]
>  \_ 1:0:1:2 sdg 8:96  [active][ready]
>=20
> Where is should be:
>=20
> [root@vlxq02md cluster]# multipath -v2 -ll
> mdi_logging (3600a0b800029f8e80000064d46e565e7) dm-9 SUN,CSM200_R
> [size=3D100G][features=3D1 queue_if_no_path][hwhandler=3D0]
> \_ round-robin 0 [prio=3D3][active]
>  \_ 1:0:0:2 sdd 8:48  [active][ready]
> \_ round-robin 0 [prio=3D0][active]
>  \_ 1:0:1:2 sdg 8:96  [active][ready]
>=20
> I've gotten this working at my other data center with the same
> hardware/software configuration. At the moment, I'm pointing my finger
> at the SAN hardware but I don't have much to back it up with.
>=20
> here's my multipath.conf file:
>=20
> blacklist
> {
>          devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|sda)[0-9]*"
> }
>=20
> defaults
> {
>         udev_dir                /dev
>         polling_interval        10
>         selector                "round-robin 0"
>         path_grouping_policy    group_by_prio
>         getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
>         prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
>         path_checker            readsector0
>         rr_min_io               100
>         rr_weight               priorities
>         failback                immediate
>         no_path_retry           queue
>         user_friendly_name      yes
> }
>=20
> devnode_blacklist
> {
>         devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st|sda)[0-9]*"
>         devnode "^hd[a-z][0-9]*"
>         devnode "^cciss!c[0-9]d[0-9]*"
> }
>=20
> multipaths
> {
>          multipath
>         {
>                 wwid                   3600a0b800029cc400000120946e5661=
6
>                 alias                  mdi_deploys
>         }
>          multipath
>         {
>                 wwid                   3600a0b800029f8e80000064d46e565e=
7
>                 alias                  mdi_logging
>         }
>          multipath
>         {
>                 wwid                   3600a0b800029cc4000001140468531f=
a
>                 alias                  primary_logging
>         }
> }
>=20
> devices
> {
>         device
>         {
>                 vendor                  "SUN"
>                 product                 "CSM200_R"
>                 path_grouping_policy    group_by_prio
>                 path_checker            readsector0
>                 prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
>                 getuid_callout          "/sbin/scsi_id -g -u -s
> /block/%n"
>                 rr_weight               uniform
>                 rr_min_io               1000
>                 features                "1 queue_if_no_path"
>         }
> }
>=20
Oh, please _don't_ use=20

rr_weight priorities

The implementation is broken (I send a patch once but it got rejected)
and it's completely useless when using 'group_by_prio'.
rr_weight =3D priorities is meant to adjust the round-robin scheduler by
the priority of each path. However, when using group_by_prio you'll the
same priority for all paths in a group. So effectively you only increase
(actually, you would increase if it would be working properly) the rr_min=
_io
value by the priority value.
So please try without this setting.

As for the AVT setting: sg_vpd can decode the RDAC mode pages; please sen=
d
the output of

sg_vpd -p vac <devname>

That should give us some hints what's going on here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
