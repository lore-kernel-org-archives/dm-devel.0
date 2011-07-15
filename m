From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm-crypt: add mapping table option
	to	allowing discard requests
Date: Fri, 15 Jul 2011 02:07:47 +0100
Message-ID: <20110715010747.GC15253@agk-dp.fab.redhat.com>
References: <1310644590-14438-1-git-send-email-mbroz@redhat.com>
	<4E1F9023.5020801@deserettechnology.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4E1F9023.5020801@deserettechnology.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jeff Cook <jeff@deserettechnology.com>
Cc: device-mapper development <dm-devel@redhat.com>, list@eworm.de, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 14, 2011 at 06:56:03PM -0600, Jeff Cook wrote:
> Thanks very much for this patch Milan. I will try compiling it shortly
> and see where things go -- are you expecting this to be submitted for
> inclusion in mainline soon?
 
I already submitted it for linux-next, so unless people report problems
which we can't fix quickly, it'll be submitted during the next merge window.

Alasdair
