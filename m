From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] handle failures in __lock_fs
Date: Wed, 9 Mar 2005 18:30:38 +0000
Message-ID: <20050309183038.GK19392@agk.surrey.redhat.com>
References: <20050210214511.GA15204@lst.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20050210214511.GA15204@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Feb 10, 2005 at 10:45:11PM +0100, Christoph Hellwig wrote:
> To handle that in DM __lock_fs need to properly unwind and it's caller
> must not ignore the return value.

OK, I've looked at this properly now.
 
> Question: how does dm_table_presuspend_targets need to be undone?

Non-trivially as the code currently stands:-(

But as far as I can see, it doesn't currently matter in what order 
dm_table_presuspend_targets and __lock_fs are called, so 
the easy way out is to call __lock_fs first.

I'll include this version of your patch in the next -dm patchset.
 
Alasdair
-- 
agk@redhat.com
