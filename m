From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 8/8] [dm-cache] cache target
Date: Thu, 14 Feb 2013 13:57:03 +0000
Message-ID: <20130214135702.GA5045@Barry.lambda.co.uk>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-9-git-send-email-ejt@redhat.com>
	<20130212152733.GH12499@agk-dp.fab.redhat.com>
	<20130212164040.GI3228@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130212164040.GI3228@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 12, 2013 at 04:40:40PM +0000, Alasdair G Kergon wrote:
> [Still to check the ref counting is sufficient: to understand why this is
> a bit simpler than dm-path-selector which also handles modules plugging into
> modules and went through a few iterations fixing ref problems]

dm-path-selector is more complicated because you have two 'type'
structures.  A public one and an internal (keyed on the ->name field
of the public one).
