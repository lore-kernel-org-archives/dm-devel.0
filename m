From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] dm: update workqueue usages
Date: Tue, 14 Dec 2010 16:49:25 +0100
Message-ID: <4D079205.3010204@kernel.org>
References: <1292181055-25696-1-git-send-email-tj@kernel.org>
	<4D053D49.1010605@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D053D49.1010605@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, snitzer@redhat.com
List-Id: dm-devel.ids

On 12/12/2010 10:23 PM, Milan Broz wrote:
> On 12/12/2010 08:10 PM, Tejun Heo wrote:
> 
>> * I'm pretty sure workqueues in dm-crypt would benefit from using
>>   multithreaded workqueue but people already seem to be working on it
>>   so I left it alone.
> 
> Yes, FYI it is already here with new queue api:
> http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-crypt-scale-to-multiple-CPUs.patch

Yeah, that looks much better.

> (So that one chunk for dm-crypt in patch 3/6 can be dropped.)

I'll regenerate the series w/o the chunk.  BTW, against which tree
should it be generated?

Thanks.

-- 
tejun
