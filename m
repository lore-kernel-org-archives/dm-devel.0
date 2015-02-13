From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-io: reject unsupported DISCARD/WRITE SAME
 requests with EOPNOTSUPP
Date: Fri, 13 Feb 2015 15:58:58 -0500
Message-ID: <20150213205858.GA7070@redhat.com>
References: <20150213092432.GC11034@birch.djwong.org>
	<20150213155550.GA32670@redhat.com>
	<yq1sie9mxcy.fsf@sermon.lab.mkp.net>
	<20150213200714.GC14719@birch.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150213200714.GC14719@birch.djwong.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: dm-devel@redhat.com, agk@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Srinivas Eeda <srinivas.eeda@oracle.com>
List-Id: dm-devel.ids

On Fri, Feb 13 2015 at  3:07P -0500,
Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Fri, Feb 13, 2015 at 02:21:01PM -0500, Martin K. Petersen wrote:
> > >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> > 
> > Mike> When I implemented dm_table_supports_discards() I consciously
> > Mike> allowed a DM table to contain a mix of discard support.  I'm now
> > Mike> wondering where it is we benefit from that?  Seems like more of a
> > Mike> liability than anything -- so a bigger hammer approach to fixing
> > Mike> this would be to require all targets and all devices in a DM table
> > Mike> support discard.
> > 
> > I think our original rationale was that since discard is only a hint it
> > would be fine to mix and match. And at the time there seemed to be value
> > in supporting a heterogeneous setups with say a disk drive and an SSD.
> > 
> > Back then the SSD vendors were all busy telling us how crucial discard
> > would be going forward. However, that turned out not to be the case and
> > discard often causes more problems than it solves. So I'm perfectly OK
> > with requiring all devices in a table to have the same capabilities. In
> > many ways I think that's a cleaner approach.
> 
> I agree that imposing that extra requirement would be cleaner from a software
> engineering POV.
> 
> That said, given that discard is advisory and most of the callers seem to
> anticipate that it might not work, why not allow heterogeneous mixes?  It seems
> unfortunate to remove that ability just because there are kernel bugs.  If
> you're implementing thin provisioning and are unmapping storage when discard
> requests come through, wouldn't it be an antifeature that this suddenly stops
> just because something got in the way?  fstrim ought to be able to talk to
> the parts of the compound device that can be trimmed.

Yeah, I'm OK with leaving it as is for now (allowing a mix).  So I'll be
picking your dm-io patch up for 3.20-rc.  But if other similar bugs
manifest then we can revisit disallowing a mix.

As for your question on thin provisioning.  The DM thinp target
advertises support for discards even if the underlying data device
doesn't (unless the user explicitly asked for discards to be disabled on
the thin-pool).  This is accomplished with the target's
'discards_supported' override.  So even if we did make the change to
disallowing a mix: the 'discards_supported' override would still enable
discards.

> Second question: Can a dm device detect that q->limits.max_discard_sectors has
> changed in one of the devices it's sitting on?  Say I have this:
> 
> X -> Y -> SSD1
>  \-> Z -> SSD2
> 
> SSD*, Z, Y, and X all advertise discard.
> 
> Then I change Y to point to a spinny disk:
> 
> X -> Y -> HDD
>  \-> Z -> SSD2
> 
> Even if Y notices that it no longer supports discard, will X figure that out
> too?

No, the DM table reload for Y would alter the discard capability of Y
but it will _not_ bubble up to X.

(would be nice if such limit stacking with refresh but...)
