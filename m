From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 06/33] multipathd: set timeout for CLI
 commands correctly
Date: Wed, 5 Apr 2017 17:07:05 -0500
Message-ID: <20170405220705.GH19236@octiron.msp.redhat.com>
References: <20170228162329.14517-1-mwilck@suse.com>
	<20170228162329.14517-7-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170228162329.14517-7-mwilck@suse.com>
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

On Tue, Feb 28, 2017 at 05:23:02PM +0100, Martin Wilck wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> The CLI command timeout wasn't set correctly for CLI commands,
> causing it to timeout prematurely before the CLI response
> could be received.

I'm pretty sure that this is wrong.  uxsock_timeout is almost always
used in recv_packet, where it is supposed to specify a time in
milliseconds.  In parse_cmd, it is being used to limit how long
multipathd will wait to get a lock when replying to a cli command before
giving up, and it's using the timeout in seconds (which is why the code
devided the timeout by 1000). With this patch it will now wait 15
minutes before giving up.  After your "multipathd: set timeout for CLI
commands correctly" patch later in this series is applied, multipathd
will wait over an hour for a reply from multipathd before timing out.  I
agree that you will need to wait longer for multipathd to grab the vecs
lock than you do when you are simply waiting for all the data in your
socket to show up, so the regular uxsock_timeout value is too small, but
an hour and seven minutes can't be what you intended.

-Ben
 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  multipathd/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index e317a4c9..86d73f7b 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1070,7 +1070,7 @@ uxsock_trigger (char * str, char ** reply, int * len, bool is_root,
>  		return 1;
>  	}
>  
> -	r = parse_cmd(str, reply, len, vecs, uxsock_timeout / 1000);
> +	r = parse_cmd(str, reply, len, vecs, uxsock_timeout);
>  
>  	if (r > 0) {
>  		if (r == ETIMEDOUT)
> -- 
> 2.11.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
