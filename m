From: Hannes Reinecke <hare@suse.de>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Fri, 27 Sep 2013 08:07:44 +0200
Message-ID: <524520B0.6010003@suse.de>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
	<20130926172422.GA31328@agk-dp.fab.redhat.com>
	<1380216716.25252.39.camel@bobble.lax.corp.google.com>
	<20130926173814.GB31328@agk-dp.fab.redhat.com>
	<1380217633.25252.46.camel@bobble.lax.corp.google.com>
	<20130926232241.GC31328@agk-dp.fab.redhat.com>
	<20130926234957.GA3658@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130926234957.GA3658@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

On 09/27/2013 01:49 AM, Mike Snitzer wrote:
> On Thu, Sep 26 2013 at  7:22pm -0400,
> Alasdair G Kergon <agk@redhat.com> wrote:
> =

>> On Thu, Sep 26, 2013 at 10:47:13AM -0700, Frank Mayhar wrote:
>>> Launching it from ramdisk won't help, particularly, since it still goes
>>> through the block layer.  The other stuff won't help if a (potentially
>>> unrelated) bug in the daemon happens to be being tickled at the same
>>> time, or if some dependency happens to be broken and _that's_ what's
>>> preventing the daemon from making progress.
>>  =

>> Then put more effort into debugging your daemon so it doesn't have
>> bugs that make it die?  Implement the timeout in a robust independent
>> daemon if it's other code there that's unreliable?
>>
>>> And as far as lvm2 and multipath-tools, yeah, they cope okay in the kind
>>> of environments most people have, but that's not the kind of environment
>>> (or scale) we have to deal with.
>>
>> In what way are your requirements so different that a locked-into-memory
>> monitoring daemon cannot implement this timeout?
> =

> Frank, I had a look at your patch.  It leaves a lot to be desired, I was
> starting to clean it up but ultimately found myself agreeing with
> Alasdair's original point: that this policy should be implemented in the
> userspace daemon.
> =

_Actually_ there is a way how this could be implemented properly:
implement a blk_timeout function.

Thing is, every request_queue might have a timeout function
implemented, whose goal is to abort requests which are beyond that
timeout. EG SCSI uses that for the dev_loss_tmo mechanism.

Multipath what with it being request-based could easily implement
the same mechanism, namely have to blk_timeout function which would
just re-arm the timeout in the default case, but abort any queued
I/O (after a timeout) if all paths are down.

Hmm. I see to draft up a PoC.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
