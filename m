From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 2/7] mpathpersist: add option
	--batch-file (-f)
Date: Wed, 22 May 2019 14:30:01 -0500
Message-ID: <20190522193001.GA7630@octiron.msp.redhat.com>
References: <20190517225703.16295-1-mwilck@suse.com>
	<20190517225703.16295-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190517225703.16295-3-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, dbond@octiron.msp.redhat.com
List-Id: dm-devel.ids

On Sat, May 18, 2019 at 12:56:58AM +0200, Martin Wilck wrote:
> Add the option --batch-file (-f) to mpathpersist. The option argument
> is a text file that is parsed line-by-line. Every line of the file is
> interpreted as an additional input line for mpathpersist. The initial
> "mpathpersist" on each line is optional. The '#' character denotes
> a comment. '#' is only recognized after whitespace. Empty lines,
> or comment lines, are allowed.
> 
> If -f is given, other command line options are parsed as usual and
> commands (if any) are run before running the batch file. Inside the
> batch file, the option -f is forbidden, and -v is ignored. If a command
> fails, the batch processing is not aborted. The return status of
> mpathpersist is 0 if all commands succeeded, and the status of the
> first failed command otherwise.

One small issue. Otherwise, this looks good.

> ---
>  mpathpersist/main.c | 195 +++++++++++++++++++++++++++++++++++---------
>  mpathpersist/main.h |   1 +
>  2 files changed, 159 insertions(+), 37 deletions(-)
> 

<snip>

> @@ -487,10 +567,51 @@ int main (int argc, char * argv[])
>  	}
>  
>  out :
> -	if (ret == MPATH_PR_SYNTAX_ERROR)
> -		usage();
> -	mpath_lib_exit(conf);
> +	if (ret == MPATH_PR_SYNTAX_ERROR) {

It's possible to set batch_fn, and then later fail with
MPATH_PR_SYNTAX_ERROR. In that case, you should still free batch_fn.

-Ben

> +		if (nline == 0)
> +			usage();
> +		else
> +			fprintf(stderr, "syntax error on line %d in batch file\n",
> +				nline);
> +	} else if (batch_fn != NULL) {
> +		int rv = do_batch_file(batch_fn);
> +
> +		free(batch_fn);
> +		ret = ret == 0 ? rv : ret;
> +	}
> +	return (ret >= 0) ? ret : MPATH_PR_OTHER;
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int ret;
> +
> +	if (optind == argc)
> +	{
> +
> +		fprintf (stderr, "No parameter used\n");
> +		usage ();
> +		exit (1);
> +	}
> +
> +	if (getuid () != 0)
> +	{
> +		fprintf (stderr, "need to be root\n");
> +		exit (1);
> +	}
> +
> +	udev = udev_new();
> +	multipath_conf = mpath_lib_init();
> +	if(!multipath_conf) {
> +		udev_unref(udev);
> +		exit(1);
> +	}
> +
> +	ret = handle_args(argc, argv, 0);
> +
> +	mpath_lib_exit(multipath_conf);
>  	udev_unref(udev);
> +
>  	return (ret >= 0) ? ret : MPATH_PR_OTHER;
>  }
>  
> diff --git a/mpathpersist/main.h b/mpathpersist/main.h
> index beb8a21b..c5f53f52 100644
> --- a/mpathpersist/main.h
> +++ b/mpathpersist/main.h
> @@ -23,6 +23,7 @@ static struct option long_options[] = {
>  	{"reserve", 0, NULL, 'R'},
>  	{"transport-id", 1, NULL, 'X'},
>  	{"alloc-length", 1, NULL, 'l'},
> +	{"batch-file", 1, NULL, 'f' },
>  	{NULL, 0, NULL, 0}
>  };
>  
> -- 
> 2.21.0
