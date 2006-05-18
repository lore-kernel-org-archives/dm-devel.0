From: Rod Nayfield <nayfield@redhat.com>
Subject: Re: [Consult-list] dm-multipath has great throughput but
	we'd like more!
Date: Thu, 18 May 2006 13:00:45 -0400
Message-ID: <1147971646.3718.22.camel@localhost.localdomain>
References: <1147935929.27006.57.camel@baggage>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1147935929.27006.57.camel@baggage>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: rgautier@redhat.com
Cc: dm-devel@redhat.com, consult-list@redhat.com
List-Id: dm-devel.ids

On Thu, 2006-05-18 at 08:05 +0100, Bob Gautier wrote:
>  but we're wondering why we are not seeing higher
> throughput per-HBA -- the QL2340 datasheet says it should manage
> 200Mbyte/s and all switches etc. run at 2GBps.

Have you tried different values of rr_min_io in multipath.conf?  I think
the default is 1000.  (the last value of dmsetup table for the device)

-rod 

p.s. you need to purge and recreate the map, just "multipath" will make
some changes but not rr_min_io.  (bz 187534)
