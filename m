From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH v3 0/8] dm-raid (raid456) target
Date: Mon, 10 Jan 2011 14:14:59 -0600
Message-ID: <5F7256B3-BE4F-489F-8B2B-0E830A8BBE0B@redhat.com>
References: <1292899065-31943-1-git-send-email-snitzer@redhat.com> <20101221141443.5aea0b12@notabene.brown> <20110105223628.GA13164@redhat.com> <20110106214645.2bd321f4@notabene.brown> <D3D5994A-7CA9-43BE-8B81-A09139220A9E@redhat.com> <20110110113718.1e042548@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110110113718.1e042548@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids


On Jan 9, 2011, at 6:37 PM, NeilBrown wrote:

>>> Also:
>>>
>>> 3:	<#raid_devs> <meta_dev1> <dev1> .. <meta_devN> <devN>
>>>
>>> This doesn't allow offsets into the various devices like dm-stripe,
>>> dm-linear, dm-raid1 all do.
>>
>> This is a conscious choice.  The offset was discarded because it is
>> unneeded.
>
> Famous last words!!!

:)

>
> When reshaping a RAID5/6 to change the chunk size or layout, or when
> converting an N drive RAID5 to N+1 drive RAID6, it makes it a lot  
> easier if
> you can can change the data offset at the same time.  Then you don't  
> have to
> keep backing up data.  md cannot do this yet but I hope to add the  
> code soon
> and because 'data_offset' is a distinct value it is conceptually  
> easy to do.
> If 'data_offset' is assumed to be zero, then it isn't.

I guess I don't understand this part.  Why would you need to change  
the data offset?  Especially the offset as it relates to the  
individual drives?

> But I don't know to what extent you are planning on supporting  
> reshaping of
> arrays....

I don't see a reason why this can't be completely supported...

  brassow

