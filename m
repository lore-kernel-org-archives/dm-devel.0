From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 6/6] multipathd: Remove a busy-waiting loop
Date: Wed, 17 Aug 2016 12:55:47 -0700
Message-ID: <dad032b7-bef9-dfbd-2b18-c4861784277e@sandisk.com>
References: <31d43b64-36c8-1a24-a849-230b5cf6323c@sandisk.com>
	<14804b8b-51a7-e860-91d7-9b594aeed63c@sandisk.com>
	<2a584b4c-88b7-288b-3f89-62c565774cf1@suse.de>
	<7b1ac503-6f17-68b5-7510-547bd5f11731@sandisk.com>
	<CAAZtj80UaRfO_iKOVp8MP4xkXwRwfT5d_hggZmCW4P6ZN2Kjag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAAZtj80UaRfO_iKOVp8MP4xkXwRwfT5d_hggZmCW4P6ZN2Kjag@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dragan Stancevic <dragan.stancevic@canonical.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/17/2016 12:42 PM, Dragan Stancevic wrote:
> Hi Bart-
>
> are the semantics below really safe, the don't appear to? Any caller of
> checker_thread_running is relaying on stale information. The
> c->thread_running could have changed as soon as you unlock.
>
> +static unsigned checker_thread_running(struct tur_checker_context *ct)
> +{
> +unsigned thread_running;
> +
> +pthread_spin_lock(&ct->hldr_lock);
> +thread_running = ct->thread_running;
> +pthread_spin_unlock(&ct->hldr_lock);
> +
> +return thread_running;
> +}

Hello Dragan,

If you have a look at libcheck_check() in tur.c then you will see that 
it is harmless if checker_thread_running() returns old information.

Bart.
