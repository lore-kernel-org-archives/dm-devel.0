From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: problem with multipathd, not all paths added to a
	disk on boot
Date: Thu, 6 Nov 2008 09:07:55 -0800
Message-ID: <20081106170755.GA11985@linux.vnet.ibm.com>
References: <20081106143100.0FBC013375@smtp.l00-bugdead-prods.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20081106143100.0FBC013375@smtp.l00-bugdead-prods.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Reitenbach <sebastia@l00-bugdead-prods.de>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Sebastian Reitenbach <sebastia@l00-bugdead-prods.de> wrote:
> /dev/sdb in group vm-store, on 1:0:0:0 is not listed, however, lsscsi
> has the disk in the list:
> [1:0:0:0]    disk    IBM      1814      FAStT  0916  /dev/sdb
> 
> for the disk that is not added to the group, I see sth like this 
> in /var/log/messages:
> Nov  6 12:32:36 srv24 kernel: end_request: I/O error, dev sdb, sector 0
> Nov  6 12:32:39 srv24 kernel: end_request: I/O error, dev sdb, sector 0
> Nov  6 12:32:39 srv24 kernel: end_request: I/O error, dev sdb, sector 8
> Nov  6 12:32:42 srv24 kernel: end_request: I/O error, dev sdb, sector 0
> Nov  6 12:32:42 srv24 multipathd: sdb: add path (uevent)
> Nov  6 12:32:42 srv24 multipathd: sdb: spurious uevent, path already in 
> pathvec
> Nov  6 12:32:42 srv24 multipathd: sdb: failed to get path uid
> Nov  6 12:32:45 srv24 kernel: end_request: I/O error, dev sdb, sector 0
> 

What does running "/sbin/scsi_id -g -u -s /block/sdb" return when you are
in this failing mode?

If scsi_id fails what does "sg_inq -v /dev/sdb" and
"cat /sys/block/sdb/device/state" return?

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
