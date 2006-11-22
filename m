From: Roland Paterson-Jones <roland@rolandpj.com>
Subject: Re: Re: device mapper integrated loops - and one more
	year !
Date: Wed, 22 Nov 2006 10:29:02 +0200
Message-ID: <45640A4E.9090509@rolandpj.com>
References: <1439173022@web.de>
	<45636B89.7080407@redhat.com>	<456375CF.10006@rolandpj.com>
	<456389C4.9000902@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <456389C4.9000902@redhat.com>
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

Hi Bryn

Bryn M. Reeves wrote:

>>Does this mean that dm-loop does not support sparse loop-back files?
>>    
>>
>
>This version doesn't, no. It's not hard to add this though, although it
>does have some implications if they are used. We've had some discussions
>over whether this is necessary/desirable - is this something you'd like
>to see?
>  
>
We very much need sparse files for our use-case (fairly dynamically 
setting up (fake) devices on demand). Sparse files save time to copy, 
for example.

Would you do this by using file ops to lazily fill holes on first write? 
Is this compatible with S_SWAPFILE? For read purposes, holes can be 
mapped to zero device, I presume.

>The bmap approach is also used for swapfiles (mm/swapfile.c) - the
>S_SWAPFILE inode flag was added in 2.6.16 when the changeover to mutexes
>happened.
>  
>
Ah. I did see that - should have made the connection. So which file 
systems support (obey?) S_SWAPFILE?

I much prefer the approach of mapping to underlying device, cos it 
sidesteps the file/page cache (loopback causes OOM!). The other annoying 
thing about loopback is that it re-nices itself to super-low (should 
that be high?) priority, so we can starve other system daemons by 
banging on the loopback device.

>There are patches to dmsetup that allow it to be called as "losetup" or
>"dmlosetup", providing the same options as the regular version, so it
>should be straightforward to compare.
>  
>
Cool. Where can I get a patch to play with? I presume device-mapper 
plug-ins can be compiled as modules?

Regards
Roland #2
