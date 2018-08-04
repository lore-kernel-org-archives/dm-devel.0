From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: LVM snapshot broke between 4.14 and 4.16
Date: Sat, 4 Aug 2018 11:19:45 -0400
Message-ID: <20180804151944.GA9417@redhat.com>
References: <CA+55aFy2DR9fxHhmGq+azSjX9D71YtLsuFKmoEuYW3uTAUYtJg@mail.gmail.com>
 <d76415de-2056-c7d6-cc88-b896deaa8ead@torlan.ru>
 <1ec0a220-d5b0-1c27-e63b-c4d3f4ce9d77@torlan.ru>
 <CA+55aFyPVQ5-gA93irsaxPC9BNQxnGWrDDHPMUYai2kxKiaKWQ@mail.gmail.com>
 <b2bbd8ec-ac5b-fa8a-d3f7-8615d87f73c3@redhat.com>
 <CA+55aFwWZX=CXmWDTkDGb36kf12XmTehmQjbiMPCqCRG2hi9kw@mail.gmail.com>
 <20180803185431.GB3258@redhat.com>
 <CA+55aFwDEY7B6OMh5xL2wc8BRj1KkzBHggNowAjbsWfma6H5Zg@mail.gmail.com>
 <20180803193037.GA4581@redhat.com>
 <20180804052033.GA4461@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180804052033.GA4461@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, wgh@torlan.ru
List-Id: dm-devel.ids

On Sat, Aug 04 2018 at  1:20am -0400,
Theodore Y. Ts'o <tytso@mit.edu> wrote:

> On Fri, Aug 03, 2018 at 03:30:37PM -0400, Mike Snitzer wrote:
> > 
> > I was trying to give context for the "best to update lvm2 anyway"
> > disclaimer that was used.  Yeah, it was specious.
> 
> Well, it seemed to indicate a certain attitude that both Linus and I
> are concerned about.  I tried to use more of a "pursuading" style to
> impress why that attitude was not ideal/correct.  Linus used a much
> more assertive style (e.g., "Hell, no!").

[I debated just ignoring this portion of your reply but it needs to be
dealt with directly]

I prefer how Linus handled it (at least he was timely with his
follow-ups).  Your initial reply where you joined a fragment of my
initial reply with Zdenek's (we sent simultaneously, each half way
around the world) served to merge Zdenek and myself into one fictional
straw-man you both could attack.  If you have something to say to _me_
address me directly; don't put words in my mouth because you thought I
had a complete mind-meld with someone else.

And please don't act like this wasn't already beaten to death yesterday;
which left me (as DM maintainer) initially _unwarrantedly_ compromised.
There was a block regression that I wasn't aware of but someone on my
broader team (Zdenek) papered over it in userspace rather than report it
as a regression.

I did brush off the seriousness of side-effects on readonly dm-snapshot
("Because dm-snapshot").  But that doesn't speak to some systemic
"problem" you seem to be concerned about.

> > And yeah, that isn't a good excuse to ignore it but: dm-snapshot is a
> > steaming pile as compared to dm thin-provisioning...
> 
> On a side note, this is the first that I've heard the assertion that
> dm-thin was better than dm-snapshot.

You don't follow DM much, that's fine.  But thinp is considerably more
powerful for modern use-cases.

> My impression was that dm-snapshot was a proven code base, that only
> did one thing and (as far as I could tell) did it well.  In contrast,
> dm-thin is much newer code, **far** more complex, with functionality
> and corner cases approaching that of a file system ---

dm-snapshot's scaling is _awful_.  This is due to the N-way copy-out
penalty associated with N snapshots.  So lots of snapshots perform very
very slowly.  Even one snapshot is slow compared to dm-thinp.

dm-thin (2011) certainly is newer than dm-snapshot (well before 2005),
and yes dm-thin is complex, but dm-snapshot's code isn't exactly
"simple".  The on-disk layout is but that simplicity contributes to why
it doesn't scale at all.

DM thin is a modern approach to snapshots grounded in the same
btree-based concepts and design used by btrfs.  Given dm-thinp's
requirements and how it has been deployed and pushed _hard_ it really is
holding up amazingly well.

> and just to be even more exciting, it [dm-thin] doesn't have an
> fsck/repair tool to deal with corrupted metadata.

That's one definition for "exciting" on your Friday night ... ;)

The documentation was outdated, see this thread:
https://www.redhat.com/archives/dm-devel/2018-July/msg00200.html

Where I shared that this Documentation update was staged for 4.19:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.19&id=6c7413c0f5ab61d2339cf516d25bb44d71f4bad4

That said, thin_repair has shown itself to be hit-or-miss.  There are
certain corruptions that it doesn't cope with well (leaving the metadata
"repaired" but the result is an empty thin-pool).  Those cases are more
rare but still occur.

So repairing thinp corruption can require escalations through
"enterprise support" (which results in fixes to thin_repair, etc).

> In your opinion, is it because you disagree with the assumption that
> dm-thin is scary?  Or is the argument that dm-snapshot is even
> scarier?

Apples and oranges.  DM thinp is complex but necessarily so.
dm-snapshot is still complex yet only covers legacy and narrow (read:
now useless) use-cases.

In the same thread I referenced above, see how Drew Hastings is looking
to use DM thinp to host VM guest storage, which implies a scaling
dm-snapshot has _zero_ hope of providing:
https://www.redhat.com/archives/dm-devel/2018-August/msg00088.html

> P.S.  It could be that my impression is wrong/out-dated, but the
> kernel documentation still says that userspace tools for checking and
> repairing the metadata are "under development".  As a file system
> developer, the reaction this inspires is best summed up as:
> 
>      https://imgflip.com/memetemplate/50971393/Scared-Face

Already addressed this.
