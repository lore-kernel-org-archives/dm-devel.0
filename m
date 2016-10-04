From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 0/9] Generate uevents for all DM events
Date: Tue, 4 Oct 2016 16:39:28 -0700
Message-ID: <fe185eba-f802-6731-8da7-736c117db135@redhat.com>
References: <1475522580-16723-1-git-send-email-agrover@redhat.com>
 <20161004072015.GA11216@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161004072015.GA11216@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: snitzer@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 10/04/2016 12:20 AM, Greg KH wrote:
> On Mon, Oct 03, 2016 at 12:22:51PM -0700, Andy Grover wrote:
>> Hi Mike and GregKH,
>>
>> I want a way to get devicemapper events without using the DM ioctl,
>> because that requires creating a thread to sleep in the ioctl for each
>> dm device I want events from.
>>
>> It would seem like using uevents and KOBJ_CHANGE would be a good way
>> to do this, but Mike said that the uevent maintainers (Greg that's
>> you?) did not think this was a good idea?
>
> KBOJ_CHANGE is a tricky one.  It has been used for a variety of
> different things, but usually it is used to show that a major change has
> happened with a device like a docking station plug in or out.
>
> How often do DM events happen?  What is triggering them?  How do you
> want to send them to userspace?  Through a sysfs file?  Why not just use
> your own netlink connection?

devicemapper is using uevents for:

a. dm-verity detected corruption
b. dm-multipath: path failed or reinstated
c. dm device renamed
d. there's also some use in md and bcache.

devicemapper uses DM_EVENT ioctl (yuck) for:

1. dm-thin pool data/metadata filling up (hit a threshold)
2. dm-cache is now clean
3. dm-log flushed or log failed
4. dm-raid error detected or sync complete

Instead of using uevent for everything, we could go to a separate 
genetlink for 1-4 instead of making them use uevent like a-d, but we'd 
end up with two different userspace notification techniques. At least to 
me, there doesn't seem to be much technical differentiation between the 
two lists.

(Would we want to then at some point transition any of a-d off of uevent 
and onto genetlink for consistency's sake?)

Thanks -- Regards -- Andy
