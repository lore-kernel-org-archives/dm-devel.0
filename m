From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: device mapper integrated loops - and one more year !
Date: Mon, 9 Oct 2006 17:36:40 -0500
Message-ID: <950bd3ad1504b8fb03e73b6236a808bc@redhat.com>
References: <2c53b31c0610060238nef13171ma6f4a42ba755c3b0@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2c53b31c0610060238nef13171ma6f4a42ba755c3b0@mail.gmail.com>
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


On Oct 6, 2006, at 4:38 AM, David Guyon Martin wrote:

> On Thu, 5 Oct 2006 20:40:05 +0100 Alasdair G Kergon wrote:
>
>> Something like:
>>   
>> http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/ 
>> editing/dm-loop.patch
>> now perhaps?
>
>> (And there are patches for dmsetup to become a drop-in losetup  
>> replacement.)
>
> Yes! This patch add a new file to the kernel tree, dm-loop.c:
> "This implements a loopback target for device mapper allowing a regular
> file to be treated as a block device."
>
> Great !!! At last :)
> It seems this dm-loop is quite new, less than a month...
> As I understand it I need kernel 2.6.18-rc7 to use it, right ?
>
> I really thank you a lot for your quick answer and link.
>
> Does anyone has yet a feedback about this dm-loop ?
>

I know Heinz Mauelshagen has been looking at it and already has some  
performance improvements.  Perhaps he'll post the updated patches soon.

  brassow
