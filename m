From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 1 of 2] DM Exception Store: return zero when
	empty
Date: Thu, 24 Sep 2009 13:51:48 +0100
Message-ID: <20090924125148.GJ3866@agk-dp.fab.redhat.com>
References: <200909231524.n8NFOw03029884@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200909231524.n8NFOw03029884@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 23, 2009 at 10:24:58AM -0500, Jon Brassow wrote:
> When the snapshot is empty, return 0 as the number of allocated sectors.
> This will be needed to properly notify userspace that merging is finished.

A kernel/userspace interface change and visible to the user in their tools.
Needs discussion.
 
Alasdair
