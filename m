From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 08/15] libmultipath: add vend_id to
	get_vpd_sgio
Date: Fri, 17 Jan 2020 17:58:25 +0100
Message-ID: <6ba3a8191f39080ac5923da7b744c968e2b41b21.camel@suse.de>
References: <1579227500-17196-1-git-send-email-bmarzins@redhat.com>
	<1579227500-17196-9-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1579227500-17196-9-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2020-01-16 at 20:18 -0600, Benjamin Marzinski wrote:
> This tells multipath how it should decode vendor specific pages. It
> will
> be used by a future patch.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c |  4 ++--
>  libmultipath/discovery.h |  2 +-
>  libmultipath/propsel.c   |  2 +-
>  tests/vpd.c              | 10 +++++-----
>  4 files changed, 9 insertions(+), 9 deletions(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>
