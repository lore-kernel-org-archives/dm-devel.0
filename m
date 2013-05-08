From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/2] simplify multipath signal handlers
Date: Wed, 08 May 2013 07:58:50 +0200
Message-ID: <5189E99A.4000309@acm.org>
References: <20130507221237.GT6253@ether.msp.redhat.com>
	<20130507221557.GU6253@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130507221557.GU6253@ether.msp.redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On 05/08/13 00:15, Benjamin Marzinski wrote:
> +	sigprocmask(SIG_SETMASK, NULL, &mask);

Not sure this is relevant on Linux, but the POSIX specs require to use 
pthread_sigmask() in multithreaded programs instead of sigprocmask() 
(see also 
http://pubs.opengroup.org/onlinepubs/9699919799/functions/pthread_sigmask.html). 
Otherwise this patch looks fine to me.

Bart.
