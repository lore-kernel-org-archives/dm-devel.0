From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: memory leak from orphan_path()
Date: Thu, 14 Jul 2016 16:52:45 +0200
Message-ID: <5787A73D.8050403@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Hello,

I've found that orphan_path() function just set pp->getuid as NULL.
But it can have a string allocated by strdup.
I think it should be freed by free().

I sent a patch and experiment result but I got a reply that my email is 
'unprocessed'.
So I could not attach my patch but it's very easy for you to catch.

I'd appreciate if you would give me any feedback.

-- 
Best regards,
Gioh Kim
