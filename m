From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] [RFC] switch DM tables to readonly
	automatically
Date: Thu, 1 May 2008 12:24:51 +0100
Message-ID: <20080501112451.GT18935@agk.fab.redhat.com>
References: <4811EB85.8090505@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4811EB85.8090505@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Apr 25, 2008 at 04:32:37PM +0200, Hannes Reinecke wrote:
> this patch switches the device-mapper table to read-only
> status automatically if one underlying device returns -EROFS.
 
I'm going to need some persuading here...

An analogy.  If I call open() with O_RDWR and but that can't be done
because the device is read-only - what happens?  Does the open()
silently give me a read-only file descriptor instead?  Or does it
give me -EROFS?

If I request DM_TABLE_LOAD without the DM_READONLY_FLAG, I am asking
for a device I can write to and if that's not possible I expect an
error.  If I'd wanted a read-only device I'd have set the
DM_READONLY_FLAG on my request.

Is the real problem that -EROFS/-ENXIO errors are not propagating back
up through target _ctr functions as perhaps they should?

Alasdair
-- 
agk@redhat.com
