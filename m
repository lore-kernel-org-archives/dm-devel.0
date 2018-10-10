From: John Pittman <jpittman@redhat.com>
Subject: Re: [PATCH] dm flakey: Document "error_writes" feature
Date: Wed, 10 Oct 2018 08:18:40 -0400
Message-ID: <CA+RJvhz8U=SkvrDGT9GcJL9WP6kEY0-U3wU7DcrkuKnDQNYejg@mail.gmail.com>
References: <1539073891-7701-1-git-send-email-nborisov@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1539073891-7701-1-git-send-email-nborisov@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: nborisov@suse.com
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Jonathan Corbet <corbet@lwn.net>
List-Id: dm-devel.ids

Hi Nikolay, I sent this one to Mike at the end of September.("dm
flakey: add error_writes to documentation -
"https://www.redhat.com/archives/dm-devel/2018-September/msg00146.html).
Unsure if he has picked it up or not.

Best Regards,

John Pittman
Customer Engagement and Experience
Red Hat Inc.

On Wed, Oct 10, 2018 at 4:20 AM Nikolay Borisov <nborisov@suse.com> wrote:
>
> Commit ef548c551e72 ("dm flakey: introduce "error_writes" feature")
> added the ability to dm flakey to error out writes in contrast to
> silently dropping it with 'drop_writes'. Unfortunately this feature
> is not currently documented and one has to be either familiar with the
> source code of dm flakey or check out xfstests sources to know of
> this parameter. So document it.
>
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  Documentation/device-mapper/dm-flakey.txt | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Documentation/device-mapper/dm-flakey.txt b/Documentation/device-mapper/dm-flakey.txt
> index c43030718cef..9f0e247d0877 100644
> --- a/Documentation/device-mapper/dm-flakey.txt
> +++ b/Documentation/device-mapper/dm-flakey.txt
> @@ -33,6 +33,10 @@ Table parameters
>         All write I/O is silently ignored.
>         Read I/O is handled correctly.
>
> +  error_writes:
> +       All write I/O is failed with an error signalled.
> +       Read I/O is handled correctly.
> +
>    corrupt_bio_byte <Nth_byte> <direction> <value> <flags>:
>         During <down interval>, replace <Nth_byte> of the data of
>         each matching bio with <value>.
> --
> 2.7.4
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
