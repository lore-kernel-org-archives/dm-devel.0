From: Joe Thornber <thornber@redhat.com>
Subject: Re: new dm-bufio
Date: Tue, 23 Aug 2011 12:30:48 +0100
Message-ID: <20110823113048.GC5442@ubuntu>
References: <Pine.LNX.4.64.1108221600510.26651@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108221600510.26651@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Aug 22, 2011 at 04:05:28PM -0400, Mikulas Patocka wrote:
> I uploaded new dm-bufio patch at 
> http://people.redhat.com/mpatocka/patches/kernel/dm-thinp-bufio/dm-bufio.patch
> 
> It reports the number of allocated bytes in 
> "/sys/module/dm_bufio/parameters/". There is a file "total_allocated" that 
> contains the number of bytes allocated for buffer cache. There are files 
> "allocated_get_free_pages", "allocated_kmalloc", "allocated_vmalloc" that 
> contain a number of allocated bytes with each method.
> 
> BTW. if you store "1" in "cache_size", it switches to a mode where it 
> won't allocate any memory during operation, relying only on preallocated 
> reserves --- useful for testing reservation deadlocks.

Great stuff, will merge straight away.

Are these stats broken down by bufio client?  ie. can we tell which pool/thinps are consuming all the space?

Would it be possible to record a high watermark as well?  This would
be very useful for benchmarking.  eg, we'd run a heavy load, then be
able to get the peak memory usage.  (Resetting this hwm would also be useful).

- Joe
