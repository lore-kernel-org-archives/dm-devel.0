From: Christoph Hellwig <hch@infradead.org>
Subject: Re: new dm-bufio
Date: Tue, 23 Aug 2011 14:54:23 -0400
Message-ID: <20110823185423.GA10936@infradead.org>
References: <Pine.LNX.4.64.1108221600510.26651@hs20-bc2-1.build.redhat.com>
	<20110823113048.GC5442@ubuntu>
	<Pine.LNX.4.64.1108231012560.2629@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108231012560.2629@hs20-bc2-1.build.redhat.com>
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
Cc: Joe Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

FYI, the "shrinker" interface in include/linux/shrinker.h is how the
VM tells subsystems to shrink their memory usage.  It is used for
various slab caches, and the XFS buffercache in
fs/xfs/linux-2.6/xfs_buf.c
