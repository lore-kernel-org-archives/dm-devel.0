From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-io: don't allocate vector larger than
	BIO_MAX_PAGES
Date: Thu, 29 Jan 2009 19:40:16 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0901291929260.32702@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0901212227100.3027@hs20-bc2-1.build.redhat.com>
	<20090130002809.GE1935@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090130002809.GE1935@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 30 Jan 2009, Alasdair G Kergon wrote:

> Pushing to linux-next.
> 
> On Wed, Jan 21, 2009 at 10:32:20PM -0500, Mikulas Patocka wrote:
> > Very likely this was the reason for bug
> > https://bugzilla.redhat.com/show_bug.cgi?id=173153
> 
> So with this and the other fixes there've been, do we still have
> any arch-dependent restrictions on chunk_size?
> 
> Or can a snapshot created on one arch be used successfully on any other
> now?

Now the chunk size is much less restricted.

There used to be bug with chunk_size < page_size, but it was already fixed 
long time ago (Milan checked it on PPC64 in Brno lab). The userspace has 
limit of minimum 4kb chunk size and I think it could be lowered to 1kb 
(although such small chunks have little practical use --- they degrade 
perfromance because every bio is split on chunk boundaries).

And with this fix, an upper bound on chunk size is the amount of memory in 
vmalloc arena divided by 2 (there are two chunks preallocated with 
vmalloc). The minimum vmalloc arena on ix86 is 128MB and the usual vmalloc 
arena size is 512MB.

Mikulas

> Alasdair
> -- 
> agk@redhat.com
> 
