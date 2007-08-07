From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: LVM on dmraid breakage
Date: Tue, 7 Aug 2007 21:52:29 +0100
Message-ID: <20070807205229.GY2064@agk.fab.redhat.com>
References: <46B0EAEF.6090305@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46B0EAEF.6090305@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, "ATARAID (eg, Promise Fasttrak,  Highpoint 370) related discussions" <ataraid-list@redhat.com>
List-Id: dm-devel.ids

On Wed, Aug 01, 2007 at 04:19:59PM -0400, Phillip Susi wrote:
> I am investigating a bug report involving the combination of lvm and 
> dmraid, and it seems to me that the problem is that lvm is detecting the 
> underlying partition on the primary disk and accessing it directly 
> rather than going through the raid device made by dmraid.  I think that 
> the problem is there is no facility for dmraid to "claim" the physical 
> disk so that lvm does not look at it, and also to have lvm scan the raid 
> device for physical volumes.

LVM tries hard to 'do the right thing' in cases like this.  If it's
getting it wrong in some particular case, we need to fix it.  I presume
it gives you a warning message about the duplicate UUID?

If this can be reproduced using the latest upstream source code release,
please supply relevant details (lvm.conf, -vvvv traces & dmsetup output)
- you can run 'lvm_dump.sh -a' (in the scripts dir) to capture this.
 
Alasdair
-- 
agk@redhat.com
