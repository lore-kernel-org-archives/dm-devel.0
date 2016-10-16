From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: use internal drd.h file
Date: Sun, 16 Oct 2016 12:26:18 +0200
Message-ID: <9e801117-cb59-b3a7-de85-b724326d2b34@gmail.com>
References: <20161008202212.11963-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161008202212.11963-1-xose.vazquez@gmail.com>
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
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/08/2016 10:22 PM, Xose Vazquez Perez wrote:

> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/debug.c | 2 +-
>  multipathd/main.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

This patch is missing.
Thank you.


> diff --git a/libmultipath/debug.c b/libmultipath/debug.c
> index 295136c..fbe171a 100644
> --- a/libmultipath/debug.c
> +++ b/libmultipath/debug.c
> @@ -8,7 +8,7 @@
>  #include "log_pthread.h"
>  #include <sys/types.h>
>  #include <time.h>
> -#include <../third-party/valgrind/drd.h>
> +#include "../third-party/valgrind/drd.h"
>  #include "vector.h"
>  #include "config.h"
>  
> diff --git a/multipathd/main.c b/multipathd/main.c
> index cdfafe8..0998085 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -23,7 +23,6 @@
>  #endif
>  #include <semaphore.h>
>  #include <time.h>
> -#include <valgrind/drd.h>
>  
>  /*
>   * libmultipath
> @@ -85,6 +84,7 @@ int uxsock_timeout;
>  #include "lock.h"
>  #include "waiter.h"
>  #include "wwids.h"
> +#include "../third-party/valgrind/drd.h"
>  
>  #define FILE_NAME_SIZE 256
>  #define CMDSIZE 160
> 
