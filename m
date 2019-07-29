From: Roman Mamedov <rm@romanrm.net>
Subject: Re: [PATCH] md/raid0: Fail BIOs if their underlying
 block device is gone
Date: Tue, 30 Jul 2019 01:18:50 +0500
Message-ID: <20190730011850.2f19e140@natsu>
References: <20190729193359.11040-1-gpiccoli@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190729193359.11040-1-gpiccoli@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: linux-block@vger.kernel.org, Song Liu <songliubraving@fb.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, jay.vosburgh@canonical.com
List-Id: dm-devel.ids

On Mon, 29 Jul 2019 16:33:59 -0300
"Guilherme G. Piccoli" <gpiccoli@canonical.com> wrote:

> Currently md/raid0 is not provided with any mechanism to validate if
> an array member got removed or failed. The driver keeps sending BIOs
> regardless of the state of array members. This leads to the following
> situation: if a raid0 array member is removed and the array is mounted,
> some user writing to this array won't realize that errors are happening
> unless they check kernel log or perform one fsync per written file.
> 
> In other words, no -EIO is returned and writes (except direct ones) appear
> normal. Meaning the user might think the wrote data is correctly stored in
> the array, but instead garbage was written given that raid0 does stripping
> (and so, it requires all its members to be working in order to not corrupt
> data).

If that's correct, then this seems to be a critical weak point in cases when
we have a RAID0 as a member device in RAID1/5/6/10 arrays.

-- 
With respect,
Roman
