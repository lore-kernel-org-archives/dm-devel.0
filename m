From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] backing-dev: use synchronize_rcu_expedited
 instead of synchronize_rcu
Date: Thu, 2 Feb 2012 16:29:02 -0800
Message-ID: <20120203002902.GQ2518@linux.vnet.ibm.com>
References: <Pine.LNX.4.64.1107202019420.26781@hs20-bc2-1.build.redhat.com>
	<1328042063.2446.250.camel@twins>
	<Pine.LNX.4.64.1202021538570.9035@hs20-bc2-1.build.redhat.com>
	<1328219944.2446.277.camel@twins>
Reply-To: paulmck@linux.vnet.ibm.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1328219944.2446.277.camel@twins>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: axboe@kernel.dk, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 02, 2012 at 10:59:04PM +0100, Peter Zijlstra wrote:
> On Thu, 2012-02-02 at 15:43 -0500, Mikulas Patocka wrote:
> > Do you have some measurable use case where the user is removing block 
> > devices so heavily that this causes a problem? 
> 
> Even one can be a problem, we're having people spend lots of time and
> effort to reduce machine wide jitter and interference. Adding it with
> such disregard isn't cool.
> 
> There's no reason a management cpu adding or removing block devices
> should perturb the high-freq trading or industrial laser control running
> on the other side of the machine.

Very true for real-time applications!

For the heavy trading apps, given Frederic's upcoming user-mode-idle work,
I can keep this stuff from perturbing the apps.  Still, batching would
be preferable.

							Thanx, Paul
