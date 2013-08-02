From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: dm-cache with zero hit rate
Date: Fri, 2 Aug 2013 15:58:28 +0200
Message-ID: <20130802135828.GA12191@uio.no>
References: <20130731185017.GA13215@uio.no> <20130731202522.GD18513@redhat.com>
	<20130802084910.GA21756@uio.no> <20130802132344.GA20629@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130802132344.GA20629@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Fri, Aug 02, 2013 at 09:23:44AM -0400, Mike Snitzer wrote:
> Yes, it is surprising.  Curious to know if the promotions aren't
> happening due to the IO scheduler somehow merging all your random small
> IO.  We don't yet have a descrete counter to show the number of
> migrations that were skipped due to sequential_threshold but that is
> something we can add.
> 
> But you can effectively disable the sequential_threshold by setting it
> really high, e.g.:
> 
> dmsetup message cache 0 sequential_threshold 16384

I tried this, and it still doesn't appear to promote anything at all:

cache: 0 23440891904 cache 913/8192 0 7021239 0 2049048 0 0 0 0 0 2 migration_threshold 2048 4 random_threshold 8 sequential_threshold 16384

It's only been running for a few minutes, though.

FWIW, earlier I ran it on only one single partition, and then it worked.
So it's not like my kernel is completely broken, at least.

> Please write a file that is smaller than your specified
> sequential_threshold, and then read it numerous times via direct IO,
> e.g.:
> 
> dd if=<your file> of=/dev/null iflag=direct bs=16K

I did, with a 16 kB file (that should certainly be small enough, right?),
executing the dd command 10000 times. Still nothing cached.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
