From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: uxlsnr patch
Date: Thu, 21 Jul 2005 23:42:53 +0200
Message-ID: <1121982174.19015.82.camel@zezette>
References: <20050721155514.GA4864@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050721155514.GA4864@phlogiston.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On jeu, 2005-07-21 at 10:55 -0500, Benjamin Marzinski wrote:
> Two little issues. Multipathd was shutting down whenever I tried to start
> up gdb monitoring on it, because uxlsnr code didn't like getting a signal.
> Also, having a lot of overlapping calls to the uxlsnr code caused really
> bad things to happen because of a linked list oversight.
> 
> This patch corrects both.
> 
Merged, thanks.
-- 
christophe varoqui <christophe.varoqui@free.fr>
