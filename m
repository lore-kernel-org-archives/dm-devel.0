From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 1/2] dm-kcopyd: introduce per-module throttle
 structure
Date: Fri, 10 Jun 2011 14:48:00 +0100
Message-ID: <20110610134759.GA10908@ubuntu>
References: <20110601095106.GA3718@ubuntu>
	<Pine.LNX.4.64.1106021536240.31532@hs20-bc2-1.build.redhat.com>
	<20110603110111.GA4969@ubuntu>
	<Pine.LNX.4.64.1106071321300.8279@hs20-bc2-1.build.redhat.com>
	<20110609094746.GA3152@ubuntu>
	<Pine.LNX.4.64.1106091136510.7642@hs20-bc2-1.build.redhat.com>
	<20110610084424.GA3672@ubuntu>
	<20110610092834.GB22211@barkeeper1-xen.linbit>
	<20110610101446.GB10144@ubuntu>
	<Pine.LNX.4.64.1106100937430.32120@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106100937430.32120@hs20-bc2-1.build.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jun 10, 2011 at 09:41:50AM -0400, Mikulas Patocka wrote:
> This works if the data is directly on the partition, but it won't work on 
> the device mapper (if MD is on the device mapper, it won't work too).
> 
> The device mapper has no function to tell where the bio is finally 
> remapped, so you can't read disk statistics for that particular disk.

ok, thx
