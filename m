From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [dm-devel] [PATCH] staging: writeboost: Add dm-writeboost
Date: Wed, 10 Dec 2014 23:43:46 +0900
Message-ID: <54885C22.3030808@gmail.com>
References: <5484498E.4000202@gmail.com> <20141207200834.GA2322@kroah.com> <5484C0E9.3060707@gmail.com> <20141209151253.GA17660@debian> <20141210100033.GA21108@debian> <548827BD.3050803@gmail.com> <20141210123349.GC21108@debian> <548843A0.6040906@gmail.com> <20141210131325.GD21108@debian> <54884B33.4090709@gmail.com> <20141210134223.GE21108@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141210134223.GE21108@debian>
Sender: linux-kernel-owner@vger.kernel.org
To: ejt@redhat.com
Cc: dm-devel@redhat.com, gregkh@linuxfoundation.org, snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 12/10/14 10:42 PM, Joe Thornber wrote:
> On Wed, Dec 10, 2014 at 10:31:31PM +0900, Akira Hayakawa wrote:
>> Joe,
>>
>>> So you copy the bio payload to a different block of ram and then
>>> complete the bio?  Or does the rambuf refer to the bio payload
>>> directly?
>> Good question.
>> The answer is, copy the data (got by bio_data(bio)) to rambuf once
>> and ack if it's not barrier things.
>> It would be nice if data in rambuf points to bio payload but it now copies
>> because bio payload can be reused after completion. Am I right?
>> Is there a way of eliminate memory copying?
> 
> You *have* to eliminate this memory copying.  Remap the bios to the
> relevant portion of your log, and don't complete them until you log
> chunk is coherent.
> 

Barrier writes don't ack until the log is written on cache device.
I guess treating other writes as well will do this work.

But, it will be much better if I can do this by manipulating reference count
of the bio payload. I am not sure how the implementation would be.

Anyway, thanks for advice,

- Akira
