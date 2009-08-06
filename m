From: =?UTF-8?B?7ZmN7IugIHNoaW4gaG9uZw==?= <hongshin@gmail.com>
Subject: BUG? a suspected race condition at dm_get_md()
Date: Thu, 6 Aug 2009 15:30:00 +0900
Message-ID: <2014bcab0908052330u5e53e01eu83f76b5dda86e421@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Hi. I am reporting a suspected race bug
while I read md device driver in recent Linux code.

Please examine the code and let me know your opinion.

At dm_put(), the decrement of md->holders is synchronized by _minor_lock.
But in dm_get_md(), the increment of md->holders is not.
Therefore,  race condition between dm_get_md() and dm_put()
might be possible when md->holders == 1.

Since I do not have much background, I am not sure whether
it is real bug or not. But, please examine the code and let me
know your opinion. Thank you.

Sincerely
Shin Hong
