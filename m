From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin vs lvm performance
Date: Sun, 22 Jan 2012 20:24:30 +0000
Message-ID: <20120122202429.GA27507@ubuntu>
References: <1326416116.56981.YahooMailNeo@web36404.mail.mud.yahoo.com>
	<20120116124158.GA4426@ubuntu>
	<1326915054.99335.YahooMailNeo@web36407.mail.mud.yahoo.com>
	<20120120170335.GA10518@ubuntu> <20120120173333.GA12920@ubuntu>
	<20120120180721.GB12920@ubuntu>
	<1327093568.21183.YahooMailNeo@web36404.mail.mud.yahoo.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1327093568.21183.YahooMailNeo@web36404.mail.mud.yahoo.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jagan Reddy <gjmsreddy@yahoo.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 20, 2012 at 01:06:08PM -0800, Jagan Reddy wrote:
> One interesting thing I notice is raw ramdisk has 9000+MB/s throughput in my tests and 5440MB/s throughput in your tests.

Yes, and if the ramdisk is unallocated the throughput tests on my machine also give ~9G/s throughput.  Can you please double check that it's allocated.  eg, are you running all the tests on the same ram disk?  If you run the thin test first and then the raw test does the raw performance change?

> I remember you mentioning that you are running tests in a VM with 4G
> memory, while I run the rests on a standalone server with 16
> quad-core processors and 12G or ram (out of that 12G, I carve out
> 4G ramdisk). Attached are the cpu and memory information. Could
> that be causing an issue?

Well memory performance will have an effect.  But I'd expect your
number to be consistent with mine.

- Joe
