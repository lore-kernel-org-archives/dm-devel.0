From: Spelic <spelic@shiftmail.org>
Subject: dm-thin f.req. : SEEK_DATA / SEEK_HOLE / SEEK_DISCARD
Date: Tue, 01 May 2012 14:53:22 +0200
Message-ID: <4F9FDCC2.2080905@shiftmail.org>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Dear dm-thin developers,
I thought that it would be immensely useful to have a SEEK_DATA / 
SEEK_HOLE implementation for dm-thin and/or even for the older non-thin 
snapshotting mechanism.
This would allow to implement a mechanism like the acclaimed "zfs send" 
with dm snapshots, i.e. cheaply replicate a thin snapshot remotely once 
the parent snapshot has been replicated already. Extremely useful imho.
Is there any plan to do that?
The "HOLE" would mean "data comes from parent snapshot/device", while 
DATA is "data that has changed since the parent snapshot". Discarded 
regions that were not discarded in the parent snapshot should preferably 
appear as zeroed DATA and not HOLE, or a new type SEEK_DISCARD because 
if you make it HOLE, you lose information (you lose: "such data region 
was meaningful in the parent snapshot but is not meaningful in the child 
snapshot", and this kind of information cannot be recovered later in any 
way) and you lose the property that reading those regions return zeroed 
data, which is a major problem for backups, see next paragraph.
Instead, if a discarded region returns zeroed DATA, not much information 
is lost because any long string of zeroes is interchangeable with a 
discard, i.e. you can detect zeroes and perform the discard afterwards. 
A new type SEEK_DISCARD could still be better.

Another question / feature request: I would like to know if reading an 
area of a thin device after a discard is guaranteed to return zeroes 
(and/or can be identified as empty from userspace via a seek_data / 
seek_hole or equivalent mechanism). This would be very important for 
backups, so to not get scarcely compressible garbage out of an old and 
now unused region.
If yes: how big should such discarded area be for that area to be seen 
from userspace as hole/zeroes: 512b, 4k, or 64m? E.g. a 512b discarded 
area surrounded by nondiscarded data will return zeroes on read?

Thank you
S.
