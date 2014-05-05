From: "John L. Utz III (WDC)" <john.utz@wdc.com>
Subject: Re: Can device mapper be taught to return new errors and
 sense codes that are part of the ZAC/ZBC spec?
Date: Mon, 05 May 2014 15:57:08 -0700
Message-ID: <53681744.40709@wdc.com>
References: <8A51900D08212F40B3DE22453052F6981D0EEEA9@wdscexmb02>
	<20140503160640.GB11659@thunk.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20140503160640.GB11659@thunk.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Ted;

Thankyou so much for the prompt response!

On 05/03/2014 09:06 AM, Theodore Ts'o wrote:
> On Sat, May 03, 2014 at 02:40:51AM +0000, John Utz wrote:
>> This question is also related to the same simulator project mentioned in my previous email.
>>
>> The ZAC/ZBC spec(s) specify some errors that dont currently
>> exist. For the simulator to be successful, it needs to be able to
>> respond appropriately to being asked to do things that other drives
>> are allowed to do, but this one is not.
>>
>> So read's and writes for the simulator have to return errors that
>> dont currently exist in the kernel as of today.
>>
>> I notice that struct dm_target has an error string entry, but that
>> is only for the ctor and it's a string.
>>
>> Can any of you provide any suggestions of guidance on this topic?
> My recommendation is to make things configurable.  One option is to
> treat it as if it were a real ZAC/ZBC specification, which is to treat
> an out-of-policy write as an I/O error --- after all, this is what a
> real restricted-mode drive would do.

No argument here or with any of the other comments that you make. :-)

However, none of these great things are going to happen if I can't 
figure out how to get device mapper to return the new errors. :-P

I will continue to look at the dm source, but I hope one of the dm 
eminences on the list can provide me with some hints as to what I should 
be looking at WRT to making it possible to return these new errors for 
reads and writes.

> Another option is to simply keep statistics on the number
> out-of-policy writes, and to use tracepoints so that developers can
> have some kind of metric of how "SMR friendly" their
> application/filesystem is currently faring.
>
> One final option, which is a nice-to-have, is to try to model a drive
> managed or host aware drive by adding latency to various I/O
> operations after out-of-policy I/O operations have occurred.  It
> doesn't have to be perfect, and it's very likely that a precise model
> of what drives will actually do will be a closely held secret.  So
> what I'd suggest is to make the delay model to be a pluggable
> interface with with an EXPORT_SYMBOL interface (with an explicit note
> that the intention that the intent of the author is to allow
> proprietary delay modelling modules to be able to use this interface).
>
> Eventually, manufacturers desires to try to keep the delay profiles a
> proprietary a secret will be hopeless, since open source developers
> can just simply carry out timing attacks on SMR drives and develop
> statistical models that that will in all likelihood be very good.  But
> given our experience with how SDD manufactuers have tried to keep the
> erase block and page size of their products to be a proprietary secret
> (despite open source programs that figure this out experimentally),
> there really is no limit to the stupidity and paranoia of product
> managers and lawyers....

tnx!

johnu
>
> 	      	       	  	  	       - Ted
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
