From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 28/57] libmultipath: use a shared lock to
 co-operate with udev
Date: Tue, 3 May 2016 07:57:01 +0200
Message-ID: <57283DAD.9040009@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
	<1461755458-29225-29-git-send-email-hare@suse.de>
	<20160502162617.GS26117@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160502162617.GS26117@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/02/2016 06:26 PM, Benjamin Marzinski wrote:
> On Wed, Apr 27, 2016 at 01:10:29PM +0200, Hannes Reinecke wrote:
>> udev since v214 is placing a shared lock on the device node
>> whenever it's processing the event. This introduces a race
>> condition with multipathd, as multipathd is processing the
>> event for the block device at the same time as udev is
>> processing the events for the partitions.
>> And a lock on the partitions will also be visible on the
>> block device itself, hence multipathd won't be able to
>> lock the device.
>> When multipath manages to take a lock on the device,
>> udev will fail, and consequently ignore this entire event.
>> Which in turn might cause the system to malfunction as it
>> might have been a crucial event like 'remove' or 'link down'.
>>
>> So we should better use LOCK_SH here; with that the flock
>> call in multipathd _and_ udev will succeed and the events
>> can be processed.
> =

> If we switch this to a shared lock, then what's the point in having it
> at all? The whole point of lock_multipath is to keep multipath and
> multipathd (or two concurrent calls to multipath) from trying to create
> a device at the same time, and both failing. Without an exclusive lock,
> this won't stop that. We can either decide that this is an unlikely
> scenario, and drop it entirely, or we can have multipath create its own
> lockfiles to prevent this issue without interfering with udev. But
> unless I'm missing something, this won't actually do anything.
> =

This is primarily for co-operation with udev.
As we typically do _not_ use multipath for creating device-mapper tables
the synchronisation problem between multipath and multipathd
doesn't typically occur.
At least not for us :-)

And as described above, we need this patch to co-operate with udev.
Kay was pretty adamant about _not_ changing udev here.

That said, I'm happy with dropping the lock functionality completely;
one possibility would be to use the CLI functionality to route calls
from multipath to multipathd.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
