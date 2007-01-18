From: Hannes Reinecke <hare@suse.de>
Subject: Re: DS4000 with multipath-tools 0.4.5
Date: Thu, 18 Jan 2007 08:05:38 +0100
Message-ID: <45AF1C42.8050304@suse.de>
References: <OF396F7E56.FA311C77-ON85257261.00787002-85257261.00789A54@mohegansun.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF396F7E56.FA311C77-ON85257261.00787002-85257261.00789A54@mohegansun.com>
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

TGrozev@mohegansun.com wrote:
> I compiled it, and it's working good. The only thing is, when I query t=
he=20
> priority of a drive, I'm getting "Auto-volume Transfer not enabled":
>=20
> ---
> # ./mpath_prio_tpc /dev/sdc
> Auto-volume Transfer not enabled6
>=20
> # ./mpath_prio_tpc /dev/sdd
> Auto-volume Transfer not enabled1
> ---
>=20
> I seem to be getting 6 for my preferred path and 1 for standby, which i=
s=20
> good. Is AVT required, or can I still use mpath_prio_tcp?
> I have multiple nodes of a Linux Cluster accessing the LUNs, so AVT has=
 to=20
> be disabled.
>=20
Unfortunately the current multipath-tools do not handle RDAC mode.
You'll need a specific hardware handler to do this properly.
Mike Christie once did some work on it, but I'm not sure if it made it
into RHEL. We will be adding support for it for SLES10 SP1, so you might
get lucky with that.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
