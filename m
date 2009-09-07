From: Hannes Reinecke <hare@suse.de>
Subject: Re: [multipath] meaning of "no_path_retry nn"
Date: Mon, 07 Sep 2009 16:43:19 +0200
Message-ID: <4AA51C07.4080104@suse.de>
References: <7ujn84$746nl@dgate20u.abg.fsc.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7ujn84$746nl@dgate20u.abg.fsc.net>
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
> I would appreciate an explanation of "no_path_retry nn" parameter in=20
> multipath.conf. Probably I misunderstood it as a number of seconds.=20
>=20
> I am setting up  a software mirror (mdadm) on top of an EMC Clariion=20
> configuration for desaster protection. The Clariions are recognized by=20
> multipath properly; it seems to be set up with "no_path_retry 60"=20
> (according to multipath -t). I had no further settings in=20
> multipath.conf; this seems to be hardcoded into multipath.=20
>=20
> However, If I disconnect one Clariion, th mirror doesnt break -=20
> multipath detects that all paths are failed and tells me that it will=20
> now wait for 60 retries. These 60 retries seem to last very long;=20
> atfter 5 minutes, it didnt complete.=20
>=20
> Evertyhing works fine if I set up a multipath.conf containing the=20
> Clariion settings from multipath -t and modify them to=20
> "no_path_retry fail" and "features 0 fail_if_no_path".  But even if I=20
> just reduce the default settings to no_path_retry 2 the mirror doesnt=20
> break - the IOs seem to hang indefinitely (well, I lost patience after=20
> ~5 minutes).
>=20
> Probably I misunderstood "no_path_retry 60" - does that mean seconds,=20
> or minutes, or what else? Is anything except "fail" a useful setting in=
=20
> mirrored configurations?=20
>=20
> system is a Suse  with multipath-tools-0.4.7-34.43
>=20
Please note that there is a bug in the multipath-tools on suse which
prevents the no_path_retry option from working correctly.

Please install the latest maintenance update.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
