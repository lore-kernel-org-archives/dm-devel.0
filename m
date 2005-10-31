From: "Bruen, Mark" <mbruen@trilegiant.com>
Subject: Re: /dev/dm-N and Veritas?
Date: Mon, 31 Oct 2005 15:04:08 -0500
Message-ID: <436678B8.9090804@trilegiant.com>
References: <4366702B.1010206@trilegiant.com>
	<1130788268.13850.128.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1130788268.13850.128.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: christophe.varoqui@free.fr, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I would like to use "device mapper" for multipathing which I have setup 
and Veritas Volume Manager for Virtualization. I normally  create LUNs 
on the SAN and they show up as /dev/sdX, /dev/sdY, etc... I initialize 
them for use with Veritas Volume Manager which allows me to expand 
filesystems across multiple LUNs, create snapshots, split disks off for 
deporting, etc...
I have many years of Veritas experience and none with LVM so I would 
(for now anyway) like to use the multipathed devices /dev/dm-N with 
Veritas. Is it possible?
Thanks.
    -Mark

Christophe Varoqui wrote:

>On lun, 2005-10-31 at 14:27 -0500, Bruen, Mark wrote:
>  
>
>>Anyone using Veritas to manage their /dev/dm-N devices?
>>Thanks.
>>    
>>
>
>I guess few people can understand what you mean.
>For one, I can't, sorry.
>
>Regards,
>cvaroqui
>
>
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
>  
>

-- 
Mark Bruen
mbruen@trilegiant.com
203-416-2358

What information consumes is rather obvious: it consumes the attention
of it's recipients. Hence a wealth of information creates a poverty of
attention..."
-Herbert Simon, Computer Scientist, Psychologist, Nobel Laureate
in Economics, 1978

The information in this electronic mail message is Trilegiant
Confidential and may be legally privileged. It is intended solely for
the addressee(s). Access to this Internet electronic mail message by
anyone else is unauthorized. If you are not the intended recipient, any
disclosure, copying, distribution or action taken or omitted to be
taken in reliance on it is prohibited and may be unlawful.

The sender believes that this E-mail and any attachments were free of 
any virus, worm, Trojan horse, and/or malicious code when sent. This 
message and its attachments could have been infected during transmission.
By reading the message and opening any attachments, the recipient accepts
full responsibility for taking protective and remedial action about 
viruses and other defects. Trilegiant Corporation is not liable for any
loss or damage arising in any way from this message or its attachments.
