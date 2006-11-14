From: Edward Goggin <egoggin@emc.com>
Subject: RE: patch to discovery.c to still get path
	priorityforpaths with path state of PATH_DOWN
Date: Tue, 14 Nov 2006 15:09:49 -0500
Message-ID: <6CCEAEDF4D06984A83F427424F47D6E4013D154C@CORPUSMX40A.corp.emc.com>
References: <1163514392.4850.22.camel@linux-cxyg.rtp.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
In-Reply-To: <1163514392.4850.22.camel@linux-cxyg.rtp.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: dave.wysochanski@redhat.com, christophe.varoqui@free.fr
List-Id: dm-devel.ids


On Tuesday, November 14, 2006 9:27 AM, Dave Wysochanski wrote:
> Are you saying that there's no way in the path checker to distinguish
> between this kind of path and a path that is genuinely down?

No, I'm certainly not saying that at all.  I would rather not
complicate matters by adding yet another path state though.

The particular problem I'm trying to fix is that the path group
membership for a multipath map can be incorrectly initially set
up if scsi_id(8) is successful but the paths are all failed.
When the paths return to a ready state, the path group membership
is not corrected by reloading the map -- this only happens if the
paths are removed and later added back.

What do you think of a fix involving changing need_switch_pathgroup()
in multipathd to check and reload a corrected version of the map
in this case?
 =20
> By "down",
> I mean "fails ioctl" either directly or with an unexpected
> CHECK_CONDITION (this seems to be what PATH_DOWN means in the=20
> code today
> for all the path checkers).  Can you return another state in your path
> checker for this type of path/LUN?
>=20
> IMO, if at all possible, it would be good to leave=20
> "PATH_DOWN" with its
> current meaning and not call the priority callouts for paths in this
> state.  If the priority callouts could obtain priorities without SG_IO
> succeeding, it might make sense, but this is not the case=20
> today.  If you
> once had a good priority because you could get a command through, now
> you call it when the path is down it will be replaced with an=20
> incorrect
> one.

Yes, good point.  The converse of this statement is indeed what my
patch is trying to prevent.  That is, initially having an incorrect
priority before the path groups are created then having the good or
correct priority calculated only after the path groups are already
created.

>=20
> Arguably the states are fuzzy and "types of paths" are mixed in with
> "path states" which leads to the fuzzyness/confusion.  Right=20
> now I don't
> have a good enough feel for it to offer clarifying suggestions though
> other than the attached comment patch which tries to clarify=20
> the meaning
> of each state as it is in the code today.
