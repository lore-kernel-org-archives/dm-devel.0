From: Hannes Reinecke <hare@suse.de>
Subject: Re: Getting device-mapper failure notifications
Date: Wed, 24 Feb 2016 18:25:43 +0800
Message-ID: <56CD8527.5000702@suse.de>
References: <CAHph7JrC0pU+Wy7DsHeCAhz7FWuJa29qGsdv+jD3OQq4aJ1bTA@mail.gmail.com>
	<56CD38FD.9010209@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56CD38FD.9010209@redhat.com>
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

On 02/24/2016 01:00 PM, Andy Grover wrote:
> On 02/01/2016 11:07 PM, Avishay Traeger wrote:
>> Hi all,
>> I have a system where various configurations are possible - iSCSI/FC,
>> single paths and multiple.  For multiple I of course use device-mapper.
>> I was wondering if it was possible to:
>> 1. use it for cases where I have a single path.
>> 2. create a monitoring process that can take some action (e.g., send a
>> notification via message queue) in the case of some failure that would
>> normally cause failover.
> =

> Does dm-multipath support a single path? I don't know...
> =

Pshaw.
Of course it does.

(Might be that RH has some magic disallowing that, but certainly there's
nothing in the source which forbids it. In fact I recommend it when
using iSCSI)

So I recommend to always use dm-multipath and listen to uevents.

> but for your #2, dm-multipath publishes a uevent when a path fails,
> maybe the process could look for that? Using libudev?
> =

Alternatively (if you don't want the failover to happen from multipath
itself) you can implement your own device_handler sending out an uevent
and waiting for some magic sysfs attribute to be written to before
completing.

Should be rather trivial.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
