From: malahal@us.ibm.com
Subject: Re: multipath performance
Date: Thu, 24 Jan 2008 17:59:39 -0800
Message-ID: <20080125015938.GB28785@us.ibm.com>
References: <20080123163820.GA1303@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080123163820.GA1303@thumper2>
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
List-Id: dm-devel.ids

Andy [genanr@emsphone.com] wrote:
> I did some basic dd tests to get an idea of the speed of multipath vs
> individual devices, some of the numbers seem not to make sense.
> 
> I ran several test with dd, 4 at a time reading different parts of the
> device.
> 
> multibus - round robin among paths rr_min_io=1, 4 paths
> individual - each dd going to a separate path
> 
> dd with iflag=direct
> 	multibus : 120 MB/s
> 	individual : 115 MB/s
> 
> dd without direct
> 	multibus : 44MB/s (why is this so bad)
> 	individual : 160MB/s (why is this so good)
> 
> Why is multibus without direct the worst, yet individual devices without
> direct is the fastest.  And why doesn't multibus perform about the same as
> going to the individual devices (25% performance hit using multibus)?

I am assuming that you are only reading from the device based on your
iflag. When you do O_DIRECT, you inherently disable read-ahead. Also
note that the read-ahead benefit would be insignificant as you increase
the block size.

without direct I/O, you end up with very big I/O's in individual mode.
Same can't be said in multibus mode as it tries to send small I/O's
(actually bio's) on different paths and it makes the system not to merge
any adjacent requests. Use iostat to see the average I/O size in each
case.

You should be able to get the same behavior even in direct I/O mode
provided you use very block size with dd.
