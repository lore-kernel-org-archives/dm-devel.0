From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH 00/29] SLES resync
Date: Tue, 16 Jul 2013 11:20:54 +0200
Message-ID: <51E51076.1090108@profitbricks.com>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
	<51E3FEEF.7050301@profitbricks.com> <51E40334.6090108@suse.de>
	<51E4F1EF.8010606@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <51E4F1EF.8010606@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 16.07.2013 09:10, Hannes Reinecke wrote:
> On 07/15/2013 04:12 PM, Hannes Reinecke wrote:
>> On 07/15/2013 03:53 PM, Sebastian Riemer wrote:
>>> On 15.07.2013 15:00, Hannes Reinecke wrote:
>>> [...]
>>>> - When using libudev to read attribute variables we'd be getting
>>>>   an automated caching from libudev. Which is nice, unless the
>>>>   data changed in between. So I'd have to go back an roll our
>>>>   own accessors, skipping libudev here.
>>> [...]
>>>
>>> Hi Hannes,
>>>
>>> nice, that's what I've already reported. Could you point me to the fix
>>> commit(s) for this please?
>>>
>>
>> Gnaa. Merge error.
>> For some reason the patch _should_ be 0014, but then it contains
>> random merge errors.
>>
>> I'll be posting an additional patch for this.
>> Christophe, I'll be probably have to rebase the branch, so wait a
>> bit with pulling.
>>
> Sigh. Sebastian, you've got me confused.
> The patch you're talking about is 0004 (Increase dev_loss_tmo prior
> to fast_io_fail), which contains the code for reading from sysfs.
> 0014 is only related to that as it uses it in some more places.
> Only the 'state' attribute itself wasn't modified, so for that we'd
> still be using libudev.
> 
> So my patchset was in fact okay, but your point is valid, too.
> 
> Hence I've done a new patchset, identical to the first one, but with
> one additional patch reading the 'state' attribute directly from sysfs.

Hi Hannes!

Thanks for the explanation and adding the device state commit! Looks
good for me now in terms of my casual review.

Reported-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>

would have been good for the last patch of the new series. But okay.

Cheers,
Sebastian
