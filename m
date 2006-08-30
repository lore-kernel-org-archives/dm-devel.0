From: seth vidal <skvidal@linux.duke.edu>
Subject: Re: Multipathd not starting up properly
Date: Wed, 30 Aug 2006 08:24:49 -0400
Message-ID: <1156940689.3962.21.camel@cutter>
References: <608c44bf0608291112h1b62eef2hec5ceeb491e9b5b@mail.gmail.com>
	<44F54174.6050803@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <44F54174.6050803@suse.de>
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

On Wed, 2006-08-30 at 09:42 +0200, Hannes Reinecke wrote:
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

And this:
 error calling out /sbin/mpath_prio_alua 65:16

Any suggestions on what to look for for that?

-sv
