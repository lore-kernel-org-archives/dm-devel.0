From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache policy mq: promotion very picky?
Date: Wed, 15 May 2013 11:26:41 +0100
Message-ID: <20130515102641.GA11029@debian>
References: <519159B7.3030205@pierre-beck.de> <20130514134452.GA8304@debian>
	<20130514181655.GB8043@blackbox.djwong.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130514181655.GB8043@blackbox.djwong.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On Tue, May 14, 2013 at 11:16:55AM -0700, Darrick J. Wong wrote:
> On Tue, May 14, 2013 at 02:44:53PM +0100, Joe Thornber wrote:
> > On Mon, May 13, 2013 at 11:23:04PM +0200, Pierre Beck wrote:
> > > Maybe I'm misunderstanding how the heuristics work - what makes mq
> > > pick a block for promotion?
> > 
> > Hi Pierre,
> > 
> > The mq policy is indeed very picky.  The first thing I'd suggest is
> > you pick up my latest patches if you haven't already:
> > 
> > http://device-mapper.org/patches/3.10/
> 
> Hm, it looks like all but two of the dmcache patches are in.  The two patches
> to mq aren't (yet) there.

y, unfortunately there's a fixme in there that frightened Alasdair,
and I don't have any free capacity to spend on dm-cache atm.

> > If you start with a discarded device (eg, you've run mkfs).  Then the
> > cache should fill up v. quickly with my latest patches.  Perhaps it
> > would be worth verifying this before you start investigating the
> > effects of sequential io?
> 
> I'm also curious about what happens if, say, you have a discard-enabled
> zerofree that can "discard" just the unallocated blocks.  That probably only
> helps if you can discard pieces big enough to fit one of dmcache's discard
> regions, right?

Yep.  But your fs will be trying to reduce fragmentation of free
space, so hopefully the pieces will be big enough.

- Joe
