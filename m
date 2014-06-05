From: Christoph Hellwig <hch@infradead.org>
Subject: good dm-mpath test setup?
Date: Thu, 5 Jun 2014 04:50:11 -0700
Message-ID: <20140605115011.GA816@infradead.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I've been looking into support blk-mq/scsi-mq in dm-mpath, but I'm
already running into issues with mainline.  I created a couple luns
(without second path) using iet, and then using the iscsi initiator
to access them.  But it seems like no I/O is possible through dm-mpath
for this simple setup as the kpartx processes spawned by udev already
hang.  Is dm-mpath (default config, no multipath.conf) support to work
for a single path setup, or is this expected behavior?

Does anyone have a good default iet or maybe lio config for dm-mpath
testing?
