From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] handle failures in __lock_fs
Date: Sun, 13 Feb 2005 16:39:15 +0000
Message-ID: <20050213163915.GO14093@agk.surrey.redhat.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 10, 2005 at 10:45:11PM +0100, Christoph Hellwig wrote:
> I have a patch pending that allows freeze_bdev to return errors.
 
In what circumstances - what sorts of errors?

(Aiming to remove as much as possible from the dm suspend/resume code.)

> Question: how does dm_table_presuspend_targets need to be undone?

Effectively by switching the operation from 'suspend' to 'resume' at
that point - I'll take a look at this later this week.

Alasdair
-- 
agk@redhat.com

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
