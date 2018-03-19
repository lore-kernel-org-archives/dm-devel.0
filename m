From: Matthew Wilcox <willy@infradead.org>
Subject: Revert "dm btree: use GFP_NOFS in dm_btree_del()"
Date: Mon, 19 Mar 2018 12:21:35 -0700
Message-ID: <20180319192135.GB6739@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Mike, Joe,

Please consider reverting commit 9f9ef0657d53d988dc07b096052b3dd07d6e3c46.
The reasoning is flawed -- just because something is an ioctl does not
mean that you should be using GFP_NOFS.  The only reason to use GFP_NOFS
is if the filesystem is holding a lock which means that calling into
the filesystem to free memory would deadlock.

If you have a lockdep splat or some chain of reasoning that shows
that there is a filesystem with, eg, an open transaction or holding
an fs-wide lock, then please add some more information to the comment.
Because the comment is wrong, I assume the entire commit is incorrect.
