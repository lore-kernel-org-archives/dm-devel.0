From: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Subject: Re: dm: move dm_table_destroy() to same header as dm_table_create()
Date: Wed, 5 Apr 2017 10:04:20 +0200
Message-ID: <f7e4e7e7-2402-28ef-a921-cda40174afd3@collabora.com>
References: <20170328183102.80620-1-briannorris@chromium.org>
 <20170328193150.GA21445@redhat.com> <20170404223552.GA121849@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170404223552.GA121849@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brian Norris <briannorris@chromium.org>, Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi,

On 05/04/17 00:35, Brian Norris wrote:
> On Tue, Mar 28, 2017 at 03:31:51PM -0400, Mike Snitzer wrote:
>> On Tue, Mar 28 2017 at  2:31pm -0400,
>> Brian Norris <briannorris@chromium.org> wrote:
>>
>>> If anyone is going to use dm_table_create(), they probably should be
>>> able to use dm_table_destroy() too. Move the dm_table_destroy()
>>> definition outside the private header, near dm_table_create()
>>>
>>> Signed-off-by: Brian Norris <briannorris@chromium.org>
>>
>> Not seeing why we need dm_table_create() exposed.  So I think you went
>> the wrong way with this.  Unless you have an actual need, I'd prefer to
>> see dm_table_create() moved from include/linux/device-mapper.h to
>> drivers/md/dm.h
> 
> We've been carrying code in our ChromeOS kernel to parse a cmdline arg
> for setting up early DM maps -- e.g., a dm-verity rootfs without using
> an initramfs. We currently use dm_table_create() from init/*.c (and we
> *should* be using dm_table_destroy() in the error paths). So I'm
> certainly not going to send the patch to do the reverse :)
> 
> Enric is working on cleaning up this work to send here, so if you don't
> want to see this patch now, you may well see it later.
> 

As Brian told you we have a use case that uses the dm_table_create and others
from init/*.c, I expect have a first patches during this week, if it's ok I'll
include this patch in my patchset so you have the overall of what we are talking
about.

Cheers,
 Enric

> Brian
> 
