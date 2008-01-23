From: Andy <genanr@emsphone.com>
Subject: multipath performance
Date: Wed, 23 Jan 2008 10:38:20 -0600
Message-ID: <20080123163820.GA1303@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

I did some basic dd tests to get an idea of the speed of multipath vs
individual devices, some of the numbers seem not to make sense.

I ran several test with dd, 4 at a time reading different parts of the
device.

multibus - round robin among paths rr_min_io=1, 4 paths
individual - each dd going to a separate path

dd with iflag=direct
	multibus : 120 MB/s
	individual : 115 MB/s

dd without direct
	multibus : 44MB/s (why is this so bad)
	individual : 160MB/s (why is this so good)

Why is multibus without direct the worst, yet individual devices without
direct is the fastest.  And why doesn't multibus perform about the same as
going to the individual devices (25% performance hit using multibus)?

Multibus is round-robin, how about a mode that sends io out on all paths
simultaneously?

Another thing I noticed during some of my test is that performance for a
single dd will increase in the multibus mode as I up the blocksize parameter
of dd.  

Thanks,

Andy
