From: Phillip Susi <psusi@cfl.rr.com>
Subject: Partitioned dm devices and BLKPG
Date: Thu, 25 Mar 2010 15:12:50 -0400
Message-ID: <4BABB5B2.8050007@cfl.rr.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>, ataraid-list-owner@redhat.com
List-Id: dm-devel.ids

I was thinking that it would be preferable to use the BLKPG ioctl to add
a kernel partition table to a dm device rather than create another
linear mapped dm device layered on top to emulate partitions.  This
would allow tools like (g)parted to understand and manipulate partitions
on dmraid disks and seems it would be more efficient not having as many
layers to travel through.  Is this possible or has anyone thought of
adding such support?
