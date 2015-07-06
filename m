From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Getting mapped device namw
Date: Mon, 6 Jul 2015 14:19:42 +0200
Message-ID: <559A725E.9080903@redhat.com>
References: <DUB115-W139FD64ED5BB7A83E674F2696930@phx.gbl>
	<559A6486.3010704@gmail.com>
	<DUB115-W96AFB4B73047869480AB5F96930@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <DUB115-W96AFB4B73047869480AB5F96930@phx.gbl>
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

Dne 6.7.2015 v 14:04 Gili B napsal(a):
> Thanks
> My module is creating target similar to pool and thin from dm_thin.c.
> if the user creates a pool named "Pool1", and now he wishes

Have you checked  dm statistic support ?

https://www.kernel.org/doc/Documentation/device-mapper/statistics.txt

Zdenek
