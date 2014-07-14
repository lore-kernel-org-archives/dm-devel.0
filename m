From: John Utz <John.Utz@wdc.com>
Subject: Re: device mapper target vs personality,
 how do you decide to pick one or the other?
Date: Mon, 14 Jul 2014 17:00:32 +0000
Message-ID: <8A51900D08212F40B3DE22453052F69839C45DF7@wdscexmb02>
References: <8A51900D08212F40B3DE22453052F69839C45AE5@wdscexmb02>,
	<20140714112525.GD22615@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140714112525.GD22615@localhost.localdomain>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Bryn;

Thankyou so very much for this answer!

I absolutely failed to understand that these where 2 different subsystems in the same directory, it makes vastly more sense now.

________________________________________
From: dm-devel-bounces@redhat.com [dm-devel-bounces@redhat.com] on behalf of Bryn M. Reeves [bmr@redhat.com]
Sent: Monday, July 14, 2014 4:25 AM
To: device-mapper development
Subject: Re: [dm-devel] device mapper target vs personality, how do you decide to pick one or the other?

On Fri, Jul 11, 2014 at 09:28:51PM +0000, John Utz wrote:
> having said that, it seems that the personality code is ancestral and is used for the personalities that can be compiled into device mapper and the target code is for newer stuff that is not expected to be compiled into device mapper.

Not really; it's just a bit confusing as two different but closely
related subsystems live in drivers/md. One is 'md', the Linux
multi-devices subsystem. This is the traditional Linux software RAID
subsystem and offers 'personalities' for different RAID levels and other
mapping types (RAID1-6, JBOD/linear, multipath w/on-disk metadata).

The other is 'dm'; the device-mapper. Using dm offers more flexibility
in specifying virtual devices via the table abstraction (which lets you
glue several targets together a bit like the MD linear personality).
Today dm has targets for linear, zero, error, mirror, snapshot (old),
thin provisioning, caching etc. and also exposes the MD RAID
personalities as dm targets (dm-raid.c; not to be confused with the
userspace dmraid utility).

> so, based on this speculation, i *think* i should be using the target construct for the new device mapper module that i am currently coding.

For dm it's always a target: you'd only create a new personality if you
wanted to extend MD's available RAID levels or types.

Regards,
Bryn.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
