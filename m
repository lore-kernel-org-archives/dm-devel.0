From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache: resize_cache_dev resizing to wrong size ?
Date: Mon, 2 Dec 2013 13:18:26 +0000
Message-ID: <20131202131826.GA30652@debian>
References: <20131130125842.098ad167@x2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131130125842.098ad167@x2>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vincent Pelletier <plr.vincent@gmail.com>
Cc: dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Sat, Nov 30, 2013 at 12:58:42PM +0100, Vincent Pelletier wrote:
> Can someone confirm my reading ?

Confirmed.  What confused me for a bit was why the tests were passing:

https://github.com/jthornber/device-mapper-test-suite/blob/master/lib/dmtest/tests/cache/resize_tests.rb

This bug means the superblock *will* record the new cache size, but
the arrays will not be resized.

The cache_check tool needs to be improved to spot this.  At the moment
it just checks that the btree is full of valid array blocks, and
determines missing ranges for damaged trees.  In our case the trees
are fine, just not big enough.

I also think I need to add more tests that force data migration on a
newly resized cache.

Thanks,

- Joe
