From: Julian Andres Klode <julian.klode@canonical.com>
Subject: Re: [PATCH] kpartx: compare image filenames with backing
 files
Date: Fri, 27 Jul 2018 09:53:19 +0800
Message-ID: <20180727015319.s5urnx6d6jz7eivj@jak-t480s>
References: <20180716125213.16767-1-yturgema@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180716125213.16767-1-yturgema@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yuval Turgeman <yturgema@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jul 16, 2018 at 03:52:13PM +0300, Yuval Turgeman wrote:
> When running `kpartx -d`, find_loop_by_file tries to compare the image's
> realpath with the output from loopinfo.lo_name, which may hold only the
> basename of the image, making kpartx exit without finding the loopdev
> for the image.
> 
> In case the original comparison fails, this patch will check the image's
> realpath with the loop device's backing_file so that find_loop_by_file
> will return the correct value.

That seems like it does the same as my patch[1] from February, but in a more
sane way. "Good" I did not follow up more on that :) /me will check if it
solves the problem shortly.

[1] https://www.redhat.com/archives/dm-devel/2018-February/msg00019.html


-- 
debian developer - deb.li/jak | jak-linux.org - free software dev
ubuntu core developer                              i speak de, en
