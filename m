From: Phillip Susi <psusi@cfl.rr.com>
Subject: Propagating queue/rotational up the stack
Date: Thu, 6 May 2010 10:11:12 -0400
Message-ID: <4BE2CE00.9050302@cfl.rr.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I am running my root fs on an lvm lv situated on a pv built on an SSD,
and have noticed that ureadahead is optimizing for rotational disks
instead of SSD.  This is because the dm-0 block device's
queue/rotational entry in sysfs reports 1 instead of 0.  It seems that
this should be set to match the value of the underlying pv.  Would this
be possible and if so, would it be very difficult?
