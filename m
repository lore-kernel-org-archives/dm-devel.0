From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] dm-kcopyd/dm-snap: Don't read the origin on
 full chunk write
Date: Mon, 20 Jun 2011 11:51:37 +0200
Message-ID: <4DFF1829.7050909@redhat.com>
References: <Pine.LNX.4.64.1106170829390.24411@hs20-bc2-1.build.redhat.com>
	<20110620080952.GA3266@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110620080952.GA3266@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Joe Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On 06/20/2011 10:09 AM, Joe Thornber wrote:
> On Fri, Jun 17, 2011 at 08:32:36AM -0400, Mikulas Patocka wrote:
>> This optimizes full chunk writes for snapshots.
>>
>> Note that there is a performance bug in device mapper that it doesn't ever 
>> send bios larger than 4k to snapshots. So this patch optimizes only 4k 
>> chunk sizes. Once the 4k limit will be removed from device mapper, this 
>> patch could optimize any chunk size.
> 
> Nack.  If you don't need to copy, don't send it to kcopyd.

I think that 4k limitation was removed almost from all the DM code
by introducing merge fn concept. Snapshots seems to be the last area...
(IMHO it was just simplification not bug - bio of page size (4k)
is always allowed so you do not need to solve bio split).

So there is another place where this restriction should be removed.

Anyway, I would like to use kcopyd later for crypt (online reencryption)
so any optimisation is welcome.

For the nack - I do not get it.
Joe, please can you explain the reasons?

Milan
