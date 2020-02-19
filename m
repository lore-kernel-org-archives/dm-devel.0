From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 5/5] libmultipath: cleanup old issues with
 directio checker
Date: Wed, 19 Feb 2020 10:51:05 +0100
Message-ID: <83602ac4a72622a33caeace1fee0395b3212d036.camel@suse.com>
References: <1582095273-10279-1-git-send-email-bmarzins@redhat.com>
	<1582095273-10279-6-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582095273-10279-6-git-send-email-bmarzins@redhat.com>
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
> The directio checker manually aligns its directio buffer, instead of
> using posix_memalign(). It also defaults the block size for the read
> to
> 512, which may be too small for 4k devices, and it only waits for 5
> ns
> for IO completion before giving up and setting the path to pending,
> which means that in will virtually always set the path to pending on
> the
> check when the IO is issued.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> ---
>  libmultipath/checkers/directio.c | 13 ++++---------
>  tests/directio.c                 |  1 -
>  2 files changed, 4 insertions(+), 10 deletions(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>
