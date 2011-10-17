From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-bufio
Date: Mon, 17 Oct 2011 11:29:28 +0100
Message-ID: <20111017102927.GA13963@ubuntu>
References: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 14, 2011 at 03:14:34PM -0400, Mikulas Patocka wrote:
> --- linux-3.1-rc3-fast.orig/drivers/md/Kconfig	2011-10-14 20:56:45.000000000 +0200
> +++ linux-3.1-rc3-fast/drivers/md/Kconfig	2011-10-14 20:56:46.000000000 +0200
> @@ -209,7 +209,7 @@ config DM_DEBUG
>  	  If unsure, say N.
>  
>  config DM_BUFIO
> -       tristate
> +       tristate "Buffered IO"
>         depends on BLK_DEV_DM && EXPERIMENTAL
>         ---help---
>  	 This interface allows you to do buffered I/O on a device and acts

This makes bufio appear in 'menuconfig' and friends.  Why do you want this user visible?
