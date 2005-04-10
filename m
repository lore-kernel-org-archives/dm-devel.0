From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: A better solution than "md_component_detection = 1"
Date: Sun, 10 Apr 2005 19:29:31 +0200
Message-ID: <20050410172931.GF12752@marowsky-bree.de>
References: <000001c5136d$3b3502a0$11051aac@pcp41116>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <000001c5136d$3b3502a0$11051aac@pcp41116>
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

On 2005-02-15T20:17:10, shahid shaikh <shahid.shaikh@patni.com> wrote:

Sorry about this late reply, but I just stumbled across this post.

To recap, the issue is that we want to prevent LVM2/EVMS2 etc from
scanning (and using!) the raw physical devices if those are already
claimed/used by multipath.

LVM2 has a special handling for md_component_detection already; what I
want to propose in the following is a bit more general, and I've
discussed it with Hannes before.

Problem: A general solution for finding out whether another component is
using the device we're looking at.

Proposed solution: Introduce sub-devices into the sysfs tree. (And,
automatically, backlink those to parent devices, but that's just so the
tree can be traversed in any order.)

For example, /sys/block/sda would have a sub/ directory with "dm-0" in
there, pointing at /sys/block/dm-0 (surprise). The
/sys/block/dm-0/parent/sd{a,b} entries would do a very surprising
thing.

This would also allow us to handle partitions in DM better: as all
linear mappings on top of /dev/dm-0 would show up in block/dm-0/sub/ and
vice versa.

md could work the same: block/sys/md0/parent/ would list all the devices
(or partitions) which it consists of.

This very simple(?) change would make a number of things much easier to
figure out.


Caveats:

- This obviously only works if the devices are already active, not if
  the specific user is offline; if LVM2 scans before multipath-tools has
  worked its magic, it won't work.=20
 =20
  (But then, multipath-tools can figure out that there's already someone
  else using the raw physical device and not mess with it! Woho, world
  saved!)

- This ONLY exports very rudimentary hierarchical information; it won't
  tell you what the device is used for or how. However, that information
  alone would be very helpful already.
 =20

Greg, Alasdair? List?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
