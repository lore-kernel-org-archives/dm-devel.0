From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 14/16] libmutipath: deprecate delay_*_checks
Date: Wed, 14 Aug 2019 21:20:46 +0000
Message-ID: <af2c96e14df9aad64dbeded65e6e0c02c9ff45cf.camel@suse.com>
References: <1564763622-31752-1-git-send-email-bmarzins@redhat.com>
	<1564763622-31752-15-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1564763622-31752-15-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <8C87C81792E4F749AAB7A5E637BF26B4@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "mkumar@redhat.com" <mkumar@redhat.com>
List-Id: dm-devel.ids

On Fri, 2019-08-02 at 11:33 -0500, Benjamin Marzinski wrote:
> The delay_checks shaky paths detection method works the same way as
> the
> san_path_err method, but not as well, with less configurability, and
> with the code spread all over check_path(). The only real difference
> is
> that marks the path as marginal for a certain number of path checks
> instead of for a specific time. This patch deprecates the
> delay_checks
> method and maps it to the the san_path_err method.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/configure.c   | 17 +----------
>  libmultipath/propsel.c     | 62 +++++++++++++++++++++++++++++-------

I suppose that quite a few users are working with "delay_*_checks" in
production. If we remove the option, we should at least clearly
document how to map existing delay_*_checks parameters to san_path_err*
parameters.

IIUC, to (roughly) imitate the settings

  delay_watch_checks = C
  delay_wait_checks = W

I need to set

  san_path_err_threshold = 2
  san_path_err_forget_rate = C
  san_path_err_recovery_time = W

Correct? Or can it be done better?

(It's not exactly the same, as delay_watch_checks starts counting when
a path is reinstated after a failure, while san_path_err_threshold
counts good->bad transitions, and the threshold would be reached if a
path fails more often than every C ticks _on average_).

If the above is fine, we might as well map these settings in the code
directly. IOW, instead of ignoring "delay_*_checks" altogether, we
should ignore it only if either san_path_* or marginal_path_*
parameters are set; Otherwise, we could simply map the delay_*_checks
parameters as shown above.

That would be a bit more user friendly in terms of backwards
compatibility.

Regards
Martin
