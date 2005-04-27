From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: what is the current utility in testing active paths
	from multipat hd?
Date: Wed, 27 Apr 2005 11:17:02 -0700
Message-ID: <20050427181701.GB9368@us.ibm.com>
References: <C2EEB4E538D3DC48BF57F391F422779321A94B@SRMANNING.eng.emc.com>
	<20050427170710.GU4431@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050427170710.GU4431@marowsky-bree.de>
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

Lars Marowsky-Bree [lmb@suse.de] wrote:
> On 2005-04-27T12:27:32, "goggin, edward" <egoggin@emc.com> wrote:
> > If not, it may be possible to significantly reduce the cpu&io
> > resource utilization consumed by multipathd path testing on
> > enterprise scale configurations by only testing those paths
> > which the kernel thinks are in a failed state -- obviously a
> > much smaller set of paths.
> 
> I could see not testing paths if we knew IO was hitting them; as an
> approximization, the active paths from the active PG might be omitted.
> However, the paths in the inactive PG all need to be tested, or else you
> are never going to find out that the paths have gone bad on you until
> you try to failover.
> 
> The best way to minimize path (re-)testing needed is to figure in the
> hierarchy of components involved; as long as the FC switch is still bad,
> there's no point testing any target which we could reach through it,
> etc; testing whether the switch itself is healthy would round-robin
> through our various connections to the switch, to make sure we don't
> declare the switch down because we got hung up on one failed path.
> 

Once support gets completed / utilized the fc_transport class should
provide data on the link state and the port state which could be provide
indication of path health for deciding if to send a patch check cmd. This
would add complication to the tester as each new transport would need some
type of handler.

> Another option would be to not mechanically test every N seconds, but to
> retest a failed path after 1s - 2s - 4s - ... 32s max as a cascading
> back-off, and maybe start at 2 - 64s for paths in inactive PGs.
> 

A cascading backoff / staggered  timer would require less topology
knowledge than the above path health testing method and would provide the
reduce IO loading desired (depending on how high a user was willing to go
on setting the delta between path tests).

-andmike
--
Michael Anderson
andmike@us.ibm.com
