From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: convert dm-thin to use dm-bufio
Date: Fri, 19 Aug 2011 19:50:59 +0100
Message-ID: <20110819185059.GK32643@agk-dp.fab.redhat.com>
References: <20110815090416.GE3159@ubuntu>
	<Pine.LNX.4.64.1108151316300.18170@hs20-bc2-1.build.redhat.com>
	<20110816091600.GA4284@ubuntu>
	<Pine.LNX.4.64.1108161755510.15859@hs20-bc2-1.build.redhat.com>
	<20110817082656.GA3267@ubuntu>
	<Pine.LNX.4.64.1108181830050.7668@hs20-bc2-1.build.redhat.com>
	<20110819070435.GA32300@redhat.com>
	<Pine.LNX.4.64.1108190926530.2592@hs20-bc2-1.build.redhat.com>
	<20110819153706.GA23736@ubuntu> <20110819182532.GA3774@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20110819182532.GA3774@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, Joe Thornber <thornber@redhat.com>
List-Id: dm-devel.ids

On Fri, Aug 19, 2011 at 02:25:32PM -0400, Mike Snitzer wrote:
> It could be that we're all in agreement here.
 
It's an easy change - whichever set of names we choose - and it can be done at
any time before the switch, if we go ahead with it, is ready for linux-next,
but there's no urgency to change it yet while both versions are in use.

Alasdair
