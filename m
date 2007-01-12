From: Ming Zhang <blackmagic02881@gmail.com>
Subject: Re: [dm-devel] [RFC] Out of order snapshot deletion
Date: Fri, 12 Jan 2007 13:37:56 -0500
Message-ID: <1168627076.2805.125.camel@localhost.localdomain>
References: <45A766F3.A9E3.000B.0@novell.com>
Reply-To: blackmagic02881@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <evms-devel-bounces@lists.sourceforge.net>
In-Reply-To: <45A766F3.A9E3.000B.0@novell.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=evms-devel>
List-Post: <mailto:evms-devel@lists.sourceforge.net>
List-Help: <mailto:evms-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: evms-devel-bounces@lists.sourceforge.net
Errors-To: evms-devel-bounces@lists.sourceforge.net
To: device-mapper development <dm-devel@redhat.com>
Cc: evms-devel@lists.sourceforge.net, linux-lvm@redhat.com
List-Id: dm-devel.ids

On Thu, 2007-01-11 at 22:19 -0700, Vijai Babu Madhavan wrote:
> Hi,
> 
> I thought I would bring this topic in a separate thread so that 
> it can be discussed independently.
> 
> As users start taking a bunch of snapshots and keep them as 
> backups, we see the following use pattern when the snapshots 
> get recycled.
> 
> Different snapshots have different life cycle. When some one 
> decides to keep 'x' snapshots, at the recycle phase, the least 
> recent does not necessarily get deleted.
> 
> As users want to keep the daily snapshots for a much longer period
> than the bi-hourly snapshots. In the same way, weekly snapshots 
> live longer than daily snapshots.
> 
> I think this is pretty much similar to the way the current backup tapes
> are managed.

make sense.

> 
> I want to know if this is the kind of use case that users are having or 
> the developers are thinking.
> 
> The reason why I am posting this is that this out of snapshot deletion
> scenario, poses some interesting challenges in the design on the solution 
> of multiple snapshots that share blocks with each other, as it is a lot easier 
> to design a solution where the least recent gets deleted always.

this does not hold true. for snapshot used as backup purpose, you 100%
can not assume the oldest or newest will be delete first. there is no
such rule.

and possibly, you create one snapshot base on policy and later mount it
and check data consistency. if it turns out to be a bad one, you want to
delete it. then you have no order to follow at all.

ps, any comment on http://sourceware.org/cluster/csnap/? this also try
to solve the current multiple snapshot issues.

thanks

Ming

> 
> Vijai
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 
http://blackmagic02881.wordpress.com/


-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
_______________________________________________
Evms-devel mailing list
Evms-devel@lists.sourceforge.net
To subscribe/unsubscribe, please visit:
https://lists.sourceforge.net/lists/listinfo/evms-devel
