From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 1/7] libmultipath: fix tur checker locking
Date: Mon, 12 Feb 2018 12:44:50 -0600
Message-ID: <20180212184450.GZ14513@octiron.msp.redhat.com>
References: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
	<1518134167-15938-2-git-send-email-bmarzins@redhat.com>
	<1518208256.2937.16.camel@suse.com>
	<20180209230449.GW14513@octiron.msp.redhat.com>
	<1518218931.2937.20.camel@suse.com>
	<1518219365.2937.22.camel@suse.com>
	<20180210003638.GY14513@octiron.msp.redhat.com>
	<1518279095.2937.25.camel@suse.com>
	<1518291751.2937.41.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1518291751.2937.41.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Feb 10, 2018 at 08:42:31PM +0100, Martin Wilck wrote:
> On Sat, 2018-02-10 at 17:11 +0100, Martin Wilck wrote:
> > On Fri, 2018-02-09 at 18:36 -0600, Benjamin Marzinski wrote:
> > > On Sat, Feb 10, 2018 at 12:36:05AM +0100, Martin Wilck wrote:
> > > > On Sat, 2018-02-10 at 00:28 +0100, Martin Wilck wrote:
> > > > > Maybe it's easier than we thought. Attached is a patch on top
> > > > > of
> > > > > yours that I think might work, please have a look. =

> > > > > =

> > > > =

> > > > That one didn't even compile. This one is better.
> > > > =

> > > > Martin
> > > =

> > > How about this one instead. The idea is that once we are in the
> > > cleanup
> > > handler, we just cleanup and exit. But before we enter it, we
> > > atomically
> > > exchange running, and if running was 0, we pause(), since the
> > > checker
> > > is
> > > either about to cancel us, or already has.
> > > =

> > =

> > Yes, that should work. Nice.
> =

> ... but I just realized that we don't rcu_register_thread() the TUR
> thread. Maybe we should if we use RCU primitives?

Looking online, I see this.

"void rcu_register_thread(void): For all RCU flavors other than
bullet-proof RCU, each thread must invoke this function before its first
call to rcu_read_lock() or call_rcu(). If a given thread never invokes
any RCU read-side functions, it need not invoke
rcu_register_thread(void)."

That makes it sound like this is unnecessary for using the atomic
operations. Did you see something that makes you think differently? I
probably won't hurt to add it anyway. But, if it's fuzzy how to
correctly use the rcu operations, we could just go back to wrapping
normal operations in a spin_lock, now that we have a method that's not
excessively complicated, and would only require holding the lock for
simple variable manipulations.

Ben

> =

> Martin
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
