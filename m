From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 8/14] barriers
Date: Thu, 26 Mar 2009 11:11:22 +0000
Message-ID: <20090326111122.GP13664@agk.fab.redhat.com>
References: <Pine.LNX.4.64.0902231421180.23293@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902231421180.23293@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Feb 23, 2009 at 02:21:41PM -0500, Mikulas Patocka wrote:
> Move wait queue declaration and unplug to dm_wait_for_completion.
> The patch reorders functions a little bit. It doesn't change any
> functionality. For proper non-deadlock operation, it is required 
> hat add_wait_queue happens before set_current_state(interruptible)
> and before the test for !atomic_read(&md->pending) --- and this
> patch follows that.
 
Can you check md->wait is sufficiently protected and the reordering
in this patch doesn't increase the likelihood of a race with its
contents changing outside a lock?

Alasdair
-- 
agk@redhat.com
