From: Hannes Reinecke <hare@suse.de>
Subject: Re: DM-MP, Xen 5.0.0 and NetApp
Date: Wed, 01 Apr 2009 16:36:00 +0200
Message-ID: <49D37BD0.5090004@suse.de>
References: <af7b4eb20904010731v5596112dy783c8c9ad05f558d@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <af7b4eb20904010731v5596112dy783c8c9ad05f558d@mail.gmail.com>
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

Rodrigo Nascimento wrote:
> Hi All,
> =20
> I'm having problems to put the Multipathing tools to work correctly wit=
h=20
> NetApp Cluster Solution.
> =20
> I have a xenpool with 3 machines the multipathing are enabled on them,=20
> the HBA are Qlogic, two FAS3140 controllers in Cluster. I created a lun=
=20
> to be a storage repository (SR), the lun is visible and was recognized=20
> on the 3 machines, but when we say to the XenServer to build a SR with=20
> this Lun, all I/O operations arrive to the FAS3140 by the non-optimized=
=20
> path.
> =20
> *XenServer multipath.conf*
> =20
> defaults {
>         user_friendly_names no
> }
> devices {
>         device {
>                 vendor                  "NETAPP"
>                 product                 "LUN"
>                 path_grouping_policy    group_by_prio
>                 getuid_callout          "/sbin/scsi_id -g -u -s /block/=
%n"
>                 prio_callout            "/sbin/mpath_prio_netapp /dev/%=
n"
>                 features                "1 queue_if_no_path"
>                 path_checker            directio
>                 failback                immediate
>         }
> }
> =20
> We made two tests, one with prio_callout as /sbin/mpath_prio_alua and=20
> other with prio_callout as /sbin/mpath_prio_netapp, both returns the=20
> same results.
> =20

What's the output of 'multipath -ll'?
Looks like all paths are configured into one group here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
