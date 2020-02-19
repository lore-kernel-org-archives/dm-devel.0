From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/5] libmultipath: turn pp->vpd_data into a
	pointer
Date: Wed, 19 Feb 2020 10:31:44 +0100
Message-ID: <d6a0e4cd4d91c4f933aadc0252fb11e452ed3f12.camel@suse.com>
References: <1582095273-10279-1-git-send-email-bmarzins@redhat.com>
	<1582095273-10279-3-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582095273-10279-3-git-send-email-bmarzins@redhat.com>
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

On Wed, 2020-02-19 at 00:54 -0600, Benjamin Marzinski wrote:
> Instead of always allocating space in the path structure for
> vpd_data,
> only allocte it when necessary.
> 
> Also, fix comments on vpd tests
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/discovery.c | 17 +++++++++++++++--
>  libmultipath/print.c     |  4 ++--
>  libmultipath/structs.c   |  3 +++
>  libmultipath/structs.h   |  2 +-
>  tests/vpd.c              |  3 ++-
>  5 files changed, 23 insertions(+), 6 deletions(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>
