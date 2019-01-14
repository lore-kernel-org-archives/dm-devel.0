From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] multipath-tools: git should ignore
	auto-generated files
Date: Mon, 14 Jan 2019 18:55:35 +0100
Message-ID: <2a6f14ce1e69d7c3fd99479000388cfe05d0654f.camel@suse.de>
References: <20190114171219.2241-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190114171219.2241-1-xose.vazquez@gmail.com>
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2019-01-14 at 18:12 +0100, Xose Vazquez Perez wrote:
> blacklist libmultipath/nvme-ioctl.[ch]
> 
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  .gitignore | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

ACK. 

> 
> diff --git a/.gitignore b/.gitignore
> index 35c59a7e..9926756b 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -21,4 +21,5 @@ libdmmp/test/libdmmp_test
>  libdmmp/test/libdmmp_speed_test
>  tests/*-test
>  tests/*.out
> -
> +libmultipath/nvme-ioctl.c
> +libmultipath/nvme-ioctl.h
