From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: Question about dmevents
Date: Tue, 17 Jul 2007 09:04:02 -0500
Message-ID: <33561910-5FB0-4747-B478-EF8156FB106F@redhat.com>
References: <D44F48C7D79D2943A073C8FA0F49A3CC011B1C49@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <D44F48C7D79D2943A073C8FA0F49A3CC011B1C49@orsmsx418.amr.corp.intel.com>
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

LVM mirroring is indeed one of the targets that makes use of this  
facility.

The device-mapper code base is the place to find the daemon (device- 
mapper/dmeventd).  This daemon resides in userspace waiting for  
events on devices that are being monitored (aka registered).  When an  
event is received from the kernel, it is passed to a registered  
shared library.  LVM2/dmeventd/mirror contains the dynamic shared  
object that handles mirror events.  (The important functions being  
'register', 'unregister', and 'process_event').

  brassow

On Jul 16, 2007, at 10:08 AM, Wood, Brian J wrote:

> Hello everyone, I was wondering if someone could point me to a utility
> that I could look at that uses the dmeventd event registration. I  
> asked
> Heinz M. if there were an LVM utilities that I could see sample  
> code for
> and it sounded like there weren't any implementations currently in LVM
> (he did mention "mirrored.c" but that seems incomplete, unless I'm
> missing something). I'm wondering if someone on this list has made  
> some
> sort of test utility that I could see the source code for (maybe a  
> small
> application and a "hello world" type DSO that I could learn from :) ).
>
> Thank you,
>
> Brian Wood
> Intel Corporation
> Digital Enterprise Group
> Manageability & Platform Software Division
> brian.j.wood@intel.com
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
