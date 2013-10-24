From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 01/24] dm: nest targets used for
	testing	under DM_TEST_TARGETS
Date: Fri, 25 Oct 2013 00:17:22 +0100
Message-ID: <20131024231722.GD17070@agk-dp.fab.redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-2-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382639437-27007-2-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -371,27 +371,12 @@ config DM_MULTIPATH_ST
  	  
> -config DM_DELAY
> -	tristate "I/O delaying target"

> +config DM_DELAY
> +	tristate "I/O delaying target (EXPERIMENTAL)"

Why has EXPERIMENTAL reappeared???
See d57916a00fd749ccd354a7f754c2aba98f86d064

Please regenerate these patches against an up-to-date upstream base!

Thanks,
Alasdair
