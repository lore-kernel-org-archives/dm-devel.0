From: "Adam Huffman" <adam.huffman@gmail.com>
Subject: Re: Multipathd not starting up properly
Date: Wed, 30 Aug 2006 17:19:54 +0100
Message-ID: <608c44bf0608300919y61d46a0bgb8fb48f5dcaf60be@mail.gmail.com>
References: <608c44bf0608291112h1b62eef2hec5ceeb491e9b5b@mail.gmail.com>
	<44F54174.6050803@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44F54174.6050803@suse.de>
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

On 30/08/06, Hannes Reinecke <hare@suse.de> wrote:
> Adam Huffman wrote:
> > I'm seeing the following messages when I start multipathd:
> >
> > Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s
> > /block/sda
> > Aug 29 19:00:21 multipathd: error calling out /sbin/scsi_id -g -u -s
> > /block/sdb
> >
> > Here is the output of multipath -v 3:
> >
> >
> [ .. ]
> > path checker = readsector0 (internal default)
> > state = 2
> > getprio = (null) (internal default)
> > prio = 1
> > getuid = /sbin/scsi_id -g -u -s /block/%n (internal default)
> > error calling out /sbin/scsi_id -g -u -s /block/sda
>
> This is your problem. Somehow 'scsi_id' cannot talk to the drive.
> Try 'sg_inq /dev/sda' to find out where the problem is.
>

Here's the output of that command:

sg_inq /dev/sda
standard INQUIRY:
  PQual=0  Device_type=0  RMB=0  [ANSI_version=2]  version=0x02
  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=1  Resp_data_format=2
  SCCS=0  ACC=0  ALUA=0  3PC=0  Protect=0
  BQue=0  EncServ=1  MultiP=1  MChngr=0  [ACKREQQ=0]  Addr16=0
  [RelAdr=0]  WBus16=0  Sync=0  Linked=0  [TranDis=0]  CmdQue=1
    length=49 (0x31)   Peripheral device type: disk
 Vendor identification: Raidtec
 Product identification: JEFF
 Product revision level: 0281
 Product serial number: 119000020000JEFF

Adam
