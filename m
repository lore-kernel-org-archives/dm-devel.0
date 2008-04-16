From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [2.6 patch] make dm_set_device_limits() static
Date: Wed, 16 Apr 2008 14:35:24 +0100
Message-ID: <20080416133524.GG18935@agk.fab.redhat.com>
References: <20080330232836.GX28445@cs181133002.pp.htv.fi>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080330232836.GX28445@cs181133002.pp.htv.fi>
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

On Mon, Mar 31, 2008 at 02:28:36AM +0300, Adrian Bunk wrote:
> This patch makes the needlessly global dm_set_device_limits() static.
 
Not needlessly global IMHO: It's part of the interface available for dm
targets to use.  For example, dm-loop uses it.  The whole device limits
thing is still problematic anyway, as dynamic changes to the
restrictions aren't propagated, so we need more work in this area.

Alasdair
-- 
agk@redhat.com
