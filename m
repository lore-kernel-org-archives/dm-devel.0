From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dm: introduce DM_GET_TARGET_VERSION
Date: Mon, 16 Sep 2019 11:01:07 -0700
Message-ID: <20190916180107.GA725@infradead.org>
References: <alpine.LRH.2.02.1909160553360.11421@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1909160553360.11421@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, lvm-devel@redhat.com, dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Mon, Sep 16, 2019 at 05:55:42AM -0400, Mikulas Patocka wrote:
> This patch introduces a new ioctl DM_GET_TARGET_VERSION. It will load a
> target that is specified in the "name" entry in the parameter structure
> and return its version.
> 
> This functionality is intended to be used by cryptsetup, so that it can
> query kernel capabilities before activating the device.

Well, if you want to query kernel features you better ask for a feature
bitmap than a version number, which can be rather meaningless with
the amount of backporting that is going on.
