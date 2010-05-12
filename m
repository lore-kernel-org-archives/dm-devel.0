From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] fix hard-coded disk header chunk size for persistent
	snapshot
Date: Wed, 12 May 2010 02:39:09 +0100
Message-ID: <20100512013909.GD2377@agk-dp.fab.redhat.com>
References: <4BEA0472.1060300@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BEA0472.1060300@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Wed, May 12, 2010 at 10:29:22AM +0900, Tomohiro Kusumi wrote:
> This patch fixes hard-coded value for the size of a chunk that includes
> disk header for persistent snapshot. It should be changed to existing
> macro NUM_SNAPSHOT_HDR_CHUNKS instead of using hard-coded value 1.
 
Any more places too?  (E.g. persistent_commit_merge)

Alasdair
