From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] md: dm-crypt: Add option to re-use a new
	global work-queue.
Date: Thu, 22 Apr 2010 20:47:55 +0200
Message-ID: <4BD099DB.2020108@redhat.com>
References: <1271958538-11193-1-git-send-email-san@google.com>	
	<4BD08F78.4000701@redhat.com>
	<q2q236ccac1004221108y276b7e27x2a30e8a1eef77b03@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <q2q236ccac1004221108y276b7e27x2a30e8a1eef77b03@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: San Mehat <san@google.com>
Cc: Brian Swetland <swetland@google.com>, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>, Christophe Saout <christophe@saout.de>
List-Id: dm-devel.ids

On 04/22/2010 08:08 PM, San Mehat wrote:
> On Thu, Apr 22, 2010 at 11:03 AM, Milan Broz <mbroz@redhat.com> wrote:
>> On 04/22/2010 07:48 PM, San Mehat wrote:
>>> Typically, dm-crypt instances each have their own set of kcrypt/kcrypt_io
>>> work-queues. This patch adds an option which will create one set of
>>> work-queues on init, and re-uses them for all dm-crypt target instances.

>> Can you explain the real reason for this patch?
>>
> 
> Sure, I'd be happy to explain.

(Please add this always to patch header.)

> 
>   Upcoming versions of android are about to start using dm/dm-crypt
> heavily, having
> a large number of small dm-crypt instances running on the device (hard
> to tell just
> how many, but i've seen cases where up to 50 or 60 instances may be
> running). This ends up creating 100 - 120 kernel threads, and I was
> simply trying to cut that down.

Sorry, but I don't take this argument. "Too many notes!" :-)

So the problem is with memory allocation? Scheduler? Or where?
Kernel threads should be cheap.

If you need 60 crypt devices, you almost surely hit at least starvation
problem with one global queue!
(Just curious - what are these crypt devices doing?)

> I'd be more than happy to discuss alternatives; but do we *really*
> need 2 work-queue threads per instance?

yes. 

For separate io queue - see commit cabf08e4d3d1181d7c408edae97fb4d1c31518af

| Add post-processing queue (per crypt device) for read operations.

| Current implementation uses only one queue for all operations
| and this can lead to starvation caused by many requests waiting
| for memory allocation. But the needed memory-releasing operation
| is queued after these requests (in the same queue).


(and there were another problem with async crypt - callback is called
in interrupt context, bio must be submitted from separate workqueue IIRC)

>> (cc: Alasdair - I think he will not accept the patch anyway.)
> 
> Probably not, but at least we can get the discussion going :)

I am not saying that I do not want to discuss this - but we must know
the real problems many queues are causing first.
And then think about possible solutions.

Milan
