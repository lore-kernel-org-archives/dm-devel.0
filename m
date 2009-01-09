From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Patchwork and patch flow
Date: Fri, 9 Jan 2009 01:00:12 +0000
Message-ID: <20090109010012.GF3512@agk.fab.redhat.com>
References: <20090107025952.GH3512@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090107025952.GH3512@agk.fab.redhat.com>
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

Patchwork states for kernel patches.

Awaiting Upstream 
- Will go upstream at the next opportunity, which normally means it is included
  in the linux-next tree.

Under Review
- The patch is included in my 'editing' tree at:
    http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/
  and is awaiting Reviewed-by and Tested-by signoffs.
  It may or may not also be in -mm.

A Delegate assigned - this person is performing (or co-ordinating) the main
review of the patch.

Accepted
- It's not clear how best to use this state.  To start with, we'll try using
it as the final state when a patch arrives in Linus's git.

So New->Under Review->Awaiting Upstream->Accepted.  Then it will get 'archived'.

Alasdair
-- 
agk@redhat.com
