From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: 2.6.16.20/dm: can't create more then one snapshot of
	an lv
Date: Tue, 20 Jun 2006 15:20:05 +0100
Message-ID: <20060620142005.GA19254@agk.surrey.redhat.com>
References: <20060619020040.GX2059@zip.com.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060619020040.GX2059@zip.com.au>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: CaT <cat@zip.com.au>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Jun 19, 2006 at 12:00:40PM +1000, CaT wrote:
> I am attempting to create multiple snapshots of an lv ontop of a raid-5
> software raid device and ext3+dir_index and resize_inode for the fs.
> The kernel is a pure 64bit compile with Debian Sarge amd64 running on
> top of it. The kernel is monolithic and I'm using lvm2 2.01.03-5 with
> devmapper 1.01.
> This works under 2.6.15.7. Under 2.6.16.20 I get this:

Update to lvm2 version 2.02.01 or later and device-mapper version 1.02.02
or later.

Alasdair
-- 
agk@redhat.com
