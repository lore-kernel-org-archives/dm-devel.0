From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: setup Pathpriority manually
Date: Thu, 21 Jun 2007 11:57:47 -0700
Message-ID: <1182452267.5301.123.camel@linuxchandra>
References: <e9cb6ff40706211113p3ea83a3di35658b19c5145b4d@mail.gmail.com>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e9cb6ff40706211113p3ea83a3di35658b19c5145b4d@mail.gmail.com>
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
Cc: dm-cvs@sourceware.org
List-Id: dm-devel.ids

On Thu, 2007-06-21 at 20:13 +0200, Markus wrote:
> Hi,
> 
> i do have an active-passive Storage where the LUN could be used by
> both Controllers but one is bloody slow. I tried all
> /sbin/mpath_prio_* ways do determin which is the "active" one but none
> of them worked. Is there a way to set this manually? Is there a
> different way to determin which is which rather than using the
> existing Commands?

If your device is not one of the supported devices, you can ask the
vendor about how to determine the active and passive paths.

mpath_prio_tpc is a good example of how the active/passive device
information is used to determine the path priority.
  
> 
> Thanks in advance
> Markus
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
