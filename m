From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] SCHED: remove proliferation of wait_on_bit action
 functions.
Date: Thu, 1 May 2014 11:31:40 +0200
Message-ID: <20140501093140.GN11096@twins.programming.kicks-ass.net>
References: <20140501123738.3e64b2d2@notabene.brown>
 <20140501074257.GK11096@twins.programming.kicks-ass.net>
 <20140501192605.6b5383f8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140501192605.6b5383f8@notabene.brown>
Sender: owner-linux-mm@kvack.org
To: NeilBrown <neilb@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, dm-devel@redhat.com, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, Steve French <sfrench@samba.org>, Theodore Ts'o <tytso@mit.edu>, Trond Myklebust <trond.myklebust@primarydata.com>, Ingo Molnar <mingo@redhat.com>, Roland McGrath <roland@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

On Thu, May 01, 2014 at 07:26:05PM +1000, NeilBrown wrote:
> On Thu, 1 May 2014 09:42:57 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, May 01, 2014 at 12:37:38PM +1000, NeilBrown wrote:
> > > +static inline int
> > > +wait_on_bit(void *word, int bit, unsigned mode)
> > > +{
> > > +	if (!test_bit(bit, word))
> > > +		return 0;
> > > +	return out_of_line_wait_on_bit(word, bit,
> > > +				       bit_wait,
> > > +				       mode & 65535);
> > > +}
> > 
> > Still puzzled by the 16 bit mask there ;-)
> 
> I clearly remember removing that!
> And I've just done it again.
> I hope it doesn't re-reappear!
> :-)
> NeilBrown

Seems dead now, I'll hold out for a little while so that dhowells can
explain this fscache thing.

Then I'll queue it. Ingo is currently enjoying a long weekend and is
fighting (well I am now) a stability issue in -tip kernels, so it might
be a little while before it actually shows up in the git tree.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
