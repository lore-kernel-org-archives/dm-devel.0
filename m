From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: Re: [PATCH] staging: writeboost: Add dm-writeboost
Date: Mon, 08 Dec 2014 06:04:41 +0900
Message-ID: <5484C0E9.3060707@gmail.com>
References: <5484498E.4000202@gmail.com> <20141207200834.GA2322@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141207200834.GA2322@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, snitzer@redhat.com, agk@redhat.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

> Greg Kroah-Hartman <gregkh@linuxfoundation.org> please, and also the
> driverdevel mailing list, which is where the rest of the staging patches
> go.
Sorry and yes, I will fix.

> And, I'll need an ack from the dm maintainers before I can accept this
> as something they think is ok and will get merged to the "real" part of
> the kernel someday.
OK.

Mike and Alasdair,
I need your ack

- Akira

On 12/8/14 5:08 AM, Greg KH wrote:
> On Sun, Dec 07, 2014 at 09:35:26PM +0900, Akira Hayakawa wrote:
>> --- /dev/null
>> +++ b/drivers/staging/writeboost/TODO
>> @@ -0,0 +1,47 @@
>> +TODO:
>> +
>> +- Expose bugs and fix them.
>> +- Clean up the interfaces. Some input values should be limited in case user may choose too big values.
>> +- Wait for proper review by Mike Snitzer.
>> +- Fix up documents.
>> +
>> +-------------------------------------------------------------------------
>> +
>> +Project Ideas:
>> +
>> +1. Add read caching feature
>> +Device-Mapper maintainer Mike Snitzer said that
>> +a single target should provide caching for both reads and writes.
>> +(cf. http://www.redhat.com/archives/dm-devel/2014-January/msg00078.html)
>> +
>> +To follow Mike's guide, I will implement read-caching for Writeboost.
>> +The great idea is, at least conceptually,
>> +sending back the read data to the write entrance.
>> +I didn't notice this simple idea at that time of previous discussion.
>> +
>> +This should be done background and
>> +some threshold to determine
>> +which sequence of data should be staged.
>> +
>> +This feature will be implemented step-by-step.
>> +I don't think this feature will change then interface drastically.
>> +
>> +2. Improve initialization time
>> +Some user complains that the initialization is too slow.
>> +
>> +Any ideas?
>> +
>> +3. Reduce metadata footprint
>> +Writeboost has a hash table in RAM for cache management.
>> +This isn't cheap.
>> +
>> +Any ideas?
>> +
>> +-------------------------------------------------------------------------
>> +
>> +Please send any patches
>> +To:
>> +Akira Hayakawa <ruby.wktk@gmail.com>
>> +Cc:
>> +Greg Kroah-Hartman <greg@kroah.com>
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> please, and also the
> driverdevel mailing list, which is where the rest of the staging patches
> go.
> 
> And, I'll need an ack from the dm maintainers before I can accept this
> as something they think is ok and will get merged to the "real" part of
> the kernel someday.
> 
> thanks,
> 
> greg k-h
> 
