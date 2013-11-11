From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 2/6] dm cache: add passthrough mode
Date: Mon, 11 Nov 2013 23:40:41 +0000
Message-ID: <20131111234041.GH24324@agk-dp.fab.redhat.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
	<1384190448-3861-3-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1384190448-3861-3-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 11, 2013 at 12:20:44PM -0500, Mike Snitzer wrote:
> From: Joe Thornber <ejt@redhat.com>

> Later, applications can perform coherency checks, the nature of which
> will depend on the type of the underlying storage.  

Any examples of how this might be done?
Might one of the later patches in this series be needed, for example,
to invalidate parts of the device found to be out-of-date before
using the cache normally again?

Alasdair
