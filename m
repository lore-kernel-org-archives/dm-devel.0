From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [patch] minor dm.c cleanup
Date: Fri, 18 Apr 2008 16:55:48 +0100
Message-ID: <20080418155548.GR18935@agk.fab.redhat.com>
References: <20080418154045.GI7134@slug>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080418154045.GI7134@slug>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frederik Deweerdt <deweerdt@free.fr>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Apr 18, 2008 at 05:40:45PM +0200, Frederik Deweerdt wrote:
> - Removes the unused md argument from both specific_minor() and next_free_minor()
> - Folds kmalloc + memset(0) into a single kzalloc call in alloc_dev()
 
Added to the batch for 2.6.26, thanks.

Alasdair
-- 
agk@redhat.com
