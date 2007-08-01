From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: LVM on dmraid breakage
Date: Wed, 1 Aug 2007 16:44:28 -0500
Message-ID: <140BA4BE-4B0E-472B-8E4C-29AF02D475C5@redhat.com>
References: <46B0EAEF.6090305@cfl.rr.com>
	<0EAFEA7F-BC32-4256-9C8E-3086756293C8@redhat.com>
	<46B0F8E9.5000609@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46B0F8E9.5000609@cfl.rr.com>
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


On Aug 1, 2007, at 4:19 PM, Phillip Susi wrote:

> Jonathan Brassow wrote:
>> I'm not aware of a mechanism that LVM used to skip over owned  
>> devices... there may exist one.  However, you could use lvm  
>> filters to skip those underlying devices.
>>  brassow
>
> LVM filters?

Look in /etc/lvm/lvm.conf for "filter".  There are some examples  
there.  Be careful though, if you exclude your root partion you may  
be in for future pain.

  brassow
