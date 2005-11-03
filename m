From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH] minor fix for multipathd's multipath
	hwentry setup
Date: Thu, 03 Nov 2005 22:41:18 +0100
Message-ID: <1131054078.7463.7.camel@zezette>
References: <ac71172a0511030009u4b923cffk500154b97ce133f@mail.gmail.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <ac71172a0511030009u4b923cffk500154b97ce133f@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: tranlan@us.ibm.com, egoggin@emc.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On jeu, 2005-11-03 at 00:09 -0800, Lan wrote:
> It looks like the hwe should be initialized before calling
> select_pgfailback, since select_pgfailback could use the mpp->hwe
> vaule. 
> 
> --- mp-bleed-1102/multipathd/main.c     2005-11-02 23:24:24.000000000
> -0800
> +++ mp-bleed-1102-patch/multipathd/main.c       2005-11-01
> 22:47:47.000000000 -0800
> @@ -394,8 +394,8 @@
>                 goto out;
>   
>         adopt_paths(vecs, mpp);
> -       select_pgfailback(mpp);
>         mpp->hwe = extract_hwe_from_path(mpp);
> +       select_pgfailback(mpp);
>         set_no_path_retry(mpp);
>   
>         return 0;
> 

Thanks to you and Ed.
Applied,
cvaroqui
