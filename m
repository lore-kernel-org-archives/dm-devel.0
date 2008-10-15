From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: merging dm-ioband into Linux
Date: Wed, 15 Oct 2008 19:00:12 +0900 (JST)
Message-ID: <20081015.190012.104035071.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
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
To: agk@sourceware.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Alasdair,

As you know, I have been developing a block I/O bandwidth controller
on Linux. Now, I have almost finished implementation of the features
and I think I have fixed all the points that you suggested.

For the next step, I would like many people to use dm-ioband in
various environments such as with a high-end storage, with a solid
state drive and so, so that I will be able to get a lot of feedback
from them to improve and enhance the controller.

So, would you consider merging the dm-ioband patch into Linux
kernel as one of device mapper modules? I think it is not hard to
merge the code, because dm-ioband doesn't touch any existing code
except Makefile and Kconfig files placed in drivers/md directory.
You can get the patch from the following URL:
http://people.valinux.co.jp/~ryov/dm-ioband/patches/dm-ioband-1.7.0.patch

I would really appreciate it if you would reply me anything.

Thanks,
Ryo Tsuruta
