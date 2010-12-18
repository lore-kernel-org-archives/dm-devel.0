From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Trying to figure out how/whether to use device mapper
	with bcache
Date: Sat, 18 Dec 2010 01:56:22 -0800
Message-ID: <4D0C8546.7010702@gmail.com>
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

If you haven't seen it, bcache is a patch to cache arbitrary block
devices with your SSD: http://bcache.evilpiepirate.org

It currently does the actual caching via a hook in
__generic_make_request(). This means you can transparently enable and
disable caching on a block device while it's mounted and in use, and you
don't have to change anything else to use caching... It's all quite
handy, but the hooks themselves were a dirty hack and need to be gotten
rid of.

It doesn't look like it's going to be possible to do the transparent
part in a way that'll be suitable for mainline any time soon... not
without deep surgery, at least not on arbitrary block devices. That's
not the end of the world though, it's not a vital feature - you don't
want transparent caching if you don't need it, so you don't accidentally
use your backing device without the cache and make the cache go stale or
worse, use it when the cache has dirty data in it.

So all I really need is a way, from bcache, to create a new block device
when it opens a backing device. It doesn't even have to be a dm device,
I just want whatever's going to be simplest at this point... But after
quite a bit of time looking through various headers and other code, I
still haven't figured out how to do this with device mapper, nor have I
even found a basic glossary for the dm specific terms. Maybe I've gotten
lazy, but I would really appreciate someone pointing me in the right
direction :)

Further off, I'm planning on adding volume management to bcache, to do
thin provisioning and tiered storage. The idea is that I've got this
index I have to consult for every IO to do caching... may as well put
the index for the backing device in the same btree, won't be any extra
runtime overhead and I should be able to reuse the allocator and other
bits too.

The implementation looks plenty straightforward, but I don't have any
burning desire to implement a bunch of stuff from scratch that lives in
isolation. I don't really know anything about the implementation of LVM
or the existing DM userspace interface, but if it'd be possible for it
to play nicely with existing stuff I'm all for that. So if anyone's got
any input on how to achieve that, I'm all ears :)
