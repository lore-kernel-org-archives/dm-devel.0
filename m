From: Tom Parker <palfrey@tevp.net>
Subject: DM Performance
Date: Thu, 07 Apr 2005 14:29:20 +0200
Message-ID: <425527A0.4040800@tevp.net>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I'm trying to find out whether there's been any work regarding device mapper 
with very large mapping tables. Specifically,

1) Is there any limit on the size of a mapping table? Can hand over a table with 
30,000+ entries and expect DM to still work?
2) Is there any significant performance degredation with large tables?
3) As I understand it, DM stores the mapping tables itself somehow, in a way 
that is persistant across reboots. I'm not certain about that, but if that's so, 
wouldn't it also create limits on table sizes? If not, are there any suggested 
ways to make complex/large tables persistant?

Thanks,

Tom Parker
-- 
palfrey@tevp.net - http://tevp.net
Illegitimus non carborundum
