From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] kernel-2.6.13 queue_if_no_path feature is
	ignored on creation
Date: Mon, 19 Sep 2005 15:33:56 +0100
Message-ID: <20050919143355.GJ18976@agk.surrey.redhat.com>
References: <OF5B409D12.DC187AE1-ONC1257081.004732E5-C1257081.0047DB49@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <OF5B409D12.DC187AE1-ONC1257081.004732E5-C1257081.0047DB49@de.ibm.com>
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

On Mon, Sep 19, 2005 at 03:07:07PM +0200, Stefan Bader wrote:
> I noticed that (at least when using multipath-tools for setup) the 
> queue_if_no_path
> feature is not recognized any more with kernel 2.6.13

See ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing-quilt/patches/dm-mpath-queue-if-no-path-fix.patch

Alasdair
-- 
agk@redhat.com
