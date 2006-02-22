From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/3] sysfs representation of stacked devices
	(dm) (rev.2)
Date: Wed, 22 Feb 2006 18:13:05 +0000
Message-ID: <20060222181305.GD31641@agk.surrey.redhat.com>
References: <43FC8C00.5020600@ce.jp.nec.com> <43FC8D92.6010006@ce.jp.nec.com>
	<20060222163438.GC31641@agk.surrey.redhat.com>
	<43FC9BD4.1010901@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43FC9BD4.1010901@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Lars Marowsky-Bree <lmb@suse.de>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 22, 2006 at 12:13:56PM -0500, Jun'ichi Nomura wrote:
> Alasdair G Kergon wrote:
> > This patch needs splitting up so that independent changes can be
> > considered separately.
> > c.f. The proposal from Mike Anderson (repeated below) which I prefer
> > because it makes it clear that a table always belongs to exactly one md.
 
> I like his proposed patch.
> The interface is useful for my purpose too and moving table
> creation inside _hash_lock means I don't need dm_get() neither.

The global _hash_lock should not be held (thereby locking out most dm ioctl 
operations on any device) while the slow populate_table() runs.

I'm trying out a variant of the patch that drops and reacquires that lock.
 
Alasdair
-- 
agk@redhat.com
