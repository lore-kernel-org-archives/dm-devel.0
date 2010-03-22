From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: dm-cache module
Date: Mon, 22 Mar 2010 16:05:27 +0100
Message-ID: <1269270327.21395.42.camel@o>
References: <4BA5623F.8040502@daevel.fr> <20100321033704.GA6448@redhat.com>
	<15606e421003202156n21de56a6n868f84bf737cce51@mail.gmail.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <15606e421003202156n21de56a6n868f84bf737cce51@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ming Zhao <mingzhao99th@gmail.com>
Cc: dm-devel@redhat.com, "Olivier B." <dm.list@daevel.fr>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Sun, 2010-03-21 at 00:56 -0400, Ming Zhao wrote:
> Hi Mike,
> 
> Thank you very much for your advice!
> 
> I can revise dm-cache code and resubmit it as you suggested. I would
> also love to know Heinz's progress on his implementation and work with
> him if there anything I could contribute.

Hi all,

this is a list of the functions of my dm-hstore
device-mapper target implementation:

o caches reads and writes keeping persistent state metadata.
o writes back in order to enhance streaming performance
  on fragmented access pattern.
o can run on top of readonly original device
o if so, writes back any dirty areas when set readwrite
  (useful for tests)
o readonly <-> readwrite access changes supported via message interface
o initializes metadata for extents in cache in the background
  in order to fasten cache construction
o supports cache resizing via message interface or constructor
o keeps metadata persistent by default
o stores CRCs with metadata for integrity checks
o stores versions with metadata to support future metadata migration

Test features only:
o transient cache
o cache write through


Provides very good performance on SSD cache backing stores.

Has been shelved for a while because of other priorities so I need to
rebase it to the actual kernel.

Regards,
Heinz

> 
> Best,
> - Ming
> 
> 
> 
> On Sat, Mar 20, 2010 at 11:37 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> > On Sat, Mar 20 2010 at  8:03pm -0400,
> > Olivier B. <dm.list@daevel.fr> wrote:
> >
> >> Hi,
> >>
> >> I'm looking at the dm-cache module from Ming Zhao (
> >> http://users.cis.fiu.edu/~zhaom/dmcache/index.html ), and would like
> >> to know if there is a problem to include it upstream.
> >>
> >> It looks stable for a while, and some people seem to use it in production.
> >
> > Such a DM target would be quite useful to have upstream given how
> > prevalent SSDs have become.
> >
> > Other work has been a priority but a caching DM target is definitely on
> > the TODO.  If others can help take steps to make a robust caching DM
> > target a reality then we should be able to get an implementation
> > upstream sooner rather than later.
> >
> > Just curious: where have you gotten this insight about dm-cache being
> > stable and used in production?  That should help dm-cache's cause if it
> > is submitted for review.
> >
> > Seems Ming posted dm-cache to dm-devel (as a large monolithic patch) on
> > 8/24/07.
> >
> > dm-cache would need to be rebased to the latest upstream kernel.org
> > kernel (e.g. Linux >= 2.6.34-rc1).
> >
> > Ideally dm-cache would be resubmitted to dm-devel incrementally such
> > that basic infrastructure is introduced in early patches and more
> > advanced capabilities (e.g. writeback) follow in later patches.  Each
> > patch should have a corresponding patch header the documents what the
> > patch provides.
> >
> > Writeback support is arguably the most useful aspect of a caching DM
> > target so emphasis must be placed on its review/implementation.  Using
> > SSD as a persistent writeback cache should afford us much more fault
> > tolerance in the face of system crashes during writeback to the slower
> > media.
> >
> > I know Heinz has taken steps to implement a caching DM target.  So
> > reconciling dm-cache's design and implementation with what Heinz has
> > would be a worthwhile component of the dm-cache review (assuming Heinz's
> > implementation is also posted for review).
> >
> > Mike
> >
