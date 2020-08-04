From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 08/35] libmultipath: create bitfield
	abstraction
Date: Tue, 04 Aug 2020 21:35:08 +0200
Message-ID: <8c69def7c61863e8b36502ebd08f5188734f7fa5.camel@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
	<20200709101620.6786-9-mwilck@suse.com>
	<20200716211708.GM11089@octiron.msp.redhat.com>
	<2ae4b38b8f07eb1ac9be31099b5be091fa6e9617.camel@suse.com>
	<bb9b9031513d4e806f0bb2f700a822ed25364e36.camel@suse.com>
	<20200804162635.GJ19233@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200804162635.GJ19233@octiron.msp.redhat.com>
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

On Tue, 2020-08-04 at 11:26 -0500, Benjamin Marzinski wrote:
> On Tue, Aug 04, 2020 at 05:18:18PM +0200, Martin Wilck wrote:
> > On Tue, 2020-08-04 at 17:04 +0200, Martin Wilck wrote:
> > > On Thu, 2020-07-16 at 16:17 -0500, Benjamin Marzinski wrote:
> > > > On Thu, Jul 09, 2020 at 12:15:53PM +0200, mwilck@suse.com
> > > > wrote:
> > > > > From: Martin Wilck <mwilck@suse.com>
> > > > > +struct bitfield *alloc_bitfield(unsigned int maxbit)
> > > > > +{
> > > > > +	unsigned int n;
> > > > > +	struct bitfield *bf;
> > > > > +
> > > > > +	n = maxbit > 0 ? (maxbit - 1) / bits_per_slot + 1 : 0;
> > > > 
> > > > What's the point in accepting 0? That's an empty bitmap.
> > > > 
> > > Thanks for spotting these, I will fix them.
> > 
> > Thinking about it once more, I believe that accepting 0 as the
> > bitfield
> > length is actually the right thing. A bitfield of length 0 makes
> > not
> > much less sense than one of length 1. The code makes sure that the
> > bit
> > operations on the 0-length bitfield behave correctly (see
> > test_bitmask_len_0()). Thus callers can use bitfields without
> > bothering
> > for extra NULL checks. That was the intention. Like we support 0-
> > length 
> > vectors.
> 
> But the calloc call itself can return NULL, so deferencing bf (as in
> bf->len = maxbit), can crash.

Of course, I wasn't arguing about that. I'm going to resend with this
fixed.

> I'm also still fuzzy on why we want to support zero length bitfields.
> Since they can't be grown like vectors can, it seem like requesting a
> zero length bitfield will always be a sign of a coding error. We
> would get a more useful error by having the failure happen closer to
> the error in the code.  Or is there actually a use for a zero length
> bitfield that can't be grown?

The only "use" would be to be able to work with bitmaps in situations
where zero elements are possible, without the need to catch another
exception. 0-element bitfields are technically possible although
logically they make no sense. That's robust design for a library
function, IMO. I don't see why it'd be "better" to return NULL instead.
If we are after errors in callers, we might want to print an error
message and still not return NULL.

Martin
