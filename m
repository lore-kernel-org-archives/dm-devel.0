From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: md_component_detection = 1
Date: Tue, 15 Feb 2005 22:51:41 +0100
Message-ID: <42126EED.2030607@free.fr>
References: <000001c5136d$3b3502a0$11051aac@pcp41116>	<42126793.4030407@free.fr>
	<20050215213425.GK14093@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050215213425.GK14093@agk.surrey.redhat.com>
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

Alasdair G Kergon wrote:

>On Tue, Feb 15, 2005 at 10:20:19PM +0100, christophe varoqui wrote:
>  
>
>>   types = [ "device-mapper", 254 ]
>>    
>>
> 
>The number is actually related to the partitioning allowed on the device.
>
> * Devices are only checked for partition tables if their minor number
> * is a multiple of the number corresponding to their type below
> * i.e. this gives the granularity of whole-device minor numbers.
> * Use 1 if the device is not partitionable.
>
>device-mapper devices don't get partitioned by the kernel
>so use 1 instead of 254.
>
>  
>
Ah, thank you for pointing this out.
Will update the FAQ accordingly.

regards,
cvaroqui

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
