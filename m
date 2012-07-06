From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: [PATCH] dm-mirror: fix crash with mirror recovery
	and discard
Date: Fri, 6 Jul 2012 14:33:58 -0500
Message-ID: <9136F921-D776-465A-9AFC-014643E823F4@redhat.com>
References: <Pine.LNX.4.64.1207061454200.1119@file.rdu.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1207061454200.1119@file.rdu.redhat.com>
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
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids


On Jul 6, 2012, at 1:56 PM, Mikulas Patocka wrote:

> 	for (bio = bios->head; bio; bio = bio->bi_next) {
> -		if (bio->bi_rw & REQ_FLUSH)
> +		if (bio->bi_rw & (REQ_FLUSH | REQ_FLUSH))
> 			continue;

Woops?

 brassow
