From: Hannes Reinecke <hare@suse.de>
Subject: Re: dm-multipath performance patches
Date: Tue, 8 Mar 2016 16:27:07 +0100
Message-ID: <56DEEF4B.2040501@suse.de>
References: <56DE81B5.80001@suse.de> <20160308144842.GA13283@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160308144842.GA13283@redhat.com>
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
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 03/08/2016 03:48 PM, Mike Snitzer wrote:
> On Tue, Mar 08 2016 at  2:39am -0500,
> Hannes Reinecke <hare@suse.de> wrote:
> =

>> Hi Mike,
>>
>> to picking up an old topic, what's the status of your performance
>> patches for dm-multipath?
>>
>> I've started looking a branch 'devel3', and was wondering if these
>> are the latest patches available.
>> Or would you have newer?
> =

> The 'devel3' was just a temporary branch I was using during
> development.  I've since staged all the changes in linux-next via
> linux-dm.git's 'for-next' branch:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/l=
og/?h=3Dfor-next
> =

> If you could test this 'for-next' and report back I'd appreciate it.
> It'd build my confidence in pushing these changes once the 4.6 merge
> window opens.
> =

> That said, these changes have held up to Junichi's test suite.  WHich
> I've now staged here (until I get around to porting them over to
> device-mapper-test-suite): https://github.com/snitm/mptest
> =

> As for code review, please have a good look at this commit:
>    b3c39bf1d dm mpath: convert from spinlock to RCU for most locking
> =

> If you find anything feel free to share an incremental fix and I'll get
> it reviewed/staged.
> =

> (Junichi I'd welcome your review of all these request-based DM core and
> multipath changes too)
> =

Right.

Looks like it's essential the same as the devel3 branch, so here
hare some general comments:

- It _really_ has a creative RCU usage. From my understanding, RCU
is protecting access to the _pointer_, not the structure pointed to.
IOW changing fields in an RCU-proctected structure are not
necessarily visible to other CPUs, and I'm not sure if
synchronize_rcu() is sufficient here.
I'd be the first to admit that I'm no expert here, but I really
would like to have an explanation if one can do that.
- I've got some patches moving the bitfields into bitops, and use
atomic_t for counters. With that I guess we can get rid of most of
the creative RCU usage as we can use smp_mb__(after|before)_atomic()
with the same results.
That also enables us to get rid of the spinlock in most cases.
- Splitting 'struct multipath' off in an RCU-protected bit shouldn't
be required anymore with those patches, so maybe we should rework
that again.
- What I'm worried of is the list of pgs and pgpaths. We can protect
against changes within the pgs and pgpaths with bitops and atomic,
but not against changes of the lists. However, from what I've seen
the pg list and pgpath lists are pretty much immutable during normal
I/O, and can only be changed by a table load.
If the table load is protected by other means (eg by the
device-mapper core) than we wouldn't need any lock here, either.
But that needs to be clarified.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
