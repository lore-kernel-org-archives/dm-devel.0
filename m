From: Anders Andersson <pipatron@gmail.com>
Subject: Using the dm tools to create a writable "mirror" of a
	physical disk
Date: Wed, 2 Feb 2011 23:31:06 +0100
Message-ID: <AANLkTinqdTZnqX7qXthQHqa+bFmonCJOJ1ShpkAosB_T@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Good evening! I was recently given the task of trying to salvage files
from a 1.5TB harddrive that was accidentally formatted and/or
repartitioned. Normally I would do a 1:1 copy of the whole drive to a
file and operate on that, but I simply do not have that much room this
time.

Ideally I would like to create a writable snapshot in the same way as
I do with my LVM volumes, storing the changes in a smaller file or in
another block device so that I can experiment freely without worrying
about destroying anything else on the drive. Is this possible
(probably) and easy (probably not?) with any device mapper tools? I'm
not really sure where I should begin looking, because dmsetup is
probably pretty low-level.

Thanks for any pointers and ideas.

// Anders
