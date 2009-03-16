From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 2/3] set pthread stack size to at least
	PTHREAD_STACK_MIN
Date: Mon, 16 Mar 2009 18:08:47 -0500
Message-ID: <20090316230847.GM32340@ether.msp.redhat.com>
References: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
	<1236883093-2989-3-git-send-email-bmarzins@redhat.com>
	<49BA3ACF.1010101@suse.de>
	<20090313205514.GL32340@ether.msp.redhat.com>
	<49BE7A89.1040808@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <49BE7A89.1040808@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> On Mon, Mar 16, 2009 at 05:12:57PM +0100, Hannes Reinecke wrote:
>> This approach doesn't doesn't actually fix the bug that I see. The
>> problem I was seeing is that setting the stacksize too small just causes
>> pthread_attr_setstacksize() to fail, leaving you with the default stack
>> size. On some architectures, the default stacksize is large, like 10Mb.
>> Since you start one waiter thread per multipath device, every 100
>> devices eats up 1Gb of memory. Your approach always uses the default
>> stack size, unless it's too small.  I've never seen problems with the
>> stack being too small. Only too large. Maybe your experience has been
>> different.
>>
> Me neither. Makes me wonder if we _really_ need to set the stacksize.
> After all, I'm not aware that we're having any excessive stack usage
> somewhere. Maybe we can simplify it by removing the stack attribute
> setting altogether?
>
> I'll see if I can get the different stacksizes and just compare them
> to the 'updated' setting. Maybe there's no big difference after all...

I definitely see a problem if we use the default stacksize on ia64
machines.  In RHEL5 at least, it's 10Mb per thread.  With one waiter
thread per multipath device, you get a gigabyte of memory wasted on
machines with over a hundred multipath devices.

>> The other problem is that when I actually read the pthread_attr_init man
>> page (it can fail. who knew?), I saw that it can fail with ENOMEM. Also,
>> that it had a function to free it, and that the result of reinitializing
>> an attr that hadn't been freed was undefined.  Clearly, this function
>> wasn't intended to be called over and over without ever freeing the
>> attr, which is how we've been using it in multipathd. So, in the spirit
>> of writing code to the interface, instead of to how it appears to be
>> currently implemented, how about this.
> Hmm. You're not freeing the attribute for all non-logging threads neither.

But I only allocate it once.

> Oversight?

Any time a new device is added, we need the waiter thread attribute.  I
suppose I could free it after each waiter thread is started, and then
reallocate it again, but it seems like sort of a waste since we want the
same values every time.

I don't explicitly deallocate it on shutdown, but no matter what the
implementation is, I expect it will be cleaned up when multipathd
ends.

Or am I missing something?

-Ben 
