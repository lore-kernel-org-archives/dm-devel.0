From: Will Drewry <wad@chromium.org>
Subject: Re: [dm-devel] [RFC PATCH v2 1/2] dm: allow a dm-fs-style device to
	be shared via dm-ioctl
Date: Mon, 17 May 2010 22:11:55 -0500
Message-ID: <AANLkTimHUPh0UHEU-5YckhwppX8AhFBYBxc4BZiIpmfZ@mail.gmail.com>
References: <20100514035347.GA20636@redhat.com>
	 <1273887701-2152-1-git-send-email-wad@chromium.org>
	 <4BF1FD33.4040305@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BF1FD33.4040305@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, May 17, 2010 at 9:36 PM, Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wr=
ote:
> Hi Will,
>
> n 05/15/2010 10:41 AM +0900, Will Drewry wrote:
>> In addition, it ensures that public functions are available that
>> allow mapped devices and tables to be created and associated
>> with the shared code paths with dm-ioctl:
>> - suspend flags are available
> snip
>> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
>> index bad1724..782d867 100644
>> --- a/drivers/md/dm.h
>> +++ b/drivers/md/dm.h
>> @@ -17,12 +17,6 @@
>> =A0#include <linux/hdreg.h>
>>
>> =A0/*
>> - * Suspend feature flags
>> - */
>> -#define DM_SUSPEND_LOCKFS_FLAG =A0 =A0 =A0 =A0 =A0 =A0 =A0 (1 << 0)
>> -#define DM_SUSPEND_NOFLUSH_FLAG =A0 =A0 =A0 =A0 =A0 =A0 =A0(1 << 1)
>> -
>> -/*
>> =A0 * Type of table and mapped_device's mempool
>> =A0 */
>> =A0#define DM_TYPE_NONE =A0 =A0 =A0 =A0 0
>> diff --git a/include/linux/device-mapper.h b/include/linux/device-ma=
pper.h
>> index 1381cd9..6c1c230 100644
>> --- a/include/linux/device-mapper.h
>> +++ b/include/linux/device-mapper.h
>> @@ -215,6 +215,18 @@ void dm_set_mdptr(struct mapped_device *md, voi=
d *ptr);
>> =A0void *dm_get_mdptr(struct mapped_device *md);
>>
>> =A0/*
>> + * Export the device via the ioctl interface (uses mdptr).
>> + */
>> +int dm_ioctl_export(struct mapped_device *md, const char *name,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *uuid);
>> +
>> +/*
>> + * Suspend feature flags
>> + */
>> +#define DM_SUSPEND_LOCKFS_FLAG =A0 =A0 =A0 =A0 =A0 =A0 =A0 (1 << 0)
>> +#define DM_SUSPEND_NOFLUSH_FLAG =A0 =A0 =A0 =A0 =A0 =A0 =A0(1 << 1)
>> +
>> +/*
>> =A0 * A device can still be used while suspended, but I/O is deferre=
d.
>> =A0 */
>> =A0int dm_suspend(struct mapped_device *md, unsigned suspend_flags);
>
> Why do you need suspend feature flags?
> I think no feature is needed (specifying '0' is enough) to make/suspe=
nd
> a dm device at boot time (although I have looked at only this flag pa=
rt).
> Am I missing something?

Not at all! I hadn't thoroughly reviewed the code path for flush/noflus=
h
and was hoping to avoid additional code paths.  However, looking at
effect, I don't see any tangible benefit to doing so with a brand new
device.

I'll switch it over to 0, and I can take exposing the flags out of this
patch.

Any additional comments are appreciated -  thanks!
will
