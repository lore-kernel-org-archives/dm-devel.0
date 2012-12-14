From: thornber@redhat.com
Subject: Re: Another cache target
Date: Fri, 14 Dec 2012 12:11:44 +0000
Message-ID: <20121214121143.GD3022@raspberrypi>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<20121213215715.GA19419@redhat.com>
	<20121214011643.GB9845@blackbox.djwong.org>
	<20121214021918.GA29561@redhat.com>
	<20121214023425.GG9453@blackbox.djwong.org>
	<20121214102443.GB3022@raspberrypi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20121214102443.GB3022@raspberrypi>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

On Fri, Dec 14, 2012 at 10:24:43AM +0000, thornber@redhat.com wrote:
> I'll add some tests to my test suite that use your maxiops program and
> see if I can work out what's going on.

I've played with your maxiops program, and added these tests to the
suite:

  def maxiops(dev, nr_seeks = 10000)
    ProcessControl.run("maxiops -s #{nr_seeks} #{dev} -wb 4096")
  end
  
  def discard_dev(dev)
    dev.discard(0, dev_size(dev))
  end
  
  def test_maxiops_cache_no_discard
    with_standard_cache(:format => true,
                        :data_size => gig(1)) do |cache|
      maxiops(cache, 10000)
    end
  end  
       
  def test_maxiops_cache_with_discard
    size = 512
    
    with_standard_cache(:format => true,
                        :data_size => gig(1),
                        :cache_size => meg(size)) do |cache|
      discard_dev(cache)
      report_time("maxiops with cache size #{size}m", STDERR) do
        maxiops(cache, 10000)
      end
    end
  end
  
  def test_maxiops_linear
    with_standard_linear(:data_size => gig(1)) do |linear|
      maxiops(linear, 10000)
    end
  end



The maxiops program appears to be doing random writes over the device
(at least the way I'm calling it).  So I'm not surprised the mq policy
can't be bothered to cache anything.

Even an agressive write policy wouldn't do much good here, as maxiops
is continuously writing.  Such a strategy needs bursty io, so the
cache has time to clean itself.

Discarding the device before running maxiops, as discussed, does
indeed persuade mq to cache blocks as soon as they're hit (see
test_maxiops_cache_with_discard).

As a sanity check I set up the cache device with various amounts of
SSD allocated and timed a short run of maxiops.  For a small amount of
SSD, performance is similar to that of my spindle, for as much SSD as
spindle, performance is the same as my SSD.

SSD size | Elapsed time (seconds)
128m     | 32
256m     | 23
512m     | 13.5
1024m    | 3.4

Now the bad news is I'm regularly seeing runs that have terrible
performance; not a hang since the io stall oops isn't triggering.  So
there's obviously a race in there somewhere that's getting things into
a bad state.  Will investigate more, it could easily be an issue in the
test suite.

- Joe
