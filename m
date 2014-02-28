From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 6/8] dm mpath: remove map_io()
Date: Fri, 28 Feb 2014 09:06:24 +0000
Message-ID: <11AF7C027C4C02408624617A49860784010D7D65@BPXM12GP.gisp.nec.co.jp>
References: <1393486229-72034-1-git-send-email-hare@suse.de>
	<1393486229-72034-7-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1393486229-72034-7-git-send-email-hare@suse.de>
Content-Language: ja-JP
Content-ID: <1893AC5B12B22B4981F4472AC356035D@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 02/27/14 16:30, Hannes Reinecke wrote:
> multipath_map() is now just a wrapper around map_io(), so we
> can rename map_io() to multipath_map().

Reviewed-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

> 
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

-- 
Jun'ichi Nomura, NEC Corporation
