From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] multipath-tools: delete trailing whitespaces
Date: Wed, 24 Oct 2018 11:41:46 +0200
Message-ID: <7144bf46b074b3aea6efcfe73f314a98379d445b.camel@suse.de>
References: <20181010195116.5588-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181010195116.5588-1-xose.vazquez@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: DM-DEV ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2018-10-10 at 21:51 +0200, Xose Vazquez Perez wrote:
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEV ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/checkers/tur.c | 2 +-
>  tests/dmevents.c            | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Nack. This just pollutes git history and "git blame" output.

Let's just try not to add more whitespace issues with new patches,
and fix issues in exisiting code when we need to touch it
anyway.

Martin
