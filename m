From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: New dm-bufio with shrinker API
Date: Mon, 5 Sep 2011 12:01:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109051148450.22564@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1109021732490.13426@hs20-bc2-1.build.redhat.com>
	<20110905090428.GA3826@ubuntu> <20110905144913.GB22386@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110905144913.GB22386@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

> I don't understand the correspondence between 'cache_size' and
> 'peak_allocated'.  I just ran a test and got these numbers:
> 
> cache_size:     7475200
> peak_allocated: 974848
> 
> Is the cache_size correct?  7M seems an awful lot.

"cache_size" is the value that you set as a maximum cache size. The 
default is 2% of memory or 25% of vmalloc area.

"cache_size" doesn't change with benchmark that you run. You can set 
cache size manually by writing the value to the file.

"peak_allocated" is the maximum number of bytes that was actually in use. 
"peak_allocated" grows as more cache is allocated, but it is never shrunk.

> With the old block manager the test suite ran nicely with
> less than 256k, from memory I think I started seeing slow down around
> 128k.  With bufio I'm seeing consistently larger cache sizes for the
> same performance.

So, reduce cache_size to 256k (or whatever value you want to test) and see 
how it performs.

> For instance the test_overwriting_various_thin_devices scenario from
> here
> (https://github.com/jthornber/thinp-test-suite/blob/master/basic_tests.rb)
> has a peak use of ~1100k, if I change from using dt with random io
> pattern to plain old dd then the usage drops to ~900k. Setting the
> max_age parameter to 1 second had very little effect.

Reduce cache_size and try it.

> Can we really not avoid using dm-io to submit the ios?  I was suprised
> to see that in there when scanning the code for parameter names.

If we didn't use dm-io, then we'd have to submit several bios in parallel. 
It is possible to avoid dm-io, but it makes no sense, because we would be 
duplicating dm-io logic in dm-bufio then.

Mikulas

> - Joe
> 
