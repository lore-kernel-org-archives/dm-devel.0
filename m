From: Hannes Reinecke <hare@suse.de>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Tue, 29 Nov 2016 07:47:31 +0100
Message-ID: <fba771cb-222d-88a9-5e9f-35e57206aecd@suse.de>
References: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
	<9797787c-30c5-08fb-f92a-5e68ec0b6333@suse.de>
	<OF1D9DC33E.849B3309-ON4825806D.002C52A8-4825806D.003020B2@zte.com.cn>
	<1479289781.14706.16.camel@suse.com>
	<OF233D7062.48FA865C-ON4825806E.000544C5-4825806E.00093C07@zte.com.cn>
	<1479379712.14706.23.camel@suse.com>
	<20161118222618.GZ1972@octiron.msp.redhat.com>
	<1479979270.13566.7.camel@suse.com>
	<20161128184624.GF1972@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161128184624.GF1972@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

On 11/28/2016 07:46 PM, Benjamin Marzinski wrote:
> On Thu, Nov 24, 2016 at 10:21:10AM +0100, Martin Wilck wrote:
>> On Fri, 2016-11-18 at 16:26 -0600, Benjamin Marzinski wrote:
>>
>>> The issue is that we simply need to work on processing the whole list
>>> at
>>> a time.  Martin's filtering definitely has a place here. He is
>>> correct
>>> that if we get a delete uevent for a device, we don't need to process
>>> any of the earlier ones.  We do need to look at both the add and
>>> change
>>> uevents individually. For instance, one of the change uevents out of
>>> a
>>> group could be for changing the read-only status of a device. If we
>>> just
>>> took the most recent, we would miss that information.  The good news
>>> is
>>> that we don't need to actually call uev_add_path and uev_update_path
>>> once for each of these events.  All we need to do is read through the
>>> uev environment variables for all of them to find the information we
>>> need (like change in ro status), and then call the function once with
>>> that information.
>>
>> Do we need to implement the environment-merging ourselves? AFAICS this
>> logic is implemented in udev itself. So if the last event for a given
>> device is a change event, we'd just need to fetch the device properties
>> from the udev db. Therefore IMO we just have to look at the last
>> received event for a given path:
>>
>>  - DELETE =3D> discard the device
>>  - ADD =3D> use the udev properties coming with the event
>>  - CHANGE =3D> query udev db for current set of properties
> =

> The issue is that when we get a change event, there may be udev
> environment variables that tell us what that specific event is for. For
> instance, a change in the Read-only status of the path device. Future
> change events will not have those environment variables set.  However,
> if we want to only call uev_update_path once, we need to know all of the
> things that changed, so we need to examine the approriate udev
> environment variables for all the change events, so that when we call
> uev_update_path, we can take all the necessary actions (in this
> instance, changing the Read-only status of the multipath device).
> =

>>> At any rate, I'd rather get rid of the gazillion waiter threads
>>> first.
>>
>> Hm, I thought the threads are good because this avoids one unresponsive
>> device to stall everything?
> =

> There is work making dm events pollable, so that you can wait for any
> number of them with one thread. At the moment, once we get an event, we
> lock the vecs lock, which pretty much keeps everything else from
> running, so this doesn't really change that.
> =

Which again leads me to the question:
Why are we waiting for dm events?
The code handling them is pretty arcane, and from what I've seen there
is nothing in there which we wouldn't be informed via other mechanisms
(path checker, uevents).
So why do we still bother with them?

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
