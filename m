From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [BUG] multipath-tools: missing internal values
	(multipath -t)
Date: Fri, 22 Sep 2017 17:59:02 +0200
Message-ID: <48b41013-08b3-4258-6b3b-19ee8702c6ca@gmail.com>
References: <5a9ce04c-3996-9f88-1682-822b0d7b9e65@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5a9ce04c-3996-9f88-1682-822b0d7b9e65@gmail.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 04/25/2017 04:26 PM, Xose Vazquez Perez wrote:

> These values:
> no_path_retry
> dev_loss_tmo
> reservation_key
> partition_delimite
> delay_watch_checks
> delay_wait_checks
> are missing from the "defaults section" of multipath -t output.

It still happens in 0.7.3
