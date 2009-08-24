From: Charlie Brady <charlieb-dm-devel@budge.apana.org.au>
Subject: Re: Sun StorageTek 2530 and dm?
Date: Mon, 24 Aug 2009 11:41:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908241128370.27199@e-smith.charlieb.ott.istop.com>
References: <20090823210536.4730636d@nb-jsosic>
	<20090823213448.154d6cff@nb-jsosic>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090823213448.154d6cff@nb-jsosic>
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


On Sun, 23 Aug 2009, Jakov Sosic wrote:

> On Sun, 23 Aug 2009 21:05:36 +0200
> Jakov Sosic <jakov.sosic@srce.hr> wrote:
>
>> Hi!
>>
>> I have StorageTek 2530 storage, which has two controllers. On host
>> side I have LSI LOGIC two SAS port cards. I've connected one cable
>> from LSI port1 to StorageTek ControllerA, and second SAS cable from
>> LSI port2 to StorageTek ControllerB.
>
> OK. I've solved it - it seems that Linux host type in initiator
> configuration is not turning on AVT on controllers. Instead, I had to
> choose "Solaris (with Veritas DMP or other)", and now everything works!
>
> Thank you, and hope this helps to others too.

I know that other people here will know more detail, but I think you have 
another alternative which might be superior.

Instead of changing the initiator configuration to use AVT, you should 
tune the device mapper to use RDAC.

To do that, I think you will need to adjust both the multipathd 
configuration and recompile the scsi_dh_rdac kernel module after adding 
support for "SUN"/"LCSM100_S".

Here's the RDAC multipath.conf I am using with a StorageTek 2510:

http://www.linux-archive.org/device-mapper-development/323661-multipathd-configuration-sun-storagetek-2510-a.html
