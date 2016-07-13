From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: NVMeoF multi-path setup
Date: Wed, 13 Jul 2016 13:19:34 +0300
Message-ID: <578615B6.8030702@grimberg.me>
References: <CAF1ivSbe+NboO+nbiWfEijHFJPd-AgNa=4AvWT24-HjH8A_izw@mail.gmail.com>
	<1467323858.15863.3.camel@ssi> <20160630225207.GB22293@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160630225207.GB22293@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Ming Lin <mlin@kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids



On 01/07/16 01:52, Mike Snitzer wrote:
> On Thu, Jun 30 2016 at  5:57pm -0400,
> Ming Lin <mlin@kernel.org> wrote:
>
>> On Thu, 2016-06-30 at 14:08 -0700, Ming Lin wrote:
>>> Hi Mike,
>>>
>>> I'm trying to test NVMeoF multi-path.
>>>
>>> root@host:~# lsmod |grep dm_multipath
>>> dm_multipath           24576  0
>>> root@host:~# ps aux |grep multipath
>>> root     13183  0.0  0.1 238452  4972 ?        SLl  13:41   0:00
>>> /sbin/multipathd
>>>
>>> I have nvme0 and nvme1 that are 2 paths to the same NVMe subsystem.
>>>
>>> root@host:/sys/class/nvme# grep . nvme*/address
>>> nvme0/address:traddr=192.168.3.2,trsvcid=1023
>>> nvme1/address:traddr=192.168.2.2,trsvcid=1023
>>>
>>> root@host:/sys/class/nvme# grep . nvme*/subsysnqn
>>> nvme0/subsysnqn:nqn.testiqn
>>> nvme1/subsysnqn:nqn.testiqn
>>>
>>> root@host:~# /lib/udev/scsi_id --export --whitelisted -d /dev/nvme1n1
>>> ID_SCSI=1
>>> ID_VENDOR=NVMe
>>> ID_VENDOR_ENC=NVMe\x20\x20\x20\x20
>>> ID_MODEL=Linux
>>> ID_MODEL_ENC=Linux
>>> ID_REVISION=0-rc
>>> ID_TYPE=disk
>>> ID_SERIAL=SNVMe_Linux
>>> ID_SERIAL_SHORT=
>>> ID_SCSI_SERIAL=1122334455667788
>>>
>>> root@host:~# /lib/udev/scsi_id --export --whitelisted -d /dev/nvme0n1
>>> ID_SCSI=1
>>> ID_VENDOR=NVMe
>>> ID_VENDOR_ENC=NVMe\x20\x20\x20\x20
>>> ID_MODEL=Linux
>>> ID_MODEL_ENC=Linux
>>> ID_REVISION=0-rc
>>> ID_TYPE=disk
>>> ID_SERIAL=SNVMe_Linux
>>> ID_SERIAL_SHORT=
>>> ID_SCSI_SERIAL=1122334455667788
>>>
>>> But seems multipathd didn't recognize these 2 devices.
>>>
>>> What else I'm missing?
>>
>> There are two problems:
>>
>> 1. there is no "/block/" in the path
>>
>> /sys/devices/virtual/nvme-fabrics/block/nvme0/nvme0n1
>
> You clarified that it is:
> /sys/devices/virtual/nvme-fabrics/ctl/nvme0/nvme0n1
>
> Do you have CONFIG_BLK_DEV_NVME_SCSI enabled?

Indeed, for dm-multipath we need CONFIG_BLK_DEV_NVME_SCSI on.

Another thing I noticed was that for nvme we need to manually
set the timeout value because nvme devices don't expose
device/timeout sysfs file. This causes dm-multipath to take
a 200 seconds default (not a huge problem because we
have keep alive in fabrics too).
