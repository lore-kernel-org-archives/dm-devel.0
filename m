From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] Handle error paths.
Date: Thu, 8 Jan 2009 14:59:45 -0600
Message-ID: <EE9F8178-CCDD-40A6-AD4E-9B8014FEB4A1@redhat.com>
References: <1231442704-19032-1-git-send-email-konrad@virtualiron.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1231442704-19032-1-git-send-email-konrad@virtualiron.com>
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

Ummm?

  brassow

On Jan 8, 2009, at 1:25 PM, Konrad Rzeszutek wrote:

>
> On memory constrained systems, where a large amount of LUNs are
> assigned (say more enough to make multipath blossom to 70% of  
> available
> memory space) forking would fail returning -ENOMEM. The kernel has  
> enough
> free pages for the new process, but when it clones the new child  
> process
> from the parent process space it accounts the parent process heap  
> space
> against the child (which counts for more pages than there are free  
> pages).
>
> Using vfork passes a flag to clone which will inhibit this calculation
> and instead check for free pages. The danger in using vfork is that  
> the child
> could use the values from the parent, but fortunatly we don't do  
> that and
> immediately call 'execve' swipping the process space free.
>
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
