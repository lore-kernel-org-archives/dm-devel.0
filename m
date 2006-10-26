From: "Haripriya S" <sharipriya@novell.com>
Subject: Re: dm-snapshot scalability - chained delta
	snapshots approach
Date: Thu, 26 Oct 2006 02:29:07 -0600
Message-ID: <4540C078.A648.00B6.0@novell.com>
References: <44DA246B020000B60000BD22@lucius.provo.novell.com>
	<44DB5BDD020000B60000BD96@lucius.provo.novell.com>
	<44DB5C21.F25D.00B6.0@novell.com> <451A5915.F25D.00B6.0@novell.com>
	<20060927091700.GA6314@X40.redhat.com>
	<62b0912f0610231016r23585c34y6308cb3540ed926c@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <62b0912f0610231016r23585c34y6308cb3540ed926c@mail.gmail.com>
Content-Disposition: inline
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

>>> "Molle Bestefich" <molle.bestefich@gmail.com> 10/23/06 10:46 PM >>>


> Complex, how?
> 
> Necessary operations (in order listed):
>  * Acquire exclusive lock on this snapshot.
>  * Check that next snapshot has room for exceptions, abort if not.

If the next snapshot in the write chain does not have
room, then we need to go through the list of earlier 
snapshots and move the exceptions to the first snapshot
which has room. This is because the earlier snapshots depend
on the data being copied in at least one of the later snapshots.
If the next snapshot is the earliest snapshot, then we can abort.

>  * Acquire exclusive lock on next snapshot.
>  * Move all exceptions to next snapshot.
>  * Unlock next snapshot.
>  * Remove this snapshot.
>  * Done...

Yes.

Thanks and Regards,
Haripriya
