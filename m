From: Lars Marowsky-Bree <lmb@suse.de>
Subject: A better solution than "md_component_detection = 1"
Date: Tue, 19 Apr 2005 23:38:10 +0200
Message-ID: <20050419213810.GY29071@marowsky-bree.de>
References: <000001c5136d$3b3502a0$11051aac@pcp41116>
	<20050410172931.GF12752@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050410172931.GF12752@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, gregkh@suse.de
Cc: hare@suse.de
List-Id: dm-devel.ids

On 2005-04-10T19:29:31, Lars Marowsky-Bree <lmb@suse.de> wrote:

This has generated absolutely no comments, so I'm resending it...

> On 2005-02-15T20:17:10, shahid shaikh <shahid.shaikh@patni.com> wrote:
>=20
> Sorry about this late reply, but I just stumbled across this post.
>=20
> To recap, the issue is that we want to prevent LVM2/EVMS2 etc from
> scanning (and using!) the raw physical devices if those are already
> claimed/used by multipath.
>=20
> LVM2 has a special handling for md_component_detection already; what I
> want to propose in the following is a bit more general, and I've
> discussed it with Hannes before.
>=20
> Problem: A general solution for finding out whether another component i=
s
> using the device we're looking at.
>=20
> Proposed solution: Introduce sub-devices into the sysfs tree. (And,
> automatically, backlink those to parent devices, but that's just so the
> tree can be traversed in any order.)
>=20
> For example, /sys/block/sda would have a sub/ directory with "dm-0" in
> there, pointing at /sys/block/dm-0 (surprise). The
> /sys/block/dm-0/parent/sd{a,b} entries would do a very surprising
> thing.
>=20
> This would also allow us to handle partitions in DM better: as all
> linear mappings on top of /dev/dm-0 would show up in block/dm-0/sub/ an=
d
> vice versa.
>=20
> md could work the same: block/sys/md0/parent/ would list all the device=
s
> (or partitions) which it consists of.
>=20
> This very simple(?) change would make a number of things much easier to
> figure out.
>=20
>=20
> Caveats:
>=20
> - This obviously only works if the devices are already active, not if
>   the specific user is offline; if LVM2 scans before multipath-tools ha=
s
>   worked its magic, it won't work.=20
>  =20
>   (But then, multipath-tools can figure out that there's already someon=
e
>   else using the raw physical device and not mess with it! Woho, world
>   saved!)
>=20
> - This ONLY exports very rudimentary hierarchical information; it won't
>   tell you what the device is used for or how. However, that informatio=
n
>   alone would be very helpful already.
>  =20
>=20
> Greg, Alasdair? List?
>=20
>=20

Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
