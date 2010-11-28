From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] libmultipath: fix snprintf buffer overflows
Date: Sun, 28 Nov 2010 22:24:52 +0100
Message-ID: <1290979492.25014.19.camel@zezette>
References: <20101128211230.GB7136@freyja.radhermit.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20101128211230.GB7136@freyja.radhermit.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tim Harder <radhermit@gentoo.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On dim., 2010-11-28 at 13:12 -0800, Tim Harder wrote:
> Hi,
> 
> I've attached a patch against the latest git version of multipath-tools
> to fix a couple snprintf buffer overflows. 
> 

Thanks,
applied.
