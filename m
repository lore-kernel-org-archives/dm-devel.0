From: Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: dm-snapshot scalability - chained delta snapshots
	approach
Date: Wed, 27 Sep 2006 11:17:00 +0200
Message-ID: <20060927091700.GA6314@X40.redhat.com>
References: <44DA246B020000B60000BD22@lucius.provo.novell.com>
	<44DB5BDD020000B60000BD96@lucius.provo.novell.com>
	<44DB5C21.F25D.00B6.0@novell.com> <451A5915.F25D.00B6.0@novell.com>
Reply-To: jblunck@suse.de,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <451A5915.F25D.00B6.0@novell.com>
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

On Tue, Sep 26, Haripriya S wrote:

> I had previously put out some performance numbers for origin writes
> where performance goes down drastically w.r.t. the number of snapshots.
> Going further, we identified one of the reasons for the performance drop
> with increase in number of snapshots as the COW copies that happen to
> every snapshot COW device when an origin write happens.

Thanks a lot for your work in this area of the device-mapper. Your performance
numbers show that work is really necessary here.

> We have currently experimented with dm-snapshot code with two different
> approaches and have got good performance numbers. I describe the first
> approach and the results here and appreciate your opinions and inputs on
> this.
> 
> Approach 1 - Chained delta snapshots

This means that every snapshot still has its own exception store. This would
make deletion of snapshots unnecessary complex. It moves the work (copying of
chunks) to the deletion of the snapshot.

We discussed some of the ideas about snapshots here at the dm summit. The
general ideas are as follows:

- one exception store per origin device that is shared by all snapshots
- don't keep the complete exception tables in memory all the time
- limit kcopyd outstanding requests

This would address the two biggest problems that I see with the snapshot
target. The throughput issues should be addressed by only writing to one
exception store. The memory issues should be addressed by the changes to the
exception table handling. Although that includes a complete redesign of the
exception store code.

There are still ongoing discussions about the snapshot target. It would be
nice if you have additional thoughts about this proposal. I guess it is
similar to one of your prototypes.

Jan
