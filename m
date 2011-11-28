From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix discard support in dm_io
Date: Mon, 28 Nov 2011 08:59:58 -0500
Message-ID: <20111128135958.GA24022@redhat.com>
References: <1322249289-1263-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1322249289-1263-1-git-send-email-mbroz@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Milan Broz <mbroz@redhat.com>
Cc: lczerner@redhat.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Nov 25 2011 at  2:28pm -0500,
Milan Broz <mbroz@redhat.com> wrote:

> This patch adds support for discard request to dm_io interface.
> 
> Currently dm_mirror can send REQ_DISCARD bios if running over
> discard enabled device and without support in dm_io the system
> crashes badly.
> 
> BUG: unable to handle kernel paging request at 00800000
> IP:  __bio_add_page.part.17+0xf5/0x1e0
> ...
>  bio_add_page+0x56/0x70
>  dispatch_io+0x1cf/0x240 [dm_mod]
>  ? km_get_page+0x50/0x50 [dm_mod]
>  ? vm_next_page+0x20/0x20 [dm_mod]
>  ? mirror_flush+0x130/0x130 [dm_mirror]
>  dm_io+0xdc/0x2b0 [dm_mod]
> ...
> 
> Signed-off-by: Milan Broz <mbroz@redhat.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
