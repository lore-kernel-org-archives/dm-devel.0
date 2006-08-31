From: "Adam Huffman" <adam.huffman@gmail.com>
Subject: Re: Multipathd not starting up properly
Date: Thu, 31 Aug 2006 10:33:27 +0100
Message-ID: <608c44bf0608310233uad60ad3y392bdcfcdae496cb@mail.gmail.com>
References: <608c44bf0608291112h1b62eef2hec5ceeb491e9b5b@mail.gmail.com>
	<44F5DD6F.4080208@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44F5DD6F.4080208@netapp.com>
Content-Disposition: inline
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

On 30/08/06, David Wysochanski <davidw@netapp.com> wrote:
> Adam Huffman wrote:
> > I'm seeing the following messages when I start multipathd:
> >
> > Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s
> > /block/sda
> > Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s
> > /block/sdb
> >
>
> Does /sbin/scsi_id exist on your system?
>

It does.

> Did you try running this manually from the command line?
>

Here's the output of /sbin/scsi_id -v -g -u -s /block/sda

(I found I had to alter scsi_id.config, to put in the Vendor and Model)

set_options: option 'g'
set_options: option 'u'
set_options: option 's' arg '/block/sda'
scsi_id: target_path /sys/block/sda
scsi_id: class_dev 0x0x8a484b8; class_dev_parent 0x(nil)
create_tmp_dev: (/sys/block/sda)
sysfs_get_attr: /sys/block/sda/dev
get_major_minor: dev value 8:0
create_tmp_dev: tmpdev '/dev/tmp-scsi-maj8-min0-7108'
sysfs_get_attr:
/sys/devices/pci0000:00/0000:00:04.0/0000:06:00.0/0000:07:01.0/host0/target0:0:0/0:0:0:0/vendor
sysfs_get_attr:
/sys/devices/pci0000:00/0000:00:04.0/0000:06:00.0/0000:07:01.0/host0/target0:0:0/0:0:0:0/model
get_file_options: vendor='Raidtec
'; model='JEFF
'
get_file_options: config file line 28: vendor '(null)'; model
'(null)'; options '-b'
get_file_options: no match
get_file_options: config file line 33: vendor 'Raidtec'; model 'JEFF';
options '-g'
get_file_options: matched vendor/model
per_dev_options: option 'g'
scsi_id: per dev options: good 1; page code 0x0; callout ''
scsi_id: buffer unaligned 0x0x8a48808; aligned 0x0x8a48a00
scsi_get_serial: opening /dev/tmp-scsi-maj8-min0-7108
scsi_inquiry: 0:0:0:0 evpd 1, page 0x0
scsi_get_serial: 0:0:0:0: Checking page0

I still get the same error message when starting multipathd, even with
the change to scsi_id.config

Adam
