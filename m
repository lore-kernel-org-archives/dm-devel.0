From: =?UTF-8?Q?Matias_Bj=c3=b8rling?= <m@bjorling.me>
Subject: Re: [PATCH 5/6] lightnvm: expose device geometry through sysfs
Date: Fri, 1 Jul 2016 09:20:57 +0200
Message-ID: <577619D9.1080209@bjorling.me>
References: <1467211901-26707-1-git-send-email-m@bjorling.me>
 <1467211901-26707-6-git-send-email-m@bjorling.me>
 <1467316875.21253.24.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1467316875.21253.24.camel@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: J Freyensee <james_p_freyensee@linux.intel.com>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@fb.com, keith.busch@intel.com, linux-nvme@lists.infradead.org, dm-devel@redhat.com
Cc: "Simon A. F. Lund" <slund@cnexlabs.com>
List-Id: dm-devel.ids

On 06/30/2016 10:01 PM, J Freyensee wrote:
> On Wed, 2016-06-29 at 16:51 +0200, Matias Bj=C3=B8rling wrote:
>> From: "Simon A. F. Lund" <slund@cnexlabs.com>
>>
>> For a host to access an Open-Channel SSD, it has to know its
>> geometry,
>> so that it writes and reads at the appropriate device bounds.
>>
>> Currently, the geometry information is kept within the kernel, and
>> not
>> exported to user-space for consumption. This patch exposes the
>> configuration through sysfs and enables user-space libraries, such a=
s
>> liblightnvm, to use the sysfs implementation to get the geometry of
>> an
>> Open-Channel SSD.
>>
>> The sysfs entries are stored within the device hierarchy, and can be
>> found using the "lightnvm" device type.
>>
>> An example configuration looks like this:
>>
>> /sys/class/nvme/
>> =E2=94=94=E2=94=80=E2=94=80 nvme0n1
>>     =E2=94=9C=E2=94=80=E2=94=80 capabilities: 3
>>     =E2=94=9C=E2=94=80=E2=94=80 device_mode: 1
>>     =E2=94=9C=E2=94=80=E2=94=80 channel_parallelism: 0
>>     =E2=94=9C=E2=94=80=E2=94=80 erase_max: 1000000
>>     =E2=94=9C=E2=94=80=E2=94=80 erase_typ: 1000000
>>     =E2=94=9C=E2=94=80=E2=94=80 flash_media_type: 0
>>     =E2=94=9C=E2=94=80=E2=94=80 media_capabilities: 0x00000001
>>     =E2=94=9C=E2=94=80=E2=94=80 media_type: 0
>>     =E2=94=9C=E2=94=80=E2=94=80 multiplane: 0x00010101
>>     =E2=94=9C=E2=94=80=E2=94=80 num_blocks: 1022
>>     =E2=94=9C=E2=94=80=E2=94=80 num_channels: 1
>>     =E2=94=9C=E2=94=80=E2=94=80 num_luns: 4
>>     =E2=94=9C=E2=94=80=E2=94=80 num_pages: 64
>>     =E2=94=9C=E2=94=80=E2=94=80 num_planes: 1
>>     =E2=94=9C=E2=94=80=E2=94=80 page_size: 4096
>>     =E2=94=9C=E2=94=80=E2=94=80 prog_max: 100000
>>     =E2=94=9C=E2=94=80=E2=94=80 prog_typ: 100000
>>     =E2=94=9C=E2=94=80=E2=94=80 read_max: 10000
>>     =E2=94=9C=E2=94=80=E2=94=80 read_typ: 10000
>>     =E2=94=9C=E2=94=80=E2=94=80 sector_oob_size: 0
>>     =E2=94=9C=E2=94=80=E2=94=80 sector_size: 4096
>>     =E2=94=9C=E2=94=80=E2=94=80 media_manager: gennvm
>>     =E2=94=9C=E2=94=80=E2=94=80 ppa_format: 0x3808300828080010101020=
08
>>     =E2=94=9C=E2=94=80=E2=94=80 vendor_opcode: 0
>>     =E2=94=94=E2=94=80=E2=94=80 version: 1
>>
>
> That is an awful lot of new things to add under nvme0n1-type sysfs
> entries when there is already a decent amount of stuff under it.
>

You are right. These are rightfully placed under /lightnvm in the sysfs=
=20
path. The description is wrong, will update it. Thanks Jay.

> Any chance these new things could be stuck under a separate sysfs
> directory under each nvmeXnY device?  If these things are mainly
> beneficial to LightNVM, it will be easier for a LightNVM newbie to
> find, recognize, and consider all the important things in an Open
> Channel SSD solution if it's under a separate directory.  And for
> current SSD solutions that don't seem to need these things exposed in
> sysfs for operation, it will make what is directly under nvmeXnY
> directories less cluttered.
>
> Thanks,
> Jay
>
