From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: Build: properly parse
 systemd's version
Date: Thu, 7 Mar 2019 19:22:58 +0100
Message-ID: <8a4f3790-a2a9-27ad-b839-d2b743e939a7@gmail.com>
References: <20190307145448.2470-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190307145448.2470-1-mwilck@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Dominique Leuenberger <dimstar@opensuse.org>, Igor Gnatenko <ignatenkobrain@fedoraproject.org>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 3/7/19 3:54 PM, Martin Wilck wrote:
> From: Dominique Leuenberger <dimstar@opensuse.org>
> 
> Since systemd 241, systemctl --version no longer 'just' prints out the
> version, but gives more information like git commit ref and whatnot. In
> it's shortest form, it gives something like "systemd 241 (241)", which when
> passed as parameter "-DUSE_SYSTEMD=241 (241)" results in shell errors.
> 
> Try to retrieve the version from pkg-config instead, and if that fails,
> discard anything after the first number in "systemctl --version" output.

There is a simpler patch in Fedora, see below.

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  Makefile.inc | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile.inc b/Makefile.inc
> index fc728ca9..56c3eda0 100644
> --- a/Makefile.inc
> +++ b/Makefile.inc
> @@ -36,8 +36,13 @@ ifndef RUN
>  endif
>  
>  ifndef SYSTEMD
> -	ifeq ($(shell systemctl --version > /dev/null 2>&1 && echo 1), 1)
> -		SYSTEMD = $(shell systemctl --version 2> /dev/null |  sed -n 's/systemd \([0-9]*\)/\1/p')
> +	ifeq ($(shell pkg-config --modversion libsystemd >/dev/null 2>&1 && echo 1), 1)
> +		SYSTEMD = $(shell pkg-config --modversion libsystemd)
> +	else
> +		ifeq ($(shell systemctl --version >/dev/null 2>&1 && echo 1), 1)
> +			SYSTEMD = $(shell systemctl --version 2> /dev/null | \
> +				sed -n 's/systemd \([0-9]*\).*/\1/p')
> +		endif
>  	endif
>  endif
>  
> 

From a4dbf985b2440f8bb0210b90aaf549030e274b4f Mon Sep 17 00:00:00 2001
From: Igor Gnatenko <ignatenkobrain@fedoraproject.org>
Date: Mon, 18 Feb 2019 00:09:17 +0100
Subject: [PATCH] Fix systemd version detection

Signed-off-by: Igor Gnatenko <ignatenkobrain@fedoraproject.org>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index fc728ca..5b2f6d4 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -37,7 +37,7 @@ endif

 ifndef SYSTEMD
 	ifeq ($(shell systemctl --version > /dev/null 2>&1 && echo 1), 1)
-		SYSTEMD = $(shell systemctl --version 2> /dev/null |  sed -n 's/systemd \([0-9]*\)/\1/p')
+		SYSTEMD = $(shell systemctl --version 2> /dev/null |  sed -n 's/systemd \([0-9]*\).*/\1/p')
 	endif
 endif

-- 
2.20.1
