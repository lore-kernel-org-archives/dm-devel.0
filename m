From: Joe Thornber <thornber@redhat.com>
Subject: Re: New dm-bufio with shrinker API
Date: Mon, 5 Sep 2011 15:49:14 +0100
Message-ID: <20110905144913.GB22386@ubuntu>
References: <Pine.LNX.4.64.1109021732490.13426@hs20-bc2-1.build.redhat.com>
	<20110905090428.GA3826@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110905090428.GA3826@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

On Mon, Sep 05, 2011 at 10:04:29AM +0100, Joe Thornber wrote:
> On Fri, Sep 02, 2011 at 05:34:09PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > I created new dm-bufio that uses shrinker API and placed it here:
> > http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/
> 
> Thanks Mikulas, I'll merge over the next day or two.

Mikulas,

It's merged and pushed to my github repo.

I changed the test suite to reset the peak_allocated parameter before
each test and record it at the end of each test.  It's very hard to
say what is right and wrong when talking about cache sizes, since you
always have to qualify anything by saying 'for this particular load'.
However, I think bufio could be more aggressive about recycling cache
entries.  With the old block manager the test suite ran nicely with
less than 256k, from memory I think I started seeing slow down around
128k.  With bufio I'm seeing consistently larger cache sizes for the
same performance.

For instance the test_overwriting_various_thin_devices scenario from
here
(https://github.com/jthornber/thinp-test-suite/blob/master/basic_tests.rb)
has a peak use of ~1100k, if I change from using dt with random io
pattern to plain old dd then the usage drops to ~900k.  Setting the
max_age parameter to 1 second had very little effect.

With my bm I would trigger a flush if there were fewer than a 1/4 of
the blocks free, and at that point would try and flush half the blocks
(I think; would have to check exact numbers).  Presumably you're doing
something very similar, except with different numbers.  Do you think
we could publish these params to allow some experimentation please?

The allocated_* parameter files always seem to contain 0.  Even when
cache_size is non-zero.

I don't understand the correspondence between 'cache_size' and
'peak_allocated'.  I just ran a test and got these numbers:

cache_size:     7475200
peak_allocated: 974848

Is the cache_size correct?  7M seems an awful lot.

Can we really not avoid using dm-io to submit the ios?  I was suprised
to see that in there when scanning the code for parameter names.

- Joe
