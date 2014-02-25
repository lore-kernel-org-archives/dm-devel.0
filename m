From: John Utz <John.Utz@wdc.com>
Subject: Re: creating a dm-linear.ko in a current kernel.
Date: Tue, 25 Feb 2014 16:23:20 +0000
Message-ID: <8A51900D08212F40B3DE22453052F6980B97D1EF@wdscexmb02>
References: <8A51900D08212F40B3DE22453052F6980B97CF4E@wdscexmb02>
	<8A51900D08212F40B3DE22453052F6980B97CFA3@wdscexmb02>,
	<530C761C.5010809@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <530C761C.5010809@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Bryn M. Reeves" <bmr@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Good Morning Bryn;

Thankyou!
________________________________________
From: Bryn M. Reeves [bmr@redhat.com]
Sent: Tuesday, February 25, 2014 2:53 AM
To: device-mapper development
Cc: John Utz
Subject: Re: [dm-devel] creating a dm-linear.ko in a current kernel.

On 02/24/2014 10:44 PM, John Utz wrote:
> Solved my own issue methinks, the name of the module that i am
> finding in drivers/md/ is linear.ko, not dm-linear.ko. that was

That's the MD linear personality not the device-mapper linear target. It
allows you to build JBOD (concatentation) arrays using the MD RAID
subsystem.

Could you briefly explain the concept of 'personality' in this context? I see it referred to but i have yet to find an explanation thereof. perhaps i have been looking in the wrong place.

I am also motivated by your response to see if i am barking up the wrong tree. :-)

I have a need to harness a hard drive like thing that can only be written to in linear fashion using device mapper.

I had assumed that i needed to start from the existing linear implementation that is in dm-linear.

Am I wrong and everything i need is already coded and i just need to create an appropriate configuration file of some kind?

Please advise when you get a chance.

Thankyou in advance.

johnu

<SNIP>

Regards,
Bryn.
