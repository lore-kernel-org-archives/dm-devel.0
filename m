From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH 8/8] [dm-cache] cache target
Date: Thu, 14 Feb 2013 14:05:50 +0000
Message-ID: <20130214140549.GB5045@Barry.lambda.co.uk>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-9-git-send-email-ejt@redhat.com>
	<20130212152733.GH12499@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20130212152733.GH12499@agk-dp.fab.redhat.com>
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

On Tue, Feb 12, 2013 at 03:27:33PM +0000, Alasdair G Kergon wrote:
> Log like other modules (e.g. dm-queue-length.c):
> 	DMINFO("version " CLEANER_VERSION " loaded");
> 
> Similar DMINFO changes in dm-cache-policy-mq.c.

When we've discussed this sort of thing before we've always decided
not to version sub modules and instead just rely on the overall kernel
version.  Who are you intending should consume this DMINFO?
