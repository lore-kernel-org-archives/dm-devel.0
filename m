From: Jason Warr <jason@warr.net>
Subject: Re: [dm-devel] Announcement: STEC EnhanceIO SSD caching software
 for Linux kernel
Date: Fri, 18 Jan 2013 09:56:19 -0600
Message-ID: <50F970A3.4000403@warr.net>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D6F3C@MYMBX.MY.STEC-INC.AD> <CAMM=eLdgD8GKeK48SU2rfC49u3H4WRf9-xFxM4ymVPbKkx+mCw@mail.gmail.com> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D70CE@MYMBX.MY.STEC-INC.AD> <20130116104546.GA3869@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D720A@MYMBX.MY.STEC-INC.AD> <20130117132620.GA2438@raspberrypi> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D7248@MYMBX.MY.STEC-INC.AD> <50F844A3.9020300@warr.net> <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B07CE4D72F1@MYMBX.MY.STEC-INC.AD>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Kale <akale@stec-inc.com>
Cc: "thornber@redhat.com" <thornber@redhat.com>, device-mapper development <dm-devel@redhat.com>, "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
List-Id: dm-devel.ids


On 01/18/2013 03:08 AM, Amit Kale wrote:
>> > Can you explain what you mean by that in a little more detail?
> Let's say latency of a block device is 10ms for 4kB requests. With single threaded IO, the throughput will be 4kB/10ms = 400kB/s. If the device is capable of more throughput, a multithreaded IO will generate more throughput. So with 2 threads the throughput will be roughly 800kB/s. We can keep increasing the number of threads resulting in an approximately linear throughput. It'll saturate at the maximum capacity the device has. So it could saturate at perhaps at 8MB/s. Increasing the number of threads beyond this will not increase throughput.
>
> This is a simplistic computation. Throughput, latency and number of threads are related in a more complex relationship. Latency is still important, but throughput is more important.
>
> The way all this matters for SSD caching is, caching will typically show a higher latency compared to the base SSD, even for a 100% hit ratio. It may be possible to reach the maximum throughput achievable with the base SSD using a high number of threads. Let's say an SSD shows 450MB/s with 4 threads. A cache may show 440MB/s with 8 threads.
>
> A practical difficulty in measuring latency is that the latency seen by an application is a sum of the device latency plus the time spent in request queue (and caching layer, when present). Increasing number of threads shows latency increase, although it's only because the requests stay in request queue for a longer duration. Latency measurement in a multithreaded environment is very challenging. Measurement of throughput is fairly straightforward.
>
>> > 
>> > As an enterprise level user I see both as important overall.  However,
>> > the biggest driving factor in wanting a cache device in front of any
>> > sort of target in my use cases is to hide latency as the number of
>> > threads reading and writing to the backing device go up.  So for me the
>> > cache is basically a tier stage where your ability to keep dirty blocks
>> > on it is determined by the specific use case.
> SSD caching will help in this case since SSD's latency remains almost constant regardless of location of data. HDD latency for sequential and random IO could vary by a factor of 5 or even much more.
>
> Throughput with caching could even be 100 times the HDD throughput when using multiple threaded non-sequential IO.
> -Amit

Thank you for the explanation.  In context your reasoning makes more
sense to me.

If I am understanding you correctly when you refer to throughput your
speaking more in terms of IOPS than what most people would think of as
referencing only bit rate.

I would expect a small increase in minimum and average latency when
adding in another layer that the blocks have to traverse.  If my minimum
and average increase by 20% on most of my workloads, that is very
acceptable as long as there is a decrease in 95th and 99th percentile
maximums.  I would hope that absolute maximum would decrease as well but
that is going to be much harder to achieve.

If I can help test and benchmark all three of these solutions please
ask.  I have allot of hardware resources available to me and perhaps I
can add value from an outsiders perspective.

Jason
