From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 01/17] multipathd: warn when configuration
 has been changed.
Date: Mon, 10 Feb 2020 15:22:45 +0100
Message-ID: <1b63c7cc5f4b3cc2f67e21e98da50e9afbed5439.camel@suse.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
	<1580929100-32572-2-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1580929100-32572-2-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-02-05 at 12:58 -0600, Benjamin Marzinski wrote:
> It would be helpful if multipathd could log a message when
> multipath.conf or files in the config_dir have been written to, both
> so
> that it can be used to send a notification to users, and to help with
> determining after the fact if multipathd was running with an older
> config, when the logs of multipathd's behaviour don't match with the
> current multipath.conf.
> 
> To do this, the multipathd uxlsnr thread now sets up inotify watches
> on
> both /etc/multipath.conf and the config_dir to watch if the files are
> deleted or closed after being opened for writing.  In order to keep
> uxlsnr from polling repeatedly if the multipath.conf or the
> config_dir
> aren't present, it will only set up the watches once per reconfigure.
> However, since multipath.conf is far more likely to be replaced by a
> text editor than modified in place, if it gets removed, multipathd
> will
> immediately try to restart the watch on it (which will succeed if the
> file was simply replaced by a new copy).  This does mean that if
> multipath.conf or the config_dir are actually removed and then later
> re-added, multipathd won't log any more messages for changes until
> the
> next reconfigure. But that seems like a fair trade-off to avoid
> repeatedly polling for files that aren't likely to appear.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.h |   1 +
>  multipathd/main.c     |   1 +
>  multipathd/uxlsnr.c   | 138
> ++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 134 insertions(+), 6 deletions(-)

Reviewed-by: Martin Wilck <mwilck@suse.com>
