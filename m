From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: linux-next: Boot hangs 3 minutes with device mapper
	on s390
Date: Tue, 5 Mar 2019 10:02:52 -0800
Message-ID: <CAKgT0UeZ26BDr2FzKKECPLgCfij0SwPrk7GA+UuUuf0nnp3S1A@mail.gmail.com>
References: <20190301183350.5ff697d4@TP-holzheu>
	<20190301183050.GA29752@redhat.com>
	<20190304110334.6f71962a@TP-holzheu>
	<20190305040321.GA21739@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190305040321.GA21739@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Benjamin Block <bblock@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, dm-devel@redhat.com, linux-next@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>, Steffen Maier <maier@linux.ibm.com>, Michael Holzheu <holzheu@linux.ibm.com>
List-Id: dm-devel.ids

On Mon, Mar 4, 2019 at 8:03 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
> Hi,
>
> Alexander reported this same boot hang in another thread.  I was able to
> reproduce using an x86_64 .config that Alexander provided.
>
> I've pushed this fix out to linux-next:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.1&id=be2c5301817833f692aadb2e5fa209582db01d3b
>
> If you could verify this fix works for you I'd appreciate it.
>
> Thanks,
> Mike

I've verified I am no longer seeing the issue with this patch applied.

Thanks.

- Alex
