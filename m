From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 1/2] dm thin: fix memory leak of singleton
 bio-prison cell
Date: Mon, 23 Apr 2012 10:26:39 +0100
Message-ID: <20120423092638.GA11835@ubuntu>
References: <1334270075-11699-1-git-send-email-snitzer@redhat.com>
	<20120423072407.GA8082@ubuntu>
	<20120423100246.GA4073@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120423100246.GA4073@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: ejt@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 23, 2012 at 11:02:46AM +0100, Alasdair G Kergon wrote:
> On Mon, Apr 23, 2012 at 08:24:08AM +0100, Joe Thornber wrote:
> > On Thu, Apr 12, 2012 at 06:34:34PM -0400, Mike Snitzer wrote:
> > > Add missing mempool_free() to __cell_release_singleton().
> > > 
> > > This is a pretty significant leak that will accumulate to over 2GB of
> > > leaked memory just from running the full thinp-test-suite.
> > When was this introduced?  With agk's tweaks for 3.4?
>  
> I think it was here:
>   http://www.redhat.com/archives/dm-devel/2012-March/msg00080.html

Yep, this should call mempool_release:

@@ -305,22 +310,45 @@ static void cell_release(struct cell *cell, struct bio_list *bios)
  * bio may be in the cell.  This function releases the cell, and also does
  * a sanity check.
  */
+static void __cell_release_singleton(struct cell *cell, struct bio *bio)
+{
+	hlist_del(&cell->list);
+	BUG_ON(cell->holder != bio);
+	BUG_ON(!bio_list_empty(&cell->bios));
+}
+
