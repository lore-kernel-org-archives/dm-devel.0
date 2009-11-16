From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/2] dm-mpath: Add element for suspended state.
Date: Mon, 16 Nov 2009 13:54:30 +0000
Message-ID: <20091116135430.GB11886@agk-dp.fab.redhat.com>
References: <20091116073819.4070.40173.stgit@localhost.localdomain>
	<20091116073829.4070.45194.stgit@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091116073829.4070.45194.stgit@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Nov 15, 2009 at 11:38:29PM -0800, Mike Anderson wrote:
> Add element to multipath structure for indication of suspended state.
 
Is there a way to avoid this?
It seems redundant for a target to need to track whether or not
it is suspended.  Core dm should be capable of that.

dm_suspend has:
        dm_table_postsuspend_targets(map);

        set_bit(DMF_SUSPENDED, &md->flags);

Can we reorder those two?

What about dm_resume?
        clear_bit(DMF_SUSPENDED, &md->flags);
Can that move a little higher up the function?
- preresume, clear DMF_SUSPENDED, resume perhaps?

Alasdair
