From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Uevent cookie env var support
Date: Wed, 8 Apr 2009 06:29:21 -0700
Message-ID: <ac3eb2510904080629m176c5b6x3f76c640414dd027@mail.gmail.com>
References: <49DC92CC.30708@redhat.com>
	<ac3eb2510904080549l50353d85xf1c4af8a31eb7613@mail.gmail.com>
	<49DC9F86.3020903@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49DC9F86.3020903@redhat.com>
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

On Wed, Apr 8, 2009 at 05:58, Peter Rajnoha <prajnoha@redhat.com> wrote:
> Kay Sievers wrote:
>> If you would use the same cookie for several actions, how do you
>> track, that udev has finished the work when you expect an arbitrary
>> number of events with the same cookie?
>
> Well, I use a simple semaphore in userspace waiting for zero. So for
> every action I just increment the semaphore and when the cookie comes back
> from uevent, I decrement it (I use this cookie value as the semaphore's
> identifier as well). So the number of uevents I'm expecting is not
> arbitrary from this perspective. I just need to fire off all the actions
> and then at some point later need to be sure that all the udev rules
> were executed (so I'm sure all the nodes are created) and so I can continue.

Sure, sounds good.

I just read "we can use the cookie value to group the actions" as you
would want to use the same value for several actions.

Thanks,
Kay
