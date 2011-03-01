From: Greg Stark <stark@mit.edu>
Subject: How to change the size of a snapshot device?
Date: Tue, 1 Mar 2011 18:23:30 +0000
Message-ID: <AANLkTimybLnLo2ZEDbj_KzMmRuQEqh-FzRBSHFCp8sjh@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I wanted to resize a filesystem in both the underlying device and a
snapshot recently. Doing this for the underlying device was a bit of a
hassle but basically straightforward. I figured doing it for the
snapshot should be trivial since it's COW anyways and I should be able
to just change the logical size of the device and have the newly added
space come from the snapshot COW space.

It doesn't seem to work that way and I'm surprised. lvmextend just
adds the space to the COW space, which isn't what I want at all. And
it looks like dmsetup can load a table but only into an unactived
slot, not replace an existing table for an existing volume.

What I would expect to do is replace the table for the snapshot volume
with a table using the same snapshot for the existing space and a new
snapshot with /dev/zero as the underlying volume for the new space. I
could create a whole new volume but I don't see any unique identifier
in the snapshot table entry to specify what point in time the snapshot
is for so I don't see how to specify the snapshot in the replacement
table though.

-- 
greg
