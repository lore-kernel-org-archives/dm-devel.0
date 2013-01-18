From: Amit Kale <akale-FZ1t8LVTR2ZWk0Htik3J/w@public.gmane.org>
Subject: RE: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Date: Fri, 18 Jan 2013 17:08:37 +0800
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD>
 <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD>
 <20130116104546.GA3869@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD>
 <20130117132620.GA2438@raspberrypi>
 <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD>
 <50F844A3.9020300@warr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50F844A3.9020300-/cow75dQlsI@public.gmane.org>
Content-Language: en-US
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Warr <jason-/cow75dQlsI@public.gmane.org>
Cc: "thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <thornber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, device-mapper development <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: dm-devel.ids

> From: Jason Warr [mailto:jason-/cow75dQlsI@public.gmane.org]
> On 01/17/2013 11:53 AM, Amit Kale wrote:
> >>> 9. Performance - Throughput is generally most important. Latency is
> >> >   also one more performance comparison point. Performance under
> >> >   different load classes can be measured.
> >> >
> >> >   I think latency is more important than throughput.  Spindles are
> >> >   pretty good at throughput.  In fact the mq policy tries to spot
> when
> >> >   we're doing large linear ios and stops hit counting; best leave
> this
> >> >   stuff on the spindle.
> > I disagree. Latency is taken care of automatically when the number of
> application threads rises.
> >
> 
> Can you explain what you mean by that in a little more detail?

Let's say latency of a block device is 10ms for 4kB requests. With single threaded IO, the throughput will be 4kB/10ms = 400kB/s. If the device is capable of more throughput, a multithreaded IO will generate more throughput. So with 2 threads the throughput will be roughly 800kB/s. We can keep increasing the number of threads resulting in an approximately linear throughput. It'll saturate at the maximum capacity the device has. So it could saturate at perhaps at 8MB/s. Increasing the number of threads beyond this will not increase throughput.

This is a simplistic computation. Throughput, latency and number of threads are related in a more complex relationship. Latency is still important, but throughput is more important.

The way all this matters for SSD caching is, caching will typically show a higher latency compared to the base SSD, even for a 100% hit ratio. It may be possible to reach the maximum throughput achievable with the base SSD using a high number of threads. Let's say an SSD shows 450MB/s with 4 threads. A cache may show 440MB/s with 8 threads.

A practical difficulty in measuring latency is that the latency seen by an application is a sum of the device latency plus the time spent in request queue (and caching layer, when present). Increasing number of threads shows latency increase, although it's only because the requests stay in request queue for a longer duration. Latency measurement in a multithreaded environment is very challenging. Measurement of throughput is fairly straightforward.

> 
> As an enterprise level user I see both as important overall.  However,
> the biggest driving factor in wanting a cache device in front of any
> sort of target in my use cases is to hide latency as the number of
> threads reading and writing to the backing device go up.  So for me the
> cache is basically a tier stage where your ability to keep dirty blocks
> on it is determined by the specific use case.

SSD caching will help in this case since SSD's latency remains almost constant regardless of location of data. HDD latency for sequential and random IO could vary by a factor of 5 or even much more.

Throughput with caching could even be 100 times the HDD throughput when using multiple threaded non-sequential IO.
-Amit


PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
