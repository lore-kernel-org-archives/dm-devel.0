From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] Add missing break statement in kpartx.
Date: Thu, 10 Nov 2011 00:01:12 +0100
Message-ID: <1320879672.1855.2.camel@lapoo.opensvc.com>
References: <4EB3B8E2.2090002@linux.vnet.ibm.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4EB3B8E2.2090002@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hegdevasant <vahegde1@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 05dfce7..0711450 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -241,6 +241,7 @@ main(int argc, char **argv){
>       while ((arg = getopt(argc, argv, short_opts)) != EOF) switch(arg) {
>           case 'r':
>               ro=1;
> +            break;
>           case 'f':
>               force_devmap=1;
>               break;
> @@ -267,6 +268,7 @@ main(int argc, char **argv){
>               break;
>           case 's':
>               sync = 1;
> +            break;
>           case 'u':
>               what = UPDATE;
>               break;

Merged.

Thanks.
