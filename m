From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: dm targets with spaces in the name
Date: Fri, 5 Dec 2008 01:59:38 +0000
Message-ID: <20081205015938.GQ26097@agk.fab.redhat.com>
References: <4936BBC6.7000800@cfl.rr.com> <1228405956.23557.74.camel@o>
	<49383A77.80903@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49383A77.80903@cfl.rr.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

I can't guarantee that names with spaces in them have had much testing
as LVM doesn't permit them.  But device-mapper itself and dmsetup
are supposed to support them.

On Thu, Dec 04, 2008 at 03:15:51PM -0500, Phillip Susi wrote:
> Not sure what you mean there, but I actually took a look at the kernel 
> code, and it was failing to parse the correct number of arguments, but 
> it looks like dm_split_args() DOES understand backslash escaping.  When 
> I backslash escape the spaces in the name, it appears to parse the 
> correct number of arguments, yet linear_ctr() still fails with "Device 
> lookup failure".
 
Tools really should not be passing path names into constructors - use the
major:minor format instead as the in-kernel code paths are much more
predictable, there are fewer opportunities for races and so it offers
better control to the userspace code.

Alasdair
-- 
agk@redhat.com
