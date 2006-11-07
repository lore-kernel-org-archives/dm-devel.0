From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2.6.19 4/5] dm: raid1: fix waiting for io on
	suspend
Date: Tue, 7 Nov 2006 12:29:04 -0800
Message-ID: <20061107122904.a49861be.akpm@osdl.org>
References: <20061107183243.GF6993@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20061107183243.GF6993@agk.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, 7 Nov 2006 18:32:43 +0000
Alasdair G Kergon <agk@redhat.com> wrote:

> +DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);

I'll make this static.
