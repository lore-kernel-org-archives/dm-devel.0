From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue
 entered for raid0 bios
Date: Wed, 8 May 2019 10:29:22 +0100
Message-ID: <5CD2A172.4010302@youngman.org.uk>
References: <20190430223722.20845-1-gpiccoli@canonical.com>
	<20190430223722.20845-2-gpiccoli@canonical.com>
	<CAPhsuW4SeUhNOJJkEf9wcLjbbc9qX0=C8zqbyCtC7Q8fdL91hw@mail.gmail.com>
	<c8721ba3-5d38-7906-5049-e2b16e967ecf@canonical.com>
	<CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPhsuW6ahmkUhCgns=9WHPXSvYefB0Gmr1oB7gdZiD86sKyHFg@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Song Liu <liu.song.a23@gmail.com>, "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: axboe@kernel.dk, linux-raid <linux-raid@vger.kernel.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, kernel@gpiccoli.net, stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Jay Vosburgh <jay.vosburgh@canonical.com>, Gavin Guo <gavin.guo@canonical.com>
List-Id: dm-devel.ids

On 06/05/19 22:07, Song Liu wrote:
> Could you please run a quick test with raid5? I am wondering whether
> some race condition could get us into similar crash. If we cannot easily
> trigger the bug, we can process with this version.

Bear in mind I just read the list and write documentation, but ...

My gut feeling is that if it can theoretically happen for all raid
modes, it should be fixed for all raid modes. What happens if code
changes elsewhere and suddenly it really does happen for say raid-5?

On the other hand, if fixing it in md.c only gets tested for raid-0, how
do we know it will actually work for other raids if they do suddenly
start falling through.

Academic purity versus engineering practicality :-)

Cheers,
Wol
