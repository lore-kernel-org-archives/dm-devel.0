From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 43/78] Fixup device-mapper 'cookie' handling
Date: Thu, 26 Mar 2015 15:20:09 +0100
Message-ID: <55141599.2060704@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
	<1426509425-15978-44-git-send-email-hare@suse.de>
	<20150325163057.GO29132@octiron.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150325163057.GO29132@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 03/25/2015 05:30 PM, Benjamin Marzinski wrote:
> On Mon, Mar 16, 2015 at 01:36:30PM +0100, Hannes Reinecke wrote:
>> device-mapper has a 'cookie', which is inserted with the ioctl
>> for modifying device-mapper devices.
>> It is used as a synchronization point between udev and any other
>> applications to notify the latter when udev has finished
>> processing the event.
>> Originally multipath would only use a single cookie for every
>> transaction, and wait for that cookie at the end of the program.
>> Which works well if you only have one transaction, but for several
>> (like calling 'multipath') it will actually overwrite the cookie
>> and fail to wait for earlier events.
> =

> That shouldn't be happening.  Looking at the dm_task_set_cookie code
> =

>         if (*cookie) {
>                 if (!_get_cookie_sem(*cookie, &semid))
>                         goto_bad;
>         } else if (!_udev_notify_sem_create(cookie, &semid))
>                 goto_bad;
> =

> The first time we use that cookie, it should be zero, so a new semaphore
> will be created, and the id will be returned to us.  Subsequent calls to
> dm_task_set_cookie with the same cookie (which is now non-zero) should
> just be using the same semaphore, allowing you you wait just one time on
> all the actions linked to that cookie.  This should be more efficient
> than having to wait on each action (since udev can complete them in the
> background as we go on).
> =

> If there really are cookies that are not waited for, you should be able
> to see that by running
> =

> # dmsetup udevcookies
> =

> After running the multipath command.  Cookies won't go away until
> someone waits for them. If there are cookies listed there, then my guess
> would be that something is resetting conf->cookie to 0 after our first
> call to dm_task_set_cookie.  If there aren't, then it would appear that
> something else, instead of not waiting for the cookies, is causing
> device mapper to fail back to manual device node creation.
> =

> If you can verify that you are passing the cookie value that you get
> back from the first call to dm_task_set_cookie() into sebsequent calls,
> and you still are seeing non-watited for cookies with "dmsetup
> udevcookies" then that sounds to me like a problem in device-mapper, and
> we should check that out.
> =

Hmm. It _might_ have been caused by multipathd not properly
synchronized with udev (the original service files didn't have a
dependency on udev), hence the call to dm_udev_set_sync_support()
would cause device-mapper to switch off the udev fallback.

Speaking of nasty side-effects ...
Can't we have a proper warning in dm_udev_set_sync_support(),
alerting us that the system will not behave as expected?

But with that resolved it might be that indeed the patch is not
required. I'll check.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
