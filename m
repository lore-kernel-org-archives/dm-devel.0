From: Akira Hayakawa <ruby.wktk@gmail.com>
Subject: payload not set (bi_sector=0) in clone_endio
Date: Thu, 8 Sep 2016 09:41:42 +0900
Message-ID: <27da7ea0-3a43-1614-9cb5-f71847c45379@gmail.com>
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

Hi,

I found an interesting behavior when I was debugging my dm-writeboost.

device-mapper splits in-coming bio into small bios called clone bio and
target writes "how to handle a clone bio". There is end_io method which is
called in clone_endio. That should be called when the clone bio is acked
by underlying device.

My expectation is clone bio payload is always set when it's reached endio
function, as well as ordinary bio. payload is set means bi_sector is set
and bvecs are filled with data.

But my expectation is betrayed.

I found there is a condition to reproduce this. It's whether the underlying
device is also wrapped by linear target or not. When it's wrapped by linear
target, the clone bio's payload is somehow set. Otherwise not.

Precisely, dm-writeboost requires backing store and caching device as underlying
devices. And I expect the read clone bio acked by backing store should be payload set.
But it's not, when the backing store is raw HDD rather than linear device
backed by a HDD.

I post this because I wonder whether this is device-mapper limitation or just a bug.

Thanks,
Akira
