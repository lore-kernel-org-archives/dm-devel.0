From: James Tanner <jtanner@redhat.com>
Subject: Re: DM-MP, Xen 5.0.0 and NetApp
Date: Thu, 02 Apr 2009 14:19:16 -0400
Message-ID: <49D501A4.7010005@redhat.com>
References: <af7b4eb20904010731v5596112dy783c8c9ad05f558d@mail.gmail.com>	<49D37BD0.5090004@suse.de>
	<af7b4eb20904010745g37191673sa7f3e4aba1fe70f2@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <af7b4eb20904010745g37191673sa7f3e4aba1fe70f2@mail.gmail.com>
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

Netapp support has a host setup guide which covers the settings you=20
should be using in multipath.conf:

defaults
{
   user_friendly_names   yes
   max_fds               4096
}
blacklist
{
    wwid <DevId>
    devnode "^(ram|raw|loop|fd|md|dm-|sr|scd|st)[0-9]*"
    devnode "^hd[a-z]"
    devnode "^cciss!c[0-9]d[0-9]*[p[0-9]*]"
}
devices
{
    device
    {
      vendor                 "NETAPP"
      product                "LUN"
      getuid_callout         "/sbin/scsi_id -g -u -s /block/%n"
      prio_callout           "/sbin/mpath_prio_ontap /dev/%n"
      features               "1 queue_if_no_path"
      hardware_handler       "0"
      path_grouping_policy group_by_prio
      failback               immediate
      rr_weight              uniform
      rr_min_io              128
      path_checker           directio
      }
}


Try those out and see if it helps.

Rodrigo Nascimento wrote:
> multipath -ll output:
> =20
> [root@CMPXEN02 ~]# multipath -ll
> 360a98000572d42774e6f4f2f682f6330dm-0 NETAPP,LUN
> [size=3D20G][features=3D1 queue_if_no_path][hwhandler=3D0]
> \_ round-robin 0 [prio=3D32][active]
>  \_ 0:0:0:0 sda        8:0   [active][ready]
>  \_ 0:0:1:0 sdb        8:16  [active][ready]
>  \_ 1:0:0:0 sdd        8:48  [active][ready]
>  \_ 1:0:1:0 sde        8:64  [active][ready]
>  \_ 2:0:0:0 sdh        8:112 [active][ready]
>  \_ 3:0:0:0 sdi        8:128 [active][ready]
>  \_ 3:0:1:0 sdj        8:144 [active][ready]
>  \_ 2:0:1:0 sdk        8:160 [active][ready]
> \_ round-robin 0 [prio=3D7][enabled]
>  \_ 0:0:2:0 sdc        8:32  [active][ready]
>  \_ 1:0:2:0 sdf        8:80  [active][ready]
>  \_ 1:0:3:0 sdg        8:96  [active][ready]
>  \_ 3:0:2:0 sdl        8:176 [active][ready]
>  \_ 3:0:3:0 sdn        8:208 [active][ready]
>  \_ 0:0:3:0 sdo        8:224 [active][ready]
>  \_ 2:0:3:0 sdp        8:240 [active][ready]
> \_ round-robin 0 [prio=3D0][enabled]
>  \_ 2:0:2:0 sdm        8:192 [failed][faulty]
>
>
> On Wed, Apr 1, 2009 at 11:36 AM, Hannes Reinecke <hare@suse.de=20
> <mailto:hare@suse.de>> wrote:
>
>     Rodrigo Nascimento wrote:
>
>         Hi All,
>          I'm having problems to put the Multipathing tools to work
>         correctly with NetApp Cluster Solution.
>          I have a xenpool with 3 machines the multipathing are enabled
>         on them, the HBA are Qlogic, two FAS3140 controllers in
>         Cluster. I created a lun to be a storage repository (SR), the
>         lun is visible and was recognized on the 3 machines, but when
>         we say to the XenServer to build a SR with this Lun, all I/O
>         operations arrive to the FAS3140 by the non-optimized path.
>          *XenServer multipath.conf*
>          defaults {
>                user_friendly_names no
>         }
>         devices {
>                device {
>                        vendor                  "NETAPP"
>                        product                 "LUN"
>                        path_grouping_policy    group_by_prio
>                        getuid_callout          "/sbin/scsi_id -g -u -s
>         /block/%n"
>                        prio_callout         =20
>          "/sbin/mpath_prio_netapp /dev/%n"
>                        features                "1 queue_if_no_path"
>                        path_checker            directio
>                        failback                immediate
>                }
>         }
>          We made two tests, one with prio_callout as
>         /sbin/mpath_prio_alua and other with prio_callout as
>         /sbin/mpath_prio_netapp, both returns the same results.
>         =20
>
>
>     What's the output of 'multipath -ll'?
>     Looks like all paths are configured into one group here.
>
>     Cheers,
>
>     Hannes
>     --=20
>     Dr. Hannes Reinecke                   zSeries & Storage
>     hare@suse.de <mailto:hare@suse.de>                          +49
>     911 74053 688
>     SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
>     GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>
>     --
>     dm-devel mailing list
>     dm-devel@redhat.com <mailto:dm-devel@redhat.com>
>     https://www.redhat.com/mailman/listinfo/dm-devel
>
>
>
>
> --=20
> Rodrigo Nascimento
> -----------------------------------------------------------------------=
-
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
