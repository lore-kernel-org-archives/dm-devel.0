From: malahal@us.ibm.com
Subject: Re: [PATCH] a deadlock bug in the kernel-side device
	mapper code
Date: Fri, 6 Nov 2009 09:27:38 -0800
Message-ID: <20091106172738.GA9738@us.ibm.com>
References: <4AF2D176.4010000@actcom.co.il>
	<20091105142435.GQ13375@agk-dp.fab.redhat.com>
	<Pine.LNX.4.64.0911052157170.18661@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0911052157170.18661@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Mikulas Patocka [mpatocka@redhat.com] wrote:
> This patch introduces a new lock, _name_read_lock, that is placed around
> regions that modify pointer to the hash with dm_set_mdptr or that modify
> hc->name or hc->uuid. When this lock is taken, the caller can safely read
> the name and uuid.
> 
> This lock has much smaller span than _hash_lock and thus lock recursion
> can't happen.

This lock actually guarantees that hash cell, name (and uuid) don't
disappear when someone holds this lock. How about naming it to something
like _hashcell_name_uuid_lock()???

Thanks, Malahal.
