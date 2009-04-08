From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Uevent cookie env var support
Date: Wed, 8 Apr 2009 05:49:11 -0700
Message-ID: <ac3eb2510904080549l50353d85xf1c4af8a31eb7613@mail.gmail.com>
References: <49DC92CC.30708@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49DC92CC.30708@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Wed, Apr 8, 2009 at 05:04, Peter Rajnoha <prajnoha@redhat.com> wrote:
> this is a kernel side patch that adds support for cookie variables.
> A cookie is a random unsigned 32 bit value generated in userspace
> and passed into the DM through ioctl (reusing the event_nr field to
> avoid the change in the interface). These values are sent back in
> CHANGE and REMOVE uevents. This way we can easily pair a process
> waiting for udev's rule completion and the udev event itself.

That sounds useful.

I always thought we would return the driver core generated seqnum with
the ioctl, so you could watch the udev event queue to see the events
being handled. But if you are going to listen to the udev events, the
cookie sounds like a nice solution.

> Also,
> we can use the cookie value to group the actions and related uevents
> together, so we know which uevents belong to actions done on one
> DM tree.

If you would use the same cookie for several actions, how do you
track, that udev has finished the work when you expect an arbitrary
number of events with the same cookie?

Thanks,
Kay
