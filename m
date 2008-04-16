From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [2.6 patch] make dm_{,
	un}register_dirty_log_type() static
Date: Wed, 16 Apr 2008 14:41:29 +0100
Message-ID: <20080416134129.GH18935@agk.fab.redhat.com>
References: <20080330232824.GV28445@cs181133002.pp.htv.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080330232824.GV28445@cs181133002.pp.htv.fi>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Adrian Bunk <bunk@kernel.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Mar 31, 2008 at 02:28:24AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global dm_{,un}register_dirty_log_type() 
> static.
 
(Patch superceded by other interface changes.)

Actively used in an area of out-of-tree development which should move in-tree
when it's ready.

Alasdair
-- 
agk@redhat.com
