From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 83/84] libmultipath: alias: static const
 variable for BINDINGS_FILE_HEADER
Date: Mon, 17 Aug 2020 17:06:07 -0500
Message-ID: <20200817220606.GL19233@octiron.msp.redhat.com>
References: <20200812113601.26658-1-mwilck@suse.com>
	<20200812113601.26658-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200812113601.26658-4-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Aug 12, 2020 at 01:36:00PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> ... and fixup the header file.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c | 17 ++++++++++++++---
>  libmultipath/alias.h | 12 ++++--------
>  2 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 35f1beb..0759c4e 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -37,6 +37,17 @@
>   * See the file COPYING included with this distribution for more details.
>   */
>  
> +#define BINDINGS_FILE_HEADER		\
> +"# Multipath bindings, Version : 1.0\n" \
> +"# NOTE: this file is automatically maintained by the multipath program.\n" \
> +"# You should not need to edit this file in normal circumstances.\n" \
> +"#\n" \
> +"# Format:\n" \
> +"# alias wwid\n" \
> +"#\n"
> +
> +static const char bindings_file_header[] = BINDINGS_FILE_HEADER;
> +
>  int
>  valid_alias(const char *alias)
>  {
> @@ -287,7 +298,7 @@ use_existing_alias (const char *wwid, const char *file, const char *alias_old,
>  	char buff[WWID_SIZE];
>  	FILE *f;
>  
> -	fd = open_file(file, &can_write, BINDINGS_FILE_HEADER);
> +	fd = open_file(file, &can_write, bindings_file_header);
>  	if (fd < 0)
>  		return NULL;
>  
> @@ -361,7 +372,7 @@ get_user_friendly_alias(const char *wwid, const char *file, const char *prefix,
>  		return NULL;
>  	}
>  
> -	fd = open_file(file, &can_write, BINDINGS_FILE_HEADER);
> +	fd = open_file(file, &can_write, bindings_file_header);
>  	if (fd < 0)
>  		return NULL;
>  
> @@ -406,7 +417,7 @@ get_user_friendly_wwid(const char *alias, char *buff, const char *file)
>  		return -1;
>  	}
>  
> -	fd = open_file(file, &unused, BINDINGS_FILE_HEADER);
> +	fd = open_file(file, &unused, bindings_file_header);
>  	if (fd < 0)
>  		return -1;
>  
> diff --git a/libmultipath/alias.h b/libmultipath/alias.h
> index 7c4b302..236b3ba 100644
> --- a/libmultipath/alias.h
> +++ b/libmultipath/alias.h
> @@ -1,11 +1,5 @@
> -#define BINDINGS_FILE_HEADER \
> -"# Multipath bindings, Version : 1.0\n" \
> -"# NOTE: this file is automatically maintained by the multipath program.\n" \
> -"# You should not need to edit this file in normal circumstances.\n" \
> -"#\n" \
> -"# Format:\n" \
> -"# alias wwid\n" \
> -"#\n"
> +#ifndef _ALIAS_H
> +#define _ALIAS_H
>  
>  int valid_alias(const char *alias);
>  char *get_user_friendly_alias(const char *wwid, const char *file,
> @@ -15,3 +9,5 @@ int get_user_friendly_wwid(const char *alias, char *buff, const char *file);
>  char *use_existing_alias (const char *wwid, const char *file,
>  			  const char *alias_old,
>  			  const char *prefix, int bindings_read_only);
> +
> +#endif /* _ALIAS_H */
> -- 
> 2.28.0
