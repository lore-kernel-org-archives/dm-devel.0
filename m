From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 08/35] libmultipath: create bitfield
	abstraction
Date: Tue, 04 Aug 2020 17:18:18 +0200
Message-ID: <bb9b9031513d4e806f0bb2f700a822ed25364e36.camel@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
	<20200709101620.6786-9-mwilck@suse.com>
	<20200716211708.GM11089@octiron.msp.redhat.com>
	<2ae4b38b8f07eb1ac9be31099b5be091fa6e9617.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2ae4b38b8f07eb1ac9be31099b5be091fa6e9617.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, 2020-08-04 at 17:04 +0200, Martin Wilck wrote:
> On Thu, 2020-07-16 at 16:17 -0500, Benjamin Marzinski wrote:
> > On Thu, Jul 09, 2020 at 12:15:53PM +0200, mwilck@suse.com wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > > 
> > > In e32d521d ("libmultipath: coalesce_paths: fix size mismatch
> > > handling"),
> > > we introduced simple bitmap handling functions. We can do better.
> > > This
> > > patch introduces a bitfield type with overflow detection and a
> > > find_first_set() method.
> > > 
> > > Use this in coalesce_paths(), and adapt the unit tests. Also, add
> > > unit tests for "odd" bitfield sizes; so far we tested only
> > > multiples
> > > of 64.
> > > 
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > >  libmultipath/configure.c |   9 +-
> > >  libmultipath/util.c      |  35 ++++++
> > >  libmultipath/util.h      |  57 ++++++++-
> > >  tests/util.c             | 263
> > > +++++++++++++++++++++++++++++++++++----
> > >  4 files changed, 327 insertions(+), 37 deletions(-)
> > > 
> > > ...
> > > diff --git a/libmultipath/util.c b/libmultipath/util.c
> > > index 3c43f28..46cacd4 100644
> > > --- a/libmultipath/util.c
> > > +++ b/libmultipath/util.c
> > > @@ -404,3 +404,38 @@ void close_fd(void *arg)
> > >  {
> > >  	close((long)arg);
> > >  }
> > > +
> > > +struct bitfield *alloc_bitfield(unsigned int maxbit)
> > > +{
> > > +	unsigned int n;
> > > +	struct bitfield *bf;
> > > +
> > > +	n = maxbit > 0 ? (maxbit - 1) / bits_per_slot + 1 : 0;
> > 
> > What's the point in accepting 0? That's an empty bitmap.
> > 
> Thanks for spotting these, I will fix them.

Thinking about it once more, I believe that accepting 0 as the bitfield
length is actually the right thing. A bitfield of length 0 makes not
much less sense than one of length 1. The code makes sure that the bit
operations on the 0-length bitfield behave correctly (see
test_bitmask_len_0()). Thus callers can use bitfields without bothering
for extra NULL checks. That was the intention. Like we support 0-length 
vectors.

Regards,
Martin
