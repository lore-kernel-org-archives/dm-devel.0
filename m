From: "John Stoffel" <john@stoffel.org>
Subject: Re: dm-cache issue
Date: Tue, 15 Nov 2016 14:57:31 -0500
Message-ID: <22571.26795.779502.143833@quad.stoffel.home>
References: <CAJV2nOTJoWWc=N80e6WCpZUh6ZRxvCW8Wt=aZWTyYSKso+kQ5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAJV2nOTJoWWc=N80e6WCpZUh6ZRxvCW8Wt=aZWTyYSKso+kQ5Q@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alexander Pashaliyski <al.pashaliyski@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


Alexander> I am in a process of evaluating dm-cache for our backup system.

Why are you bothering to cache your backup destination?  What
filesystems are you using for your destinations?

Alexander> Currently I have an issue when restart the backup
Alexander> server. The server is booting for hours, because of IO
Alexander> load. It seems is triggered a flush from SSD disk (that is
Alexander> used for a cache device) to the raid controllers (they are
Alexander> with slow SATA disks).  I have 10 cached logical volumes in
Alexander> writethrough mode, each with 2T of data over 2 raid
Alexander> controllers. I use a single SSD disk for the cache.  The
Alexander> backup system is with lvm2-2.02.164-1 & kernel 4.4.30.

How big is the SSD cache?  Do you have any output from the bootup
(syslog, dmesg, etc) you can share.  =


Alexander> Do you have any ideas why such flush is triggered? In
Alexander> writethrough cache mode we shouldn't have dirty blocks in
Alexander> the cache. =A0

I wonder if it makes more sense to use 'lvcache' instead, since you
can add/remove cache from LVs at will.  With bcache, once you setup a
volume with the cache, you're stuck with it.

Also, did you mirror your SSD incase it fails?

In my experience, using RAID6 on a bunch of SATA disks for backup is
fine, you're writing large chunks of data in a few sets of files, so
fragmentation and the Read-Modify-Write cycle is much less painful,
since you tend to stream your writes to the storage, which is
perfectly fine with SATA drives.

Also, bcache skips sequential IO by default, which is what you want
when doing backups... so I'm wondering what your thinking was here for
using this?

John
