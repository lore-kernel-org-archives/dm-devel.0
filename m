From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm thin: set {minimum,
	optimal}_io_size to pool's data block size
Date: Fri, 18 Jul 2014 18:26:34 -0400
Message-ID: <20140718222634.GA7755@redhat.com>
References: <1405720783-7904-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1405720783-7904-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: ejt@redhat.com
List-Id: dm-devel.ids

On Fri, Jul 18 2014 at  5:59pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Before if the block layer's limit stacking didn't establish an
...

I revised this header when staging for 3.17 in for-next, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=a99c223c2a88aeb404afaa1bfce91eb0dd36b80b
