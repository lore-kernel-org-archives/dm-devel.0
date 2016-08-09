From: Gioh Kim <gi-oh.kim@profitbricks.com>
Subject: multipathd: cancel free(pp->getuid) in orphan_path()
Date: Tue, 9 Aug 2016 14:58:17 +0200
Message-ID: <aa8b1b03-985a-597b-e0cd-eb7267878476@profitbricks.com>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

Hello,

I have found "free(pp->getuid)" is added into orphan_path().

I think it'd better to revert the patch: 
http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commit;h=44b753d34ff82ecc229407fe8247b11f15f435ce


The latest code does not allocation memory for pp->getuid, but just 
share the global value.

Therefore pp->getuid should not be freed.

I proposed it but I am wrong.

I'm very sorry to confuse you.



-- 
Best regards,
Gioh Kim
TEL: 0176 2697 8962
