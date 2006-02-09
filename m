From: Dale.R.Fowle@seagate.com
Subject: path checker in regards to failback
Date: Thu, 9 Feb 2006 12:39:07 -0700
Message-ID: <OF63663B7F.8E27641A-ON87257110.006B2BE6-87257110.006BF522@seagate.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
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


Hi all, I have a question related to failover/failback. I'm running
0.4.5-0.11. I'm wondering what the path checker does for the multipathd
daemon.

Here's my senario:
I have two paths to a LUN, configure it with 'multipath -v 2 -p failover'.
Run some I/O down the path of the /dev/mapper/<device>.
I fail one of the paths either by pulling the fibre or disabling the port
it's connected to.
When I run 'multipath -ll' I see the failed path 'failed faulty'.
I restore the path physically.
Run 'multipath -ll' again to see the status and it's 'failed ready'.

Now, my question is, is multipathd supposed to handle making that path
'active ready'?
I have 'failback immediate' set in the /etc/multipath.conf file. And it
does do the immediate failback,...but based on the 'active ready' status.
To get to that status, I have to actually issue a 'multipath' command to
reinstate the path to active.

Is there something that I'm missing or am I just going to have to make a
cron job run every few minutes to do path status updates?

Thanks much,
Dale


Dale Fowle
Seagate Technology
Colorado Springs, CO
719-388-5584
