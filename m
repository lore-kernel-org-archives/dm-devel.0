From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 0/3] New approach at handling changed WWIDs
Date: Mon, 18 Mar 2019 13:12:32 +0100
Message-ID: <20190318121235.8942-1-mwilck@suse.com>
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
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Hi Ben, hi Christophe,

after reviewing Ben's last patch set, I've been pondering over the
handling of changed WWIDs, which seems to have become a bit too clever
and complex for my taste, and I came up with this new approach
instead.

TL;DR: instead of treating paths with changed WWIDs as faulty, act
as if the path was removed, and another path was then added and
obtained the device ID of the removed path.

Long version:

What would cause the WWID of an in-use path to change on the fly? Other than
a) gross malfunction of the storage or kernel (which would be almost certain
to corrupt data anyway, whether or not multipathd is taking precautions),
I can think of two scenarios: b) multipathd might have missed both a
"remove" and a subsequent "add" uevent for the device in question; c)
the admin may have played with the udev rules, and solicited change
uevents manually.

In case b), doing what my patch does is obviously the right thing. In case
c), the right thing would be throwing slimy stinking things at the admin,
but as we can't do that, removing and re-adding seems still more reasonable
than pretending the path was faulty. Even in case a), removing the path
from the current map is no worse than failing it.

What remains to be considered is what Ben was dealing with in his latest set,
a permanent or temporary failure to retrieve the WWID, resulting in a 0-length
WWID to be returned. IMO it's actually the best thing about this new approach
that this doesn't need to be special-cased. The path initialization logic
that we already have would take care of it using the INIT_MISSING_UDEV logic.
Either the WWID would be successfully retrieved eventually, in which case the
path would be re-added to the previous map, or (depending on configuration)
added to a new map or left alone. Or the failure is permanent, in which case
multipathd would eventually give up and orphan the path. AFAICS this would
be the "right thing" to do in all these different cases, without any
additional logic.

Note also that if a "reconfigure" was carried out in the presence of
paths with changed WWID, the final outcome would likely be the same that
my patch now achieves without "reconfigure".

I case I've come to the wrong conclusions because I overlooked something
essential, please tell me.

Going one step futher, I've actually come to think differently about the
"fallback logic" for the case that no WWID can be obtained from udev. I
believe now that such fallback logic should _not_ be used. The point is not
to derive _some_ WWID, but _the right one_, and that's udev's job. But udev
can be customized in complex ways that multipathd has no idea about.
In the worst case, we'd receive some WWIDs from udev and some from our
own logic, and combine paths into a map which wouldn't acutally belong
together. Therefore I vote for ripping out the fallback logic altogether
and depend on udev exclusively for WWID generation. I haven't included this
in the current patch set in order not to make it too controversial.

The only purpose for the fallback logic that I could see is to provide
a configuration option to force multipathd to _always_ determine the
WWID by itself, ignoring udev device properties.

Regards
Martin

Martin Wilck (3):
  multipathd: handle changed wwids by removal and addition
  multipathd: remove "wwid_changed" path attribute
  multipathd: ignore "disable_changed_wwids"

 libmultipath/config.c      |  1 -
 libmultipath/config.h      |  1 -
 libmultipath/dict.c        | 18 +++++++--
 libmultipath/structs.h     |  1 -
 multipath/multipath.conf.5 |  8 +---
 multipathd/main.c          | 77 +++++++++++++++++++-------------------
 6 files changed, 55 insertions(+), 51 deletions(-)

-- 
2.21.0
