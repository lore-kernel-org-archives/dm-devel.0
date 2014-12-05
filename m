From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: raid1 round-robin scheduler
Date: Fri, 5 Dec 2014 16:25:49 +0400
Message-ID: <CACaajQsaw_GvVNp1t9dGy0xabroskqYtVvrviNA+XxXGhBZgHg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
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
To: device-mapper <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello. Does the somebody create scheduler for raid1 to add ability to
read data from all devices, for example i need to read from all
devices when have sequential read.

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
