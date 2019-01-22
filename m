From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 3/4] dm: fix missing bio_split() pattern code
	in __split_and_process_bio()
Date: Tue, 22 Jan 2019 15:56:00 +0000
Message-ID: <20190122155601.0D5FA217F5@mail.kernel.org>
References: <20190119180506.1300-4-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190119180506.1300-4-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sasha Levin <sashal@kernel.org>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: NeilBrown <neilb@suse.com>, stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 18a25da84354 dm: ensure bio submission follows a depth-first tree walk.

The bot has tested the following trees: v4.20.3, v4.19.16.

v4.20.3: Failed to apply! Possible dependencies:
    7ed15898163a ("dm: fix redundant IO accounting for bios that need splitting")

v4.19.16: Failed to apply! Possible dependencies:
    7ed15898163a ("dm: fix redundant IO accounting for bios that need splitting")


How should we proceed with this patch?

--
Thanks,
Sasha
