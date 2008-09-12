From: Adam Hamsik <haaaad@gmail.com>
Subject: Re: Regarding dm-linear.c
Date: Sat, 13 Sep 2008 01:58:13 +0200
Message-ID: <7F15CEC3-B773-40FA-BAD7-539F120B5482@gmail.com>
References: <42a668660809121018x4f43f72am2b610bf49d0c4788@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <42a668660809121018x4f43f72am2b610bf49d0c4788@mail.gmail.com>
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

Hi,
On Sep,Friday 12 2008, at 7:18 PM, rohit vashist wrote:

> Hi,
>
> I am currently working on device mapper and logical volume  
> manager.My question is whether dm-linear.c 's
> function linear_ctr and linear_map is called or not when we do  
> lvcreate.(or vgcreate,pvcreate).I am concentrating
> on linear mapping only.I did strace but i m not able to figure it out.

pvcreate and vgcreate are completely independent from device-mapper  
driver. Only lvcreate and other lv
commands communicates with dm driver.

I'm not linux expert :), but I think that during lvcreate only  
linear_ctr function is called. Because it allocates "linear context"  
for loaded table. Context is probably some target specific  
configuration memory
area.

linear_map is probably called only during IO. When is IO issued on  
virtual device mapped to a real
block device.

Regards

Adam.
