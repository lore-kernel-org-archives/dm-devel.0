From: Milan Broz <mbroz@redhat.com>
Subject: Re: Next set of device-mapper  patches
Date: Wed, 21 Jun 2006 13:44:15 +0200
Message-ID: <4499310F.3000007@redhat.com>
References: <3EC60E80D9AA7C4E910ACC9DA2003AC30606C55C@BGEEXC02.asiapacific.cpqcorp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3EC60E80D9AA7C4E910ACC9DA2003AC30606C55C@BGEEXC02.asiapacific.cpqcorp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Singh, Santosh (STSD)" <santosh.singh3@hp.com>
Cc: "P S, Suresh (STSD)" <suresh.pathamadai@hp.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello,

ioctl patch simple route ioctls to underlying block device
-> it supports all ioctl which are supported by your physical device.

e.g.
in simple case you have volume /dev/mapper/VolGroup00-LogVol0
mapped to physical device /dev/sda, inquiry ioctl (using tools from sg3_util)
sg_inq /dev/sda   
	is the same as
sg_inq /dev/mapper/VolGroup00-LogVol0

In the case of multipath target ioctl command is sent through
active path.

This patch doesn't add some special ioctls to manage dm devices yet.

Milan

--
Milan Broz
mbroz@redhat.com

Singh, Santosh (STSD) wrote:
>  Hi Broz,
> 
> I build  the device-mapper ioctl patches created  by you & Alasdair. I
> am able to load the modules but wanted to know how to  use the ioctl
> call or how to issue the  ioctl call on the device mapper devices.
> 
> 
> Thanks & Regards
> Santosh Singh
> Hewlett-Packard
> 
> -----Original Message-----
> From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com]
> On Behalf Of Alasdair G Kergon
> Sent: Thursday, June 15, 2006 9:47 PM
> To: device-mapper development
> Subject: Re: [dm-devel] Next set of device-mapper patches
> 
> On Thu, Jun 15, 2006 at 09:16:56PM +0530, Singh, Santosh (STSD) wrote:
>> I tried to patch on 2.6.16 as following and got the error below
>  
> Strange.  That file got truncated.  I've uploaded it again.
> 
> Alasdair
> --
> agk@redhat.com
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
