From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] shared snapshots
Date: Wed, 23 Sep 2009 21:11:22 +0900
Message-ID: <20090923211002B.fujita.tomonori@lab.ntt.co.jp>
References: <Pine.LNX.4.64.0909072313050.26479@hs20-bc2-1.build.redhat.com>
	<20090908133514.GA8054@infradead.org>
	<Pine.LNX.4.64.0909081055570.24837@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0909081055570.24837@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: hch@infradead.org, agk@redhat.com
List-Id: dm-devel.ids

On Tue, 8 Sep 2009 11:10:41 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 8 Sep 2009, Christoph Hellwig wrote:
> 
> > On Mon, Sep 07, 2009 at 11:15:18PM -0400, Mikulas Patocka wrote:
> > > [ the previous message was eaten by mailing-list server, probably because 
> > > it was too long, so I am reposting it without the patch. The patch is at 
> > > the URL below. ]
> > > 
> > > Hi
> > > 
> > > This is patch for shared snapshots to be included in the next merge 
> > > window. The patch only adds new modules dm_multisnapshot and 
> > > dm_store_mikulas, it doesn't modify any existing code.
> > 
> > Not that I have anything against people advertising their names, but
> > wouldn't a descriptive module name telling what this store is useful be
> > better?
> 
> Well, I doubt it would be useful if someone renamed for example "xfs.ko" 
> to "a_btree_based_journaled_filesystem.ko" --- and it would be less 
> descriptive too because there are several other btree-based journaled 
> filesystems.
> 
> Currently, there are two exception stores for these shared snapshots, they 
> both use btrees and they have different format which has different pros 
> and cons --- so I named them according to their designers, "mikulas" and 
> "fujita-daniel". With what other names they should be differentiated?

Is anyone plan to push the zumastor-based implementation into
mainline? I'm not because seems that you push your implementation; I
don't think that potential user base is large enough for maintaining
two dm snapshot implementations though there are pros and cons about
two implementations.

Anyway, please don't use my name for zumastor code. I don't do much
for that code (and I don't like to leave my name in such way).
