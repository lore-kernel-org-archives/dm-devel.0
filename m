From: Tim Kirk <kirk@ysbl.york.ac.uk>
Subject: Re: dm-devel : disks being taken over by dm-raid/dm at
	boot.
Date: Thu, 21 Sep 2006 14:11:44 +0100
Message-ID: <0B4D5886-ADB2-420F-9DB6-F9540EF44FE8@ysbl.york.ac.uk>
References: <20060915160030.725E07358C@hormel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060915160030.725E07358C@hormel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids


On 15 Sep 2006, at 17:00, dm-devel-request@redhat.com wrote:

>
>
> Message: 2
> Date: Thu, 14 Sep 2006 09:41:54 -0400
> From: AJ Lewis <alewis@rackable.com>
> Subject: Re: [dm-devel] (no subject)
>
> Sounds like dmraid is grabbing them.  I'm not sure where the  
> configuration for
> dmraid is, but that's a starting point.
>
> Message: 6
> Date: Thu, 14 Sep 2006 10:00:06 -0400
> From: Dave Wysochanski <dave.wysochanski@redhat.com>
> Subject: Re: [dm-devel] (no subject)
>
>> Surely there is some way to tell device-mapper to leave things alone?
>> I simply need four drives that I can use as four separate units - no
>> RAIDing, nothing fancy, but this it seems impossible to tell the OS
>> that...
>>
> Did you try blacklisting in /etc/multipath.conf?
>

Thanks AJ, Thanks Dave.

I don't think I'm using multipathing : have no /etc/multipath.conf at  
all.

I thought I'd stopped dmraid, but it was still registering the drives  
it seems. I simply commented the dmraid startup lines out of /etc/ 
rc.sysinit and everything seems to be working how I want it to now.

There must be a nicer way of telling dmraid to leave things alone,  
but I couldn't find one and as this is working (and I'm not expecting  
to have to put a RAID on this machine in the future) I'm not too  
worried.

Cheers,

Tim
