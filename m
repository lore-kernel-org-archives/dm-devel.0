From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: device mapper mapping across reboot
Date: Fri, 9 Mar 2018 14:31:41 +0100
Message-ID: <f0e41723-159a-fe39-42f2-4a2ef1466bfa@redhat.com>
References: <CAN-6CVmztjkV6JL0k3N8Vh47Tr4oY_8Jj6-JL16b2YY5yNEHOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAN-6CVmztjkV6JL0k3N8Vh47Tr4oY_8Jj6-JL16b2YY5yNEHOA@mail.gmail.com>
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
To: jitendra kumar khasdev <jkhasdev@gmail.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Dne 9.3.2018 v 10:58 jitendra kumar khasdev napsal(a):
> Hi All,
> 
> I wrote the basic target using device mapper framework. Using dmsetup utility 
> I am able to create device node under /dev/mapper/my_custom_mapper.
> 
> But when I do reboot the system, it lost the mapping. Is there any way by 
> which I can create mapping during boot like LVM does.
> 

Hi

lvm2 is exactly solving this problem as it maintains consistent 'metadata' on 
every device - so upon reboot devices are discovered and from their metadata 
dm tables are actived/restored.

So  are you looking for recreation of all the lvm2 infrastructure for this 
relatively quite complex task ?

Or you just want to 'create' DM after kernel is booted ?

Or you even want to pass 'DM' table line on kernel boot option line - so even 
your boot device is a 'DM' device ?


It's unclear which problem are you actually solving so please be more specific.


Regards

Zdenek
