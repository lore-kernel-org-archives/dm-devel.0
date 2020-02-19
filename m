From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 1/5] multipath: fix issues found by
 compiling with gcc 10
Date: Wed, 19 Feb 2020 21:39:56 +0100
Message-ID: <fcd9b7f4d012c60cf708f5ac4a99b6ef9d39528f.camel@suse.com>
References: <1582143705-20886-1-git-send-email-bmarzins@redhat.com>
	<1582143705-20886-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582143705-20886-2-git-send-email-bmarzins@redhat.com>
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

On Wed, 2020-02-19 at 14:21 -0600, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  kpartx/dasd.c        |  6 +++---
>  libmultipath/print.c | 16 ++++++++--------
>  multipath/main.c     |  2 +-
>  3 files changed, 12 insertions(+), 12 deletions(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>
