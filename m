From: Milan Broz <mbroz@redhat.com>
Subject: Re: Next set of device-mapper  patches
Date: Wed, 21 Jun 2006 15:26:36 +0200
Message-ID: <4499490C.5070603@redhat.com>
References: <3EC60E80D9AA7C4E910ACC9DA2003AC30606C55C@BGEEXC02.asiapacific.cpqcorp.net>	<4499310F.3000007@redhat.com>
	<20060621130620.GA11880@fenrir.local>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060621130620.GA11880@fenrir.local>
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



AJ Lewis wrote:
> On Wed, Jun 21, 2006 at 01:44:15PM +0200, Milan Broz wrote:
>> ioctl patch simple route ioctls to underlying block device
>> -> it supports all ioctl which are supported by your physical device.
>>
>> e.g.
>> in simple case you have volume /dev/mapper/VolGroup00-LogVol0
>> mapped to physical device /dev/sda, inquiry ioctl (using tools from 
>> sg3_util)
>> sg_inq /dev/sda   
>> 	is the same as
>> sg_inq /dev/mapper/VolGroup00-LogVol0
>>
>> In the case of multipath target ioctl command is sent through
>> active path.
> 
> So what happens when you have multiple block devices in the volume?  And what
> if those block devices have different levels of support for the ioctls?

Currently supported for simple mapping with single target only,
if there are more than one target, it will fail with error -ENOTTY.

Milan

-- 
Milan Broz
mbroz@redhat.com
