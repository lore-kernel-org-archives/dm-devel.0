From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 4/5] libmultipath: change directio
 get_events() timeout handling
Date: Wed, 19 Feb 2020 10:46:28 +0100
Message-ID: <48f3cbd6e31c4f2fccfa572c1a73c8be13674488.camel@suse.com>
References: <1582095273-10279-1-git-send-email-bmarzins@redhat.com>
	<1582095273-10279-5-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1582095273-10279-5-git-send-email-bmarzins@redhat.com>
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
> get_events() used a NULL or a zeroed timeout to mean "don't wait".
> io_getevents() uses a NULL timeout to mean "wait forever" and a
> zeroed timeout to mean "don't wait". Make get_events() work like
> io_getevents().
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/checkers/directio.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Thank you.

Reviewed-by: Martin Wilck <mwilck@suse.com>
