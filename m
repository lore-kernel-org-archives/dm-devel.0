From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3 87/87] libmultipath: fix a
 -Wformat-truncation warning from gcc 10
Date: Thu, 20 Aug 2020 21:09:06 +0200
Message-ID: <82099d75b9a0787d46c995ff88d4000599422a50.camel@suse.com>
References: <20200819131819.13493-1-mwilck@suse.com>
	<20200819131819.13493-5-mwilck@suse.com>
	<20200819224015.GW19233@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200819224015.GW19233@octiron.msp.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, 2020-08-19 at 17:40 -0500, Benjamin Marzinski wrote:
> On Wed, Aug 19, 2020 at 03:18:19PM +0200, mwilck@suse.com wrote:
> > From: Martin Wilck <mwilck@suse.com>
> > 
> > This fixes a warning seen with gcc 10 on x86 (32 bit).
> > Fix it by checking the snprintf() return value.
> > 
> Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> > Signed-off-by: Martin Wilck <mwilck@suse.com>

Thanks a lot, Ben!

This was the last Reviewed-by: tag missing on this series.
I've pushed it to github.com/openSUSE/multipath-tools (upstream-queue)
now.

Regards
Martin
