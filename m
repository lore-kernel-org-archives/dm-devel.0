From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: FW: Re:  calling dm_io
Date: Mon, 12 Nov 2012 20:27:29 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1211122019450.11950@file.rdu.redhat.com>
References: <20121108180038.GE2683@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20121108180038.GE2683@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
List-Id: dm-devel.ids

It doesn't seem to matter if you use REQ_FLUSH or WRITE_FLUSH, but for 
consistency, you can apply this patch.


On Thu, 8 Nov 2012, Alasdair G Kergon wrote:

> We use a mixture of REQ_FLUSH and WRITE_FLUSH in dm.
> 
> fs.h:#define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_FLUSH)
> 
> Could you do a quick check that we always use the right one in the right 
> places?
> 
> Alasdair
> 
> ----- Forwarded message from "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> -----
> 
> Date: Thu, 8 Nov 2012 19:51:36 +0200
> From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
> Subject: Re: [dm-devel] calling dm_io
> To: device-mapper development <dm-devel@redhat.com>
> 
> On Thu, Nov 8, 2012 at 7:22 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> > On Thu, Nov 08, 2012 at 06:04:44PM +0200, Kasatkin, Dmitry wrote:
> >> So it expects caller to initialize notify.fn, but in couple of places
> >> it is not done when allocating on stack...
> >
> > As far as I can see it is initialised where it needs to be.
> >
> >>       struct dm_io_request io_req = {
> >>               ....,
> >>               .notify.fn = NULL,
> >>       };
> >
> > (Struct members not listed explicitly are initialised according to the same
> > rules used for initialising static variables.  IOW a pointer is initialised
> > to NULL.)
> 
> oh. indeed.
> 
> 
> dm_bufio_issue_flush() uses REQ_FLUSH, but all other places in the
> kernel use WRITE_FLUSH...
> Should dm_bufio_issue_flush() also use WRITE_FLUSH?
> 
> - Dmitry
> 
> 
> >
> > Alasdair
> >
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> ----- End forwarded message -----
> 

dm-bufio: use WRITE_FLUSH instead of REQ_FLUSH

Use WRITE_FLUSH instead of REQ_FLUSH to make it consistent with the rest
of the kernel. There is no functional change - the kernel accepts either
WRITE_FLUSH or REQ_FLUSH.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.6.6-fast/drivers/md/dm-bufio.c
===================================================================
--- linux-3.6.6-fast.orig/drivers/md/dm-bufio.c	2012-11-13 02:13:01.000000000 +0100
+++ linux-3.6.6-fast/drivers/md/dm-bufio.c	2012-11-13 02:13:08.000000000 +0100
@@ -1194,7 +1194,7 @@ EXPORT_SYMBOL_GPL(dm_bufio_write_dirty_b
 int dm_bufio_issue_flush(struct dm_bufio_client *c)
 {
 	struct dm_io_request io_req = {
-		.bi_rw = REQ_FLUSH,
+		.bi_rw = WRITE_FLUSH,
 		.mem.type = DM_IO_KMEM,
 		.mem.ptr.addr = NULL,
 		.client = c->dm_io,
