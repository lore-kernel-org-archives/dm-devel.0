From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Refcounting (and other) questions
Date: Thu, 30 Dec 2010 12:30:18 -0800
Message-ID: <ifiq5h$obd$1@dough.gmane.org>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I got bcache functioning with dm... it's buggy, but it runs. _Much_ 
thanks to akg for educating me, I now have a vague idea of how dm is 
structured.

My most immediate problem is what to do in the target destructor. It 
looks like when the destructor returns, the dm_target is gone. This an 
issue if I use dm_get_device() and dm_put_device() - if writeback is 
going on in the background I can't just close the backing device 
arbitrarily, I've got refcounting that I need to use.

So I could just not use dm_get_device and instead use 
open_bdev_exclusive - like I do for caches, but I was hoping to get some 
input on the subject.

I may have to do that anyways; the way bcache + dm is structed currently 
is basically a stopgap. I'm planning on starting on volume management + 
thin provisioning soon; what this means is that it doesn't really make 
sense for userspace to arbitrarily create and remove targets. Rather, 
the kernel knows what volumes are available (and their sizes and labels).

It seems to me that there's going to be some moderately painful... model 
mismatch if I try to do this with device mapper. OTOH, I've heard 
references of some standard interface for managing volumes that's in the 
works; I haven't been able to find out anything more about it but it 
sounds like it might be relevant, if someone wanted to point me at it.

Last question: Right now I'm doing
# dmsetup foo
0 10000 bcache /dev/vdb
^D

for testing. The problem is userspace has no idea how big the target 
should be; that's not just dependent on the size of the backing device 
but the start of actual data (for alignment, mainly) is stored in the 
superblock which the kernel reads. I can't be the first person to run 
into this issue - how should bcache convey the actual size of the target 
to dm/somewhere where it can be useful?
