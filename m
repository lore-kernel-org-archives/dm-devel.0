From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: [dm-devel] [PATCH v12] dm: add support to directly boot to a
 mapped device
Date: Wed, 5 Jun 2019 10:35:49 +0200
Message-ID: <c5eae05c-f209-8578-f7fd-cd2feabb309c@redhat.com>
References: <20190221203334.24504-1-helen.koike@collabora.com>
 <5cf5a724.1c69fb81.1e8f0.08fb@mx.google.com>
 <d6b4fb26-9a1b-0acd-ce4a-e48322a17e7d@collabora.com>
 <5cf6c7e6.1c69fb81.e1551.8ac4@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5cf6c7e6.1c69fb81.e1551.8ac4@mx.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <swboyd@chromium.org>, Helen Koike <helen.koike@collabora.com>, dm-devel@redhat.com
Cc: wad@chromium.org, keescook@chromium.org, snitzer@redhat.com, linux-doc@vger.kernel.org, richard.weinberger@gmail.com, linux-kernel@vger.kernel.org, linux-lvm@redhat.com, enric.balletbo@collabora.com, kernel@collabora.com, agk@redhat.com
List-Id: dm-devel.ids

Dne 04. 06. 19 v 21:35 Stephen Boyd napsal(a):
> Quoting Helen Koike (2019-06-04 10:38:59)
>> On 6/3/19 8:02 PM, Stephen Boyd wrote:
>>>
>>> I'm trying to boot a mainline linux kernel on a chromeos device with dm
>>> verity and a USB stick but it's not working for me even with this patch.
>>> I've had to hack around two problems:
>>>
>>>   1) rootwait isn't considered
>>>
>>>   2) verity doesn't seem to accept UUID for <hash_dev> or <dev>
>>>
>>> For the first problem, it happens every boot for me because I'm trying
>>> to boot off of a USB stick and it's behind a hub that takes a few
>>> seconds to enumerate. If I hack up the code to call dm_init_init() after
>>> the 'rootdelay' cmdline parameter is used then I can make this work. It
>>> would be much nicer if the whole mechanism didn't use a late initcall
>>> though. If it used a hook from prepare_namespace() and then looped
>>> waiting for devices to create when rootwait was specified it would work.
>>
>> The patch was implemented with late initcall partially to be contained
>> in drivers/md/*, but to support rootwait, adding a hook from
>> prepare_namespace seems the way to go indeed.
> 
> Alright, great.
> 
>>
>>>
>>> The second problem is that in chromeos we have the bootloader fill out
>>> the UUID of the kernel partition (%U) and then we have another parameter
>>> that indicates the offset from that kernel partition to add to the
>>> kernel partition (typically 1, i.e. PARTNROFF=1) to find the root
>>> filesystem partition. The way verity seems to work here is that we need
>>> to specify a path like /dev/sda3 or the major:minor number of the device


Hi

As not a direct dm developer - isn't this going a bit too far ? -
This way you will need to soon move halve of the userspace functionality into 
kernel space.

IMHO would be way more progressive to start using initramdisk and let 
userspace resolve all the issue.

Clearly once you start to wait for some 'devices' to appear - then you will 
need to way for CORRECT device as well - since sda,sdb... goes in random 
order, so you would need to parse disk headers and so on.

What you are effectively doing at this moment is you are shifting/ballooning 
'ramdisk' code into kernel image - just to be named a kernel.

So why it is so big deal to start to use ramdisk on ChromeOS?
That would have solved most of problems you have or you will have instantly.

Regards

Zdenek
