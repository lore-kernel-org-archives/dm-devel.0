From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dm: introduce DM_GET_TARGET_VERSION
Date: Mon, 16 Sep 2019 23:32:42 -0700
Message-ID: <20190917063242.GA10776@infradead.org>
References: <alpine.LRH.2.02.1909160553360.11421@file01.intranet.prod.int.rdu2.redhat.com>
	<20190916180107.GA725@infradead.org>
	<127b8c4e-a6dc-6d5e-caff-fe1a0ca3a5bb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <127b8c4e-a6dc-6d5e-caff-fe1a0ca3a5bb@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <gmazyland@gmail.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, lvm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Mon, Sep 16, 2019 at 08:16:41PM +0200, Milan Broz wrote:
> 
> So the main idea behind this was just use already existing functionality
> in kernel DM, and provide simple user-friendly way to detect some incompatibilites
> more early. If detection is not there, we just fallback to the old way.

Well, and the nice way to do that is to actually report the features,
not some arbitrary version number.  That is have a sysfs file (or
ioctl for dm if that is the way to go) that reports a list of
capabilities.  Then userspace checks for that desired capability and
only tries the feture if it is supported.
