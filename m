From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] fix-linebreaks
Date: Mon, 22 Aug 2011 15:50:39 +0200
Message-ID: <1314021039.30562.5.camel@lapoo.opensvc.com>
References: <4E4EE0D7.9020706@haquarter.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4E4EE0D7.9020706@haquarter.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Craig <craig@haquarter.de>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On sam., 2011-08-20 at 00:16 +0200, Craig wrote:
> Hi,
> 
> error messages (DM message failed) in the logs look like this in multipath:
> 
> Jul 24 06:17:47 onosendai multipathd: DM message failed [queue_if_no_path
> Jul 24 06:17:47 onosendai ]
> Jul 24 06:17:47 onosendai multipathd: sdc: alua not supported
> Jul 24 06:17:47 onosendai multipathd: sdd: alua not supported
> Jul 24 06:17:47 onosendai multipathd: DM message failed [queue_if_no_path
> Jul 24 06:17:47 onosendai ]
> 
> The patch fixes the unneccessary \n in libmultipath/devmapper.c
> 
Merged.

Thanks,
-- 
Christophe Varoqui
OpenSVC - Tools to scale
http://www.opensvc.com/
