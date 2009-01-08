From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: [PATCH] Handle error paths.
Date: Thu, 8 Jan 2009 17:08:46 -0500
Message-ID: <20090108220846.GA21097@mars.virtualiron.com>
References: <1231442704-19032-1-git-send-email-konrad@virtualiron.com>
	<EE9F8178-CCDD-40A6-AD4E-9B8014FEB4A1@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <EE9F8178-CCDD-40A6-AD4E-9B8014FEB4A1@redhat.com>
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

On Thu, Jan 08, 2009 at 02:59:45PM -0600, Jonathan Brassow wrote:
> Ummm?

Here is the patch:

https://www.redhat.com/archives/dm-devel/2009-January/msg00058.html

>
>  brassow
>
> On Jan 8, 2009, at 1:25 PM, Konrad Rzeszutek wrote:
>
>>
>> On memory constrained systems, where a large amount of LUNs are
>> assigned (say more enough to make multipath blossom to 70% of available
>> memory space) forking would fail returning -ENOMEM. The kernel has enough
>> free pages for the new process, but when it clones the new child process
>> from the parent process space it accounts the parent process heap space
>> against the child (which counts for more pages than there are free pages).
>>
>> Using vfork passes a flag to clone which will inhibit this calculation
>> and instead check for free pages. The danger in using vfork is that the 
>> child
>> could use the values from the parent, but fortunatly we don't do that and
>> immediately call 'execve' swipping the process space free.
>>
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
