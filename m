From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: LVM on dmraid breakage
Date: Wed, 1 Aug 2007 15:29:47 -0500
Message-ID: <0EAFEA7F-BC32-4256-9C8E-3086756293C8@redhat.com>
References: <46B0EAEF.6090305@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <46B0EAEF.6090305@cfl.rr.com>
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

I'm not aware of a mechanism that LVM used to skip over owned  
devices... there may exist one.  However, you could use lvm filters  
to skip those underlying devices.

  brassow

On Aug 1, 2007, at 3:19 PM, Phillip Susi wrote:

> I am investigating a bug report involving the combination of lvm  
> and dmraid, and it seems to me that the problem is that lvm is  
> detecting the underlying partition on the primary disk and  
> accessing it directly rather than going through the raid device  
> made by dmraid.  I think that the problem is there is no facility  
> for dmraid to "claim" the physical disk so that lvm does not look  
> at it, and also to have lvm scan the raid device for physical volumes.
>
> Does anyone have any thoughts on how this might be accomplished?
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
