From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCHv9 0/8] dm-multipath: push back requests
 instead of queueing
Date: Wed, 12 Mar 2014 17:46:14 -0400
Message-ID: <20140312214614.GA1080@redhat.com>
References: <1393598029-67995-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1393598029-67995-1-git-send-email-hare@suse.de>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 28 2014 at  9:33am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> Hi Mike,
> 
> here's version 9 of the patchset which might just be the
> final one. I've included the remaining issue Jun'ichi pointed
> out, and added the respective 'reviewed-by' tags where missing.

I've picked these patches up.  They are now queued for 3.15 and in
linux-dm.git's 'for-next' branch.

I'll likely rebase linux-dm.git to 3.14 once it is released but aside
from commit id churn there won't be any other changes to this series
(unless linux-next turns something up).

Thanks for sorting this area of mpath out and sticking with this
patchset for so many review iterations.

Mike
