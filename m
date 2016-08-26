From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/6] multipathd: Remove a busy-waiting loop
Date: Fri, 26 Aug 2016 16:04:41 +0200
Message-ID: <0c70007e-60ec-d6fc-5921-8ab5c6c55227@suse.de>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
	<14804b8b-51a7-e860-91d7-9b594aeed63c@sandisk.com>
	<2a584b4c-88b7-288b-3f89-62c565774cf1@suse.de>
	<20160825033331.GT26062@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160825033331.GT26062@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/25/2016 05:33 AM, Benjamin Marzinski wrote:
> On Tue, Aug 16, 2016 at 08:31:16AM +0200, Hannes Reinecke wrote:
[ .. ]
>>
>> Makes one wonder: what happens to the waitevent threads?
>> We won't be waiting for them after applying this patch, right?
>> So why did we ever had this busy loop here?
>> Ben?
> =

> Unless something waits for the threads to stop, mutipathd can easily
> crash if a thread runs after we deallocate vecs.  At one point, I tried
> solving this with non-detached threads, but I kept finding corner cases
> where zombie threads could be created.  Probably the easiest way to
> avoid this is to simply not free vecs, and not wait for the threads.
> =

Ah, yes. True.

>>
>> (And while we're at the subject: can't we drop the waitevent threads
>> altogether? We're listening to uevents nowadays, so we should be
>> notified if something happened to the device-mapper tables. Which should
>> make the waitevent threads unnecessary, right?)
> =

> This is definitely a discussion worth having.  I would love to see the
> waiter threads go. The only issue is that uevents aren't guaranteed to
> be received. They were designed to be "best effort" notifications. The
> dm events are guaranteed to be issued. This means that multipathd may
> miss uevents. Now, we sync the multipath state with the kernel when we
> check the path, but there are a number of steps from update_multipath
> (which is what gets called by the waitevent threads) that we skip.  It
> would take some looking into, but if we can determine that either these
> steps aren't necessary (for instance, when we are already calling the
> checker, there's no point in adjusting the time of the next check) or
> that we can safely do them on every path_check, then at worst, missing a
> uevent would delay this work until the next time we check the path.
> =

> There are really two things that multipath doesn't want to have to wait
> on, failing over, and failing back.  I don't see how missing a uevent
> could slow down failing over at all. It could slow down failing back in =

> some cases. For instance, if a path just dropped for an very small time, =
the
> kernel would failover, issue a dm event and uevent, and when multipathd
> called update_multipath, it would lower the time to the next path check,
> if it was too long. I'm not sure that this is that big of a deal,
> however.
> =

Indeed, it would only affect failback.
Failover is handled mainly inside the kernel (redirecting I/O and
whatnot), so that doesn't really need multipath interaction at all.

And if failback is delayed that shouldn't matter, either, as it's hard
to predict when the failback will happen even nowadays.
The only worry we might have is that we're missing failback events
altogether, but the path checker should insulate us against this
eventuality.

> I should note that the kernel issues dm events when it switches
> pathgroups, but not uevents.  Off the top of my head, I don't see
> missing these events being a big deal (the code even says that there is
> nothing to do here, although update_multipath gets called all the same).
> =

> Also, we would need to change some things about how multipath works to
> rely on uevents.  For instance, multipathd would probably want to call
> update_map() whenever it gets a change uevent. Also, we would need to
> sync the old checker state with the kernel state after calling
> update_strings in check_path. Otherwise, if we missed a uevent, the
> daemon might never realize that a path went down, and needed multipathd
> to issue a reinstate so that the kernel started using it again.
> =

> There may be other issues that I'm not thinking of right now, but so
> far, I can't think of any reason why we couldn't remove the waitevent
> threads. I would be greatful if other people gave this some thought to
> see if they can think of some reason that I'm missing.
> =

I don't, and in fact I've been wondering about the reason why we're
keeping waitevents with us for so long :-)

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
