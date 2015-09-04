From: Joe Julian <me@joejulian.name>
Subject: udev rules do not create partition entries when an lvm
 lv is partitioned
Date: Fri, 4 Sep 2015 11:18:26 -0700
Message-ID: <55E9E072.8080209@joejulian.name>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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
To: linux-lvm@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Yes, I'm aware of all the arguments against even doing this, but I have 
my reasons for doing it this way.

When you create a partition on an lv:

   sgdisk /dev/vg1/lv1 -n 0:0:0

there is no udev rule to create the partition entry, '/dev/vg1/lv1p1' 
(for instance). For my immediate use case, this causes ceph-disk to fail 
as it cannot find the partition as it's expecting to find the device 
name with a new "1" at the end. Any suggestions on how I could make this 
happen?
