From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: do not call dm_sync_table() when creating new
	devices
Date: Wed, 5 Nov 2014 09:15:43 -0500
Message-ID: <20141105141542.GB14285@redhat.com>
References: <1415194550-121498-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1415194550-121498-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 05 2014 at  8:35am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> When creating new devices dm_sync_table() calls
> synchronize_rcu_expedited(), causing _all_ pending
> RCU pointers to be flushed. This causes a latency
> overhead especially noticeable when creating lots
> of devices.
> And all of this is pointless as there are no old
> maps to be disconnected, and hence no stale pointers
> which would need to be cleared up.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks good, I'll get it staged for 3.19 (will need to be rebased on the
linux-dm.git 'dm-for-3.19' branch given the suspend related refactoring
there, but I'll take care of it as needed).
