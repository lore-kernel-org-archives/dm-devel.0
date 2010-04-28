From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: semop failed for cookie?
Date: Wed, 28 Apr 2010 11:38:01 +0200
Message-ID: <4BD801F9.3020803@redhat.com>
References: <4BD74F99.8020605@filteredperception.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4BD74F99.8020605@filteredperception.org>
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
Cc: Sebastian Dziallas <sdz@sugarlabs.org>, satellit@bendbroadband.com
List-Id: dm-devel.ids

On 04/27/2010 10:56 PM, Douglas McClendon wrote:
> zyx-liveinstaller-cli: creating temporary rootfs virtual duplicate
> device-mapper: resume ioctl failed: Invalid argument
> semid 65536: semop failed for cookie 0xd4d423c: incorrect semaphore state
> Failed to set a proper state for notification semaphore identified by
> cookie value 223167036 (0xd4d423c) to initialize waiting for incoming
> notifications.

Well, the primary cause is that "resume" ioctl that is failing
(can you trace the exact parameters that are substituted in the
script for that failing dmsetup call?). I think the errors printed
afterwards are just an outcome of this failure.

Anyway, it seems that our internal "_udev_complete" fn is called more
than once on some error path. This call is exactly the same as calling
"dmsetup udevcomplete", but we have to call one internally if any error
occurs while processing a device-mapper task (that generates udev events).
That's because we can't await any notification for failed ioctls since
no udev events will be generated. We need to do that to prevent
infinite waiting for notifications that will never come.

If that internal _udev_complete is called more than necessary, we'll
get into an improper state with the semaphore so that needs to be
fixed!

What's the exact version of dmsetup/lvm2 used? Also, in addition to
Alasdair's hints in the other post, could you please run the failing
dmsetup with verbose output "dmsetup -vv ...". This way we should
see how the semaphore is handled throughout processing..

Peter
