From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 0/7] dm-integrity patches
Date: Mon, 23 Mar 2020 10:28:17 -0400
Message-ID: <20200323142817.GA27360@redhat.com>
References: <20200322194220.074515600@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200322194220.074515600@debian-a64.vm>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, David Teigland <teigland@redhat.com>
List-Id: dm-devel.ids

On Sun, Mar 22 2020 at  3:42pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> Here I'm sending dm-integrity patches for the upcoming merge window.
> They supersede dm-integrity patches that I sent before.

So the dm-bufio discard support isn't needed with your latest
dm-integrity patches right?

https://patchwork.kernel.org/patch/11371287/
