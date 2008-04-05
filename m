From: malahal@us.ibm.com
Subject: Re: dm-ioband = smarter than me
Date: Fri, 4 Apr 2008 20:23:05 -0700
Message-ID: <20080405032304.GA15564@us.ibm.com>
References: <2EABDA74-5CC4-4CA2-9839-1EA2C89F2548@blueboxgrp.com>
	<20080405014540.GB10916@us.ibm.com>
	<7ABA9490-2FB2-4886-8061-08BB30CA568B@blueboxgrp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7ABA9490-2FB2-4886-8061-08BB30CA568B@blueboxgrp.com>
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

Clint Moore [clint@blueboxgrp.com] wrote:
>
> On Apr 4, 2008, at 6:45 PM, malahal@us.ibm.com wrote:
>>
>> Don't you need to unmount first?
>
> 	I don't think that I missed that in the directions - do you have to do 
> that?  I just assumed that it didn't matter.  Still, I'm not sure how I 
> would do that to a root partition... unless you aren't supposed to use this 
> on one.

If you really want one on root device, do it before you mount the root
device and mount your ioband device as root device.

--Malahal.
PS: Try it on an umounted block device (or a loop device to see if it
works.)
