From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH] Create: tell udev md device is not ready when first
 created.
Date: Wed, 3 May 2017 10:44:37 -0400
Message-ID: <0a91080f-5f08-4970-3ab1-99ac2f63a2df@gmail.com>
References: <149265560315.31004.3851231165281498425.stgit@noble>
 <149265600601.31004.323865505557190368.stgit@noble>
 <dedd27cd-9c2e-f244-d8aa-7a074679d3c6@gmail.com>
 <87mvbasqx6.fsf@notabene.neil.brown.name>
 <40a5fbff-9eef-07b3-fe1b-fb9a888cfb8b@redhat.com>
 <87h919ruj5.fsf@notabene.neil.brown.name>
 <6bd347e1-170c-48e9-1171-09ff143ace83@redhat.com>
 <c5fe5d16-5ca6-94b0-fd5b-0b6009d78bab@gmail.com>
 <2f431da6-0dce-b485-4109-6f8669814430@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2f431da6-0dce-b485-4109-6f8669814430@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rajnoha <prajnoha@redhat.com>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 05/03/2017 10:13 AM, Peter Rajnoha wrote:
> On 05/02/2017 03:32 PM, Jes Sorensen wrote:
>> On 04/28/2017 05:28 AM, Peter Rajnoha wrote:
>>> On 04/28/2017 07:05 AM, NeilBrown wrote:
>>>>
>>>> When an array is created the content is not initialized,
>>>> so it could have remnants of an old filesystem or md array
>>>> etc on it.
>>>> udev will see this and might try to activate it, which is almost
>>>> certainly not what is wanted.
>>>>
>>>> So create a mechanism for mdadm to communicate with udev to tell
>>>> it that the device isn't ready.  This mechanism is the existance
>>>> of a file /run/mdadm/created-mdXXX where mdXXX is the md device name.
>>>>
>>>> When creating an array, mdadm will create the file.
>>>> A new udev rule file, 01-md-raid-creating.rules, will detect the
>>>> precense of thst file and set ENV{SYSTEMD_READY}="0".
>>>> This is fairly uniformly used to suppress actions based on the
>>>> contents of the device.
>>>
>>> The scans in udev are primarily directed by blkid call which detects the
>>> signatures and based on this information various other udev rules fire.
>>>
>>> The blkid as well as wipefs uses common libblkid library to detect these
>>> signatures - is mdadm going to use libblkid to wipe the signatures on MD
>>> device initialization or is it relying on external tools to do this? How
>>> is mdadm actually initializing/wiping the newly created MD device?
>>
>> mdadm doesn't wipe data and it isn't supposed to. Being able to create
>> an array from drives with existing data is a feature.
>>
>> It is the responsibility of the system administrator to handle drives
>> with existing data, in the same way the administrator is expected to
>> handle insertion of USB drives or external drives being powered on.
>
> There's a difference though - when you're *creating* a completely new
> device that is an abstraction over existing devices, you (most of the
> time) expect that new device to be initialized. For those corner cases
> where people do need to keep the old data, there can be an option to do
> that. When you're inserting existing drives, you're not creating them -
> when those device come from factory (they're "created"), they never
> contain garbage and old data when you buy them.

Sorry, you are once again assuming *your* corner case to be the default 
that everyone else expects. mdadm users (except for you and anaconda) 
expect the current behavior.

Devices that come from the factory pretty much always contain old data, 
plugin a USB drive and it will be filled with windows backup crap.

Jes

