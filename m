From: Hannes Reinecke <hare@suse.de>
Subject: Re: Improve processing efficiency for addition and
 deletion of multipath devices
Date: Wed, 16 Nov 2016 08:53:15 +0100
Message-ID: <9797787c-30c5-08fb-f92a-5e68ec0b6333@suse.de>
References: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF7C96E124.CD19B12D-ON4825806D.00095E60-4825806D.0009BD8C@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tang.junhui@zte.com.cn, christophe.varoqui@opensvc.com, bmarzins@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/16/2016 02:46 AM, tang.junhui@zte.com.cn wrote:
> In these scenarios, multipath processing efficiency is very low:
> 1) There are many paths in multipath devices,
> 2) Add/delete devices when iSCSI login/logout or FC link up/down.
> =

> Multipath process so slowly that it is not satisfied some applications,
> For example, openstack is often timeout in waiting for the creation of
> multipath devices.
> =

> The reason of the low processing efficiency I think is that multipath
> process uevent message one by one, and each one also produce a new dm
> addition/change/deletion uevent message to increased system resource
> consumption, actually most of these uevent message have no sense at all.
> =

> So, can we find out a way to reduce these uevent messages to promote
> multipath processing efficiency? Personally, I think we can merge
> these uevent messages before processing. For example, during the
> 4 iSCSI session login procedures, we can wait for a moment until
> the addition uevent messages of 4 paths are all arrived, and then we can
> merge these uevent messages to one and deal with it at once. The way to
> deal with deletion uevent messages is the same.
> =

> How do you think about? Any points of view are welcome.

The problem is that we don't know beforehand on how many uevents we
should be waiting for.
And even if we do there still would be a chance of one or several of
these uevents failing to setup the device, so we would be waiting
forever here.

The one possible way out would be to modify the way we're handling
events internally. Event processing really are several steps:
1) Getting information about the attached device (pathinfo() and friends)
2) Store the information in our pathvec
3) Identify and update the mpp structure with the new pathvecs
Currently, we're processing each step for every uevent.
As we have only a single lock protecting both, pathvec and mppvec, we
have to take the lock prior to setup 2 and release it after step 3.
So while we could receive events in parallel, we can only process them
one-by-one, with every event having to re-do step 3.

The idea would be to split off single lock into a pathvec lock and an
mppvec lock, and create a separate thread for updating mppvec.

Then event processing can be streamlined by having the uevent thread
adding the new device to the pathvec and notifying the mppvec thread.
This thread could then check if an pathvec update is in progress, and
only start once this pathvec handling has finished.
With this we would avoid having to issue several similar mppvec updates,
and the entire handling would be far smoother.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
