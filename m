From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: Re: 2.6.27-rc5-mmotm0829 - lvm issues at boot, possible
	disk_devt() related?
Date: Tue, 02 Sep 2008 08:16:01 -0400
Message-ID: <48BD2E81.2030406@hp.com>
References: <4963.1220240176@turing-police.cc.vt.edu>	<48BBA0B0.5070309@kernel.org>	<7045.1220260558@turing-police.cc.vt.edu>	<20080901095651.GI15123@agk.fab.redhat.com>
	<20080901101543.GL20055@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040000010509070000010300"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080901101543.GL20055@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-kernel@vger.kernel.org, lvm-devel@redhat.com, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------040000010509070000010300
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jens Axboe wrote:
> On Mon, Sep 01 2008, Alasdair G Kergon wrote:
>> On Mon, Sep 01, 2008 at 05:15:58AM -0400, Valdis.Kletnieks@vt.edu wrote:
>>> On Mon, 01 Sep 2008 09:58:40 +0200, Tejun Heo said:
>>>> Yeah, I made a mistake converting two of them and devt lookup fails when
>>>> the disk is zero sized.  Bartlomiej debugged the problem and posted a
>>>> patch and I followed up with an updated patch.  It should be fine in the
>>>> next round.
>>>>   http://article.gmane.org/gmane.linux.kernel.next/2663
>>>>   http://article.gmane.org/gmane.linux.kernel.next/2676
>>>> If you're seeing other problems, please let me know.
>>> Confirming - 2.6.27-rc5-mmotm0829 plus the merge of the 2 above patches
>>> does find the LVM volumes and come up.  Thanks for the clue.. :)
>> I expect we'll need some patches to userspace lvm2 to support these extended
>> device numbers properly too...
>>
>> Alasdair (back from holiday)
> 
> They'll be defaulting to off from now on, so it should not be a big
> worry. But Alan Brunelle did find that the "10-character limit
> in dm/lib/libdm-deptree is too small".
> 

Tejun pointed out:

"dev_t is 32bits and MINORBITS is 20.  So, major 12 bits, minor 20
bits, so 4 characters for major, 7 characters for minor."

That would mean: 4+':'+7+'\0' = 13 characters at a minimum, so attached
patch seems to work...

--------------040000010509070000010300
Content-Type: text/x-diff;
	name="0001-Set-major-minor-buffers-to-13-character-to-hold-larg.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename*0="0001-Set-major-minor-buffers-to-13-character-to-hold-larg.pa";
	filename*1="tch"

[PATCH] Set major,minor buffers to 13 character to hold largest values

Need 4 for major, 7 for minor, 1 for the separator plus 1 for the
terminator.

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 lib/libdm-deptree.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/libdm-deptree.c b/lib/libdm-deptree.c
index c73ed50..a437311 100644
--- a/lib/libdm-deptree.c
+++ b/lib/libdm-deptree.c
@@ -1243,7 +1243,7 @@ static int _emit_areas_line(struct dm_task *dmt __attribute((unused)),
 			    size_t paramsize, int *pos)
 {
 	struct seg_area *area;
-	char devbuf[10];
+	char devbuf[13];
 	int tw;
 	const char *prefix = "";
 
@@ -1270,7 +1270,7 @@ static int _emit_segment_line(struct dm_task *dmt, struct load_segment *seg, uin
         int pos = 0;
 	int tw;
         int r;
-	char originbuf[10], cowbuf[10], logbuf[10];
+	char originbuf[13], cowbuf[13], logbuf[13];
 	const char *logtype;
 
 	switch(seg->type) {
-- 
1.5.4.3


--------------040000010509070000010300
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------040000010509070000010300--
