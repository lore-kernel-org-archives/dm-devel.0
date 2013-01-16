From: thornber@redhat.com
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software for
 Linux kernel
Date: Wed, 16 Jan 2013 16:58:15 +0000
Message-ID: <20130116165814.GA4124@raspberrypi>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130116104546.GA3869@raspberrypi>
Sender: linux-kernel-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On Wed, Jan 16, 2013 at 10:45:47AM +0000, thornber@redhat.com wrote:
> I think the first thing we need to do is make it easy to compare the
> performance of these impls.

I've added EnhanceIO support to my cache tests [1].

I've run it through one of the benchmarks and got some curious results.

The benchmark runs with a 2G origin and a 256m of SSD and does the
following.

	a) format device
	b) clone the linux git tree into it
	c) checkout 5 different tags

So it's only a microbenchmark, but probably a scenario of interest to
developers like us.  It uses a lot of cpu and has a working set size
of around 1G.

Running on SSD (no cache involved, we're just establishing a
baseline), takes ~140 seconds.

Running on spindle (again no cache involved takes 261 seconds.

Running on dm-cache with mq policy takes 241 seconds (I told you it
was a tough scenario).

Running on EnhanceIO in wb mode (I presume this is the fastest?) takes
361 seconds.  Considerably slower than the Spindle alone.

In addition I often run tests with an SSD cache on an SSD origin.
This gives me a good idea of the overhead of the target.  In this
configuration dm-cache takes 161 seconds.  20 seconds of overhead
which I consider a lot and am working to cut down.  EnhanceIO in this
configuration takes 309 seconds, or 169 seconds of overhead.

Obviously different caches are going to perform differently under
different workloads.  But I think people will be upset if adding
expensive SSD to their spindle device slows things down.

Can you describe scenarios where eio performs well please?


- Joe


  [1] https://github.com/jthornber/thinp-test-suite/commit/730448e1f068d23a2ca54aad1fed76a4e8bd6dbb
