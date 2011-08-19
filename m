From: Joe Thornber <thornber@redhat.com>
Subject: Re: convert dm-thin to use dm-bufio
Date: Fri, 19 Aug 2011 10:11:07 +0100
Message-ID: <20110819091106.GA3193@ubuntu>
References: <Pine.LNX.4.64.1108141602440.28009@hs20-bc2-1.build.redhat.com>
	<20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
	<Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
	<20110817082656.GA3267@ubuntu>
	<Pine.LNX.4.64.1108181830050.7668@hs20-bc2-1.build.redhat.com>
	<20110819070435.GA32300@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110819070435.GA32300@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 19, 2011 at 03:04:36AM -0400, Mike Snitzer wrote:
> Question for Joe:
> You're making conflicting changes quick enough that I wonder if you
> and Mikulas will ever converge (e.g. why do multiple block managers need
> to have access to the same metadata device!?).

They don't; my issue is with getting an oops if they do through user
error.  I clearly said in the commit message that this was a hack to
get round issues introduced by agk's move to a kmemcache.  Cook
something cleaner up between yourselves, or wait for me to look at it
again once I've got through some more pressing issues.

An alternative would be to iterate through all the pools in the system
check whether any of them already had the same metadata device open.
Of course this doesn't catch the cases where the stacking is used and
a metadata device eventually maps onto the same physical disk as an
existing md area.

- Joe
