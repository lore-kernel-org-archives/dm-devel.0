From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: pre8
Date: Wed, 06 Apr 2005 09:02:54 -0700
Message-ID: <4254082E.1010101@us.ibm.com>
References: <20050405213223.GJ9049@agk.surrey.redhat.com>
	<20050406063240.GC12408@averon.dyndns.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050406063240.GC12408@averon.dyndns.org>
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

Christophe Varoqui wrote:
> On Tue, Apr 05, 2005 at 10:32:23PM +0100, Alasdair G Kergon wrote:
> 
>>I appear to have almost succeeded in squeezing 0.4.4-pre8 into 
>>RHEL4 U1, but I doubt I'll be allowed any more updates now except 
>>for severe bugs.
>>
> 
> Just to let you you know what I think is still needed before 0.4.4 :
> 
> o memory allocation error paths audit (mostly done in pre9)

The pathcheckers use sgio, right? The block layer sg io code does some 
allocations with GFP_KERNEL (bio_copy_user and bio_map_user for 
example), so if you are relying on that path for failback I think you 
will be in trouble.

> o don't loose events in multipathd
> o /dev/shm/cache has the same security problems you spotted in /tmp
> 
> I guess this last item will help justify your upgrading to 0.4.4
> 
> Regards,
> cvaroqui
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
