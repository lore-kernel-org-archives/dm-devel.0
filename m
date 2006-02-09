From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: path checker in regards to failback
Date: Thu, 09 Feb 2006 21:04:52 +0100
Message-ID: <1139515492.2915.25.camel@zezette>
References: <OF63663B7F.8E27641A-ON87257110.006B2BE6-87257110.006BF522@seagate.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF63663B7F.8E27641A-ON87257110.006B2BE6-87257110.006BF522@seagate.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On jeu, 2006-02-09 at 12:39 -0700, Dale.R.Fowle@seagate.com wrote:
> Hi all, I have a question related to failover/failback. I'm running
> 0.4.5-0.11. I'm wondering what the path checker does for the multipathd
> daemon.
> 
> Here's my senario:
> I have two paths to a LUN, configure it with 'multipath -v 2 -p failover'.
> Run some I/O down the path of the /dev/mapper/<device>.
> I fail one of the paths either by pulling the fibre or disabling the port
> it's connected to.
> When I run 'multipath -ll' I see the failed path 'failed faulty'.
> I restore the path physically.
> Run 'multipath -ll' again to see the status and it's 'failed ready'.
> 
> Now, my question is, is multipathd supposed to handle making that path
> 'active ready'?

Yes, multipathd should reinstate the path upon checker status change
from "faulty" to "ready"

> I have 'failback immediate' set in the /etc/multipath.conf file. And it
> does do the immediate failback,...but based on the 'active ready' status.
> To get to that status, I have to actually issue a 'multipath' command to
> reinstate the path to active.
> 
Likely a bug you'll have to chase down a little.
Starting to challenge the devel branch would be a good idea, too.

> Is there something that I'm missing or am I just going to have to make a
> cron job run every few minutes to do path status updates?
> 
You should not need to resort to that.

Regards,
cvaroqui
