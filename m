From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm Kconfig: fix menu indentation
Date: Thu, 7 Nov 2013 22:54:39 -0500
Message-ID: <20131108035438.GA9290@redhat.com>
References: <alpine.LRH.2.02.1311071204230.10583@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1311071204230.10583@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 07 2013 at 12:05pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> The option DM_LOG_USERSPACE is sub-option of DM_MIRROR, so it should be
> placed right after DM_MIRROR.
> 
> If we place DM_LOG_USERSPACE after DM_MIRROR, the config menu is correctly
> indented:
> <M>   Device mapper support
> [ ]     Device mapper debugging support
> <M>     Crypt target support
> <M>     Snapshot target
> <M>     Thin provisioning target
> [ ]       Keep stack trace of thin provisioning block lock holders
> <M>     Cache target (EXPERIMENTAL)
> <M>       MQ Cache Policy (EXPERIMENTAL)
> <M>       Cleaner Cache Policy (EXPERIMENTAL)
> <M>     Mirror target
> < >       Mirror userspace logging
> <M>     RAID 1/4/5/6/10 target
> <M>     Zero target
> <M>     Multipath target
> <M>       I/O Path Selector based on the number of in-flight I/Os
> <M>       I/O Path Selector based on the service time
> <M>     I/O delaying target
> [*]     DM uevents
> <M>     Flakey target
> <M>     Verity target support
> <M>     Switch target support (EXPERIMENTAL)
> 
> Previously, the menu was indented incorrectly:
> <M>   Device mapper support
> [ ]     Device mapper debugging support
> <M>     Crypt target support
> <M>     Snapshot target
> <M>     Thin provisioning target
> [ ]       Keep stack trace of thin provisioning block lock holders
> <M>     Cache target (EXPERIMENTAL)
> <M>       MQ Cache Policy (EXPERIMENTAL)
> <M>       Cleaner Cache Policy (EXPERIMENTAL)
> <M>     Mirror target
> <M>     RAID 1/4/5/6/10 target
> < >   Mirror userspace logging
> <M>   Zero target
> <M>   Multipath target
> <M>     I/O Path Selector based on the number of in-flight I/Os
> <M>     I/O Path Selector based on the service time
> <M>   I/O delaying target
> [*]   DM uevents
> <M>   Flakey target
> <M>   Verity target support
> <M>   Switch target support (EXPERIMENTAL)
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Great, I've wondered by the indentation was wrong.  Thanks for fixing
this.
