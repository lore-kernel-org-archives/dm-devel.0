From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm: fix freeze_bdev() return value check
Date: Mon, 24 Sep 2007 14:04:02 +0100
Message-ID: <20070924130402.GI18444@agk.fab.redhat.com>
References: <20070924105636.GA30406@APFDCB5C>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070924105636.GA30406@APFDCB5C>
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
List-Id: dm-devel.ids

On Mon, Sep 24, 2007 at 07:56:36PM +0900, Akinobu Mita wrote:
> freeze_bdev() does not return errno as pointer on failure.
 
Please check the history of this - was this ever in the tree
or is it still pending or not?

Alasdair
-- 
agk@redhat.com
