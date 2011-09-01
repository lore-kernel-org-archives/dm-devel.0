From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: strdup multipath alias,
 so that it isn't deleted.
Date: Thu, 01 Sep 2011 08:55:18 +0200
Message-ID: <1314860118.14056.78.camel@lapoo.opensvc.com>
References: <20110725182700.GK15149@ether.msp.redhat.com>
	<20110901024542.GA11793@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110901024542.GA11793@ether.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On mer., 2011-08-31 at 21:45 -0500, Benjamin Marzinski wrote:
> When a multipath device is added to multipathd with ev_add_map(),
> > the alias is not duplicated, and is freed immediately after
> ev_add_map()
> > returns, causing a memory error. This patch corrects that.
> > 
Merged.

Do you think the "mpp->alias = NULL" is still necessary in the following
setup_multipath() error code path ? alias is set to NULL by
free_multipath() these days ...

>       if (setup_multipath(vecs, mpp)) {
>               mpp->alias = NULL;                <========
