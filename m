From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [multipath] meaning of "no_path_retry nn"
Date: Fri, 28 Aug 2009 09:42:26 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF474C65FA4@cosmail01.lsi.com>
References: <7ujn84$746nl@dgate20u.abg.fsc.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7ujn84$746nl@dgate20u.abg.fsc.net>
Content-Language: en-US
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

This is how the time is calculated.=20
Total queing time =3D  nn* polling_interval.

For example=20
	polling_interval        10
	no_path_retry 		5

This will queue-up the i/os for 50 seconds. You should see i/o error afte=
r 50 seconds in case of all path failure.

However, this may not work in all the distros. We have seen problems with=
 this feature. Looks like upstream tool has fixed this problem.
=20
Thanks
Babu Moger=20

> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Diedrich Ehlerding
> Sent: Friday, August 28, 2009 8:16 AM
> To: dm-devel@redhat.com
> Subject: [dm-devel] [multipath] meaning of "no_path_retry nn"
>=20
> I would appreciate an explanation of "no_path_retry nn" parameter in
> multipath.conf. Probably I misunderstood it as a number of seconds.
>=20
> I am setting up  a software mirror (mdadm) on top of an EMC Clariion
> configuration for desaster protection. The Clariions are recognized by
> multipath properly; it seems to be set up with "no_path_retry 60"
> (according to multipath -t). I had no further settings in
> multipath.conf; this seems to be hardcoded into multipath.
>=20
> However, If I disconnect one Clariion, th mirror doesnt break -
> multipath detects that all paths are failed and tells me that it will
> now wait for 60 retries. These 60 retries seem to last very long;
> atfter 5 minutes, it didnt complete.
>=20
> Evertyhing works fine if I set up a multipath.conf containing the
> Clariion settings from multipath -t and modify them to
> "no_path_retry fail" and "features 0 fail_if_no_path".  But even if I
> just reduce the default settings to no_path_retry 2 the mirror doesnt
> break - the IOs seem to hang indefinitely (well, I lost patience after
> ~5 minutes).
>=20
> Probably I misunderstood "no_path_retry 60" - does that mean seconds,
> or minutes, or what else? Is anything except "fail" a useful setting in
> mirrored configurations?
>=20
> system is a Suse  with multipath-tools-0.4.7-34.43
>=20
> Thanks
> Diedrich
> --
> Diedrich Ehlerding, Fujitsu Technology Solutions GmbH, R GE TIS N IC2
> Hildesheimer Str 25, D-30880 Laatzen
> Fon +49 511 8489-1806, Fax -251806, Mobil +49 173 2464758
> Firmenangaben: http://de.ts.fujitsu.com/imprint.html
>=20
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
