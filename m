From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache refusing to come up again after a crash
Date: Fri, 6 Dec 2013 17:57:13 +0000
Message-ID: <20131206175712.GD23496@debian>
References: <20131206154914.GE25206@samfundet.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20131206154914.GE25206@samfundet.no>
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
List-Id: dm-devel.ids

On Fri, Dec 06, 2013 at 04:49:14PM +0100, Steinar H. Gunderson wrote:
> Linux (3.12.0-rc5) hung, and on boot, I can't get the dm-cache up again:
> 
> (initramfs) echo 0 23440891904 cache /dev/cache/metadata /dev/cache/blocks /dev/md1 1024 1 writeback
> default 4 random_threshold 8 sequential_threshold 512 | dmsetup create cache -u CACHE-0a8bb56fc873c195bf7117af925c7f08
> device-mapper: reload ioctl on cache failed: Input/output error
> Command failed
> 
> The kernel complains with
> 
> [  639.189756] attempt to access beyond end of device
> [  639.189761] dm-0: rw=0, want=18445688752888627208, limit=1048576
> [  639.189764] device-mapper: transaction manager: couldn't open metadata space map
> [  639.189767] device-mapper: cache metadata: tm_open_with_sm failed
> [  639.283130] device-mapper: table: 254:2: cache: Error creating metadata object
> [  639.283134] device-mapper: ioctl: error adding target to table
> 
> Is there anything I can do short of nuking the metadata partition
> and taking the loss of whatever wasn't written back?

Yep, grab:

https://github.com/jthornber/thin-provisioning-tools

build, and then try cache_check on it (which should tell you what's
wrong).  Other programs to play with are cache_dump, cache_restore and
cache_repair.

Let me know how it goes,

- Joe
