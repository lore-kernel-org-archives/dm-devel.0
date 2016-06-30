From: Ming Lin <mlin@kernel.org>
Subject: NVMeoF multi-path setup
Date: Thu, 30 Jun 2016 14:08:57 -0700
Message-ID: <CAF1ivSbe+NboO+nbiWfEijHFJPd-AgNa=4AvWT24-HjH8A_izw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

Hi Mike,

I'm trying to test NVMeoF multi-path.

root@host:~# lsmod |grep dm_multipath
dm_multipath           24576  0
root@host:~# ps aux |grep multipath
root     13183  0.0  0.1 238452  4972 ?        SLl  13:41   0:00
/sbin/multipathd

I have nvme0 and nvme1 that are 2 paths to the same NVMe subsystem.

root@host:/sys/class/nvme# grep . nvme*/address
nvme0/address:traddr=192.168.3.2,trsvcid=1023
nvme1/address:traddr=192.168.2.2,trsvcid=1023

root@host:/sys/class/nvme# grep . nvme*/subsysnqn
nvme0/subsysnqn:nqn.testiqn
nvme1/subsysnqn:nqn.testiqn

root@host:~# /lib/udev/scsi_id --export --whitelisted -d /dev/nvme1n1
ID_SCSI=1
ID_VENDOR=NVMe
ID_VENDOR_ENC=NVMe\x20\x20\x20\x20
ID_MODEL=Linux
ID_MODEL_ENC=Linux
ID_REVISION=0-rc
ID_TYPE=disk
ID_SERIAL=SNVMe_Linux
ID_SERIAL_SHORT=
ID_SCSI_SERIAL=1122334455667788

root@host:~# /lib/udev/scsi_id --export --whitelisted -d /dev/nvme0n1
ID_SCSI=1
ID_VENDOR=NVMe
ID_VENDOR_ENC=NVMe\x20\x20\x20\x20
ID_MODEL=Linux
ID_MODEL_ENC=Linux
ID_REVISION=0-rc
ID_TYPE=disk
ID_SERIAL=SNVMe_Linux
ID_SERIAL_SHORT=
ID_SCSI_SERIAL=1122334455667788

But seems multipathd didn't recognize these 2 devices.

What else I'm missing?

Thanks,
Ming
