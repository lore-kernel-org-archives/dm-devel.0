From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH Debian] kpartx: increase retries was Re: Next
	release plans?
Date: Tue, 10 May 2016 18:39:54 +0200
Message-ID: <05bfcd42-5a72-35c6-d4a7-8b44b130b63b@gmail.com>
References: <561531AF.4080907@gmail.com> <570BDA57.7040606@gmail.com>
	<CABr-Gnfgz=upeMOUuMSPTXMqLojqOxEfub7GEd0rAjDZ1F3Z6w@mail.gmail.com>
	<7daddb85-3de7-9015-35fd-2e535f707f7a@gmail.com>
	<1461066476.4833.40.camel@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461066476.4833.40.camel@debian.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: rrs@debian.org, device-mapper development <dm-devel@redhat.com>, mathieu.tl@gmail.com
List-Id: dm-devel.ids

On 04/19/2016 01:47 PM, Ritesh Raj Sarraf wrote:

> In Debian, we don't have much delta. The only minor (1 liner) patch I see
> carrying is:
> 
> rrs@learner:~/.rrs-home/Community/Packaging/multipath-tools (master)$ cat
> debian/patches/increase-kpartx-retries.patch 
> https://www.redhat.com/archives/dm-devel/2015-May/msg00087.html
> 
> Many users have reported that increasing the retries solves the problem
> 
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=785251
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=734794
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=608737
> Index: multipath-tools/kpartx/lopart.c
> ===================================================================
> --- multipath-tools.orig/kpartx/lopart.c	2015-10-16 21:33:27.235438304
> +0530
> +++ multipath-tools/kpartx/lopart.c	2015-10-16 21:33:27.231438251 +0530
> @@ -296,7 +296,7 @@
>  extern int 
>  del_loop (const char *device)
>  {
> -	int retries = 3;
> +	int retries = 5;
>  	int fd;
>  
>  	if ((fd = open (device, O_RDONLY)) < 0) {
> 

This patch also was lost.
