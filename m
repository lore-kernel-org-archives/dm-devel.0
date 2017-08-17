From: "John Stoffel" <john@stoffel.org>
Subject: Re: [PATCH] dm-crypt: limit the number of allocated pages
Date: Thu, 17 Aug 2017 14:50:30 -0400
Message-ID: <22933.58742.629722.398176@quad.stoffel.home>
References: <alpine.LRH.2.02.1708132240130.18210@file01.intranet.prod.int.rdu2.redhat.com>
	<22930.1510.64868.411152@quad.stoffel.home>
	<alpine.LRH.2.02.1708142001390.24994@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1708142001390.24994@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, John Stoffel <john@stoffel.org>, Tom Yan <tom.ty89@gmail.com>, dm-devel@redhat.com, Ondrej Kozina <okozina@redhat.com>, hch@lst.de, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

>>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:

Mikulas> On Mon, 14 Aug 2017, John Stoffel wrote:

>> >>>>> "Mikulas" == Mikulas Patocka <mpatocka@redhat.com> writes:
>> 
Mikulas> dm-crypt consumes excessive amount memory when the user attempts to zero
Mikulas> a dm-crypt device with "blkdiscard -z". The command "blkdiscard -z" calls
Mikulas> the BLKZEROOUT ioctl, it goes to the function __blkdev_issue_zeroout,
Mikulas> __blkdev_issue_zeroout sends large amount of write bios that contain the
Mikulas> zero page as their payload.
>> 
Mikulas> For each incoming page, dm-crypt allocates another page that holds the
Mikulas> encrypted data, so when processing "blkdiscard -z", dm-crypt tries to
Mikulas> allocate the amount of memory that is equal to the size of the device.
Mikulas> This can trigger OOM killer or cause system crash.
>> 
Mikulas> This patch fixes the bug by limiting the amount of memory that dm-crypt
Mikulas> allocates to 2% of total system memory.
>> 
>> Is this limit per-device or system wide?  it's not clear to me if the
>> minimum is just one page, or more so it might be nice to clarify
>> that.

Mikulas> The limit is system-wide. The limit is divided by the number
Mikulas> of active dm-crypt devices and each device receives an equal
Mikulas> share.

Ok, thanks for the clarification.  Can it be expanded dynamically?  I
could see that for large systems, it might not scale well.  

Mikulas> There is a lower bound of BIO_MAX_PAGES * 16. The per-device
Mikulas> limit is never lower than this.

Nice.

>> Also, for large memory systems, that's still alot of pages.  Maybe it
>> should be more exponential in it's clamping as memory sizes go up?  2%
>> of 2T is 4G, which is pretty darn big...

Mikulas> The more we restrict it, the less parallelism is used in dm-crypt, so it 
Mikulas> makes sense to have a big value on machines with many cores.

True... but it's still a concern that it's hardcoded.

Thanks for your replies.
