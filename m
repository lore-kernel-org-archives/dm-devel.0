From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: Device-mapper Question
Date: Tue, 1 Mar 2005 14:10:06 -0600
Message-ID: <dc12ae6eca9ec389ec4efb2439e6e9c2@redhat.com>
References: <200502281320.05297.defranco@cup.hp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200502281320.05297.defranco@cup.hp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: defranco@cup.hp.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

A note I saw from Stephen Tweedie on the same subject:

"man 5 exports:

        fsid=num
               This  option forces the filesystem identification portion 
of the
               file handle and file attributes used  on  the  wire  to  
be  num
               instead  of  a number derived from the major and minor 
number of
               the block device on which the filesystem is mounted.  Any 
32 bit
               number  can  be  used,  but  it  must  be unique amongst 
all the
               exported filesystems.

               This can be useful for NFS failover, to ensure that both 
servers
               of  the  failover  pair  use  the  same NFS file handles 
for the
               shared  filesystem  thus  avoiding  stale  file  handles  
  after
               failover.

That should work for this case, and will make the file handle completely
independent of any device driver enumeration effects.  However, I
suspect it can lead to odd failure modes if the underlying filesystem
failed to get mounted and you end up exporting a subtree of some other
filesystem with the wrong fsid."

That being said, I believe there is information on keeping a specific 
minor number for volumes in the man pages for lvcreate and lvchange...

  brassow

On Feb 28, 2005, at 3:20 PM, John DeFranco wrote:

> Hello all,
>
> I have a question that I believe is related to the device-mapper but 
> may
> easily be lvm2 instead. In any even here goes. For the purposes of this
> discussion I have two volume groups defined, vg1 and vg2, each with one
> logical volume (lvol0 for each). When I activate a volume group the 
> logical
> volume(s) appear under the /dev/mapper directory such as:
>
> # vgchange -a y vg2
> # ll /dev/mapper
> total 181
> drwxr-xr-x   2 root root    104 Feb 25 09:34 .
> drwxr-xr-x  35 root root 185472 Feb 25 09:34 ..
> lrwxrwxrwx   1 root root     16 Feb 16 17:34 control -> 
> ../device-mapper
> brw-------   1 root root 253, 0 Feb 25 09:34 vg2-lvol0
> #
>
> And
>
> # vgchange -a y vg1
> # ll /dev/mapper
> total 181
> drwxr-xr-x   2 root root    136 Feb 28 12:26 .
> drwxr-xr-x  36 root root 185496 Feb 28 12:26 ..
> lrwxrwxrwx   1 root root     16 Feb 16 17:34 control -> 
> ../device-mapper
> brw-------   1 root root 253, 1 Feb 28 12:26 vg1-lvol0
> brw-------   1 root root 253, 0 Feb 25 09:46 vg2-lvol0
> #
>
> So no problems. Now if I deactivate them and reactivate them in a 
> different
> order I get different minor numbers:
> # vgchange -a n vg1
>   0 logical volume(s) in volume group "vg1" now active
> # vgchange -a n vg2
>   0 logical volume(s) in volume group "vg2" now active
> # vgchange -a y vg1
>   1 logical volume(s) in volume group "vg1" now active
> # vgchange -a y vg2
>   1 logical volume(s) in volume group "vg2" now active
> # !ll
> ll /dev/mapper
> total 181
> drwxr-xr-x   2 root root    136 Feb 28 12:27 .
> drwxr-xr-x  36 root root 185496 Feb 28 12:27 ..
> lrwxrwxrwx   1 root root     16 Feb 16 17:34 control -> 
> ../device-mapper
> brw-------   1 root root 253, 0 Feb 28 12:27 vg1-lvol0
> brw-------   1 root root 253, 1 Feb 28 12:27 vg2-lvol0
> #
>
> Overall this is ok except in the case of nfs. If I'm exporting these
> filesystems and the minor numbers change the client gets a 'stale file
> handle'. Is there anyway to keep the same minor numbers or otherwise a 
> way
> around this?
>
> Thanks!
>
>
>
>
>
> -- 
> ==========
>
> John DeFranco
> Hewlett-Packard Company
> Availability Clusters Solution Division
> 19111 Pruneridge Ave, M/S 4101
> Cupertino, CA 95014
> phone: 408-447-7543
> mailto: john.defranco@hp.com
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
