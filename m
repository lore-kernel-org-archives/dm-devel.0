From: Yael Chemla <Yael.Chemla@arm.com>
Subject: Q about: dm verity: don't crash on vmallocated buffer
Date: Thu, 13 Dec 2018 19:01:38 +0000
Message-ID: <362BCD76-61EC-4746-8EEC-0B003A274D8C@arm.com>
References: <DB6PR08MB26296B2A37865B22D540A01DFAA00@DB6PR08MB2629.eurprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <DB6PR08MB26296B2A37865B22D540A01DFAA00@DB6PR08MB2629.eurprd08.prod.outlook.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Mikulas and Mike,
Regarding this patch (e4b069e0945f), it adds verity_hash_upadate a do-while loop.
Can you see any scenario it'll loop more than twice? Please elaborate.
Is there a case where the data parameter is larger than PAGE_SIZE.
Thanks,
Yael
IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
