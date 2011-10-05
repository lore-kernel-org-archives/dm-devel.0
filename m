From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH][multipath-tools]'multipath' with -h and -t
 option, it returns '1' (fail) for successful command execution
Date: Wed, 05 Oct 2011 22:45:02 +0200
Message-ID: <1317847502.32002.1.camel@lapoo.opensvc.com>
References: <20111005143410.4265.68055.stgit@arunaltc>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111005143410.4265.68055.stgit@arunaltc>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com, arunabal@in.ibm.com
List-Id: dm-devel.ids

On mer., 2011-10-05 at 20:06 +0530, Aruna Balakrishnaiah wrote:
> Fix exit status for -h and -t options in multipath command
> 
Merged.

Thanks for the effort to comply to the patch submission best practices.

cvaroqui

> 
> ---
>  multipath/main.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 654e031..9c45b8b 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -116,7 +116,6 @@ usage (char * progname)
>  		"          . multipath including the path with maj:min 'dev' (ex: 8:0)\n" \
>  		);
>  
> -	exit(1);
>  }
>  
>  static int
> @@ -404,8 +403,10 @@ main (int argc, char *argv[])
>  			break;
>  		case 'v':
>  			if (sizeof(optarg) > sizeof(char *) ||
> -			    !isdigit(optarg[0]))
> +			    !isdigit(optarg[0])) {
>  				usage (argv[0]);
> +				exit(1);
> +			}
>  
>  			conf->verbosity = atoi(optarg);
>  			break;
> @@ -445,24 +446,29 @@ main (int argc, char *argv[])
>  			if (conf->pgpolicy_flag == -1) {
>  				printf("'%s' is not a valid policy\n", optarg);
>  				usage(argv[0]);
> +				exit(1);
>  			}
>  			break;
>  		case 'r':
>  			conf->force_reload = 1;
>  			break;
>  		case 't':
> -			dump_config();
> +			r = dump_config();
>  			goto out;
>  		case 'h':
>  			usage(argv[0]);
> +			exit(0);
>  		case ':':
>  			fprintf(stderr, "Missing option arguement\n");
>  			usage(argv[0]);
> +			exit(1);
>  		case '?':
>  			fprintf(stderr, "Unknown switch: %s\n", optarg);
>  			usage(argv[0]);
> +			exit(1);
>  		default:
>  			usage(argv[0]);
> +			exit(1);
>  		}
>  	}
>  	if (optind < argc) {
> 
