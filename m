From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2] multipath: Fix compiler warnings when
 built without systemd.
Date: Wed, 17 Jun 2020 09:28:36 +0200
Message-ID: <5fd1cca644c31d1ac4c6eaa951e53eeeb733413f.camel@suse.com>
References: <d909fc0a2383f028ae7c3ad00c142193ca8d9ae7.camel@suse.com>
	<20200616231126.18538-1-marius@devup.no>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200616231126.18538-1-marius@devup.no>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Marius Bakke <marius@devup.no>, dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Wed, 2020-06-17 at 01:11 +0200, Marius Bakke wrote:
> Add ifdef guards for code that is unused when systemd is not
> available.
> ---
>  libmultipath/config.c |  6 ++++--
>  multipathd/main.c     | 10 +++++++++-
>  2 files changed, 13 insertions(+), 3 deletions(-)
> 

Reviewed-by: Martin Wilck <mwilck@suse.com>

Thanks!
Martin
