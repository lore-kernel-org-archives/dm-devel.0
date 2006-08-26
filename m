From: seth vidal <skvidal@linux.duke.edu>
Subject: Re: failover time and failback time
Date: Sat, 26 Aug 2006 15:14:09 -0400
Message-ID: <1156619650.13298.38.camel@cutter>
References: <1156613723.13298.18.camel@cutter>
	<1156615617.13298.25.camel@cutter> <1156617542.13298.31.camel@cutter>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1156617542.13298.31.camel@cutter>
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

On Sat, 2006-08-26 at 14:39 -0400, seth vidal wrote:
> On Sat, 2006-08-26 at 14:06 -0400, seth vidal wrote:
> > On Sat, 2006-08-26 at 13:35 -0400, seth vidal wrote:
> > > Hi, 
> > 
> > 
> > <snip>
> > > Then I yank one connection on one of the cards in the back of the
> > > system.
> > > I watch dmesg and I see:
> > > qla2300 0000:03:0b.0: LOOP DOWN detected (2).
> > > 
> > > At this point I would expect multipathd to fail out the paths connected
> > > and continue happily. 
> > > 
> > 
> > So, I think I know why multipathd was failing back correctly :)
> > 
> > It's because it wasn't running. I thought it was but I was wrong.
> > 
> > However, now I'm seeing this when it tries to failover:
> > Aug 26 14:04:10 multipathd: error calling out /sbin/mpath_prio_alua
> > 8:240
> > Aug 26 14:04:10 kernel: SCSI error : <1 0 3 3> return code = 0x10000
> > 
> > I've checked /sbin/mpath_prio_alua works to run - so I'm not sure where
> > I should look next.
> 
> It's so fun learning things in semi-public :)
> 
> This is calling to verify the path. It continues to do this until the
> path is restored.
> 
> Now - is there  any way to tell multipath: "yes, we know, it's down,
> stop trying for now b/c it isn't going to be back"
> 
> Sort of like acknowledging an alert in nagios.
> 
> I can think of some controlled 'failures' where I might want to tell it
> to be quiet.
> 
> Thanks for putting up with my messages. :)

And one more question.

I tested:

interface 2 fail over: worked
interface 2 failback: worked
interface 1 fail over: worked
interface 1 fail back: did not work - multipathd appeared to have died.
It was running before but needed to be restarted in order for the
failback to come up.



I've looked through bugzilla but didn't find anything. Are there any
known situations where multipathd will exit?

-sv
