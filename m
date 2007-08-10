From: Tom Parker <palfrey@tevp.net>
Subject: Re: Using device-mapper with many targets
Date: Sat, 11 Aug 2007 01:53:49 +0200
Message-ID: <46BCFA8D.4070607@tevp.net>
References: <46AFA7D0.8040900@tevp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46AFA7D0.8040900@tevp.net>
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

Tom Parker wrote:
> With RAID 1 targets, I can get up to about 600 targets before the whole 
> thing seems to lock hard (dmsetup itself gets OOM'ed, and I can't get 
> back to the shell or to any other of the virtual terminals). While 
> scaling up to that point, I find that for every RAID 1 target, 
> device-mapper seems to eat ~.5MB of RAM. The targets themselves are 
> currently very small (1MB I think) as this was more a test in many 
> targets, rather than in large targets.

I've been trying to investigate this on my own, and ran into the issue 
that there's both a dm-raid1.c file in the 2.6.22 kernel, *and* in the 
device-mapper CVS. Additionally, the dm-raid1.c in the device-mapper CVS 
appears to be out of sync with current kernels. This does raise the 
issue of which one I should be investigating regarding the memory issues....

Any good reason why this is? Should I just be looking at the current 
kernel versions of that file?

Thanks,

Tom

P.S. If anyone knows any good tools for getting per-module memory usage 
(preferably with alloc/free tracing) out of the kernel, I'd love to know 
about them. I'm tempted at the moment to go with manual printk adding 
just because it's simple and it'll work.
