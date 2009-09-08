From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] shared snapshots
Date: Tue, 8 Sep 2009 09:35:14 -0400
Message-ID: <20090908133514.GA8054@infradead.org>
References: <Pine.LNX.4.64.0909071505070.6165@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909072313050.26479@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0909072313050.26479@hs20-bc2-1.build.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Sep 07, 2009 at 11:15:18PM -0400, Mikulas Patocka wrote:
> [ the previous message was eaten by mailing-list server, probably because 
> it was too long, so I am reposting it without the patch. The patch is at 
> the URL below. ]
> 
> Hi
> 
> This is patch for shared snapshots to be included in the next merge 
> window. The patch only adds new modules dm_multisnapshot and 
> dm_store_mikulas, it doesn't modify any existing code.

Not that I have anything against people advertising their names, but
wouldn't a descriptive module name telling what this store is useful be
better?
