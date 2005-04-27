From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: what is the current utility in testing active paths
	from multipat hd?
Date: Wed, 27 Apr 2005 22:10:24 +0200
Message-ID: <20050427201024.GD4431@marowsky-bree.de>
References: <C2EEB4E538D3DC48BF57F391F422779321A94B@SRMANNING.eng.emc.com>
	<20050427170710.GU4431@marowsky-bree.de>
	<20050427181701.GB9368@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050427181701.GB9368@us.ibm.com>
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

On 2005-04-27T11:17:02, Mike Anderson <andmike@us.ibm.com> wrote:

> Once support gets completed / utilized the fc_transport class should
> provide data on the link state and the port state which could be provid=
e
> indication of path health for deciding if to send a patch check cmd. Th=
is
> would add complication to the tester as each new transport would need s=
ome
> type of handler.

ACK. Yes, this is part of the additional information to use I was
referring to. As long as the port is down, why bother...

> > Another option would be to not mechanically test every N seconds, but=
 to
> > retest a failed path after 1s - 2s - 4s - ... 32s max as a cascading
> > back-off, and maybe start at 2 - 64s for paths in inactive PGs.
> >=20
> A cascading backoff / staggered  timer would require less topology
> knowledge than the above path health testing method and would provide t=
he
> reduce IO loading desired (depending on how high a user was willing to =
go
> on setting the delta between path tests).

Yes, it's easier, but it also slows down responsiveness and path
reactivation of course. One can argue that the combination of the two
works; we only retest every path every N seconds, but we interleave
them, so that essentially we test a path every N/M seconds; and as soon
as one path finds a state change, we shorten the timers for all paths so
they get all tested faster.

That's probably a pretty sophisticated heuristic which would work
reasonably well w/o any additional configuration.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
