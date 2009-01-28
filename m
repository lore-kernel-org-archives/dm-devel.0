From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 0/8] dm: request-based dm-multipath
Date: Wed, 28 Jan 2009 15:40:19 +0000
Message-ID: <20090128154019.GB23158@agk.fab.redhat.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: j-nomura@ce.jp.nec.com, dm-devel@redhat.com, mbroz@redhat.com
List-Id: dm-devel.ids

On Fri, Oct 03, 2008 at 11:08:25AM -0400, Kiyoshi Ueda wrote:
> This patch-set is the updated version of request-based dm-multipath.
> The changes from the previous version (*) are to follow up the change
> of the interface to export lld's busy state (PATCH 5).

I've fixed them up to compile again, but haven't thoroughly checked for
side-effects.

Alasdair
-- 
agk@redhat.com
