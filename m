From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Re: New kernel shared snapshots
Date: Tue, 25 Aug 2009 22:02:36 -0400
Message-ID: <20090826020236.GA5681@infradead.org>
References: <Pine.LNX.4.64.0907270657080.527@hs20-bc2-1.build.redhat.com>
	<805301CC-A5EA-4905-9867-0B4762B63D8E@redhat.com>
	<Pine.LNX.4.64.0908251026430.19589@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908251026430.19589@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Tue, Aug 25, 2009 at 10:43:33AM -0400, Mikulas Patocka wrote:
> 
> I mean, if I have function
> static struct some_structure *some_function(int a, int b, int c,
>                                             int d, long long e,
>                                             struct blablabla *p)

Don't align additional paramter lines to after the opening brace,
but always two tabs from column zero, e.g.

static struct some_structure *some_function(int a, int b, int c,
		int d, long long e, struct blablabla *p)

also much easier to edit, especially if the function name and/or return
type changes.

And yes, except maye for printks absolutely stick to the 80 column
limit, it's an absolute pain to read otherwise.
