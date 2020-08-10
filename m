From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 08/35] libmultipath: create bitfield
	abstraction
Date: Mon, 10 Aug 2020 20:59:15 +0200
Message-ID: <7f5040a66421b9d63578079e0c31fb9d5b1d4155.camel@suse.com>
References: <20200709101620.6786-1-mwilck@suse.com>
	<20200709101620.6786-9-mwilck@suse.com>
	<20200716211708.GM11089@octiron.msp.redhat.com>
	<2ae4b38b8f07eb1ac9be31099b5be091fa6e9617.camel@suse.com>
	<bb9b9031513d4e806f0bb2f700a822ed25364e36.camel@suse.com>
	<20200804162635.GJ19233@octiron.msp.redhat.com>
	<8c69def7c61863e8b36502ebd08f5188734f7fa5.camel@suse.com>
	<20200810180525.GL19233@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200810180525.GL19233@octiron.msp.redhat.com>
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

Hi Ben,

On Mon, 2020-08-10 at 13:05 -0500, Benjamin Marzinski wrote:
> On Tue, Aug 04, 2020 at 09:35:08PM +0200, Martin Wilck wrote:
> > On Tue, 2020-08-04 at 11:26 -0500, Benjamin Marzinski wrote:
> > > 
> > > I'm also still fuzzy on why we want to support zero length
> > > bitfields.
> > > Since they can't be grown like vectors can, it seem like
> > > requesting a
> > > zero length bitfield will always be a sign of a coding error. We
> > > would get a more useful error by having the failure happen closer
> > > to
> > > the error in the code.  Or is there actually a use for a zero
> > > length
> > > bitfield that can't be grown?
> > 
> > The only "use" would be to be able to work with bitmaps in
> > situations
> > where zero elements are possible, without the need to catch another
> > exception. 0-element bitfields are technically possible although
> > logically they make no sense. That's robust design for a library
> > function, IMO. I don't see why it'd be "better" to return NULL
> > instead.
> > If we are after errors in callers, we might want to print an error
> > message and still not return NULL.
> 
> Fine. It's a pretty trivial thing either way.

It took me a while, but ...

The current typical usage e.g. in group_by_match() looks like this:

	bitmap = alloc_bitfield(VECTOR_SIZE(paths));

	if (!bitmap)
		goto out;

	for (i = 0; i < VECTOR_SIZE(paths); i++) {
	        ....

Here, VECTOR_SIZE(paths) == 0 is a valid value that just causes nothing
to happen in the function. The other callers aren't much different. I
think we rather don't want to print an error message in these cases.

Every caller needs to check the return value of alloc_bitfield()
anyway, to guard against OOM. The code above would actually be slightly
optimized by returning NULL from alloc_bitfield() for maxbit == 0, by
returning immediately. Besides, we eliminate an (albeit minimal) risk
of hitting OOM by avoiding one needless memory allocation. 

The fact that all our callers work like this convinces me. I'll change
the return value to NULL like you suggested.

Cheers,
Martin
