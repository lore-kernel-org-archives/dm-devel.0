From: Teng-Feng Yang <shinrairis@gmail.com>
Subject: Holding both virtual and physical blocks prison when
 processing discard in dm-thin
Date: Mon, 30 Sep 2013 16:33:23 +0800
Message-ID: <CAKTMprNnya4Zt=a+BXee89ym362RWXeQq1H_cy4dKchtqjY2_g@mail.gmail.com>
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

Hi folks,

I recently traced the code of how dm-thin handles DISCARD requests and
found something interesting.
In thin_bio_map(), thin device will acquire the virtual and physical
bio_prison in sequence when it tries to remap bio based on a private
mapping.
I know it is necessary to hold these prisons to avoid a possible
deadlock when there are parallel discard and non-discard requests to
the very same block.
However, I am curious about why we need to acquire the virtual
bio_prison first instead of trying to acquire only the physical
bio_prison.
Since all bios from the same thin device (protected by virtual
bio_prison) will eventually be passed to physical blocks which are
protected by physical bio_prison,
it seems that holding only the physical bio_prison is sufficient to
prevent discard bios being processed in parallel with any other bios
targeting the same block.

Any help would be greatly appreciated.

Best Regards,
Dennis
