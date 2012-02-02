From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] backing-dev: use synchronize_rcu_expedited instead of
 synchronize_rcu
Date: Thu, 02 Feb 2012 22:59:04 +0100
Message-ID: <1328219944.2446.277.camel@twins>
References: <Pine.LNX.4.64.1107202019420.26781@hs20-bc2-1.build.redhat.com>
	 <1328042063.2446.250.camel@twins>
	 <Pine.LNX.4.64.1202021538570.9035@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1202021538570.9035@hs20-bc2-1.build.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: axboe@kernel.dk, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>
List-Id: dm-devel.ids

On Thu, 2012-02-02 at 15:43 -0500, Mikulas Patocka wrote:
> Do you have some measurable use case where the user is removing block 
> devices so heavily that this causes a problem? 

Even one can be a problem, we're having people spend lots of time and
effort to reduce machine wide jitter and interference. Adding it with
such disregard isn't cool.

There's no reason a management cpu adding or removing block devices
should perturb the high-freq trading or industrial laser control running
on the other side of the machine.
