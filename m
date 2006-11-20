From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath-tools with STK FLEXLINE 380
Date: Mon, 20 Nov 2006 09:07:00 +0100
Message-ID: <45616224.4040401@suse.de>
References: <1163700218.11483.24.camel@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1163700218.11483.24.camel@localhost.localdomain>
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
Cc: daniel.milani@connexim.ca
List-Id: dm-devel.ids

Tony Lapointe wrote:
> Hi list,
>=20
> we're trying to get multipath working on a server (which run SLES 10)
> connected to a STK FLEXLINE 380 SAN. This SAN has AVT (Auto Volume
> Transfer) activated and we have two LUNs exported to the server, which
> one on a different preferred path (one on controller A and the other on
> controller B).
>=20
> Since the SAN has AVT activated and that we are using preferred path,
> i'm guessing that we have to use group_by_prio policy with the
> mpath_prio_tpc callout program.
>=20
> I can see that mpath_prio_tpc get the right priority :
>=20
> # mpath_prio_tpc /dev/sda
> 3
> # mpath_prio_tpc /dev/sdb
> 0
> # mpath_prio_tpc /dev/sdd
> 0
> # mpath_prio_tpc /dev/sde
> 3
>=20
> and then if i issue "fdisk -l" on /dev/sda and /dev/sde, each LUN stay
> on his preferred controller on the SAN.
>=20
> The problem is when i start multipath, it will not coalesces the paths
> together.
>=20
> Here's my multipath.conf :
>=20
> defaults {
>         udev_dir        /dev
>         polling_interval 10
>=20
>=20
>         path_grouping_policy    group_by_prio
>         getuid_callout  "/sbin/scsi_id -g -u -s /block/%n"
>=20
>=20
>         prio_callout    "/sbin/mpath_prio_tpc /dev/%n"
>         path_checker    tur
>=20
>         rr_weight       priorities
>=20
>         failback        immediate
>=20
> #       user_friendly_names yes
>=20
> }
Do not use 'rr_weight=3Dpriorities'. The priorities handling is currently=
=20
buggered; or, put it the other way round, you will need at least my=20
latest fix to get it working. Just remove that line and stay with the=20
defaults. That should work.

And as a sidenote: Using 'group_by_prio' and 'rr_weight=3Dpriorities' is=20
completely pointless, even if 'rr_weight=3Dpriorities' should be working.
'group_by_prio' will lump all devices with the same priority into one=20
group. And 'rr_weight=3Dpriorities' will then modify the 'minio' based on=
=20
the priority. So you can as well directly modify the 'minio' parameter.
'rr_weight=3Dpriorities' only makes sense if you have path with different=
=20
priorities in one group, ie when using 'multibus' or 'group_by_serial'.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
