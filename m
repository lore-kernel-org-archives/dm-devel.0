From: Tejun Heo <tj@kernel.org>
Subject: Re: [RESEND][PATCH] Send uevents for disk write_protect
	changes
Date: Tue, 21 Jul 2009 22:39:27 +0900
Message-ID: <4A65C50F.6090605@kernel.org>
References: <200907211128.07252.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200907211128.07252.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

Nikanth Karthikesan wrote:
> Hi
> 
> This patch is needed for the dm-multipath, so that the daemon can capture the 
> event and reload the dm table when the read-only setting of the disk changes. 
> Can this be merged?

This is for the next merge window, right?

Thanks.

-- 
tejun
