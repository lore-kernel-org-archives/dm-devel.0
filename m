From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 1/7] libmultipath: fix tur checker locking
Date: Tue, 13 Feb 2018 14:41:19 -0600
Message-ID: <20180213204119.GC14513@octiron.msp.redhat.com>
References: <1518493334-18170-1-git-send-email-bmarzins@redhat.com>
	<1518493334-18170-2-git-send-email-bmarzins@redhat.com>
	<09963d9d-033c-222d-2302-8481de41d7c4@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <09963d9d-033c-222d-2302-8481de41d7c4@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 13, 2018 at 11:20:39AM +0100, Hannes Reinecke wrote:
> On 02/13/2018 04:42 AM, Benjamin Marzinski wrote:

> I would rather set 'ct->running' from within the thread; otherwise there
> is a chance that pthread_create() returns without error, but the thread
> itself hasn't been run yet.

That worry is why I put ct->running where I did. If pthread_create
returns without an error, but ct->running isn't set yet because the
thread sets it, and it hasn't run yet, then it can appear to the checker
as if the thread has already completed.  This can cause it to return the
results of the thread before it actually has completed, and potentially
even start up a new thread, which would really mess with the value of
ct->running.

On the other hand, if you set running before starting the thread, the
checker won't do anything until the it hits the timeout, at which point
it will cancel the thread.  We are guaranteed that if pthread_create
returns successfully, we have the correct Thread ID to cancel the thread
with, so there's no problem with cancelling a thread that hasn't run.

Am I missing something here?

-Ben

> =

> Cheers,
> =

> Hannes
> -- =

> Dr. Hannes Reinecke		   Teamlead Storage & Networking
> hare@suse.de			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=FCrnberg)
> =

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
