From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2] multipath: add find_multipaths feature.
Date: Thu, 01 Sep 2011 16:35:16 +0200
Message-ID: <4E5F9824.1020105@suse.de>
References: <20110725185758.GA1368@ether.msp.redhat.com>
	<20110901025518.GD11793@ether.msp.redhat.com>
	<1314861263.14056.89.camel@lapoo.opensvc.com>
	<20110901125720.GF11793@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110901125720.GF11793@ether.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 09/01/2011 02:57 PM, Benjamin Marzinski wrote:
> On Thu, Sep 01, 2011 at 09:14:23AM +0200, Christophe Varoqui wrote:
>> On mer., 2011-08-31 at 21:55 -0500, Benjamin Marzinski wrote:
>>> This adds a new default feature, find_multipaths. When this is set to y=
es,
>>> multipath will no longer try to create a multipath device for every
>>> non-blacklisted device. Instead, it will only create a device when one =
of
>>> three conditions are met.
>>>
>>> 1. Three are at least two non-blacklisted paths with the same wwid
>>> 2. The user manually forces the creation, by specifying a device with t=
he
>>>     multipath command.
>>> 3. A path has the same wwid as a multipath device that was previously c=
rreated
>>>     (even if that multipath device doesn't currently exist).
>>>
>> Hannes,
>>
>> this patch implements complex semantics and mis-use /etc to store
>> variable data (/run was suggested as a replacement). Though I realize
>> the benefits, I'm not at ease merging it.
>
> This will add wwids to the wwids file at the same times that new bindings
> get added to the bindings file. We decided to move the bindings file to
> /etc/multipath/bindings because it caused problems during bootup, if
> /var/run was not mounted.  This will have the same problems where you
> will be writing to a file that eventually gets mounted over.  So I am
> against using /var/run
>
I already did a patch to allow for a different location for the =

bindings file (methinks it's upstream, isn't it?)

But that's not the issue.
The issue here is an inversion in behaviour.
Normally multipath would access / manage all devices except those
blacklisted in /etc/multipath.conf
With the patch multipath would access / manage _no_ devices except =

those listed in /etc/multipath.conf

Which is the main point of contention.
So as such I'm not happy with this, too.

However, we definitely need to figure out how integrate with systemd.
 From my understanding we need to have some 'trigger', telling =

systemd to ignore any disks multipath might hook onto.

Sure, the find_multipaths feature would be a possible solution here, =

as then systemd could evaluate the config file any everything would =

be dandy.

However, I would prefer to modify 'multipath' (which is in the =

process on becoming obsoleted currently). This could program could =

then be used to provide systemd with the required information, ie if =

a device should be ignored or not.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
