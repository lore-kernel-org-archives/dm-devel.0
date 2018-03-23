From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 08/20] libmultipath: use const char* in
	open_file()
Date: Fri, 23 Mar 2018 15:08:24 -0500
Message-ID: <20180323200824.GL3103@octiron.msp.redhat.com>
References: <20180319150155.5363-1-mwilck@suse.com>
	<20180319150155.5363-9-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180319150155.5363-9-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 19, 2018 at 04:01:43PM +0100, Martin Wilck wrote:

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/file.c | 6 +++---
>  libmultipath/file.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/file.c b/libmultipath/file.c
> index e4951c92eb67..d5165ec6709a 100644
> --- a/libmultipath/file.c
> +++ b/libmultipath/file.c
> @@ -37,7 +37,7 @@
>   */
>  
>  static int
> -ensure_directories_exist(char *str, mode_t dir_mode)
> +ensure_directories_exist(const char *str, mode_t dir_mode)
>  {
>  	char *pathname;
>  	char *end;
> @@ -80,7 +80,7 @@ sigalrm(int sig)
>  }
>  
>  static int
> -lock_file(int fd, char *file_name)
> +lock_file(int fd, const char *file_name)
>  {
>  	struct sigaction act, oldact;
>  	sigset_t set, oldset;
> @@ -118,7 +118,7 @@ lock_file(int fd, char *file_name)
>  }
>  
>  int
> -open_file(char *file, int *can_write, char *header)
> +open_file(const char *file, int *can_write, const char *header)
>  {
>  	int fd;
>  	struct stat s;
> diff --git a/libmultipath/file.h b/libmultipath/file.h
> index 4f96dbf55e34..70bffa5301ad 100644
> --- a/libmultipath/file.h
> +++ b/libmultipath/file.h
> @@ -6,6 +6,6 @@
>  #define _FILE_H
>  
>  #define FILE_TIMEOUT 30
> -int open_file(char *file, int *can_write, char *header);
> +int open_file(const char *file, int *can_write, const char *header);
>  
>  #endif /* _FILE_H */
> -- 
> 2.16.1
