From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 0/2] dm: alternate solution to reloading
 with failed paths
Date: Thu, 18 Sep 2014 14:50:30 -0400
Message-ID: <20140918185029.GB10829@redhat.com>
References: <1407956023-32372-1-git-send-email-bmarzins@redhat.com>
	<1411056149-16418-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1411056149-16418-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hare@suse.de
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 18 2014 at 12:02pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Hi Hannes,
> 
> Here is v2 of Ben's approach to fixing the inability to reload a
> multipath table that includes failed paths.  I've staged it in
> linux-dm.git's 'for-next' branch.
> 
> But I wanted to send this v2 out to verify this approach works for
> you.  This approach is focused on allowing failed paths to be pushed
> down in a multipath table.
> 
> It does _not_ allow non-existent devices to be listed in an mpath
> table like your patchset did.  So the aggressive dev_loss_tmo case
> isn't covered... but Ben said that case is already handled by
> multipathd getting a change event and pushing the table down without
> the removed SCSI device(s).

It also doesn't allow the initial multipath table load to include failed
devices...
