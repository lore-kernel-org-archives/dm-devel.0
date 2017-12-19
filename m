From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] persistent-data: fix bug about btree of
 updating internal node's minima key in btree_split_beneath.
Date: Tue, 19 Dec 2017 19:05:58 +0000
Message-ID: <20171219190557.aif7othfwkotybl7@reti>
References: <20171218212758.GA12360@yyp.>
	<20171218171307.obyq62v3jt4lgqwg@reti>
	<20171218173409.px65ncx2kp7d6p2v@reti>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171218173409.px65ncx2kp7d6p2v@reti>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: monty_pavel@sina.com, dm-devel@redhat.com, ejt@redhat.com
List-Id: dm-devel.ids

On Mon, Dec 18, 2017 at 05:34:09PM +0000, Joe Thornber wrote:
> Patch below.  This is completely untested.  I'll test tomorrow and update.

The patch appears to work.  I'm using this test to reproduce the problem:

   https://github.com/jthornber/thin-provisioning-tools/blob/master/functional-tests/device-mapper/dm-tests.scm#L593

I need to do some more regression testing before I send it upstream.

- Joe
