From: Christoph Hellwig <hch@infradead.org>
Subject: why does __split_and_process_bio use bio_clone_bioset?
Date: Thu, 14 Jun 2018 01:19:47 -0700
Message-ID: <20180614081947.GA23375@infradead.org>
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
To: NeilBrown <neilb@suse.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Hi Neil,

In commit 18a25da8 ("dm: ensure bio submission follows a depth-first
tree walk") you've added a call to bio_clone_bioset to
__split_and_process_bio.  Unlike all other bio splitting code this
actually allocates a new bio_vec array instead of just splitting the bio
and the iterator.  I can't actually find a good reason for that either
in a cursory review of the code, the commit or the comments.

Do you remember why this can't just use bio_clone_fast?
