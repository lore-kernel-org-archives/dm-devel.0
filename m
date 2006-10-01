From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Recommendations for cascaded snapshots
Date: Sun, 1 Oct 2006 22:09:21 +0100
Message-ID: <20061001210921.GC17654@agk.surrey.redhat.com>
References: <D47F6AD4-A487-41B7-8576-D480D50E9F23@mac.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <D47F6AD4-A487-41B7-8576-D480D50E9F23@mac.com>
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

On Sun, Oct 01, 2006 at 03:12:01PM -0400, Kyle Moffett wrote:
> Another quickie question:  How can I measure the current %use of a  
> given snapshot device?  

lvs -o snap_percent vgname/lvname
(see man page for formatting options to control output units & suppress
headings etc.)

> My first "solution" was to use stacked snapshots such that the  

See the list archives for the thread last week.
I'll review the concept & initial code later this week.
[see LVM2/lib/report/columns.h in the source tree for the definitive 
list of fields; we should probably fix the tools to display the
list that got compiled in.]

> First of all, it doesn't seem  
> possible to merge two snapshots together

Mark has code to do this for read-only origins (originally implemented in
userspace).

> but I couldn't determine how stable it was or whether  
> or not it applied to recent kernels.

I'm part-way through integrating it.
Once the snapshot concurrent read/write bug fix is finally sorted out, it
shouldn't take long.
 
Alasdair
-- 
agk@redhat.com
