From: Jens Axboe <axboe@kernel.dk>
Subject: Re: dm: propagate QUEUE_FLAG_NO_SG_MERGE
Date: Fri, 15 Aug 2014 12:47:06 -0600
Message-ID: <53EE55AA.2010209@kernel.dk>
References: <x49iom3hvle.fsf@segfault.boston.devel.redhat.com>	<20140811011108.GA13946@redhat.com> <x49mwbbozsb.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x49mwbbozsb.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 08/11/2014 08:40 AM, Jeff Moyer wrote:
> Mike Snitzer <snitzer@redhat.com> writes:
> 
>> Hi Jeff,
>>
>> Thanks for the patch.  But I think you need the following tweak.
>> Otherwise if the DM table is reloaded (and the devices in the table
>> happen to change) the flag won't get cleared as needed.
> 
> Ah, thanks for the education.  Looks good to me.

Ditto, you can add my acked-by, if not already queued up etc.

-- 
Jens Axboe
