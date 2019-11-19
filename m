From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH RT 1/2 v2] dm-snapshot: fix crash with the realtime kernel
Date: Tue, 19 Nov 2019 09:48:39 +0100
Message-ID: <20191119084839.dvzfettd6vbvqd4w@linutronix.de>
References: <alpine.LRH.2.02.1911121057490.12815@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1911121057490.12815@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Nikos Tsironis <ntsironis@arrikto.com>, Scott Wood <swood@redhat.com>, Ilias Tsitsimpis <iliastsi@arrikto.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>, linux-rt-users@vger.kernel.org, tglx@linutronix.de
List-Id: dm-devel.ids

On 2019-11-12 11:09:51 [-0500], Mikulas Patocka wrote:
> Snapshot doesn't work with realtime kernels since the commit f79ae415b64c.
> hlist_bl is implemented as a raw spinlock and the code takes two non-raw
> spinlocks while holding hlist_bl (non-raw spinlocks are blocking mutexes
> in the realtime kernel).

this series is still on the list of things for me to look at…

Sebastian
