From: Hannes Reinecke <hare@suse.de>
Subject: Re: multipath: expected results of
	configuring	"no_path_retry"?
Date: Thu, 30 Apr 2009 11:17:25 +0200
Message-ID: <49F96CA5.9050607@suse.de>
References: <7oranp$22o15k@dgate10u.abg.fsc.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7oranp$22o15k@dgate10u.abg.fsc.net>
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

Diedrich Ehlerding wrote:
> I have a question concerning the expected behavior of dm_multipath=20
> connected to an EMC Clariion array. Different versions of multipath=20
> give different results when I disconnect all pathes to the storage.=20
>=20
> I have one server (SuSE SLES10 SP2, 2.6.16.60-0.3, multipath-tools=20
> 0.4.7-34.43) and another one (SLES 11,  2.6.27.19-5-default, 0.4.8-
> 40.1). Both versions recognize the Clariion without further setting in=20
> multipath.conf. The settings for the Clariion in multipath -t seem to=20
> be the same (especially queue_if_no_path + no_path_retry 60)
>=20
> Trying to setup a software mirror on top, i.e. trying to mirror the=20
> data into a second box, I observed the follwoing diffenrent behavior=20
> between these two versions:=20
>=20
> - on the SLES10 machine, disconnecting the disk in one Clariion results=
=20
> in IO error, the mirror breaks up, and the use IO continues on the=20
> surviving part of the mirror. This is the behavior which I want, and=20
> which I expected, and this was my understanding of "no_path_retry" -=20
> retry some times, then terminate IO. =20
>=20
> - on the SLES11 machine, the same attempt makes IO hang infinitely. The=
=20
> messages display that all pathes fail, and then "Entering recovery=20
> mode: max_retries=3D60" - but then, nothing happens; IOs hang.
>=20
Yes, I know. You are triggering Novell bugzilla #485281

Patch is already available from my multipath repository

git://git.kernel.org/pub/scm/linux/kernel/git/hare/multipath-tools.git
branch sles11

Will be included in the next maintenance update.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
