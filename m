From: Jan Blunck <jblunck@suse.de>
Subject: Re: dm-snapshot scalability - chained delta snapshots
	approach
Date: Tue, 24 Oct 2006 11:52:00 +0200
Message-ID: <20061024095200.GE4729@hasse.suse.de>
References: <44DA246B020000B60000BD22@lucius.provo.novell.com>
	<44DB5BDD020000B60000BD96@lucius.provo.novell.com>
	<44DB5C21.F25D.00B6.0@novell.com> <451A5915.F25D.00B6.0@novell.com>
	<20060927091700.GA6314@X40.redhat.com>
	<62b0912f0610231016r23585c34y6308cb3540ed926c@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <62b0912f0610231016r23585c34y6308cb3540ed926c@mail.gmail.com>
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

On Mon, Oct 23, Molle Bestefich wrote:

> >This means that every snapshot still has its own exception store.
> >This would make deletion of snapshots unnecessary complex.
> 
> Complex, how?
> 
> Necessary operations (in order listed):
> * Acquire exclusive lock on this snapshot.
> * Check that next snapshot has room for exceptions, abort if not.
> * Acquire exclusive lock on next snapshot.
> * Move all exceptions to next snapshot.
> * Unlock next snapshot.
> * Remove this snapshot.
> * Done...
> 
> Sounds simple to me, but maybe I'm missing the point.

Hmm, sounds simple. Somehow I can't remember exactly where I thought the
problem is ...

> >We discussed some of the ideas about snapshots here at the dm summit. The
> >general ideas are as follows:
> >
> >- one exception store per origin device that is shared by all snapshots
> 
> Now that sounds complex.

But that is something already implemented for clustered snapshots although
that is userspace code.

> >Although that includes a complete redesign of the exception store code.
> 
> Especially when you say stuff like that :-).
> 

The chained-snapshots approach needs that too.

> >The throughput issues should be addressed by only
> >writing to one exception store.
> 
> Wouldn't this make debugging more complex, and further add to
> the difficulty of snapshot resizing?

Resizing? Nope, you only need to resize the exception store thats it. Resizing
the chained-snapshots approach is complex however: in the worst case you have
to move the exception stores to get enough free space.
