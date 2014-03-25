From: David Lang <david@lang.hm>
Subject: Re: [dm-devel] [PATCH RFC v1 00/01] dm-lightnvm introduction
Date: Mon, 24 Mar 2014 20:08:02 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1403242004580.527@nftneq.ynat.uz>
References: <1395383538-18019-1-git-send-email-m@bjorling.me> <20140321090630.GA30044@debian> <532C5930.7040107@bjorling.me>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <532C5930.7040107@bjorling.me>
Sender: linux-kernel-owner@vger.kernel.org
To: Matias Bjorling <m@bjorling.me>
Cc: device-mapper development <dm-devel@redhat.com>, snitzer@redhat.com, agk@redhat.com, neilb@suse.de, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, 21 Mar 2014, Matias Bjorling wrote:

> On 03/21/2014 02:06 AM, Joe Thornber wrote:
>> Hi Matias,
>>
>> This looks really interesting and I'd love to get involved.  Do you
>> have any recommendations for what hardware I should pick up?
>
> Hi Joe,
>
> The most easily available platform is OpenSSD
> (http://www.openssd-project.org). It's a little old, but still very
> functional. When there's a good firmware implementation, I think it will
> be easier for the custom SSD vendor's to jump on board with their own
> firmware.

Is this something that would make sense to use for accessing the NAND flash 
that's being used on routers nowdays? Talking with the OpenWRT folks, they are 
having trouble supporting those devices because the flash may contain defects 
and squashfs doesn't work in such an environment. This appears to be the one 
remaining problem preventing a lot of new routers from working.

If this can work as a shim layer between the hardware and the filesystem for 
OpenWRT, you would gain a very large userbase rather quickly.

David Lang
