From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm missing bdput/thaw_bdev at removal
Date: Fri, 24 Feb 2006 16:31:04 +0000
Message-ID: <20060224163104.GP31641@agk.surrey.redhat.com>
References: <43FE4DB5.5050904@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43FE4DB5.5050904@ce.jp.nec.com>
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

On Thu, Feb 23, 2006 at 07:05:09PM -0500, Jun'ichi Nomura wrote:
> Then dm_suspend will try to freeze_bdev and wait forever.
 
> Attached patch fixes this problem.

Indeed - well spotted!

Alasdair
-- 
agk@redhat.com
