From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] multipath: don't let init script stop
 multipathd for root devices
Date: Fri, 26 Mar 2010 11:04:22 +0900
Message-ID: <4BAC1626.3080605@ct.jp.nec.com>
References: <20100325175205.GG23952@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100325175205.GG23952@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Ben,

On 03/26/2010 02:52 AM +0900, Benjamin Marzinski wrote:
> This patch modifies the redhat init script, so that it doesn't allow
> multipathd to be stopped when the root device is on it.

Why do you need to prevent stopping daemon by script-level forcibly?
I think that users/developers may want to restart the daemon at their
own risk when it starts to behave something wrong or they change
a configuration (since "reconfigure" may not be stable feature).

# Maybe others have different opinion but I often use "restart".

If you need this patch anyway, please add other options to stop/restart
the daemon forcibly.  (e.g. adding force-stop/force-restart)

Thanks,
Kiyoshi Ueda
