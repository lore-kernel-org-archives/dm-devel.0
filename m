From: Hannes Reinecke <hare@suse.de>
Subject: Re: Changes in multipathing between 0.4.5 (SLES9) and
	0.4.7	(SLES10)
Date: Fri, 27 Mar 2009 16:38:08 +0100
Message-ID: <49CCF2E0.7010009@suse.de>
References: <20090326160641.GA12038@lupe-christoph.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090326160641.GA12038@lupe-christoph.de>
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

Hi,

Lupe Christoph wrote:
> Hi!
>=20
> I just ran into a strange difference in the behavious of multipathing
> between SLES9 and SLES10. While SLES9 seemed to ignore single-pathed
> disks like volumes on the internal RAID controller of IBM xSeries,
> SLES10 welcomes them leading to different pathes in /etc/fstab.
>=20
> There is a lot of our software involved in this behavious, so let's jus=
t
> say that the change is unwelcome ;-)
>=20
> We have for now overcome this by blacklisting the internal RAID
> controller. But there are many types of RAID controllers involved (the
> machines have all hardware-mirrored internal disks), so we would like t=
o
> have a better solution.
>=20
> Is there a way to tell the multipath-tools to ignore devices that have
> only a single path? I found nothing in the multipath.conf manpage, but
> maybe I read it wrong.
>=20
No, there isn't. For multipathing we cannot distinguish between 'real'
single path systems and multipath systems with all but one path failed.
So whenever multipath is activated we have to assume that the admin
really wants to have multipath, and consequently the admin will have
to take appropriate steps.

Although there is no harm in running the system entirely on multipath;
the performance impact for the root fs is negligible ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
