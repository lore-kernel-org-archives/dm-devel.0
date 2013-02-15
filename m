From: thornber@redhat.com
Subject: Re: dm-thinp BUG at
 drivers/md/persistent-data/dm-btree-remove.c:188
Date: Fri, 15 Feb 2013 10:52:26 +0000
Message-ID: <20130215105226.GA9053@raspberrypi>
References: <alpine.DEB.2.00.1302141757240.50852@ware.dreamhost.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1302141757240.50852@ware.dreamhost.com>
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
List-Id: dm-devel.ids

On Thu, Feb 14, 2013 at 06:07:56PM -0800, Eric Wheeler wrote:
> 
> Hello all,
> 
> I've been experimenting with dm-thinp recently and for the past few
> months and all has been well---until today.

Hi Eric,

Thanks for testing thinp and giving such a good bug report.  This bug
is one I haven't seen before (nothing to do with the race fix that
Mike mentioned).  It's almost certainly in the btree remove code, very
close to where the BUG() triggered.

Discard support is the main user of the btree_remove, so turning off
discard support in the pool should be a good temporary fix.

Could you let me know what sort of work load you were applying to the
ext4 fs to cause this to happen?  If I can reproduce this I should be
able to get a fix to you v. quickly.

- Joe
