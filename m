From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-kcopyd/dm-snap: Don't read the origin on
 full chunk write
Date: Mon, 20 Jun 2011 09:09:53 +0100
Message-ID: <20110620080952.GA3266@ubuntu>
References: <Pine.LNX.4.64.1106170829390.24411@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106170829390.24411@hs20-bc2-1.build.redhat.com>
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
Cc: "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 17, 2011 at 08:32:36AM -0400, Mikulas Patocka wrote:
> Hi
> 
> This optimizes full chunk writes for snapshots.
> 
> Note that there is a performance bug in device mapper that it doesn't ever 
> send bios larger than 4k to snapshots. So this patch optimizes only 4k 
> chunk sizes. Once the 4k limit will be removed from device mapper, this 
> patch could optimize any chunk size.

Nack.  If you don't need to copy, don't send it to kcopyd.

- Joe
