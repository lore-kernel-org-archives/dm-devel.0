From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH next] Btrfs: fix comparison in __btrfs_map_block()
Date: Mon, 18 Jul 2016 15:28:52 -0600
Message-ID: <17530fad-226a-77e7-ff76-3fca3b1ffc97@kernel.dk>
References: <1465155145-10812-14-git-send-email-mchristi@redhat.com>
 <1468595001-4270-1-git-send-email-vincent.stehle@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1468595001-4270-1-git-send-email-vincent.stehle@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: =?UTF-8?Q?Vincent_Stehl=c3=a9?= <vincent.stehle@intel.com>, linux-btrfs@vger.kernel.org
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mike Christie <mchristi@redhat.com>, Jens Axboe <axboe@fb.com>
List-Id: dm-devel.ids

On 07/15/2016 09:03 AM, Vincent Stehl=E9 wrote:
> Add missing comparison to op in expression, which was forgotten when =
doing
> the REQ_OP transition.

Thanks, added to the 4.8 branch.

--=20
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
