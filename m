From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] remove alloc_page from dm-emc.c
Date: Mon, 11 Apr 2005 04:32:47 -0700
Message-ID: <425A605F.9080807@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Lars Marowsky-Bree <lmb@suse.de>, Alasdair G Kergon <agk@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hey Lars,

Here is what I meant. A Page for just something around 8-16 bytes
seems wasteful. Plus there is no reserve.

If you have to end up setting more bits maybe it is better to
preallocate a command per device at create time, or maybe since
there are four different combos I should have done it with this
patch?

This was made against 2.6.12-rc2. Only compile tested.

Mike
