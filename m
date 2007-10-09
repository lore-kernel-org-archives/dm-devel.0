From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] device-mapper: fix bd_mount_sem corruption
Date: Tue, 9 Oct 2007 17:21:03 +0100
Message-ID: <20071009162103.GW10006@agk.fab.redhat.com>
References: <470ABDE5.30200@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <470ABDE5.30200@ce.jp.nec.com>
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
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Oct 08, 2007 at 07:31:49PM -0400, Jun'ichi Nomura wrote:
> This patch fixes a bd_mount_sem counter corruption bug in device-mapper.

[summary of follow-up]

Affects 2.6.16 (and 2.6.15.5) upwards if someone removes a suspended device
(which shouldn't happen during normal lvm2 operation).

Alasdair
-- 
agk@redhat.com
