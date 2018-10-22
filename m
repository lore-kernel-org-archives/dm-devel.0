From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: How to understand dm-writecache/memory_entry
Date: Mon, 22 Oct 2018 11:25:18 -0400
Message-ID: <20181022152518.GA4469@redhat.com>
References: <d9aa74ec-413b-6bdc-1346-541228fb43ea@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <d9aa74ec-413b-6bdc-1346-541228fb43ea@foxmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: shenghui <shhuiw@foxmail.com>
Cc: Mikulas Patocka <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sun, Oct 21 2018 at  9:18am -0400,
shenghui <shhuiw@foxmail.com> wrote:

> Hi Mikulas,
> 
> Sorry to trouble you again.
> 
> I'm reading the source code of dm-writecache, and noticed:
> -----------------------------------------------------
> static struct wc_memory_entry *memory_entry(struct dm_writecache *wc, struct wc_entry *e)
> {
> 	if (is_power_of_2(sizeof(struct wc_entry)) && 0)    // why this?
> 		return &sb(wc)->entries[e - wc->entries];
> 	else
> 		return &sb(wc)->entries[e->index];
> }
> 
> Seems there is something wrong with the if condition, right?

Certainly looks very wrong.

I've staged this fix:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.20&id=da4ad3a23af3d7f357b24b33e9fec7531b59ee49
