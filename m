From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 1/2] log-writes: Add support to output human
 readable flags
Date: Wed, 28 Feb 2018 10:09:07 -0500
Message-ID: <20180228150906.6vwf5iezghqv4s4f@destiny>
References: <20180228073326.30106-1-wqu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180228073326.30106-1-wqu@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Qu Wenruo <wqu@suse.com>
Cc: jbacik@fb.com, dm-devel@redhat.com
List-Id: dm-devel.ids

I merged the pull request for these, but you should maybe send them up for the
xfstests version of log-writes.  Thanks,

Josef

On Wed, Feb 28, 2018 at 03:33:25PM +0800, Qu Wenruo wrote:
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  log-writes.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 57 insertions(+), 3 deletions(-)
> 
> diff --git a/log-writes.c b/log-writes.c
> index fa4f3f3b42d6..5ef328656c89 100644
> --- a/log-writes.c
> +++ b/log-writes.c
> @@ -117,6 +117,58 @@ int log_discard(struct log *log, struct log_write_entry *entry)
>  	return 0;
>  }
>  
> +#define DEFINE_LOG_FLAGS_STR_ENTRY(x)	\
> +	{LOG_##x##_FLAG, #x}
> +
> +struct flags_to_str_entry {
> +	u64 flags;
> +	const char *str;
> +} log_flags_table[] = {
> +	DEFINE_LOG_FLAGS_STR_ENTRY(FLUSH),
> +	DEFINE_LOG_FLAGS_STR_ENTRY(FUA),
> +	DEFINE_LOG_FLAGS_STR_ENTRY(DISCARD),
> +	DEFINE_LOG_FLAGS_STR_ENTRY(MARK)
> +};
> +
> +#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> +#define LOG_FLAGS_BUF_SIZE	128
> +/*
> + * Convert numeric flags to human readable flags.
> + * @flags:	numeric flags
> + * @buf:	output buffer for human readable string.
> + * 		must have enough space (LOG_FLAGS_BUF_SIZE) to contain all
> + * 		the string
> + */
> +static void entry_flags_to_str(u64 flags, char *buf)
> +{
> +	int empty = 1;
> +	int left_len;
> +	int i;
> +
> +	buf[0] = '\0';
> +	for (i = 0; i < ARRAY_SIZE(log_flags_table); i++) {
> +		if (flags & log_flags_table[i].flags) {
> +			if (!empty)
> +				strncat(buf, "|", LOG_FLAGS_BUF_SIZE);
> +			empty = 0;
> +			strncat(buf, log_flags_table[i].str, LOG_FLAGS_BUF_SIZE);
> +			flags &= ~log_flags_table[i].flags;
> +		}
> +	}
> +	if (flags) {
> +		if (!empty)
> +			strncat(buf, "|", LOG_FLAGS_BUF_SIZE);
> +		empty = 0;
> +		left_len = LOG_FLAGS_BUF_SIZE - strnlen(buf,
> +						        LOG_FLAGS_BUF_SIZE);
> +		if (left_len > 0)
> +			snprintf(buf + strnlen(buf, LOG_FLAGS_BUF_SIZE),
> +				 left_len, "UNKNOWN.%llu", flags);
> +	}
> +	if (empty)
> +		strncpy(buf, "NONE", LOG_FLAGS_BUF_SIZE);
> +}
> +
>  /*
>   * @log: the log we are replaying.
>   * @entry: where we put the entry.
> @@ -135,6 +187,7 @@ int log_replay_next_entry(struct log *log, struct log_write_entry *entry,
>  	size_t read_size = read_data ? log->sectorsize :
>  		sizeof(struct log_write_entry);
>  	char *buf;
> +	char flags_buf[LOG_FLAGS_BUF_SIZE];
>  	ssize_t ret;
>  	off_t offset;
>  
> @@ -158,16 +211,17 @@ int log_replay_next_entry(struct log *log, struct log_write_entry *entry,
>  		}
>  	}
>  
> +	flags = le64_to_cpu(entry->flags);
> +	entry_flags_to_str(flags, flags_buf);
>  	if (log_writes_verbose)
> -		printf("replaying %d: sector %llu, size %llu, flags %llu\n",
> +		printf("replaying %d: sector %llu, size %llu, flags %llu(%s)\n",
>  		       (int)log->cur_entry - 1,
>  		       (unsigned long long)le64_to_cpu(entry->sector),
>  		       (unsigned long long)size,
> -		       (unsigned long long)le64_to_cpu(entry->flags));
> +		       (unsigned long long)flags, flags_buf);
>  	if (!size)
>  		return 0;
>  
> -	flags = le64_to_cpu(entry->flags);
>  	if (flags & LOG_DISCARD_FLAG)
>  		return log_discard(log, entry);
>  
> -- 
> 2.16.2
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
