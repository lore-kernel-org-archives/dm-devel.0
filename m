From: "Scott Moseman" <scmoseman@gmail.com>
Subject: How to Resize Partition
Date: Tue, 12 Feb 2008 09:30:38 -0600
Message-ID: <342d47870802120730h324dff50ic68f58a2fc20a98@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

This is the original size of my partition, 50GB...

# df -h | grep mpath
/dev/mapper/mpath0p1   50G  2.1G   45G   5% /san

I increased it to 60GB and am trying to resize.  Through my
troubleshooting and various attempts, I've increased /dev/sdb1 (NIC),
/dev/sdc1 (HBA) and /dev/mapper/mpath0p1 (MPIO).

Disk /dev/sdb: 64.4 GB, 64424509440 bytes
/dev/sdb1               1       61440    62914544   83  Linux

Disk /dev/sdc: 64.4 GB, 64424509440 bytes
/dev/sdc1               1       61440    62914544   83  Linux

Disk /dev/mapper/mpath0: 64.4 GB, 64424509440 bytes
/dev/mapper/mpath0p1               1       61440    62914544   83  Linux

I unmount/mount, reboot, etc and the mounted partition keeps showing
up as 50GB.  How do I get my additional 10GB?  This is on a CentOS 4.5
server.

Thanks,
Scott
