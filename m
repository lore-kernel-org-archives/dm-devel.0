From: Eric Wheeler <dm-devel@ew.ewheeler.org>
Subject: Re: dm-thinp BUG at
 drivers/md/persistent-data/dm-btree-remove.c:188
Date: Fri, 15 Feb 2013 15:21:41 -0800 (PST)
Message-ID: <alpine.DEB.2.00.1302151517240.48618@ware.dreamhost.com>
References: <alpine.DEB.2.00.1302141757240.50852@ware.dreamhost.com>
	<20130215105226.GA9053@raspberrypi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130215105226.GA9053@raspberrypi>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: thornber@redhat.com
List-Id: dm-devel.ids

On Fri, 15 Feb 2013, thornber@redhat.com wrote:
> On Thu, Feb 14, 2013 at 06:07:56PM -0800, Eric Wheeler wrote:
> Discard support is the main user of the btree_remove, so turning off
> discard support in the pool should be a good temporary fix.

Yep, I did just that and it seems to be stable at the moment.

> Could you let me know what sort of work load you were applying to the
> ext4 fs to cause this to happen?  If I can reproduce this I should be
> able to get a fix to you v. quickly.

I'm sure it was very light load.  Backups happen at night using 
rdiff-backup, but the failure was happening during the day outside of a 
backup period.

I do have a MySQL replication writing to a volume, so that would generate 
a few writes---but its an extremely-low-write database, so that seems 
unlikely.

The best I can think is something like mlocate was scanning the disk, so 
maybe just a filesystem traversal was doing it---but mlocate would have 
been read-only.

I wouldn't think so, but is it possible for a read to cause a discard 
under dm-thinp?

-Eric

--
Eric Wheeler
www.globallinuxsecurity.pro
