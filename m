From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] simplify multipath signal handlers
Date: Fri, 10 May 2013 20:23:38 +0200
Message-ID: <518D3B2A.3040004@acm.org>
References: <20130508183604.GW6253@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130508183604.GW6253@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/08/13 20:36, Benjamin Marzinski wrote:
> This patch changes how multipath's signal handlers work.  Instead of
> having sighup and sigusr1 acquire locks and call functions directly,
> they now both simply set atomic variables.  These two signals are
> blocked in child(), and all other threads inherit this sigmask. The
> only place in all the multipath code that doesn't block these signals
> is now the ppoll() call by the uxlsnr thread.  When it is interrupted
> by a signal, the uxlsnr thread does the actual processing work.
>
> Instead of sigend using mutex locks and condition variables to tell
> the child() function to exit, it now uses a signal_handler safe
> semaphore that child() waits on and exit_daemon() increments.
>
> This patch also switches all the sigprocmask() calls to
> pthread_sigmask()
>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Thanks for addressing my comments.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
