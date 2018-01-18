From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/2] dm: add new loop and ram targets
Date: Thu, 18 Jan 2018 07:06:19 -0500
Message-ID: <20180118120619.GB10787@redhat.com>
References: <cover.1516124587.git.heinzm@redhat.com>
	<20180117212936.GA6756@redhat.com>
	<20180118114231.GG8694@localhost.localdomain>
	<20180118115649.GA10787@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180118115649.GA10787@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 18 2018 at  6:56am -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Jan 18 2018 at  6:42am -0500,
> Bryn M. Reeves <bmr@redhat.com> wrote:
> 
> > On Wed, Jan 17, 2018 at 04:29:36PM -0500, Mike Snitzer wrote:
> > > On Wed, Jan 17 2018 at  2:33pm -0500,
> > > As for dm-loop, doubling the performance of the loopback driver is quite
> > > nice (especially with only 1/7 the number of lines of code as
> > > drives/block/loop.c).
> > 
> > Isn't this going to raise the same objection that akpm had years ago,
> > with the original dm-loop (block mapping) target?
> > 
> > We had an even bigger performance boost with that but it was rejected
> > on the grounds that a second loop back block device implementation was
> > not welcome unless the two could share code.
> 
> Could.  But I wasn't around for that particular spat.  It seems quite
> misplaced to swoop in with an aire of design purity to defeat a DM
> target that shows such clear wins.
> 
> This idea that our poor Linux users will lose their heads because they
> have multiple options is also idiotic.
> 
> But we'll cross that bridge as needed (before burning it down?) ;)

Reflecting on getting spun up about the potential for a fight made me
feel like this guy wanting to use the phone in "Dumb and Dumber":
https://youtu.be/Gue2LvHibpg?t=25

Could easily be in the end someone like akpm or Jens will just
effectively punch me in the face from inside their phone booth ;)
