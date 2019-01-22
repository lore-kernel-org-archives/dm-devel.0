From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 2/4] dm: fix redundant IO accounting for bios
	that need splitting
Date: Tue, 22 Jan 2019 15:55:57 +0000
Message-ID: <20190122155558.A23FA217D4@mail.kernel.org>
References: <20190119180506.1300-3-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============8059954724532003437=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190119180506.1300-3-snitzer@redhat.com>
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

--===============8059954724532003437==
Content-Type: text/plain

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 18a25da84354 dm: ensure bio submission follows a depth-first tree walk.

The bot has tested the following trees: v4.20.3, v4.19.16.

v4.20.3: Build failed! Errors:
    drivers/md/dm.c:1582:3: error: implicit declaration of function ‘part_stat_get’; did you mean ‘part_stat_dec’? [-Werror=implicit-function-declaration]
    drivers/md/dm.c:1639:10: error: ‘sectors’ undeclared (first use in this function); did you mean ‘Sector’?

v4.19.16: Build failed! Errors:
    drivers/md/dm.c:1581:3: error: implicit declaration of function ‘part_stat_get’; did you mean ‘part_stat_dec’? [-Werror=implicit-function-declaration]
    drivers/md/dm.c:1641:10: error: ‘sectors’ undeclared (first use in this function); did you mean ‘Sector’?


How should we proceed with this patch?

--
Thanks,
Sasha


--===============8059954724532003437==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============8059954724532003437==--
